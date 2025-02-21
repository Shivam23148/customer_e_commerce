import 'package:customer_e_commerce/core/theme/app_colors.dart';
import 'package:customer_e_commerce/core/utils/validators.dart';
import 'package:customer_e_commerce/features/user/presentation/widgets/my_elevated_button.dart';
import 'package:customer_e_commerce/size_config.dart';
import 'package:flutter/material.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: getRelativeWidth(0.03)),
            child: Container(
              padding: EdgeInsets.all(16),
              height: getRelativeHeight(0.55),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Let's get started",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: getRelativeWidth(0.08)),
                  ),
                  SizedBox(
                    height: getRelativeHeight(0.05),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "First name",
                              style:
                                  TextStyle(fontSize: getRelativeWidth(0.05)),
                            ),
                            SizedBox(
                              height: getRelativeHeight(0.01),
                            ),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: _firstNameController,
                              validator: Validators.validateName,
                              decoration: InputDecoration(
                                hintText: "Enter first name",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: getRelativeWidth(0.02),
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Last name",
                              style:
                                  TextStyle(fontSize: getRelativeWidth(0.05)),
                            ),
                            SizedBox(
                              height: getRelativeHeight(0.01),
                            ),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: _lastNameController,
                              validator: Validators.validateName,
                              decoration: InputDecoration(
                                hintText: "Enter last name",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: getRelativeHeight(0.03),
                  ),
                  Text(
                    "Phone number",
                    style: TextStyle(fontSize: getRelativeWidth(0.05)),
                  ),
                  SizedBox(
                    height: getRelativeHeight(0.01),
                  ),
                  Row(
                    children: [
                      Text(
                        "+91",
                        style: TextStyle(fontSize: getRelativeWidth(0.05)),
                      ),
                      SizedBox(
                        width: getRelativeWidth(0.02),
                      ),
                      Flexible(
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          controller: _phoneController,
                          validator: Validators.validateEmail,
                          decoration: InputDecoration(
                            hintText: "Enter your phone number",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: getRelativeHeight(0.05),
                  ),
                  MyElevatedButton(
                      onPressed: () {
                        print("Get Started button pressed");
                      },
                      text: "Get Started →")
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
