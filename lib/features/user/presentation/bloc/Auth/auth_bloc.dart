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
    on<AuthUserChanged>((event, emit) {
      if (event.user != null) {
        emit(AuthAuthenticated(event.user!));
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
