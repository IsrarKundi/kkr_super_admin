import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:khaabd_web/models/utils/base_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreService {
  static const String _getInventoryEndpoint = '/store/inventory/current';
  static const String _getPurchaseHistoryEndpoint = '/store/inventory/purchase-history';
  static const String _getSupplierLedgerEndpoint = '/store/supplier-ledger/all';
  static const String _addPurchaseEndpoint = '/store/inventory/add-purchase';
  static const String _makePaymentEndpoint = '/store/supplier-ledger/make-payment';
  static const String _cancelPurchaseEndpoint = '/store/inventory/cancel-purchase';
  static const String _deleteItemEndpoint = '/store/inventory/delete-item';
  static const String _transferToKitchenEndpoint = '/store/inventory/transfer-to-kitchen';

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
    int limit = 16,
    String section = 'all',
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
    int limit = 16,
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

  /// Add purchase
  static Future<Map<String, dynamic>> addPurchase({
    required String itemName,
    required String supplierName,
    required String category,
    required String measuringUnit,
    required double pricePerUnit,
    required int quantity,
    required String paymentMethod,
  }) async {
    try {
      final token = await _getToken();
      final url = Uri.parse('$baseUrl$_addPurchaseEndpoint');
      
      final requestBody = {
        'itemName': itemName,
        'supplierName': supplierName,
        'category': category,
        'measuringUnit': measuringUnit,
        'pricePerUnit': pricePerUnit,
        'quantity': quantity,
        'paymentMethod': paymentMethod,
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      final responseData = jsonDecode(response.body);
      log("Add Purchase Response Data: $responseData Status Code: ${response.statusCode}");
      
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

  /// Make payment to supplier
  static Future<Map<String, dynamic>> makePayment({
    required String supplierId,
    required double amount,
  }) async {
    try {
      final token = await _getToken();
      final url = Uri.parse('$baseUrl$_makePaymentEndpoint');
      
      final requestBody = {
        'supplierId': supplierId,
        'amount': amount,
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      final responseData = jsonDecode(response.body);
      log("Make Payment Response Data: $responseData Status Code: ${response.statusCode}");
      
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

  /// Cancel purchase
  static Future<Map<String, dynamic>> cancelPurchase({
    required String purchaseId,
  }) async {
    try {
      final token = await _getToken();
      final url = Uri.parse('$baseUrl$_cancelPurchaseEndpoint/$purchaseId');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );
      log("url : $url");

      final responseData = jsonDecode(response.body);
      log("Cancel Purchase Response Data: $responseData Status Code: ${response.statusCode}");
      
      if (response.statusCode == 200 || response.statusCode == 204) {
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

  /// Delete inventory item
  static Future<Map<String, dynamic>> deleteInventoryItem({
    required String itemId,
  }) async {
    try {
      final token = await _getToken();
      final url = Uri.parse('$baseUrl$_deleteItemEndpoint/$itemId');
      
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );
      log("Delete Item URL: $url");

      final responseData = jsonDecode(response.body);
      log("Delete Item Response Data: $responseData Status Code: ${response.statusCode}");
      
      if (response.statusCode == 200 || response.statusCode == 204) {
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

  /// Transfer to kitchen
  static Future<Map<String, dynamic>> transferToKitchen({
    required String itemId,
    required int quantity,
    required String kitchenSection,
  }) async {
    try {
      final token = await _getToken();
      final url = Uri.parse('$baseUrl$_transferToKitchenEndpoint');
      
      final requestBody = {
        'itemId': itemId,
        'quantity': quantity,
        'kitchenSection': kitchenSection,
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );
      log("Transfer to Kitchen URL: $url");
      log("Transfer to Kitchen Request Body: $requestBody");

      final responseData = jsonDecode(response.body);
      log("Transfer to Kitchen Response Data: $responseData Status Code: ${response.statusCode}");
      
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
}