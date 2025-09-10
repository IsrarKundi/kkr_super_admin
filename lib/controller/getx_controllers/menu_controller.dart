import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../api_services/menu_apis.dart';
import '../../models/utils/snackbars.dart';
import '../../models/models/kitchen_models/get_menu_items.dart';
import '../../models/models/kitchen_models/get_items_by_section_model.dart';

class MenuGetxController extends GetxController {
  // Observable variables for menu items
  var isLoadingMenuItems = false.obs;
  var menuItems = <Datum>[].obs;
  var menuCurrentPage = 1.obs;
  var menuTotalPages = 1.obs;
  var menuHasNext = false.obs;
  var menuHasPrev = false.obs;
  var menuTotal = 0.obs;

  // Observable variables for items by section
  var isLoadingItemsBySection = false.obs;
  var itemsBySection = <IngredientsDatum>[].obs;

  // Observable variable for adding menu item
  var isAddingMenuItem = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Load initial data
    getMenuItems();
  }

  /// Get menu items
  Future<void> getMenuItems({
    int page = 1,
    int limit = 8,
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

  /// Get items by section
  Future<void> getItemsBySection({
    required String kitchenSection,
    int page = 1,
    int limit = 50,
    bool showLoading = true,
    required BuildContext context,
  }) async {
    try {
      if (showLoading) {
        isLoadingItemsBySection.value = true;
      }

      final result = await MenuService.getItemsBySection(
        page: page,
        limit: limit,
        kitchenSection: kitchenSection,
      );

      if (result['success']) {
        final getItemsBySectionModel = GetItemsBySectionModel.fromJson(result['data']);
        
        // Update observable variables
        itemsBySection.value = getItemsBySectionModel.data;
        
        print('Items by section loaded successfully: ${itemsBySection.length} items');
      } else {
        print('Failed to load items by section: ${result['data']['message'] ?? 'Unknown error'}');
        showNativeErrorSnackbar(context ,result['data']['message'] ?? 'Failed to load items');
      }
    } catch (e) {
      print('Get items by section error: $e');
      showNativeErrorSnackbar(context ,'Failed to load items: ${e.toString()}');
    } finally {
      if (showLoading) {
        isLoadingItemsBySection.value = false;
      }
    }
  }

  /// Add menu item
  Future<bool> addMenuItem({
    required String menuItemName,
    required String foodSection,
    required int sellingPrice,
    required String description,
    required String takeAwayPacking,
    required List<Map<String, dynamic>> ingredients,
    required BuildContext context,
  }) async {
    try {
      isAddingMenuItem.value = true;

      final result = await MenuService.addMenuItem(
        menuItemName: menuItemName,
        foodSection: foodSection,
        sellingPrice: sellingPrice,
        description: description,
        takeAwayPacking: takeAwayPacking,
        ingredients: ingredients,
      );

      if (result['success']) {
        showNativeSuccessSnackbar(context ,result['data']['message'] ?? 'Menu item added successfully');
        // Refresh menu items to reflect changes
              isAddingMenuItem.value = false;

        await refreshMenuItems();
        return true;
      } else {
        // Show error message from backend
        final errorMessage = result['data']['message'] ?? 'Failed to add menu item';
        showNativeErrorSnackbar(context ,errorMessage);
        return false;
      }
    } catch (e) {
      showNativeErrorSnackbar(context ,'Add menu item failed: ${e.toString()}');
      print('Add menu item error: $e');
      return false;
    } finally {
      isAddingMenuItem.value = false;
    }
  }

  /// Update menu item
  Future<bool> updateMenuItem({
    required String itemId,
    required String menuItemName,
    required String foodSection,
    required int sellingPrice,
    required String description,
    required String takeAwayPacking,
    required List<Map<String, dynamic>> ingredients,
    required BuildContext context,
  }) async {
    try {
      isAddingMenuItem.value = true;

      final result = await MenuService.updateMenuItem(
        itemId: itemId,
        menuItemName: menuItemName,
        foodSection: foodSection,
        sellingPrice: sellingPrice,
        description: description,
        takeAwayPacking: takeAwayPacking,
        ingredients: ingredients,
      );

      if (result['success']) {
        showNativeSuccessSnackbar(context ,result['data']['message'] ?? 'Menu item updated successfully');
              isAddingMenuItem.value = false;

        // Refresh menu items to reflect changes
        await refreshMenuItems();
        return true;
      } else {
        // Show error message from backend
        final errorMessage = result['data']['message'] ?? 'Failed to update menu item';
        showNativeErrorSnackbar(context ,errorMessage);
        return false;
      }
    } catch (e) {
      showNativeErrorSnackbar(context ,'Update menu item failed: ${e.toString()}');
      print('Update menu item error: $e');
      return false;
    } finally {
      isAddingMenuItem.value = false;
    }
  }

  /// Delete menu item
  Future<bool> deleteMenuItem({
    required String itemId,
    required BuildContext context,
  }) async {
    try {
      isAddingMenuItem.value = true;

      final result = await MenuService.deleteMenuItem(
        itemId: itemId,
      );

      if (result['success']) {
        showNativeSuccessSnackbar(context ,result['data']['message'] ?? 'Menu item deleted successfully');
        await refreshMenuItems();
        return true;
      } else {
        final errorMessage = result['data']['message'] ?? 'Failed to delete menu item';
        showNativeErrorSnackbar(context ,errorMessage);
        return false;
      }
    } catch (e) {
      showNativeErrorSnackbar(context ,'Delete menu item failed: ${e.toString()}');
      print('Delete menu item error: $e');
      return false;
    } finally {
      isAddingMenuItem.value = false;
    }
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

    // Clear items by section data
    itemsBySection.clear();
  }
}