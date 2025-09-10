import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:khaabd_web/models/utils/base_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuService {
  static const String _getMenuItemsEndpoint = '/kitchen/menu/menu-items';
  static const String _addMenuItemEndpoint = '/kitchen/menu/add-menu-item';
  static const String _updateMenuItemEndpoint = '/kitchen/menu/update-menu-item';
  static const String _getItemsBySectionEndpoint = '/kitchen/menu/items-by-section';
  static const String _deleteMenuItemEndpoint = '/kitchen/menu/delete-menu-item';

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

  /// Get menu items
  static Future<Map<String, dynamic>> getMenuItems({
    int page = 1,
    int limit = 16,
  }) async {
    try {
      final token = await _getToken();
      final url = Uri.parse('$baseUrl$_getMenuItemsEndpoint?page=$page&limit=$limit');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      final responseData = jsonDecode(response.body);
      log("Get Menu Items Response Data: $responseData Status Code: ${response.statusCode}");
      
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

  /// Add menu item
  static Future<Map<String, dynamic>> addMenuItem({
    required String menuItemName,
    required String foodSection,
    required int sellingPrice,
    required String description,
    required String takeAwayPacking,
    required List<Map<String, dynamic>> ingredients,
  }) async {
    try {
      final token = await _getToken();
      final url = Uri.parse('$baseUrl$_addMenuItemEndpoint');

      final requestBody = {
        'menuItemName': menuItemName,
        'foodSection': foodSection,
        'sellingPrice': sellingPrice,
        'description': description,
        'takeAwayPacking': takeAwayPacking,
        'ingredients': ingredients,
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
      log("Add Menu Item Response Data: $responseData Status Code: ${response.statusCode}");

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

  /// Update menu item
  static Future<Map<String, dynamic>> updateMenuItem({
    required String itemId,
    required String menuItemName,
    required String foodSection,
    required int sellingPrice,
    required String description,
    required String takeAwayPacking,
    required List<Map<String, dynamic>> ingredients,
  }) async {
    try {
      final token = await _getToken();
      final url = Uri.parse('$baseUrl$_updateMenuItemEndpoint/$itemId');

      final requestBody = {
        'menuItemName': menuItemName,
        'foodSection': foodSection,
        'sellingPrice': sellingPrice,
        'description': description,
        'takeAwayPacking': takeAwayPacking,
        'ingredients': ingredients,
      };

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      final responseData = jsonDecode(response.body);
      log("Update Menu Item Response Data: $responseData Status Code: ${response.statusCode}");

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

  /// Get items by section
  static Future<Map<String, dynamic>> getItemsBySection({
    int page = 1,
    int limit = 10,
    required String kitchenSection,
  }) async {
    try {
      final token = await _getToken();
      final url = Uri.parse('$baseUrl$_getItemsBySectionEndpoint?page=$page&limit=$limit&kitchenSection=$kitchenSection');
      log("url : $url");
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      final responseData = jsonDecode(response.body);
      log("Get Items By Section Response Data: $responseData Status Code: ${response.statusCode}");
      
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

  /// Delete menu item
  static Future<Map<String, dynamic>> deleteMenuItem({
    required String itemId,
  }) async {
    try {
      final token = await _getToken();
      final url = Uri.parse('$baseUrl$_deleteMenuItemEndpoint/$itemId');

      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      final responseData = jsonDecode(response.body);
      log("Delete Menu Item Response Data: $responseData Status Code: ${response.statusCode}");

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