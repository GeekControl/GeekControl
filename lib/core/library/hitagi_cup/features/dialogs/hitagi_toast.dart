import 'package:flutter/material.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toast_service.dart';

enum ToastType { error, success, warning }

class HitagiToast {
  static Future<void> show(
    BuildContext context, {
    required String message,
    required ToastType type,
  }) async {
    switch (type) {
      case ToastType.error:
        await ToastService.showErrorToast(
          context,
          length: ToastLength.medium,
          expandedHeight: 100,
          message: message,
        );
        break;
      case ToastType.success:
        await ToastService.showSuccessToast(
          context,
          length: ToastLength.medium,
          expandedHeight: 100,
          message: message,
        );
        break;
      case ToastType.warning:
        await ToastService.showWarningToast(
          context,
          length: ToastLength.medium,
          expandedHeight: 100,
          message: message,
        );
        break;
    }
  }
}
