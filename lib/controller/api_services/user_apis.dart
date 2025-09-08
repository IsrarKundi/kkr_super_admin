import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:khaabd_web/models/utils/base_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String _addUserEndpoint = '/admin/users/add-new-user';
  static const String _getAllUsersEndpoint = '/admin/users/all';
  static const String _updateUserEndpoint = '/admin/users/update';
  static const String _deleteUserEndpoint = '/admin/users/delete';

  /// Get authorization token from SharedPreferences
  static Future<String?> _getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('auth_token');
    } catch (e) {
      print('Error getting token: $e');
      return null;
    }
  }

  /// Add new user
  static Future<Map<String, dynamic>> addNewUser({
    required String username,
    required String role,
    required String password,
    required String email,
  }) async {
    try {
      final token = await _getToken();
      final url = Uri.parse('$baseUrl$_addUserEndpoint');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'username': username,
          'role': role,
          'password': password,
          'email': email,
        }),
      );

      final responseData = jsonDecode(response.body);
      log("Add User Response Data: $responseData Status Code: ${response.statusCode}");
      
      if (response.statusCode == 200 || response.statusCode == 201) {
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

  /// Get all users with pagination
  static Future<Map<String, dynamic>> getAllUsers({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final token = await _getToken();
      final url = Uri.parse('$baseUrl$_getAllUsersEndpoint?page=$page&limit=$limit');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      final responseData = jsonDecode(response.body);
      log("Get All Users Response Data: $responseData Status Code: ${response.statusCode}");
      
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

  /// Update user
  static Future<Map<String, dynamic>> updateUser({
    required String userId,
    required String username,
    required String role,
    required String password,
    required String email,
  }) async {
    try {
      final token = await _getToken();
      final url = Uri.parse('$baseUrl$_updateUserEndpoint/$userId');
      
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'username': username,
          'role': role,
          'password': password,
          'email': email,
        }),
      );

      final responseData = jsonDecode(response.body);
      log("Update User Response Data: $responseData Status Code: ${response.statusCode}");
      
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

  /// Delete user
  static Future<Map<String, dynamic>> deleteUser({
    required String userId,
  }) async {
    try {
      final token = await _getToken();
      final url = Uri.parse('$baseUrl$_deleteUserEndpoint/$userId');
      
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      final responseData = jsonDecode(response.body);
      log("Delete User Response Data: $responseData Status Code: ${response.statusCode}");
      
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