import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:thinktap/constants/color.dart';

mixin SnackbarMixin {
  void showSuccess({
    required String title,
    required String message,
    SnackPosition position = SnackPosition.BOTTOM,
    Color backgroundColor = CustomColor.successColor,
    Color textColor = Colors.white,
    Duration duration = const Duration(seconds: 2),
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: position,
      backgroundColor: backgroundColor,
      colorText: textColor,
      duration: duration,
      margin: EdgeInsets.all(10),
      borderRadius: 8,
    );
  }
  void showError({
    required String title,
    required String message,
    SnackPosition position = SnackPosition.BOTTOM,
    Color backgroundColor = CustomColor.errorColor,
    Color textColor = Colors.white,
    Duration duration = const Duration(seconds: 2),
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: position,
      backgroundColor: backgroundColor,
      colorText: textColor,
      duration: duration,
      margin: EdgeInsets.all(10),
      borderRadius: 8,
    );
  }
}
