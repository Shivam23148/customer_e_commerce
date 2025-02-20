import 'dart:ui';

import 'package:customer_e_commerce/core/theme/app_colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtil {
  static void showToast(String message, Color backgroundColor) {
    Fluttertoast.showToast(
        backgroundColor: backgroundColor,
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        textColor: AppColors.background,
        fontSize: 14);
  }
}
