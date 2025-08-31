import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:khaabd_web/models/utils/base_url.dart';

class AuthService {
  static const String _loginEndpoint = '/auth/login';
  static const String _forgetPasswordEndpoint = '/auth/forget-password';
  static const String _verifyOtpEndpoint = '/auth/verify-forget-password-otp';
  static const String _resetPasswordEndpoint = '/auth/reset-password';

  /// Login user with username and password
  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$_loginEndpoint');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      final responseData = jsonDecode(response.body);
      log("Response Data: $responseData Status Code: ${response.statusCode}");
      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': responseData,
        };
      } else {
        return {
          'success': false,
          'data': responseData
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  /// Forget password - send OTP to email
  static Future<Map<String, dynamic>> forgetPassword({
    required String email,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$_forgetPasswordEndpoint');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
        }),
      );

      final responseData = jsonDecode(response.body);
      log("Forget Password Response Data: $responseData Status Code: ${response.statusCode}");
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': responseData,
        };
      } else {
        return {
          'success': false,
          'data': responseData
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  /// Verify OTP for password reset
  static Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$_verifyOtpEndpoint');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'otp': otp,
        }),
      );

      final responseData = jsonDecode(response.body);
      log("Verify OTP Response Data: $responseData Status Code: ${response.statusCode}");
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': responseData,
        };
      } else {
        return {
          'success': false,
          'data': responseData
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  /// Reset password with reset token
  static Future<Map<String, dynamic>> resetPassword({
    required String resetToken,
    required String password,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$_resetPasswordEndpoint');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'resetToken': resetToken,
          'password': password,
        }),
      );

      final responseData = jsonDecode(response.body);
      log("Reset Password Response Data: $responseData Status Code: ${response.statusCode}");
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': responseData,
        };
      } else {
        return {
          'success': false,
          'data': responseData
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }
}