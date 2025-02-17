import 'package:customer_e_commerce/features/user/data/repositories/auth_repository_impl.dart';
import 'package:customer_e_commerce/features/user/domain/repositories/auth_repository.dart';
import 'package:customer_e_commerce/features/user/presentation/bloc/login/login_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

Future<void> setUpLocator() async {
  //Firebase Auth
  serviceLocator
      .registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  //Auth Repository
  serviceLocator
      .registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  //BLOC
  serviceLocator.registerLazySingleton(
      () => LoginBloc(authRepository: serviceLocator<AuthRepository>()));
}
