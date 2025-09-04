import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:khaabd_web/models/utils/base_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KitchenService {
  static const String _getKitchenInventoryEndpoint = '/kitchen/inventory';
  static const String _getTransferHistoryEndpoint = '/kitchen/transfer-history';

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

  /// Get kitchen inventory
  static Future<Map<String, dynamic>> getKitchenInventory({
    int page = 1,
    int limit = 16,
    String section = 'all',
  }) async {
    try {
      final token = await _getToken();
      final url = Uri.parse('$baseUrl$_getKitchenInventoryEndpoint?page=$page&limit=$limit&section=$section');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      final responseData = jsonDecode(response.body);
      log("Get Kitchen Inventory Response Data: $responseData Status Code: ${response.statusCode}");
      
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

  /// Get transfer history
  static Future<Map<String, dynamic>> getTransferHistory({
    int page = 1,
    int limit = 16,
  }) async {
    try {
      final token = await _getToken();
      final url = Uri.parse('$baseUrl$_getTransferHistoryEndpoint?page=$page&limit=$limit');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      final responseData = jsonDecode(response.body);
      log("Get Transfer History Response Data: $responseData Status Code: ${response.statusCode}");
      
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