import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/modal_popup.dart';
import '../widgets/close_button.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/gradient_button.dart';
import '../controller/getx_controllers/auth_controller.dart';
import '../models/utils/snackbars.dart';

class ResetPasswordPopup extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback onNext;
  const ResetPasswordPopup({Key? key, required this.onClose, required this.onNext}) : super(key: key);

  @override
  State<ResetPasswordPopup> createState() => _ResetPasswordPopupState();
}

class _ResetPasswordPopupState extends State<ResetPasswordPopup> {
  final TextEditingController _emailController = TextEditingController();
  final AuthController _authController = Get.find<AuthController>();

  void _onNext() async {
    if (_emailController.text.isEmpty) {
      showNativeErrorSnackbar(context, 'Please enter your email');
      return;
    }

    // Validate email format
    if (!GetUtils.isEmail(_emailController.text)) {
      showNativeErrorSnackbar(context, 'Please enter a valid email');
      return;
    }

    // Call forget password API
    final success = await _authController.forgetPassword(
      email: _emailController.text,
      context: context,
    );

    // If successful, proceed to next step
    if (success) {
      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalPopup(
      onClose: widget.onClose,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PopupCloseButton(onPressed: widget.onClose),
          const SizedBox(height: 8),
          const Text(
            'Reset Your Password',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Enter your email and we'll send you a\nlink to reset your password.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 32),
          AuthTextField(
            controller: _emailController,
            hintText: 'Email',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 32),
          Obx(() => GradientButton(
            text: _authController.isLoading.value ? 'Sending...' : 'Next',
            onPressed: _authController.isLoading.value ? null : _onNext,
          )),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
} 