import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khaabd_web/controller/getx_controllers/auth_controller.dart';
import 'package:khaabd_web/models/utils/snackbars.dart';
import 'package:khaabd_web/utils/colors.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/gradient_button.dart';
import '../utils/responsive.dart';
import 'reset_password_popup.dart';
import 'enter_code_popup.dart';
import 'create_new_password_popup.dart';
import 'dashboard/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthController authController = Get.put(AuthController());
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  // Popup state
  bool _showResetPassword = false;
  bool _showEnterCode = false;
  bool _showCreatePassword = false;
  String _resetEmail = '';

  void _openResetPassword() {
    setState(() {
      _showResetPassword = true;
    });
  }

  void _closeAllPopups() {
    setState(() {
      _showResetPassword = false;
      _showEnterCode = false;
      _showCreatePassword = false;
    });
  }

  void _onResetNext() {
    setState(() {
      _showResetPassword = false;
      _showEnterCode = true;
      _resetEmail = authController.userEmail.value;
    });
  }

  void _onCodeNext() {
    setState(() {
      _showEnterCode = false;
      _showCreatePassword = true;
    });
  }

  void _onCreatePasswordNext() {
    _closeAllPopups();
    // Show success message
    showNativeSuccessSnackbar(context, 'Password reset successfully! You can now login with your new password.');
  }

  void _onLogin() {
    if(_usernameController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
      authController.login(
        username: _usernameController.text,
        password: _passwordController.text,
        context: context
      );
    }else{
      log("Please enter both username and password");
      showNativeErrorSnackbar(context, 'Please enter both username and password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration:  BoxDecoration(
              color: scaffoldBackgroundColor,
            ),
            child: Stack(
              children: [
                // Positioned( 
                //   top: -15,
                //   right: 0,
                //   child: SizedBox(
                //     width: 200,
                //     height: 200,
                //     child: Image.asset(
                //       'assets/auth_box_2.png',
                //       fit: BoxFit.contain,
                //     ),
                //   ),
                // ),
                // Positioned(
                //   bottom: -10,
                //   left: 0,
                //   child: SizedBox(
                //     width: 250,
                //     height: 250,
                //     child: Image.asset(
                //       'assets/auth_box_3.png',
                //       fit: BoxFit.contain,
                //     ),
                //   ),
                // ),
                // Positioned(
                //   top: 150,
                //   right: -100,
                //   child: SizedBox(
                //     width: 300,
                //     height: 300,
                //     child: Image.asset(
                //       'assets/auth_box_1.png',
                //       fit: BoxFit.contain,
                //     ),
                //   ),
                // ),
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Responsive.horizontalPadding(context),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Spacer(flex: 2),
                        Center(
                          child: Column(
                            children: [
                              SizedBox(
                                width: 200,
                                height: 200,
                                child: Image.asset(
                                  'assets/pngs/kkr_logo.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                        const Spacer(flex: 1),
                        const Text(
                          'Login',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 40),
                        AuthTextField(
                          controller: _usernameController,
                          hintText: 'Username',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        AuthTextField(
                          controller: _passwordController,
                          hintText: 'Password',
                          prefixIcon: Icons.lock_outline,
                          obscureText: !_isPasswordVisible,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Colors.black.withOpacity(0.7),
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _openResetPassword,
                            child: Text(
                              'Forgot password?',
                              style: TextStyle(
                                color: const Color(0xFFc89849).withOpacity(0.8),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        GradientButton(
                          text: 'Login',
                          onPressed: _onLogin,
                        ),
                        const Spacer(flex: 2),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_showResetPassword)
            ResetPasswordPopup(
              onClose: _closeAllPopups,
              onNext: _onResetNext,
            ),
          if (_showEnterCode)
            EnterCodePopup(
              onClose: _closeAllPopups,
              onNext: _onCodeNext,
              email: _resetEmail.isNotEmpty ? _resetEmail : 'example@gmail.com',
            ),
          if (_showCreatePassword)
            CreateNewPasswordPopup(
              onClose: _closeAllPopups,
              onNext: _onCreatePasswordNext,
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
} 