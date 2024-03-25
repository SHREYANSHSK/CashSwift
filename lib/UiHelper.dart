
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UiHelper {
  SnackbarController snackBar({
    required String titleMsg,
    required String subTitleMsg,
    Color? bgColor,
    IconData? iconData,
  }) {
    return Get.snackbar(
      titleMsg,
      subTitleMsg,
      borderRadius: 12,
      isDismissible: true,
      dismissDirection: DismissDirection.startToEnd,
      colorText: Colors.black,
      backgroundColor: bgColor,
      icon: iconData != null ? Icon(iconData) : null,
      animationDuration: const Duration(milliseconds: 800),
      overlayBlur: 2,
      forwardAnimationCurve: Curves.easeInOutCubicEmphasized,
    );
  }
}
