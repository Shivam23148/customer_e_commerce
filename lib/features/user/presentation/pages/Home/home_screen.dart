import 'package:customer_e_commerce/core/router/my_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Center(
        child: ElevatedButton(
          child: Text("Login screen"),
          onPressed: () {
            GoRouter.of(context).push(MyRoutes.loginRoute);
          },
        ),
      )),
    );
  }
}
