import 'package:customer_e_commerce/core/di/service_locator.dart';
import 'package:customer_e_commerce/core/router/my_routes.dart';
import 'package:customer_e_commerce/features/user/domain/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  GoRouter.of(context).push(MyRoutes.addresspopupRoute);
                },
                child: Text("Address Popup Test")),
            ElevatedButton(
              child: Text("Logout"),
              onPressed: () async {
                await serviceLocator<AuthRepository>().logout();
                await Future.delayed(Duration(milliseconds: 100));
                GoRouter.of(context).go(MyRoutes.splashRoute);
              },
            ),
          ],
        ),
      )),
    );
  }
}
