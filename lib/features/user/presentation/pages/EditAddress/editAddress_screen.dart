import 'package:customer_e_commerce/core/theme/app_colors.dart';
import 'package:customer_e_commerce/core/utils/popup_confirmation.dart';
import 'package:customer_e_commerce/core/utils/toast_util.dart';
import 'package:customer_e_commerce/core/utils/validators.dart';
import 'package:customer_e_commerce/features/user/data/models/address_model.dart';
import 'package:customer_e_commerce/features/user/presentation/bloc/Address/address_bloc.dart';
import 'package:customer_e_commerce/features/user/presentation/widgets/my_elevated_button.dart';
import 'package:customer_e_commerce/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EditAddressScreen extends StatefulWidget {
  final UserAddress address;
  EditAddressScreen({super.key, required this.address});

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen>
    with PopupConfirmationMxin {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _houseNoController;
  late final TextEditingController _streetController;
  late final TextEditingController _landmarkController;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _zipController;

  @override
  void initState() {
    super.initState();
    _houseNoController =
        TextEditingController(text: widget.address.houseNo ?? "");
    _streetController =
        TextEditingController(text: widget.address.street ?? "");
    _landmarkController =
        TextEditingController(text: widget.address.landmark ?? "");
    _cityController = TextEditingController(text: widget.address.city ?? "");
    _stateController = TextEditingController(text: widget.address.state ?? "");
    _zipController = TextEditingController(text: widget.address.zip ?? "");

    //Register all controllers with the mixin
    registerControllers([
      _houseNoController,
      _streetController,
      _landmarkController,
      _cityController,
      _stateController,
      _zipController
    ]);
  }

  @override
  void dispose() {
    _houseNoController.dispose();
    _streetController.dispose();
    _landmarkController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    print("Address json is : ${widget.address.toJson()}");
    return PopScope(
      canPop: !hasChanges,
      onPopInvoked: (bool didPop) async {
        print("PopScope triggered: didPop = $didPop");
        if (didPop) return;
        final shouldPop = await confirmDiscardChanges();
        if (shouldPop) {
          GoRouter.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          title: Text("Edit Address"),
        ),
        body: SafeArea(
          minimum: EdgeInsets.symmetric(horizontal: getRelativeWidth(0.05)),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "House No.",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: getRelativeWidth(0.05),
                    ),
                  ),
                  TextFormField(
                    controller: _houseNoController,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    validator: Validators.validateAddress,
                    decoration: InputDecoration(
                      hintText: "Enter your house no.",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: getRelativeHeight(0.02)),
                  Text(
                    "Street",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: getRelativeWidth(0.05),
                    ),
                  ),
                  TextFormField(
                    controller: _streetController,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    validator: Validators.validateAddress,
                    decoration: InputDecoration(
                      hintText: "Enter street",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: getRelativeHeight(0.02)),
                  Text(
                    "Landmark/ Nearby place",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: getRelativeWidth(0.05),
                    ),
                  ),
                  TextFormField(
                    controller: _landmarkController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      hintText: "(Optional)",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: getRelativeHeight(0.02)),
                  Text(
                    "City",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: getRelativeWidth(0.05),
                    ),
                  ),
                  TextFormField(
                    controller: _cityController,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    validator: Validators.validateAddress,
                    decoration: InputDecoration(
                      hintText: "Enter your city",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: getRelativeHeight(0.02)),
                  Text(
                    "State",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: getRelativeWidth(0.05),
                    ),
                  ),
                  TextFormField(
                    controller: _stateController,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    validator: Validators.validateAddress,
                    decoration: InputDecoration(
                      hintText: "Enter your state",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: getRelativeHeight(0.02)),
                  Text(
                    "Zip Code",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: getRelativeWidth(0.05),
                    ),
                  ),
                  TextFormField(
                    controller: _zipController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    validator: Validators.validateZipCode,
                    decoration: InputDecoration(
                      hintText: "Enter zip code",
                      counterText: "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: getRelativeHeight(0.03)),
                  BlocConsumer<AddressBloc, AddressState>(
                    listener: (context, state) {
                      if (state is AddressUpdatedState) {
                        ToastUtil.showToast("Address Updated Successfully!",
                            AppColors.successColor);
                        GoRouter.of(context).pop();
                      } else if (state is AddressErrorMessage) {
                        ToastUtil.showToast(state.message, AppColors.primary);
                      }
                    },
                    builder: (context, state) {
                      if (state is AddressListLoadingState) {
                        return CircularProgressIndicator(
                          color: AppColors.textSecondary,
                        );
                      }
                      return MyElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final address = UserAddress(
                                houseNo: _houseNoController.text,
                                street: _streetController.text,
                                landmark: _landmarkController.text,
                                city: _cityController.text,
                                state: _stateController.text,
                                country: widget.address.country,
                                zip: _zipController.text,
                                addressType: widget.address.addressType,
                                lastUpdated: DateTime.now(),
                              );
                              context.read<AddressBloc>().add(
                                  UpdateAddressEvent(
                                      address, widget.address.id ?? ""));
                            }
                          },
                          text: "Update Address");
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
