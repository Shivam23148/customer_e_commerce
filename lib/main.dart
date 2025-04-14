import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:customer_e_commerce/core/di/service_locator.dart';
import 'package:customer_e_commerce/core/router/app_router.dart';
import 'package:customer_e_commerce/core/router/my_routes.dart';
import 'package:customer_e_commerce/features/user/presentation/bloc/Auth/auth_bloc.dart';
import 'package:customer_e_commerce/features/user/presentation/bloc/CheckNetwork/connectivity_bloc.dart';
import 'package:customer_e_commerce/features/user/presentation/bloc/ProfileSetup/profile_setup_bloc.dart';
import 'package:customer_e_commerce/features/user/presentation/bloc/Register/register_bloc.dart';
import 'package:customer_e_commerce/features/user/presentation/bloc/login/login_bloc.dart';
import 'package:customer_e_commerce/features/user/presentation/pages/NetworkError/network_error_screen.dart';
import 'package:customer_e_commerce/features/user/presentation/pages/ProfileSetup/dummy_profile_setup_screen.dart';
import 'package:customer_e_commerce/features/user/presentation/pages/ProfileSetup/profile_setup_screen.dart';
import 'package:customer_e_commerce/firebase_options.dart';
import 'package:customer_e_commerce/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setUpLocator();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => serviceLocator<ConnectivityBloc>()),
        BlocProvider(create: (context) => serviceLocator<LoginBloc>()),
        BlocProvider(create: (context) => serviceLocator<RegisterBloc>()),
        BlocProvider(create: (context) => serviceLocator<ProfileSetupBloc>()),
        BlocProvider(
          create: (context) => AuthBloc()
            ..add(AuthUserChanged(serviceLocator<FirebaseAuth>()
                .currentUser)), // Initialize AuthBloc
        ),
      ],
      child: BlocBuilder<ConnectivityBloc, ConnectivityState>(
        builder: (context, state) {
          print("Main file state is ${state}");

          if (state is ConnectivityDisconnected) {
            // connectivityBloc.lastvisitedRoute =
            //     router.routerDelegate.currentConfiguration.fullPath;
            // router.go(MyRoutes.networkerrorRoute);
            return MaterialApp(
              builder: (context, widget) {
                return NetworkErrorScreen();
              },
            );
          }
          return MaterialApp.router(
            routerConfig: AppRouter.router,
            builder: (context, child) {
              SizeConfig.initSize(context);
              return child ?? SizedBox();
            },
            debugShowMaterialGrid: false,
          ); /* 
          return MaterialApp(
            builder: (context, child) {
              SizeConfig.initSize(context);
              return child ?? SizedBox.shrink();
            },
            home: ProfileSetupScreen(),
          ); */
        },
      ),
    );
    /* return BlocProvider(
      create: (context) => ConnectivityBloc(Connectivity()),
      child: MaterialApp.router(
        routerConfig: AppRouter.router,
      ),
    ); */
  }
}
