import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:customer_e_commerce/core/di/service_locator.dart';
import 'package:customer_e_commerce/core/router/app_router.dart';
import 'package:customer_e_commerce/core/router/my_routes.dart';
import 'package:customer_e_commerce/features/user/presentation/bloc/CheckNetwork/connectivity_bloc.dart';
import 'package:customer_e_commerce/features/user/presentation/pages/NetworkError/network_error_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await serviceLocator();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    /*return BlocProvider(
      create: (context) => ConnectivityBloc(Connectivity()),
      child: BlocBuilder<ConnectivityBloc, ConnectivityState>(
        builder: (context, state) {
          print("Main file state is ${state}");
          final connectivityBloc = context.read<ConnectivityBloc>();

          if (state is ConnectivityDisconnected) {
            // connectivityBloc.lastvisitedRoute =
            //     router.routerDelegate.currentConfiguration.fullPath;
            // router.go(MyRoutes.networkerrorRoute);
            return MaterialApp.router(
              builder: (context, widget) {
                return NetworkErrorScreen();
              },
            );
          }
          return MaterialApp.router(
            routerConfig: AppRouter.router,
            debugShowMaterialGrid: false,
          );
        },
      ),
    ); */
    return BlocProvider(
      create: (context) => ConnectivityBloc(Connectivity()),
      child: MaterialApp.router(
        routerConfig: AppRouter.router,
      ),
    );
  }
}
