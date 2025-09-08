import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../api_services/kitchen_apis.dart';
import '../../models/utils/snackbars.dart';
import '../../models/models/kitchen_models/get_kitchen_inventory_model.dart';
import '../../models/models/kitchen_models/get_kitchen_transfer_history_model.dart';

class KitchenController extends GetxController {
  // Observable variables for kitchen inventory
  var isLoadingKitchenInventory = false.obs;
  var kitchenInventory = <Inventory>[].obs;
  var inventoryCurrentPage = 1.obs;
  var inventoryTotalPages = 1.obs;
  var inventoryHasNext = false.obs;
  var inventoryHasPrev = false.obs;
  var inventoryTotal = 0.obs;

  // Observable variables for transfer history
  var isLoadingTransferHistory = false.obs;
  var transferHistory = <History>[].obs;
  var transferCurrentPage = 1.obs;
  var transferTotalPages = 1.obs;
  var transferHasNext = false.obs;
  var transferHasPrev = false.obs;
  var transferTotal = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Load initial data
    getKitchenInventory();
    getTransferHistory();
  }

  /// Get kitchen inventory
  Future<void> getKitchenInventory({
    int page = 1,
    int limit = 13,
    String section = 'all',
    bool showLoading = true,
  }) async {
    try {
      if (showLoading) {
        isLoadingKitchenInventory.value = true;
      }

      final result = await KitchenService.getKitchenInventory(
        page: page,
        limit: limit,
        section: section,
      );

      if (result['success']) {
        final getKitchenInventoryModel = GetKitchenInventoryModel.fromJson(result['data']);
        
        // Update observable variables
        kitchenInventory.value = getKitchenInventoryModel.data.inventory;
        inventoryCurrentPage.value = int.parse(getKitchenInventoryModel.data.pagination.page);
        inventoryTotalPages.value = getKitchenInventoryModel.data.pagination.totalPages;
        inventoryHasNext.value = getKitchenInventoryModel.data.pagination.hasNext;
        inventoryHasPrev.value = getKitchenInventoryModel.data.pagination.hasPrev;
        inventoryTotal.value = getKitchenInventoryModel.data.pagination.total;
        
        print('Kitchen inventory loaded successfully: ${kitchenInventory.length} items');
      } else {
        print('Failed to load kitchen inventory: ${result['data']['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      print('Get kitchen inventory error: $e');
    } finally {
      if (showLoading) {
        isLoadingKitchenInventory.value = false;
      }
    }
  }

  /// Get transfer history
  Future<void> getTransferHistory({
    int page = 1,
    int limit = 13,
    bool showLoading = true,
  }) async {
    try {
      if (showLoading) {
        isLoadingTransferHistory.value = true;
      }

      final result = await KitchenService.getTransferHistory(
        page: page,
        limit: limit,
      );

      if (result['success']) {
        final getTransferHistoryModel = GetKitchenTransferHistoryModel.fromJson(result['data']);
        
        // Update observable variables
        transferHistory.value = getTransferHistoryModel.data.history;
        transferCurrentPage.value = getTransferHistoryModel.data.pagination.page;
        transferTotalPages.value = getTransferHistoryModel.data.pagination.totalPages;
        transferHasNext.value = getTransferHistoryModel.data.pagination.hasNext;
        transferHasPrev.value = getTransferHistoryModel.data.pagination.hasPrev;
        transferTotal.value = getTransferHistoryModel.data.pagination.total;
        
        print('Transfer history loaded successfully: ${transferHistory.length} items');
      } else {
        print('Failed to load transfer history: ${result['data']['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      print('Get transfer history error: $e');
    } finally {
      if (showLoading) {
        isLoadingTransferHistory.value = false;
      }
    }
  }

  // Pagination methods for kitchen inventory
  Future<void> loadNextInventoryPage() async {
    if (inventoryHasNext.value && !isLoadingKitchenInventory.value) {
      await getKitchenInventory(
        page: inventoryCurrentPage.value + 1,
        showLoading: false,
      );
    }
  }

  Future<void> loadPreviousInventoryPage() async {
    if (inventoryHasPrev.value && !isLoadingKitchenInventory.value && inventoryCurrentPage.value > 1) {
      await getKitchenInventory(
        page: inventoryCurrentPage.value - 1,
        showLoading: false,
      );
    }
  }

  // Pagination methods for transfer history
  Future<void> loadNextTransferPage() async {
    if (transferHasNext.value && !isLoadingTransferHistory.value) {
      await getTransferHistory(
        page: transferCurrentPage.value + 1,
        showLoading: false,
      );
    }
  }

  Future<void> loadPreviousTransferPage() async {
    if (transferHasPrev.value && !isLoadingTransferHistory.value && transferCurrentPage.value > 1) {
      await getTransferHistory(
        page: transferCurrentPage.value - 1,
        showLoading: false,
      );
    }
  }

  /// Refresh methods
  Future<void> refreshKitchenInventory() async {
    await getKitchenInventory(page: 1);
  }

  Future<void> refreshTransferHistory() async {
    await getTransferHistory(page: 1);
  }

  /// Clear all data
  void clearData() {
    // Clear kitchen inventory data
    kitchenInventory.clear();
    inventoryCurrentPage.value = 1;
    inventoryTotalPages.value = 1;
    inventoryHasNext.value = false;
    inventoryHasPrev.value = false;
    inventoryTotal.value = 0;

    // Clear transfer history data
    transferHistory.clear();
    transferCurrentPage.value = 1;
    transferTotalPages.value = 1;
    transferHasNext.value = false;
    transferHasPrev.value = false;
    transferTotal.value = 0;
  }
}