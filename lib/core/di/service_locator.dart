import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:customer_e_commerce/core/services/geolocator_service.dart';
import 'package:customer_e_commerce/core/services/notification_service.dart';
import 'package:customer_e_commerce/features/user/data/repositories/address_repository_impl.dart';
import 'package:customer_e_commerce/features/user/data/repositories/auth_repository_impl.dart';
import 'package:customer_e_commerce/features/user/data/repositories/cart_repository.dart';
import 'package:customer_e_commerce/features/user/data/repositories/profile_repository_impl.dart';
import 'package:customer_e_commerce/features/user/data/repositories/shop_repositry_impl.dart';
import 'package:customer_e_commerce/features/user/data/repositories/wishlist_repository.dart';
import 'package:customer_e_commerce/features/user/domain/repositories/auth_repository.dart';
import 'package:customer_e_commerce/features/user/domain/repositories/profile_repository.dart';
import 'package:customer_e_commerce/features/user/presentation/bloc/Address/address_bloc.dart';
import 'package:customer_e_commerce/features/user/presentation/bloc/Auth/auth_bloc.dart';
import 'package:customer_e_commerce/features/user/presentation/bloc/Cart/cart_bloc.dart';
import 'package:customer_e_commerce/features/user/presentation/bloc/CheckNetwork/connectivity_bloc.dart';
import 'package:customer_e_commerce/features/user/presentation/bloc/OrderStatus/orderstatus_bloc.dart';
import 'package:customer_e_commerce/features/user/presentation/bloc/Profile/profile_bloc.dart';
import 'package:customer_e_commerce/features/user/presentation/bloc/ProfileSetup/profile_setup_bloc.dart';
import 'package:customer_e_commerce/features/user/presentation/bloc/Register/register_bloc.dart';
import 'package:customer_e_commerce/features/user/presentation/bloc/Shop/shop_bloc.dart';
import 'package:customer_e_commerce/features/user/presentation/bloc/Wishlist/wishlist_bloc.dart';
import 'package:customer_e_commerce/features/user/presentation/bloc/Login/login_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

Future<void> setUpLocator() async {
  //Firebase Auth
  serviceLocator
      .registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  //Connecitivity
  final connectivity = Connectivity();
  serviceLocator.registerLazySingleton<Connectivity>(() => connectivity);

  //Firebase Firestore
  serviceLocator.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance);

  //Firebase Messaging
  serviceLocator.registerLazySingleton<FirebaseMessaging>(
      () => FirebaseMessaging.instance);

  //Flutter Local Notification
  serviceLocator.registerLazySingleton<FlutterLocalNotificationsPlugin>(
      () => FlutterLocalNotificationsPlugin());

  //Shared Preferences
  final sharedPrefernces = await SharedPreferences.getInstance();
  serviceLocator
      .registerLazySingleton<SharedPreferences>(() => sharedPrefernces);

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
  serviceLocator.registerLazySingleton<ShopRepository>(() => ShopRepository());
  //Address Repository
  serviceLocator.registerLazySingleton<AddressRepositoryImpl>(
      () => AddressRepositoryImpl());
  //Cart Repository
  serviceLocator.registerLazySingleton<CartRepository>(() => CartRepository());
  //Wishlist Repository
  serviceLocator
      .registerLazySingleton<WishlistRepository>(() => WishlistRepository());

  //Service
  //Geolocator Service
  serviceLocator
      .registerLazySingleton<GeolocatorService>(() => GeolocatorService());
  //Notification Service
  serviceLocator
      .registerLazySingleton<NotificationService>(() => NotificationService());
  await serviceLocator<NotificationService>().init();

  //BLOC
  //Connectivity Bloc
  serviceLocator.registerLazySingleton(
      () => ConnectivityBloc(serviceLocator<Connectivity>()));
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
  //Shop
  serviceLocator.registerLazySingleton(() => ShopBloc());
  //Cart
  serviceLocator.registerLazySingleton<CartBloc>(() => CartBloc());
  //OrderWaiting
  serviceLocator
      .registerLazySingleton<OrderstatusBloc>(() => OrderstatusBloc());
  //Wishlist
  serviceLocator.registerLazySingleton<WishlistBloc>(() => WishlistBloc());
  //Profile
  serviceLocator.registerLazySingleton<ProfileBloc>(() => ProfileBloc());
  //Address
  serviceLocator.registerLazySingleton<AddressBloc>(() => AddressBloc());
}
