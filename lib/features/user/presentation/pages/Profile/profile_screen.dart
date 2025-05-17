import 'package:customer_e_commerce/core/di/service_locator.dart';
import 'package:customer_e_commerce/core/router/my_routes.dart';
import 'package:customer_e_commerce/core/theme/app_colors.dart';
import 'package:customer_e_commerce/core/utils/assets_manager.dart';
import 'package:customer_e_commerce/core/utils/toast_util.dart';
import 'package:customer_e_commerce/core/utils/validators.dart';
import 'package:customer_e_commerce/features/user/data/models/profile_models.dart';
import 'package:customer_e_commerce/features/user/presentation/bloc/Profile/profile_bloc.dart';
import 'package:customer_e_commerce/features/user/presentation/widgets/my_elevated_button.dart';
import 'package:customer_e_commerce/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    print("Profile Screen build called");
    return BlocProvider(
      create: (context) => serviceLocator<ProfileBloc>(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          title: Text(
            "Profile",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: SafeArea(
          minimum: EdgeInsets.symmetric(horizontal: getRelativeWidth(0.05)),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    AssetsManager.profileIcon,
                    height: getRelativeHeight(0.2),
                  ),
                  StreamBuilder<Profile>(
                      stream: serviceLocator<ProfileBloc>().profileStream(),
                      builder: (context, snapshot) {
                        print("Profile data snapshot is : ${snapshot}");
                        if (snapshot.hasError) {}
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          );
                        }
                        final profile = snapshot.data;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${profile?.firstName} ${profile?.lastName}",
                              style: TextStyle(
                                  fontSize: getRelativeWidth(0.06),
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: getRelativeHeight(0.005),
                            ),
                            Text(
                              "${profile?.email}",
                              style:
                                  TextStyle(fontSize: getRelativeWidth(0.04)),
                            ),
                            SizedBox(
                              height: getRelativeHeight(0.005),
                            ),
                            Text(
                              "+91 ${profile?.phone}",
                              style:
                                  TextStyle(fontSize: getRelativeWidth(0.04)),
                            )
                          ],
                        );
                      })
                ],
              ),
              SizedBox(
                height: getRelativeHeight(0.0),
              ),
              ProfileItem(
                imagePath: AssetsManager.accountsettingIcon,
                subtitle: "Edit profile and login details",
                title: "Account Settings",
                onTap: () {
                  showAccountSettings(context);
                },
              ),
              ProfileItem(
                imagePath: AssetsManager.addressinfoIcon,
                subtitle: "Manage your delivery addresses",
                title: "Address Info",
                onTap: () {
                  GoRouter.of(context).push(MyRoutes.addressRoute);
                },
              ),
              ProfileItem(
                  imagePath: AssetsManager.orderHistoryIcon,
                  subtitle: "View and track past orders",
                  title: "Order History"),
              ProfileItem(
                  imagePath: AssetsManager.helpsupportIcon,
                  subtitle: "Get help or report an issue",
                  title: "Help & Support"),
              ProfileItem(
                  imagePath: AssetsManager.privacysecurityIcon,
                  subtitle: "Control your privacy and security settings",
                  title: "Privacy & Security"),
              ProfileItem(
                  imagePath: AssetsManager.logoutIcon,
                  subtitle: "Sign out of your account",
                  title: "Logout"),
            ],
          ),
        ),
      ),
    );
  }

  void showAccountSettings(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return DraggableScrollableSheet(
              expand: false,
              snap: true,
              initialChildSize: 0.26,
              minChildSize: 0.25,
              maxChildSize: 0.26,
              builder: (_, controller) {
                return SingleChildScrollView(
                  controller: controller,
                  child: Column(
                    children: [
                      AccountSettingItem(
                        icon: Icons.edit,
                        buttonText: "Edit Profile",
                        onTap: () => _showFeatureSheet(context, "Edit Profile"),
                      ),
                      AccountSettingItem(
                        icon: Icons.phone,
                        buttonText: "Update Phone Number",
                        onTap: () => _showFeatureSheet(context, "Update Phone"),
                      ),
                      AccountSettingItem(
                        icon: Icons.lock,
                        buttonText: "Update Password",
                        onTap: () =>
                            _showFeatureSheet(context, "Update Password"),
                      ),
                    ],
                  ),
                );
              });
        });
  }

  void _showFeatureSheet(BuildContext context, String type) {
    final _formKey = GlobalKey<FormState>();

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        backgroundColor: AppColors.background,
        builder: (context) {
          if (type == "Edit Profile") {
            final TextEditingController _firstNameController =
                TextEditingController();
            final TextEditingController _lastNameController =
                TextEditingController();
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: getRelativeWidth(0.05),
                  right: getRelativeWidth(0.05)),
              child: SizedBox(
                height: getRelativeHeight(0.4),
                child: BlocConsumer<ProfileBloc, ProfileState>(
                  bloc: serviceLocator<ProfileBloc>(),
                  listener: (context, state) {
                    if (state is ProfileEditedState) {
                      ToastUtil.showToast("Profile Updated Successfully",
                          AppColors.successColor);
                      Future.delayed(Duration(seconds: 2), () {
                        GoRouter.of(context).pop();
                      });
                    } else if (state is ProfileErrorMessage) {
                      ToastUtil.showToast(state.message, AppColors.primary);
                    }
                  },
                  builder: (context, state) {
                    print("State of profile screen is : ${state}");
                    if (state is ProfileLoadingState) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    } else if (state is ProfileEditedState) {
                      return Center(
                        child: LottieBuilder.asset(
                            AssetsManager.successLottieIcon),
                      );
                    }
                    return Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "First name",
                                      style: TextStyle(
                                          fontSize: getRelativeWidth(0.05),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: getRelativeHeight(0.01),
                                    ),
                                    TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      controller: _firstNameController,
                                      textCapitalization:
                                          TextCapitalization.words,
                                      validator: Validators.validateName,
                                      decoration: InputDecoration(
                                        hintText: "Enter first name",
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
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
                                      style: TextStyle(
                                          fontSize: getRelativeWidth(0.05),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: getRelativeHeight(0.01),
                                    ),
                                    TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      controller: _lastNameController,
                                      textCapitalization:
                                          TextCapitalization.words,
                                      validator: Validators.validateName,
                                      decoration: InputDecoration(
                                        hintText: "Enter last name",
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: getRelativeHeight(0.04),
                          ),
                          MyElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  serviceLocator<ProfileBloc>()
                                    ..add(EditProfileDataEvent(
                                        firstName:
                                            _firstNameController.text.trim(),
                                        lastName:
                                            _lastNameController.text.trim()));
                                  Future.delayed(Duration(seconds: 3), () {
                                    serviceLocator<ProfileBloc>()
                                      ..add(ProfileResetEvent());
                                  });
                                }
                              },
                              text: "Update Profile")
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          } else if (type == "Update Password") {
            final _formKey = GlobalKey<FormState>();
            final _currentPasswordController = TextEditingController();
            final _newPasswordController = TextEditingController();
            final _confirmPasswordController = TextEditingController();

            bool _obscureCurrentPassword = true;
            bool _obscureNewPassword = true;
            bool _currentPasswordVerified = false;
            return StatefulBuilder(builder: (context, setModalState) {
              return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    left: getRelativeWidth(0.05),
                    right: getRelativeWidth(0.05)),
                child: SizedBox(
                  height: getRelativeHeight(0.5),
                  child: BlocConsumer<ProfileBloc, ProfileState>(
                    bloc: serviceLocator<ProfileBloc>(),
                    listener: (context, state) {
                      if (state is ProfileErrorMessage) {
                        print(
                            "Updating password profile bloc error: ${state.message}");
                        ToastUtil.showToast(state.message, AppColors.primary);
                      }
                      if (state is CurrentPasswordVerified) {
                        setModalState(() => _currentPasswordVerified = true);
                        ToastUtil.showToast("Current password verified",
                            AppColors.successColor);
                      }
                      if (state is UpdatePasswordSuccess) {
                        GoRouter.of(context).pop();
                        ToastUtil.showToast("Password updated successfully!",
                            AppColors.successColor);
                      }
                    },
                    builder: (context, state) {
                      print("Update password state is :$state");
                      if (state is ProfileLoadingState) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        );
                      }
                      return Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Update Password",
                                style: TextStyle(
                                    fontSize: getRelativeWidth(0.07),
                                    fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: getRelativeHeight(0.05),
                            ),
                            if (!_currentPasswordVerified) ...[
                              TextFormField(
                                  controller: _currentPasswordController,
                                  decoration: InputDecoration(
                                    hintText: "Enter Current Password",
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    suffixIcon: IconButton(
                                      icon: Icon(_obscureCurrentPassword
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                      onPressed: () => setModalState(() =>
                                          _obscureCurrentPassword =
                                              !_obscureCurrentPassword),
                                    ),
                                  ),
                                  obscureText: _obscureCurrentPassword,
                                  validator: Validators.validatePassword),
                              SizedBox(height: getRelativeHeight(0.02)),
                              MyElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    serviceLocator<ProfileBloc>().add(
                                      VerifyPasswordEvent(
                                        _currentPasswordController.text.trim(),
                                      ),
                                    );
                                  }
                                },
                                text: state is ProfileLoadingState
                                    ? "Processing...."
                                    : "Verify Password",
                              ),
                            ] else ...[
                              TextFormField(
                                controller: _newPasswordController,
                                decoration: InputDecoration(
                                  hintText: "Enter New Password",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  suffixIcon: IconButton(
                                    icon: Icon(_obscureNewPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                    onPressed: () => setModalState(() =>
                                        _obscureNewPassword =
                                            !_obscureNewPassword),
                                  ),
                                ),
                                obscureText: _obscureNewPassword,
                                validator: Validators.validatePassword,
                              ),
                              SizedBox(height: getRelativeHeight(0.02)),
                              TextFormField(
                                  controller: _confirmPasswordController,
                                  decoration: InputDecoration(
                                    hintText: "Re-enter New Password",
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    suffixIcon: IconButton(
                                      icon: Icon(_obscureNewPassword
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                      onPressed: () => setModalState(() =>
                                          _obscureNewPassword =
                                              !_obscureNewPassword),
                                    ),
                                  ),
                                  obscureText: _obscureNewPassword,
                                  validator: Validators.validatePassword),
                              SizedBox(height: getRelativeHeight(0.02)),
                              state is ProfileLoadingState
                                  ? CircularProgressIndicator(
                                      color: AppColors.primary,
                                    )
                                  : MyElevatedButton(
                                      onPressed: state is ProfileLoadingState
                                          ? null
                                          : () {
                                              print(
                                                  "New Password Profile screen : ${_newPasswordController.text} ${_confirmPasswordController.text}");

                                              if (_formKey.currentState!
                                                      .validate() &&
                                                  (_newPasswordController
                                                          .text ==
                                                      _confirmPasswordController
                                                          .text)) {
                                                serviceLocator<ProfileBloc>()
                                                    .add(
                                                  UpdatePasswordWithNew(
                                                    _currentPasswordController
                                                        .text,
                                                    _newPasswordController.text,
                                                  ),
                                                );
                                              } else {
                                                ToastUtil.showToast(
                                                    "Password do not match!",
                                                    AppColors.primary);
                                              }
                                            },
                                      text: "Update Password",
                                    ),
                              TextButton(
                                onPressed: () {
                                  setModalState(
                                      () => _currentPasswordVerified = false);
                                },
                                child: const Text('Re-enter current password'),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            });
          } else if (type == "Update Phone") {
            final _formKey = GlobalKey<FormState>();
            final _phoneController = TextEditingController();
            return StatefulBuilder(builder: (context, setModalState) {
              return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    left: getRelativeWidth(0.05),
                    right: getRelativeWidth(0.05)),
                child: SizedBox(
                  height: getRelativeHeight(0.4),
                  child: BlocConsumer<ProfileBloc, ProfileState>(
                    bloc: serviceLocator<ProfileBloc>(),
                    listener: (context, state) {
                      if (state is ProfileErrorMessage) {
                        ToastUtil.showToast(state.message, AppColors.primary);
                      }

                      if (state is PhoneUpdatedState) {
                        GoRouter.of(context).pop();
                        ToastUtil.showToast("Phone updated successfully!",
                            AppColors.successColor);
                      }
                    },
                    builder: (context, state) {
                      if (state is ProfileLoadingState) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        );
                      }
                      return Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Update Phone",
                                style: TextStyle(
                                    fontSize: getRelativeWidth(0.07),
                                    fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: getRelativeHeight(0.05),
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
                                    maxLength: 10,
                                    validator: Validators.validatePhone,
                                    decoration: InputDecoration(
                                      hintText: "Enter your phone number",
                                      counterText: "",
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
                                  if (_formKey.currentState!.validate()) {
                                    serviceLocator<ProfileBloc>().add(
                                        UpdatePhoneEvent(
                                            _phoneController.text));
                                  }
                                },
                                text: "Save Phone")
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            });
          } else {
            return Text("Unknown State");
          }
        });
  }
}

class ProfileItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final Function()? onTap;

  const ProfileItem(
      {super.key,
      this.onTap,
      required this.imagePath,
      required this.subtitle,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          contentPadding:
              EdgeInsets.symmetric(horizontal: getRelativeWidth(0.01)),
          leading: Container(
            height: getRelativeHeight(0.07),
            width: getRelativeWidth(0.12),
            decoration: BoxDecoration(
                color: Colors.grey.shade200, shape: BoxShape.circle),
            child: Center(child: Image.asset(imagePath)),
          ),
          title: Text(title),
          subtitle: Text(
            subtitle,
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ),
        Divider(
          height: 1,
          color: Colors.grey.shade200,
        )
      ],
    );
  }
}

class AccountSettingItem extends StatelessWidget {
  final IconData? icon;
  final String buttonText;
  final Function()? onTap;

  const AccountSettingItem(
      {super.key, required this.icon, required this.buttonText, this.onTap});
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(
            icon,
            color: AppColors.primary,
          ),
          title: Text(buttonText),
          onTap: onTap,
        ),
        Divider(
          indent: 10,
          endIndent: 10,
          height: 1,
          color: Colors.grey.shade200,
        )
      ],
    );
  }
}
