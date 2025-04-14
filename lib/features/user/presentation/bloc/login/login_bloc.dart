import 'package:bloc/bloc.dart';
import 'package:customer_e_commerce/features/user/domain/repositories/auth_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;
  LoginBloc({required this.authRepository}) : super(LoginInitial()) {
    print("Login Bloc initialized");
    on<LoginSubmitted>((event, emit) async {
      emit(LoginLoading());
      try {
        await authRepository.login(event.email, event.password);
        emit(LoginSuccess());
      } catch (e) {
        emit(LoginFailure(errorMessage: e.toString()));
      }
    });
  }
  @override
  Future<void> close() {
    print("❌ LoginBloc CLOSED"); // Check when this happens
    return super.close();
  }
}
