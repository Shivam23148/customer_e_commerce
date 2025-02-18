import 'package:customer_e_commerce/core/di/service_locator.dart';
import 'package:customer_e_commerce/core/router/my_routes.dart';
import 'package:customer_e_commerce/core/utils/validators.dart';
import 'package:customer_e_commerce/features/user/presentation/bloc/login/login_bloc.dart';
import 'package:customer_e_commerce/features/user/presentation/widgets/my_elevated_button.dart';
import 'package:customer_e_commerce/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final _formSignKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<LoginBloc>(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: Colors.white),
        body: Form(
          key: _formSignKey,
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: getRelativeWidth(0.05)),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0XFFF6FF50),
                  borderRadius: BorderRadius.circular(10),
                ),
                width: getRelativeWidth(0.9),
                child: SingleChildScrollView(
                  child: BlocListener<LoginBloc, LoginState>(
                    listener: (context, state) {
                      if (state is LoginSuccess) {
                        GoRouter.of(context).go(MyRoutes.homeRoute);
                      } else if (state is LoginFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.errorMessage)),
                        );
                      }
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0XFFFD4040),
                          ),
                        ),
                        SizedBox(height: getRelativeHeight(0.03)),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text("Email",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        _EmailField(
                          controller: _emailController,
                        ),
                        SizedBox(height: getRelativeHeight(0.02)),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text("Password",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        _PasswordField(
                          controller: _passwordController,
                        ),
                        SizedBox(height: getRelativeHeight(0.03)),
                        _LoginButton(
                          emailController: _emailController,
                          formKey: _formSignKey,
                          passwordController: _passwordController,
                        ),
                        SizedBox(height: getRelativeHeight(0.02)),
                        GestureDetector(
                          onTap: () => GoRouter.of(context)
                              .pushReplacement(MyRoutes.registerRoute),
                          child: const Text(
                            "Create New Account",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailField extends StatelessWidget {
  final TextEditingController controller;
  const _EmailField({required this.controller});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      validator: Validators.validateEmail,
      decoration: InputDecoration(
        hintText: "hello@example.com",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

class _PasswordField extends StatefulWidget {
  final TextEditingController controller;
  const _PasswordField({required this.controller});
  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: _obscureText,
      validator: Validators.validatePassword,
      decoration: InputDecoration(
        hintText: "********",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        suffixIcon: IconButton(
          icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => _obscureText = !_obscureText),
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const _LoginButton({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return MyElevatedButton(
          onPressed: state is LoginLoading
              ? null
              : () {
                  if (formKey.currentState!.validate()) {
                    final email = emailController.text.trim();
                    final password = passwordController.text.trim();
                    context
                        .read<LoginBloc>()
                        .add(LoginSubmitted(email: email, password: password));
                  }
                },
          text: state is LoginLoading ? "Logging in..." : "Login",
        );
      },
    );
  }
}
