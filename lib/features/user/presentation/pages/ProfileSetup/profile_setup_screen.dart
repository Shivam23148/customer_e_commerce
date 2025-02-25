import 'package:customer_e_commerce/core/router/my_routes.dart';
import 'package:customer_e_commerce/core/theme/app_colors.dart';
import 'package:customer_e_commerce/core/utils/toast_util.dart';
import 'package:customer_e_commerce/core/utils/validators.dart';
import 'package:customer_e_commerce/features/user/presentation/bloc/ProfileSetup/profile_setup_bloc.dart';
import 'package:customer_e_commerce/features/user/presentation/widgets/my_elevated_button.dart';
import 'package:customer_e_commerce/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
  final TextEditingController _homeController = TextEditingController();
  final TextEditingController _buildingController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose

    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _buildingController.dispose();
    _homeController.dispose();
    _landmarkController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    super.dispose();
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
        child: SafeArea(
          minimum: EdgeInsets.symmetric(horizontal: getRelativeWidth(0.03)),
          child: Center(
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: SingleChildScrollView(
                child: BlocListener<ProfileSetupBloc, ProfileSetupState>(
                  listener: (context, state) {
                    if (state is ProfileSaved) {
                      ToastUtil.showToast(
                          "Information Saved", AppColors.background);
                      GoRouter.of(context).go(MyRoutes.homeRoute);
                    }
                    if (state is ProfileError) {
                      ToastUtil.showToast(state.message, AppColors.primary);
                    }
                  },
                  child: Column(
                    children: [
                      BlocBuilder<ProfileSetupBloc, ProfileSetupState>(
                        builder: (context, state) {
                          if (state is ProfileSetupLoading) {
                            return CircularProgressIndicator(
                              color: AppColors.background,
                            );
                          }
                          if (state is ProfileSetupInitial) {
                            return Column(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "First name",
                                            style: TextStyle(
                                                fontSize:
                                                    getRelativeWidth(0.05)),
                                          ),
                                          SizedBox(
                                            height: getRelativeHeight(0.01),
                                          ),
                                          TextFormField(
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            controller: _firstNameController,
                                            validator: Validators.validateName,
                                            decoration: InputDecoration(
                                              hintText: "Enter first name",
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Last name",
                                            style: TextStyle(
                                                fontSize:
                                                    getRelativeWidth(0.05)),
                                          ),
                                          SizedBox(
                                            height: getRelativeHeight(0.01),
                                          ),
                                          TextFormField(
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            controller: _lastNameController,
                                            validator: Validators.validateName,
                                            decoration: InputDecoration(
                                              hintText: "Enter last name",
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
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
                                  style: TextStyle(
                                      fontSize: getRelativeWidth(0.05)),
                                ),
                                SizedBox(
                                  height: getRelativeHeight(0.01),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "+91",
                                      style: TextStyle(
                                          fontSize: getRelativeWidth(0.05)),
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
                                              borderRadius:
                                                  BorderRadius.circular(10)),
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
                                      final name = _firstNameController.text +
                                          _lastNameController.text;
                                      context.read<ProfileSetupBloc>().add(
                                          SaveBasicInfoEvent(
                                              name: name.trim(),
                                              phone: _phoneController.text
                                                  .trim()));
                                      print("Get Started button pressed");
                                    },
                                    text: "Get Started →")
                              ],
                            );
                          }
                          if (state is ProfileBasicInfoSaved) {
                            return SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Add Address",
                                    style: TextStyle(
                                        fontSize: getRelativeWidth(0.09),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: getRelativeHeight(0.03),
                                  ),
                                  Text("House No."),
                                  TextFormField(
                                    keyboardType: TextInputType.name,
                                    controller: _homeController,
                                    decoration: InputDecoration(
                                      hintText: "Enter your house no.",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: getRelativeHeight(0.02),
                                  ),
                                  Text("Building No."),
                                  TextFormField(
                                    keyboardType: TextInputType.name,
                                    controller: _buildingController,
                                    decoration: InputDecoration(
                                      hintText: "Enter first name",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: getRelativeHeight(0.02),
                                  ),
                                  Text("Landmark/ Nearby place"),
                                  TextFormField(
                                    keyboardType: TextInputType.name,
                                    controller: _landmarkController,
                                    decoration: InputDecoration(
                                      hintText:
                                          "Enter your Landmark/ Nearby place",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: getRelativeHeight(0.02),
                                  ),
                                  Text("City"),
                                  TextFormField(
                                    keyboardType: TextInputType.name,
                                    controller: _cityController,
                                    decoration: InputDecoration(
                                      hintText: "Enter your city",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: getRelativeHeight(0.02),
                                  ),
                                  Text("State"),
                                  TextFormField(
                                    keyboardType: TextInputType.name,
                                    controller: _buildingController,
                                    decoration: InputDecoration(
                                      hintText: "Enter your state",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: getRelativeHeight(0.02),
                                  ),
                                  Text("Zip Code"),
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: _zipController,
                                    decoration: InputDecoration(
                                      hintText: "Enter zip code",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: getRelativeHeight(0.03),
                                  ),
                                  MyElevatedButton(
                                      onPressed: () {
                                        print("Save Address button pressed");
                                        context.read<ProfileSetupBloc>().add(
                                            SaveAddressEvent(
                                                house:
                                                    _homeController.text.trim(),
                                                buildingNo: _buildingController
                                                    .text
                                                    .trim(),
                                                landmark: _landmarkController
                                                    .text
                                                    .trim(),
                                                city:
                                                    _cityController.text.trim(),
                                                state: _stateController.text
                                                    .trim(),
                                                zip: _zipController.text
                                                    .trim()));
                                      },
                                      text: "Save Address")
                                ],
                              ),
                            );
                          }
                          return CircularProgressIndicator(
                            color: AppColors.primary,
                          );
                        },
                      ),
                    ],
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
