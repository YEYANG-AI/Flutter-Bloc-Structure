import 'package:flutter/material.dart';
import 'package:laoblogger/core/styles/colors/app_colors.dart';

class MessageHelper {
  static GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void showSnackBarMessage({isSuccess = bool, message = String}) {
    scaffoldMessengerKey.currentState!.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        backgroundColor: isSuccess
            ? AppColors.positiveColor
            : AppColors.negativeColor,
        padding: const EdgeInsets.all(18),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 6, // ເພີ່ມເງົາ
        content: Row(
          // ປ່ຽນເປັນ Row ເພື່ອເພີ່ມ icon
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.error,
              color: AppColors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message ?? "",
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void showTopSnackBar({isSuccess = bool, message = String}) {
    scaffoldMessengerKey.currentState!.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        backgroundColor: isSuccess
            ? AppColors.positiveColor
            : AppColors.negativeColor,
        padding: const EdgeInsets.all(18),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 6, // ເພີ່ມເງົາ
        content: Row(
          // ປ່ຽນເປັນ Row ເພື່ອເພີ່ມ icon
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.error,
              color: AppColors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
