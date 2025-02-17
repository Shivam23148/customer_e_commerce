/* import 'package:customer_e_commerce/core/network/network_checker.dart';
import 'package:customer_e_commerce/core/router/my_routes.dart';
import 'package:customer_e_commerce/features/user/presentation/pages/NetworkError/network_error_screen.dart';
import 'package:customer_e_commerce/features/user/presentation/pages/Home/home_screen.dart';
import 'package:customer_e_commerce/features/user/presentation/pages/Login/login_screen.dart';
import 'package:customer_e_commerce/features/user/presentation/pages/Register/registered_screen.dart';
import 'package:customer_e_commerce/features/user/presentation/pages/Splash/splash_screen.dart';
import 'package:customer_e_commerce/features/user/presentation/pages/SuccesfulLogin/successful_login_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
      initialLocation: MyRoutes.splashRoute,
      observers: [RouteObserver()],
      redirect: (context, state) {
        return null;
      },
      routes: [
        GoRoute(
            path: MyRoutes.splashRoute,
            builder: (context, state) => SplashScreen()),
        GoRoute(
            path: MyRoutes.loginRoute,
            builder: (context, state) => LoginScreen()),
        GoRoute(
            path: MyRoutes.registerRoute,
            builder: (context, state) => RegisteredScreen()),
        GoRoute(
            path: MyRoutes.succesfulloginRoute,
            builder: (context, state) => SuccessfulLoginScreen()),
        GoRoute(
            path: MyRoutes.networkerrorRoute,
            builder: (context, state) => NetworkErrorScreen()),
        GoRoute(
          path: MyRoutes.homeRoute,
          builder: (context, state) => HomeScreen(),
        )
      ]);
}

class RoutesObserver extends NavigatorObserver {
  static String? lastvisitedRoute;
  @override
  void didPush(Route route, Route? previousRoute) {
    if (route.settings.name != null) {
      lastvisitedRoute = previousRoute!.settings.name;
    }
    super.didPush(route, previousRoute);
  }

  void didPop(Route route, Route? previousRoute) {
    if (previousRoute != null) {
      lastvisitedRoute = previousRoute.settings.name;
    }
    super.didPop(route, previousRoute);
  }
}
 */

import 'package:customer_e_commerce/core/router/my_routes.dart';
import 'package:customer_e_commerce/features/user/presentation/bloc/CheckNetwork/connectivity_bloc.dart';
import 'package:customer_e_commerce/features/user/presentation/pages/Register/registered_screen.dart';
import 'package:customer_e_commerce/features/user/presentation/pages/NetworkError/network_error_screen.dart';
import 'package:customer_e_commerce/features/user/presentation/pages/Home/home_screen.dart';
import 'package:customer_e_commerce/features/user/presentation/pages/Login/login_screen.dart';
import 'package:customer_e_commerce/features/user/presentation/pages/Splash/splash_screen.dart';
import 'package:customer_e_commerce/features/user/presentation/pages/SuccesfulLogin/successful_login_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: MyRoutes.splashRoute,
    redirect: (context, state) {
      print("App Router file state is ${state}");
      final connectivityState = context.read<ConnectivityBloc>().state;
      if (connectivityState is ConnectivityDisconnected) {
        return MyRoutes.networkerrorRoute;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: MyRoutes.splashRoute,
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: MyRoutes.loginRoute,
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: MyRoutes.registerRoute,
        builder: (context, state) => RegisteredScreen(),
      ),
      GoRoute(
        path: MyRoutes.succesfulloginRoute,
        builder: (context, state) => SuccessfulLoginScreen(),
      ),
      GoRoute(
        path: MyRoutes.networkerrorRoute,
        builder: (context, state) => NetworkErrorScreen(),
      ),
      GoRoute(
        path: MyRoutes.homeRoute,
        builder: (context, state) => HomeScreen(),
      ),
    ],
  );
}
/* 
class RoutesObserver extends NavigatorObserver {
  static String? lastVisitedRoute;

  @override
  void didPush(Route route, Route? previousRoute) {
    if (route.settings.name != null) {
      lastVisitedRoute = previousRoute?.settings.name;
    }
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    if (previousRoute != null) {
      lastVisitedRoute = previousRoute.settings.name;
    }
    super.didPop(route, previousRoute);
  }
}
 */