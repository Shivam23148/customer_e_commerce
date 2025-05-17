import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:customer_e_commerce/core/di/service_locator.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth firebaseAuth = serviceLocator<FirebaseAuth>();
  late final StreamSubscription<User?> _authSubscription;
  AuthBloc() : super(AuthInitial()) {
    _authSubscription = firebaseAuth.authStateChanges().listen((user) {
      add(AuthUserChanged(user));
    });
    on<AuthUserChanged>((event, emit) async {
      final user = event.user;
      if (user != null) {
        await user.reload();
        if (user.emailVerified) {
          emit(AuthAuthenticated(event.user!));
        } else {
          await firebaseAuth.signOut();
          emit(AuthUnauthenticated());
        }
      } else {
        emit(AuthUnauthenticated());
      }
    });
  }
  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}
