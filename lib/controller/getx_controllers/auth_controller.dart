import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api_services/auth_apis.dart';
import '../../models/utils/snackbars.dart';
import '../../screens/dashboard/dashboard_screen.dart';

class AuthController extends GetxController {
  // Observable variables
  var isLoading = false.obs;
  var resetToken = ''.obs;
  var userEmail = ''.obs;

  // SharedPreferences keys
  static const String _tokenKey = 'auth_token';

  /// Login user
  Future<void> login({
    required String username,
    required String password,
    required BuildContext context,
  }) async {
    try {
      isLoading.value = true;

      final result = await AuthService.login(
        username: username,
        password: password,
      );

      if (result['success']) {
        final token = result['data']['data']['token'];
        
        // Store token in SharedPreferences
        await _storeToken(token);

        // Show success message
showNativeSuccessSnackbar(context, result['data']['message'] ?? 'Login successful');


        // Navigate to dashboard
        Get.offAllNamed('/dashboard');
      } else {
        // Show error message from server
        showNativeErrorSnackbar(context, result['data']['message'] ?? 'Login failed');
      }
    } catch (e) {
      showNativeErrorSnackbar(context, 'An unexpected error occurred');
      print('Login error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Store token in SharedPreferences
  Future<void> _storeToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
    } catch (e) {
      print('Error storing token: $e');
    }
  }

  /// Get stored token
  Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } catch (e) {
      print('Error getting token: $e');
      return null;
    }
  }

  /// Forget password - send OTP to email
  Future<bool> forgetPassword({
    required String email,
    required BuildContext context,
  }) async {
    try {
      isLoading.value = true;
      userEmail.value = email;

      final result = await AuthService.forgetPassword(email: email);

      if (result['success']) {
        final otp = result['data']['data']['otp'];
        final message = result['data']['message'] ?? 'Verification code sent check your Email';
        
        // Show success message with OTP
        showNativeSuccessSnackbar(context, '$message - OTP: $otp');
        return true;
      } else {
        // Show error message from server
        showNativeErrorSnackbar(context, result['data']['message'] ?? 'Failed to send verification code');
        return false;
      }
    } catch (e) {
      showNativeErrorSnackbar(context, 'An unexpected error occurred');
      print('Forget password error: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Verify OTP for password reset
  Future<bool> verifyOtp({
    required String otp,
    required BuildContext context,
  }) async {
    try {
      isLoading.value = true;

      final result = await AuthService.verifyOtp(
        email: userEmail.value,
        otp: otp,
      );

      if (result['success']) {
        resetToken.value = result['data']['data']['resetToken'];
        final message = result['data']['message'] ?? 'OTP verified successfully';
        
        // Show success message
        showNativeSuccessSnackbar(context, message);
        return true;
      } else {
        // Show error message from server
        showNativeErrorSnackbar(context, result['data']['message'] ?? 'Invalid OTP');
        return false;
      }
    } catch (e) {
      showNativeErrorSnackbar(context, 'An unexpected error occurred');
      print('Verify OTP error: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Reset password with new password
  Future<bool> resetPassword({
    required String password,
    required BuildContext context,
  }) async {
    try {
      isLoading.value = true;

      final result = await AuthService.resetPassword(
        resetToken: resetToken.value,
        password: password,
      );

      if (result['success']) {
        final message = result['data']['message'] ?? 'Password updated successfully';
        
        // Show success message
        showNativeSuccessSnackbar(context, message);
        
        // Clear stored data
        resetToken.value = '';
        userEmail.value = '';
        
        return true;
      } else {
        // Show error message from server
        showNativeErrorSnackbar(context, result['data']['message'] ?? 'Failed to reset password');
        return false;
      }
    } catch (e) {
      showNativeErrorSnackbar(context, 'An unexpected error occurred');
      print('Reset password error: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      
      // Navigate to login screen
      Get.offAllNamed('/login');
    } catch (e) {
      print('Error during logout: $e');
    }
  }
}