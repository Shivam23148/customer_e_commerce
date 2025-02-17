import 'package:customer_e_commerce/core/router/my_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text("Register screen"),
          onPressed: () {
            GoRouter.of(context).push(MyRoutes.registerRoute);
          },
        ),
      ),
    );
  }
}
