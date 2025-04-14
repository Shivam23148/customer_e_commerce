import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:customer_e_commerce/core/services/geolocator_service.dart';
import 'package:customer_e_commerce/features/user/data/repositories/address_repository_impl.dart';
import 'package:customer_e_commerce/features/user/data/repositories/auth_repository_impl.dart';
import 'package:customer_e_commerce/features/user/data/repositories/profile_repository_impl.dart';
import 'package:customer_e_commerce/features/user/data/repositories/shop_repositry_impl.dart';
import 'package:customer_e_commerce/features/user/domain/repositories/auth_repository.dart';
import 'package:customer_e_commerce/features/user/domain/repositories/profile_repository.dart';
import 'package:customer_e_commerce/features/user/presentation/bloc/Auth/auth_bloc.dart';
import 'package:customer_e_commerce/features/user/presentation/bloc/CheckNetwork/connectivity_bloc.dart';
import 'package:customer_e_commerce/features/user/presentation/bloc/ProfileSetup/profile_setup_bloc.dart';
import 'package:customer_e_commerce/features/user/presentation/bloc/Register/register_bloc.dart';
import 'package:customer_e_commerce/features/user/presentation/bloc/login/login_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

Future<void> setUpLocator() async {
  //Firebase Auth
  serviceLocator
      .registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  //Firebase Firestore
  serviceLocator.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance);

  //Collection Reference
  //Profile
  serviceLocator.registerLazySingleton<CollectionReference>(
      () => serviceLocator<FirebaseFirestore>().collection('users'),
      instanceName: 'users');
  //Shops
  serviceLocator.registerLazySingleton<CollectionReference>(
      () => serviceLocator<FirebaseFirestore>().collection('shops'),
      instanceName: 'shops');
  //Products
  serviceLocator.registerLazySingleton<CollectionReference>(
      () => serviceLocator<FirebaseFirestore>().collection('products'),
      instanceName: 'products');

  //Connectivity
  final connectivity = Connectivity();
  serviceLocator.registerLazySingleton<Connectivity>(() => connectivity);
  serviceLocator.registerLazySingleton(() => ConnectivityBloc(connectivity));

  //Repository
  //Auth Repository
  serviceLocator
      .registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  //Profile Repository
  serviceLocator.registerLazySingleton<ProfileRepository>(() =>
      ProfileRepositoryImpl(
          firestore: serviceLocator<FirebaseFirestore>(),
          firebaseAuth: serviceLocator<FirebaseAuth>()));
  //Shop Repository
  serviceLocator.registerLazySingleton(() => ShopRepository());
  //Address Repository
  serviceLocator.registerLazySingleton(() => AddressRepositoryImpl());

  //Service
  //Geolocator Service
  serviceLocator
      .registerLazySingleton<GeolocatorService>(() => GeolocatorService());

  //BLOC
  //Auth
  serviceLocator.registerLazySingleton(() => AuthBloc());
  //Login
  serviceLocator.registerLazySingleton(
      () => LoginBloc(authRepository: serviceLocator<AuthRepository>()));
  //Register
  serviceLocator.registerLazySingleton(
      () => RegisterBloc(serviceLocator<AuthRepository>()));
  //Profile Setup
  serviceLocator.registerLazySingleton(() => ProfileSetupBloc());
}
