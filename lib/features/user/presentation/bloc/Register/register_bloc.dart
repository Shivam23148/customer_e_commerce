import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:customer_e_commerce/core/di/service_locator.dart';
import 'package:customer_e_commerce/core/services/notification_service.dart';
import 'package:customer_e_commerce/features/user/domain/repositories/auth_repository.dart';
part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  Timer? _timer;
  final AuthRepository authRepository;
  final NotificationService notificationService =
      serviceLocator<NotificationService>();
  RegisterBloc(this.authRepository) : super(RegisterInitial()) {
    on<SendVerificationEmailEvent>((event, emit) async {
      emit(RegisterLoading());
      try {
        await authRepository.handleEmailEntry(event.email);
        emit(EmailSentState());
        _timer = Timer.periodic(Duration(seconds: 1), (timer) {
          add(CheckEmailVerificationEvent());
        });
      } catch (e) {
        rethrow;
      }
    });
    on<CheckEmailVerificationEvent>((event, emit) async {
      emit(RegisterLoading());
      try {
        final isVerified = await authRepository.isEmailVerified();
        if (isVerified) {
          _timer?.cancel();
          emit(EmailVerifiedState());
        }
      } catch (e) {
        _timer?.cancel();
        rethrow;
      }
    });
    on<CompleteRegistrationEvent>((event, emit) async {
      emit(RegisterLoading());
      try {
        final user = await authRepository.getCurrentUser();
        if (user != null && user.emailVerified) {
          await user.updatePassword(event.password);
          notificationService.showNotification(
            title: 'Registration Successful',
            body:
                'Welcome to the app, ${user.displayName ?? 'New User'}! We are excited to have you.',
          );

          emit(RegistrationCompletedState());
        } else {
          emit(RegistrationErrorState("Email is not verified"));
        }
      } catch (e) {
        rethrow;
      }
    });
    on<ResetRegisterStateEvent>((event, emit) {
      _timer?.cancel(); // Cancel any ongoing timer
      emit(RegisterInitial()); // Emit the initial state
    });
  }
  @override
  Future<void> close() {
    _timer?.cancel(); // Ensure the timer is cancelled when the bloc is closed
    return super.close();
  }
}
