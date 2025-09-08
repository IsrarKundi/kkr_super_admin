import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../api_services/menu_apis.dart';
import '../../models/utils/snackbars.dart';
import '../../models/models/kitchen_models/get_menu_items.dart';

class MenuGetxController extends GetxController {
  // Observable variables for menu items
  var isLoadingMenuItems = false.obs;
  var menuItems = <Datum>[].obs;
  var menuCurrentPage = 1.obs;
  var menuTotalPages = 1.obs;
  var menuHasNext = false.obs;
  var menuHasPrev = false.obs;
  var menuTotal = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Load initial data
    getMenuItems();
  }

  /// Get menu items
  Future<void> getMenuItems({
    int page = 1,
    int limit = 13,
    bool showLoading = true,
  }) async {
    try {
      if (showLoading) {
        isLoadingMenuItems.value = true;
      }

      final result = await MenuService.getMenuItems(
        page: page,
        limit: limit,
      );

      if (result['success']) {
        final getMenuItemsModel = GetMenuItemsModel.fromJson(result['data']);
        
        // Update observable variables
        menuItems.value = getMenuItemsModel.data;
        
        // Note: The API response doesn't seem to have pagination info in the model
        // We'll need to handle pagination based on the actual API response structure
        // For now, setting basic pagination values
        menuCurrentPage.value = page;
        menuTotal.value = getMenuItemsModel.data.length;
        
        // Calculate pagination based on response
        if (getMenuItemsModel.data.length == limit) {
          menuHasNext.value = true;
        } else {
          menuHasNext.value = false;
        }
        menuHasPrev.value = page > 1;
        
        print('Menu items loaded successfully: ${menuItems.length} items');
      } else {
        print('Failed to load menu items: ${result['data']['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      print('Get menu items error: $e');
    } finally {
      if (showLoading) {
        isLoadingMenuItems.value = false;
      }
    }
  }

  // Pagination methods for menu items
  Future<void> loadNextMenuPage() async {
    if (menuHasNext.value && !isLoadingMenuItems.value) {
      await getMenuItems(
        page: menuCurrentPage.value + 1,
        showLoading: false,
      );
    }
  }

  Future<void> loadPreviousMenuPage() async {
    if (menuHasPrev.value && !isLoadingMenuItems.value && menuCurrentPage.value > 1) {
      await getMenuItems(
        page: menuCurrentPage.value - 1,
        showLoading: false,
      );
    }
  }

  /// Refresh methods
  Future<void> refreshMenuItems() async {
    await getMenuItems(page: 1);
  }

  /// Clear all data
  void clearData() {
    // Clear menu items data
    menuItems.clear();
    menuCurrentPage.value = 1;
    menuTotalPages.value = 1;
    menuHasNext.value = false;
    menuHasPrev.value = false;
    menuTotal.value = 0;
  }
}