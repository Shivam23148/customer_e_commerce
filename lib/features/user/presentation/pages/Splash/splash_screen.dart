import 'package:customer_e_commerce/core/router/my_routes.dart';
import 'package:customer_e_commerce/core/theme/app_colors.dart';
import 'package:customer_e_commerce/core/utils/assets_manager.dart';
import 'package:customer_e_commerce/features/user/presentation/bloc/Auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateToHomeScreen();
  }

  void navigateToHomeScreen() async {
    await Future.delayed(Duration(milliseconds: 1800));
    if (!mounted) return null;
    final authbloc = context.read<AuthBloc>();
    final state = authbloc.state;
    if (state is AuthAuthenticated) {
      GoRouter.of(context).go(MyRoutes.homeRoute);
    } else {
      GoRouter.of(context).go(MyRoutes.loginRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primary,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(AssetsManager.chipsAdminIcon),
                Image.asset(AssetsManager.chipsAdminTextImage)
              ],
            ),
            Image.asset(AssetsManager.chipsImage)
          ],
        ));
  }
}
