import 'dart:ui';

import 'package:customer_e_commerce/core/theme/app_colors.dart';
import 'package:customer_e_commerce/core/utils/assets_manager.dart';
import 'package:customer_e_commerce/features/user/data/models/address_model.dart';
import 'package:customer_e_commerce/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AddressSelectionDialog extends StatelessWidget {
  final List<UserAddress> addresses;
  final Function(UserAddress) onAddressSelected;

  const AddressSelectionDialog({
    super.key,
    required this.addresses,
    required this.onAddressSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: getRelativeWidth(0.02),
        vertical: getRelativeHeight(0.2),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: AlertDialog(
          backgroundColor: AppColors.primary,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                AssetsManager.homeIcon,
                height: getRelativeHeight(0.05),
                width: getRelativeWidth(0.05),
              ),
              const Text(
                'Address Confirmation',
                style: TextStyle(color: AppColors.background),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                final address = addresses[index];
                return ListTile(
                  title: Text(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    address.formattedAddress,
                    style: TextStyle(color: AppColors.background),
                  ),
                  subtitle: Text(
                    address.addressType ?? '',
                    style: TextStyle(
                        color: AppColors.background,
                        fontWeight: FontWeight.bold),
                  ),
                  onTap: () => onAddressSelected(address),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
