import 'package:customer_e_commerce/core/router/my_routes.dart';
import 'package:customer_e_commerce/core/theme/app_colors.dart';
import 'package:customer_e_commerce/core/utils/toast_util.dart';
import 'package:customer_e_commerce/core/utils/validators.dart';
import 'package:customer_e_commerce/features/user/data/models/address_model.dart';
import 'package:customer_e_commerce/features/user/data/models/profile_models.dart';
import 'package:customer_e_commerce/features/user/presentation/bloc/ProfileSetup/profile_setup_bloc.dart';
import 'package:customer_e_commerce/features/user/presentation/widgets/my_elevated_button.dart';
import 'package:customer_e_commerce/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfileSetupScreen extends StatefulWidget {
  final String email;
  final String password;
  ProfileSetupScreen({super.key, required this.email, required this.password});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _houseNoController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Request location permission when address screen appears
    /* WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isAddressScreen()) {
        context.read<ProfileSetupBloc>().add(RequestLocationPermissionEvent());
      }
    });
 */
  }

  bool _isAddressScreen() {
    final state = context.read<ProfileSetupBloc>().state;
    return state is ProfileBasicInfoSaved || state is LocationPermissionGranted;
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _houseNoController.dispose();
    _streetController.dispose();
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
        leading: _isAddressScreen()
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => context
                    .read<ProfileSetupBloc>()
                    .add(ProfileSetupResetEvent()),
              )
            : null,
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
                      GoRouter.of(context).go(MyRoutes.mainScreenRoute);
                    }
                    if (state is ProfileError) {
                      ToastUtil.showToast(state.message, AppColors.primary);
                    }
                    if (state is LocationAddressError) {
                      print("Location Error message :${state.message}");
                      ToastUtil.showToast("Location Error", AppColors.primary);
                    }
                    if (state is LocationPermissionGranted) {
                      context
                          .read<ProfileSetupBloc>()
                          .add(FetchLocationAddressEvent());
                    }
                    if (state is ProfileBasicInfoSaved) {
                      context
                          .read<ProfileSetupBloc>()
                          .add(RequestLocationPermissionEvent());
                    }
                  },
                  child: Column(
                    children: [
                      BlocBuilder<ProfileSetupBloc, ProfileSetupState>(
                        builder: (context, state) {
                          print("Profile Setup state is : $state");
                          if (state is ProfileSetupLoading) {
                            return CircularProgressIndicator(
                              color: AppColors.primary,
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
                                            textCapitalization:
                                                TextCapitalization.words,
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
                                            textCapitalization:
                                                TextCapitalization.words,
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
                                        validator: Validators.validatePhone,
                                        maxLength: 10,
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
                                      final profileData = Profile(
                                          email: widget.email,
                                          password: widget.password,
                                          firstName:
                                              _firstNameController.text.trim(),
                                          lastName:
                                              _lastNameController.text.trim(),
                                          phone: _phoneController.text,
                                          lastUpdated: DateTime.now());
                                      context.read<ProfileSetupBloc>().add(
                                          SaveBasicInfoEvent(
                                              profileData: profileData));
                                      print("Get Started button pressed");
                                    },
                                    text: "Get Started →")
                              ],
                            );
                          }
                          if (state is ProfileBasicInfoSaved ||
                              state is LocationPermissionGranted ||
                              state is LocationPermissionDenied ||
                              state is LocationAddressFetched ||
                              state is LocationAddressError) {
                            return buildAddressForm(context, state);
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

  Widget buildAddressForm(BuildContext context, ProfileSetupState state) {
    if (state is LocationAddressFetched) {
      _streetController.text = state.address.street ?? "";
      _landmarkController.text = state.address.landmark ?? "";
      _cityController.text = state.address.city ?? "";
      _stateController.text = state.address.state ?? "";
      _zipController.text = state.address.zip ?? "";
    }
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        context
                            .read<ProfileSetupBloc>()
                            .add(ProfileSetupResetEvent());
                      },
                      icon: Icon(Icons.arrow_back)),
                  Text(
                    "Add Address",
                    style: TextStyle(
                        fontSize: getRelativeWidth(0.09),
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(Icons.location_on),
                onPressed: () {
                  if (state is LocationAddressError) {
                    context
                        .read<ProfileSetupBloc>()
                        .add(RequestLocationPermissionEvent());
                  }
                  if (state is LocationPermissionGranted) {
                    context
                        .read<ProfileSetupBloc>()
                        .add(FetchLocationAddressEvent());
                  }
                  if (state is LocationAddressFetched) {
                    ToastUtil.showToast(
                        "Location Address already fetched", Colors.green);
                  }
                  if (state is LocationPermissionDenied) {
                    context
                        .read<ProfileSetupBloc>()
                        .add(CheckLocationServiceEvent());
                  }
                },
              ),
            ],
          ),
          SizedBox(
            height: getRelativeHeight(0.03),
          ),
          Text("House No."),
          TextFormField(
            keyboardType: TextInputType.name,
            controller: _houseNoController,
            textCapitalization: TextCapitalization.words,
            validator: Validators.validateAddress,
            decoration: InputDecoration(
              hintText: "Enter your house no.",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          SizedBox(
            height: getRelativeHeight(0.02),
          ),
          Text("Street"),
          TextFormField(
            keyboardType: TextInputType.name,
            controller: _streetController,
            textCapitalization: TextCapitalization.words,
            validator: Validators.validateAddress,
            decoration: InputDecoration(
              hintText: "Enter street",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
              hintText: "(Optional)",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          SizedBox(
            height: getRelativeHeight(0.02),
          ),
          Text("City"),
          TextFormField(
            keyboardType: TextInputType.name,
            controller: _cityController,
            textCapitalization: TextCapitalization.words,
            validator: Validators.validateAddress,
            decoration: InputDecoration(
              hintText: "Enter your city",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          SizedBox(
            height: getRelativeHeight(0.02),
          ),
          Text("State"),
          TextFormField(
            keyboardType: TextInputType.name,
            controller: _stateController,
            textCapitalization: TextCapitalization.words,
            validator: Validators.validateAddress,
            decoration: InputDecoration(
              hintText: "Enter your state",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          SizedBox(
            height: getRelativeHeight(0.02),
          ),
          Text("Zip Code"),
          TextFormField(
            keyboardType: TextInputType.number,
            controller: _zipController,
            maxLength: 6,
            validator: Validators.validateZipCode,
            decoration: InputDecoration(
              hintText: "Enter zip code",
              counterText: "",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          SizedBox(
            height: getRelativeHeight(0.03),
          ),
          MyElevatedButton(
              onPressed: () {
                print("Save Address button pressed");
                if (_formKey.currentState!.validate()) {
                  final address = UserAddress(
                      houseNo: _houseNoController.text,
                      street: _streetController.text,
                      landmark: _landmarkController.text,
                      city: _cityController.text,
                      state: _stateController.text,
                      country: "India",
                      zip: _zipController.text,
                      addressType: 'Home',
                      lastUpdated: DateTime.now());
                  context
                      .read<ProfileSetupBloc>()
                      .add(SaveAddressEvent(address));
                }
              },
              text: "Save Address")
        ],
      ),
    );
  }
}
