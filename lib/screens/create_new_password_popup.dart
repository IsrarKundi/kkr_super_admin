import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/modal_popup.dart';
import '../widgets/close_button.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/gradient_button.dart';
import '../controller/getx_controllers/auth_controller.dart';
import '../models/utils/snackbars.dart';

class CreateNewPasswordPopup extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback onNext;
  const CreateNewPasswordPopup({Key? key, required this.onClose, required this.onNext}) : super(key: key);

  @override
  State<CreateNewPasswordPopup> createState() => _CreateNewPasswordPopupState();
}

class _CreateNewPasswordPopupState extends State<CreateNewPasswordPopup> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final AuthController _authController = Get.find<AuthController>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  void _onNext() async {
    // Validate password
    if (_passwordController.text.isEmpty) {
      showNativeErrorSnackbar(context, 'Please enter a password');
      return;
    }

    if (_passwordController.text.length < 8) {
      showNativeErrorSnackbar(context, 'Password must be at least 8 characters long');
      return;
    }

    // Validate confirm password
    if (_confirmPasswordController.text.isEmpty) {
      showNativeErrorSnackbar(context, 'Please confirm your password');
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      showNativeErrorSnackbar(context, 'Passwords do not match');
      return;
    }

    // Call reset password API
    final success = await _authController.resetPassword(
      password: _passwordController.text,
      context: context,
    );

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
            'Create a new password',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Your new password must be different\nfrom previous used passwords.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 32),
          AuthTextField(
            controller: _passwordController,
            hintText: 'Password',
            prefixIcon: Icons.password_outlined,
            obscureText: !_isPasswordVisible,
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: Colors.black.withOpacity(0.7),
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          AuthTextField(
            controller: _confirmPasswordController,
            hintText: 'Confirm Password',
            prefixIcon: Icons.password_outlined,
            obscureText: !_isConfirmPasswordVisible,
            suffixIcon: IconButton(
              icon: Icon(
                _isConfirmPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: Colors.black.withOpacity(0.7),
              ),
              onPressed: () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              },
            ),
          ),
          const SizedBox(height: 32),
          Obx(() => GradientButton(
            text: _authController.isLoading.value ? 'Updating...' : 'Reset Password',
            onPressed: _authController.isLoading.value ? null : _onNext,
          )),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
} 