import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:customer_e_commerce/features/user/data/repositories/auth_repository_impl.dart';
import 'package:customer_e_commerce/features/user/domain/repositories/auth_repository.dart';
import 'package:customer_e_commerce/features/user/presentation/bloc/CheckNetwork/connectivity_bloc.dart';
import 'package:customer_e_commerce/features/user/presentation/bloc/Register/register_bloc.dart';
import 'package:customer_e_commerce/features/user/presentation/bloc/login/login_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

Future<void> setUpLocator() async {
  //Firebase Auth
  serviceLocator
      .registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  //Connectivity
  final connectivity = Connectivity();
  serviceLocator.registerLazySingleton<Connectivity>(() => connectivity);
  serviceLocator.registerLazySingleton(() => ConnectivityBloc(connectivity));

  //Auth Repository
  serviceLocator
      .registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  //BLOC

  //Login
  serviceLocator.registerLazySingleton(
      () => LoginBloc(authRepository: serviceLocator<AuthRepository>()));
  //Register
  serviceLocator.registerLazySingleton(
      () => RegisterBloc(serviceLocator<AuthRepository>()));
}
