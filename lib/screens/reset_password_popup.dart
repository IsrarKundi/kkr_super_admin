import 'package:flutter/material.dart';
import '../widgets/modal_popup.dart';
import '../widgets/close_button.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/gradient_button.dart';

class ResetPasswordPopup extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback onNext;
  const ResetPasswordPopup({Key? key, required this.onClose, required this.onNext}) : super(key: key);

  @override
  State<ResetPasswordPopup> createState() => _ResetPasswordPopupState();
}

class _ResetPasswordPopupState extends State<ResetPasswordPopup> {
  final TextEditingController _emailController = TextEditingController();

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
          GradientButton(
            text: 'Next',
            onPressed: widget.onNext,
          ),
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