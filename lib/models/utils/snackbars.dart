import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSuccessSnackbar(String message) {
  // For web, use GetX snackbar with specific web-friendly configuration
  Get.snackbar(
    'Success',
    message,
    snackPosition: SnackPosition.TOP, // TOP works better on web
    backgroundColor: Colors.green,
    colorText: Colors.white,
    duration: const Duration(seconds: 3),
    margin: const EdgeInsets.all(16),
    borderRadius: 8,
    isDismissible: true,
    dismissDirection: DismissDirection.horizontal,
    forwardAnimationCurve: Curves.easeOutBack,
    reverseAnimationCurve: Curves.easeInBack,
    animationDuration: const Duration(milliseconds: 300),
  );
}

void showErrorSnackbar(String? message) {
  Get.snackbar(
    'Error',
    message ?? 'An unexpected error occurred',
    snackPosition: SnackPosition.TOP, // TOP works better on web
    backgroundColor: Colors.red,
    colorText: Colors.white,
    duration: const Duration(seconds: 4), // Longer duration for errors
    margin: const EdgeInsets.all(16),
    borderRadius: 8,
    isDismissible: true,
    dismissDirection: DismissDirection.horizontal,
    forwardAnimationCurve: Curves.easeOutBack,
    reverseAnimationCurve: Curves.easeInBack,
    animationDuration: const Duration(milliseconds: 300),
  );
}

void showInfoSnackbar(String message) {
  Get.snackbar(
    'Info',
    message,
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.blue,
    colorText: Colors.white,
    duration: const Duration(seconds: 3),
    margin: const EdgeInsets.all(16),
    borderRadius: 8,
    isDismissible: true,
    dismissDirection: DismissDirection.horizontal,
    forwardAnimationCurve: Curves.easeOutBack,
    reverseAnimationCurve: Curves.easeInBack,
    animationDuration: const Duration(milliseconds: 300),
  );
}

void showWarningSnackbar(String message) {
  Get.snackbar(
    'Warning',
    message,
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.orange,
    colorText: Colors.white,
    duration: const Duration(seconds: 3),
    margin: const EdgeInsets.all(16),
    borderRadius: 8,
    isDismissible: true,
    dismissDirection: DismissDirection.horizontal,
    forwardAnimationCurve: Curves.easeOutBack,
    reverseAnimationCurve: Curves.easeInBack,
    animationDuration: const Duration(milliseconds: 300),
  );
}

// Alternative implementation using Flutter's native SnackBar
// Use this if GetX snackbars still don't work properly on web
void showNativeSuccessSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}

void showNativeErrorSnackbar(BuildContext context, String? message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.error, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(child: Text(message ?? 'An unexpected error occurred')),
        ],
      ),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 4),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}