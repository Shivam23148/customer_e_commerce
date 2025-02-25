import 'package:customer_e_commerce/core/router/my_routes.dart';
import 'package:customer_e_commerce/core/theme/app_colors.dart';
import 'package:customer_e_commerce/core/utils/assets_manager.dart';
import 'package:customer_e_commerce/core/utils/toast_util.dart';
import 'package:customer_e_commerce/core/utils/validators.dart';
import 'package:customer_e_commerce/features/user/presentation/bloc/Register/register_bloc.dart';
import 'package:customer_e_commerce/features/user/presentation/widgets/my_elevated_button.dart';
import 'package:customer_e_commerce/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class RegisteredScreen extends StatefulWidget {
  const RegisteredScreen({super.key});

  @override
  State<RegisteredScreen> createState() => _RegisteredScreenState();
}

class _RegisteredScreenState extends State<RegisteredScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();

    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
      ),
      body: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is RegistrationErrorState) {
            ToastUtil.showToast(state.message, AppColors.primary);
          }
          if (state is RegistrationCompletedState) {
            ToastUtil.showToast(
                "Registration Successful!", AppColors.textPrimary);
            GoRouter.of(context).go(MyRoutes.profilesetupRoute);
          }
        },
        child: Form(
            key: _formKey,
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getRelativeWidth(0.05),
                ),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(10)),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          "SIGNUP",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(
                          height: getRelativeHeight(0.05),
                        ),
                        BlocBuilder<RegisterBloc, RegisterState>(
                          builder: (context, state) {
                            if (state is RegisterLoading) {
                              return LottieBuilder.asset(
                                  AssetsManager.emailverification);
                            }
                            if (state is RegisterInitial) {
                              return Column(
                                children: [
                                  TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    controller: _emailController,
                                    validator: Validators.validateEmail,
                                    decoration: InputDecoration(
                                      hintText: "hello@example.com",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: getRelativeHeight(0.05),
                                  ),
                                  MyElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          print(
                                              "Registered Email for verificatino ${_emailController.text}");
                                          context.read<RegisterBloc>().add(
                                              SendVerificationEmailEvent(
                                                  email: _emailController.text
                                                      .trim()));
                                        }
                                      },
                                      text: "Check Email")
                                ],
                              );
                            }
                            if (state is EmailSentState) {
                              return LottieBuilder.asset(
                                  AssetsManager.emailverification);
                            }
                            if (state is EmailVerifiedState) {
                              return Column(
                                children: [
                                  const Align(
                                    alignment: Alignment.topLeft,
                                    child: Text("Password",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  SizedBox(height: getRelativeHeight(0.01)),
                                  TextFormField(
                                    obscureText: _obscureText,
                                    controller: _passwordController,
                                    validator: Validators.validatePassword,
                                    decoration: InputDecoration(
                                      hintText: "********",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      suffixIcon: IconButton(
                                        icon: Icon(_obscureText
                                            ? Icons.visibility_off
                                            : Icons.visibility),
                                        onPressed: () => setState(
                                            () => _obscureText = !_obscureText),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: getRelativeHeight(0.01),
                                  ),
                                  const Align(
                                    alignment: Alignment.topLeft,
                                    child: Text("Confirm Password",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  SizedBox(height: getRelativeHeight(0.01)),
                                  TextFormField(
                                    obscureText: _obscureText,
                                    controller: _confirmPasswordController,
                                    validator: Validators.validatePassword,
                                    decoration: InputDecoration(
                                      hintText: "********",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      suffixIcon: IconButton(
                                        icon: Icon(_obscureText
                                            ? Icons.visibility_off
                                            : Icons.visibility),
                                        onPressed: () => setState(
                                            () => _obscureText = !_obscureText),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: getRelativeHeight(0.05),
                                  ),
                                  MyElevatedButton(
                                      onPressed: () {
                                        print(
                                            "Registerd credential for registered screen : ${_emailController.text} ${_passwordController.text} ${_confirmPasswordController.text}");
                                        if (_formKey.currentState!.validate() &&
                                            (_passwordController.text ==
                                                _confirmPasswordController
                                                    .text)) {
                                          context.read<RegisterBloc>().add(
                                              CompleteRegistrationEvent(
                                                  email: _emailController.text
                                                      .trim(),
                                                  password: _passwordController
                                                      .text
                                                      .trim()));
                                        } else {
                                          ToastUtil.showToast(
                                              "Password do not match!",
                                              AppColors.primary);
                                        }
                                      },
                                      text: "Submit")
                                ],
                              );
                            }
                            return LottieBuilder.asset(
                                AssetsManager.emailverification);
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
