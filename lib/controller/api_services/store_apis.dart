import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:khaabd_web/models/utils/base_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreService {
  static const String _getInventoryEndpoint = '/store/inventory/current';
  static const String _getPurchaseHistoryEndpoint = '/store/inventory/purchase-history';
  static const String _getSupplierLedgerEndpoint = '/store/supplier-ledger/all';

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

  /// Get current inventory
  static Future<Map<String, dynamic>> getCurrentInventory({
    int page = 1,
    int limit = 9,
    String section = 'kitchen',
  }) async {
    try {
      final token = await _getToken();
      final url = Uri.parse('$baseUrl$_getInventoryEndpoint?page=$page&limit=$limit&section=$section');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      final responseData = jsonDecode(response.body);
      log("Get Current Inventory Response Data: $responseData Status Code: ${response.statusCode}");
      
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

  /// Get purchase history
  static Future<Map<String, dynamic>> getPurchaseHistory({
    int page = 1,
    int limit = 9,
  }) async {
    try {
      final token = await _getToken();
      final url = Uri.parse('$baseUrl$_getPurchaseHistoryEndpoint?page=$page&limit=$limit');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      final responseData = jsonDecode(response.body);
      log("Get Purchase History Response Data: $responseData Status Code: ${response.statusCode}");
      
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

  /// Get supplier ledger
  static Future<Map<String, dynamic>> getSupplierLedger({
    int page = 1,
    int limit = 9,
  }) async {
    try {
      final token = await _getToken();
      final url = Uri.parse('$baseUrl$_getSupplierLedgerEndpoint?page=$page&limit=$limit');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      final responseData = jsonDecode(response.body);
      log("Get Supplier Ledger Response Data: $responseData Status Code: ${response.statusCode}");
      
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