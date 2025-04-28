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

import 'package:customer_e_commerce/core/di/service_locator.dart';
import 'package:customer_e_commerce/core/router/my_routes.dart';
import 'package:customer_e_commerce/features/user/data/models/auth_data.dart';
import 'package:customer_e_commerce/features/user/data/models/product_detail_data.dart';
import 'package:customer_e_commerce/features/user/domain/repositories/auth_repository.dart';
import 'package:customer_e_commerce/features/user/presentation/bloc/Auth/auth_bloc.dart';
import 'package:customer_e_commerce/features/user/presentation/bloc/CheckNetwork/connectivity_bloc.dart';
import 'package:customer_e_commerce/features/user/presentation/bloc/login/login_bloc.dart';
import 'package:customer_e_commerce/features/user/presentation/pages/AddressPopup/address_pop_up_testscreen.dart';
import 'package:customer_e_commerce/features/user/presentation/pages/Cart/cart_screen.dart';
import 'package:customer_e_commerce/features/user/presentation/pages/MainScreen/main_screen.dart';
import 'package:customer_e_commerce/features/user/presentation/pages/ProductDetail/product_detail_screen.dart';
import 'package:customer_e_commerce/features/user/presentation/pages/ProfileSetup/profile_setup_screen.dart';
import 'package:customer_e_commerce/features/user/presentation/pages/Register/registered_screen.dart';
import 'package:customer_e_commerce/features/user/presentation/pages/NetworkError/network_error_screen.dart';
import 'package:customer_e_commerce/features/user/presentation/pages/Home/home_screen.dart';
import 'package:customer_e_commerce/features/user/presentation/pages/Login/login_screen.dart';
import 'package:customer_e_commerce/features/user/presentation/pages/Splash/splash_screen.dart';
import 'package:customer_e_commerce/features/user/presentation/pages/SuccesfulLogin/successful_login_screen.dart';
import 'package:customer_e_commerce/features/user/presentation/pages/Wishlist/wishlist_screen.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: MyRoutes.splashRoute,
    redirect: (context, state) {
      print("App Router file state is ${state.fullPath}");
      final connectivityState = context.read<ConnectivityBloc>().state;
      if (connectivityState is ConnectivityDisconnected) {
        return MyRoutes.networkerrorRoute;
      }
      final authState = context.read<AuthBloc>().state;
      final isAuthenticated = authState is AuthAuthenticated;

      // Define public routes (routes that don't require authentication)
      final publicRoutes = [
        MyRoutes.splashRoute,
        MyRoutes.networkerrorRoute,
        MyRoutes.loginRoute,
        MyRoutes.registerRoute, // Add login route if you have one
      ];

      // If the user is not authenticated and tries to access a protected route, redirect to splash/login
      if (!isAuthenticated && !publicRoutes.contains(state.uri.path)) {
        return MyRoutes.splashRoute; // or MyRoutes.loginRoute
      }

      // If the user is authenticated and tries to access the splash/login route, redirect to home
      if (isAuthenticated && publicRoutes.contains(state.uri.path)) {
        return MyRoutes.homeRoute;
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
        builder: (context, state) => BlocProvider(
          create: (context) =>
              LoginBloc(authRepository: serviceLocator<AuthRepository>()),
          child: LoginScreen(),
        ),
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

      GoRoute(
        path: MyRoutes.productDetailRoute,
        builder: (context, state) {
          final data = state.extra as ProductDetailData;
          return ProductDetailScreen(
            shopId: data.shopId,
            ownerId: data.ownerId,
            product: data.product,
          );
        },
      ),

      GoRoute(
        path: MyRoutes.cartRoute,
        builder: (context, state) => CartScreen(),
      ),

      GoRoute(
        path: MyRoutes.wishlistRoute,
        builder: (context, state) {
          return WishlistScreen();
        },
      ),
      GoRoute(
        path: MyRoutes.profilesetupRoute,
        builder: (context, state) {
          final authData = state.extra as AuthData;
          return ProfileSetupScreen(
            email: authData.email,
            password: authData.password,
          );
        },
      ),
      GoRoute(
        path: MyRoutes.mainScreenRoute,
        builder: (context, state) => MainScreen(),
      ),

      //Test

      GoRoute(
        path: MyRoutes.addresspopupRoute,
        builder: (context, state) => AddressPopUpTestscreen(),
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