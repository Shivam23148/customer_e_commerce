/* import 'package:customer_e_commerce/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

mixin PopupConfirmationMxin<T extends StatefulWidget> on State<T> {
  bool hasText = false;
  List<TextEditingController> controllers = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (final controller in controllers) {
      controller.addListener(_checkText);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    for (final controller in controllers) {
      controller.removeListener(_checkText);
    }
    super.dispose();
  }

  void _checkText() {
    setState(() {
      hasText = controllers.any((controller) => controller.text.isNotEmpty);
    });
  }

  Future<bool> confirmDiscardChanges() async {
    if (hasText) {
      final shouldPop = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.background,
          title: Text("Discard Changes"),
          content: Text(
            "You have unsaved changes. Are you sure you want to leave?",
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => GoRouter.of(context).pop(false)
              /* Navigator.of(context).pop(false) */
              ,
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () => GoRouter.of(context)
                  .pop(true) /*  Navigator.of(context).pop(true) */,
              child: Text("Discard"),
            ),
          ],
        ),
      );
      return shouldPop ?? false;
    }
    return true;
  }
}
 */
import 'package:flutter/material.dart';
import 'package:customer_e_commerce/core/theme/app_colors.dart';

mixin PopupConfirmationMxin<T extends StatefulWidget> on State<T> {
  List<TextEditingController> controllers = [];
  List<String> initialValues = [];

  /// Call this in `initState` of your screen
  void registerControllers(
    List<TextEditingController> ctrls, {
    List<String>? initial,
  }) {
    controllers = ctrls;
    initialValues = initial ?? ctrls.map((c) => c.text).toList();

    for (final controller in controllers) {
      controller.addListener(_onFieldChanged);
    }
  }

  @override
  void dispose() {
    for (final controller in controllers) {
      controller.removeListener(_onFieldChanged);
    }
    super.dispose();
  }

  void _onFieldChanged() {
    setState(() {});
  }

  bool get hasChanges {
    for (int i = 0; i < controllers.length; i++) {
      if (controllers[i].text.trim() != initialValues[i].trim()) {
        return true;
      }
    }
    return false;
  }

  Future<bool> confirmDiscardChanges() async {
    if (hasChanges) {
      final shouldPop = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.background,
          title: const Text("Discard Changes"),
          content: const Text(
            "You have unsaved changes. Are you sure you want to leave?",
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Discard"),
            ),
          ],
        ),
      );
      return shouldPop ?? false;
    }
    return true;
  }
}
