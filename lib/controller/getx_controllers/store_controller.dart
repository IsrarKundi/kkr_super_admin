import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../api_services/store_apis.dart';
import '../../models/utils/snackbars.dart';
import '../../models/models/store_models/get_inventory_model.dart';
import '../../models/models/store_models/get_purchase_history_model.dart';
import '../../models/models/store_models/get_supplier_ledger_model.dart';

class StoreController extends GetxController {
  // Observable variables for inventory
  var isLoadingInventory = false.obs;
  var currentInventory = <CurrentInventory>[].obs;
  var inventoryCurrentPage = 1.obs;
  var inventoryTotalPages = 1.obs;
  var inventoryHasNext = false.obs;
  var inventoryHasPrev = false.obs;
  var inventoryTotal = 0.obs;

  // Observable variables for purchase history
  var isLoadingPurchaseHistory = false.obs;
  var purchaseHistory = <PurchaseHistory>[].obs;
  var purchaseCurrentPage = 1.obs;
  var purchaseTotalPages = 1.obs;
  var purchaseHasNext = false.obs;
  var purchaseHasPrev = false.obs;
  var purchaseTotal = 0.obs;

  // Observable variables for supplier ledger
  var isLoadingSupplierLedger = false.obs;
  var supplierLedger = <Ledger>[].obs;
  var supplierCurrentPage = 1.obs;
  var supplierTotalPages = 1.obs;
  var supplierHasNext = false.obs;
  var supplierHasPrev = false.obs;
  var supplierTotal = 0.obs;

  // Observable variable for add purchase loading
  var isAddingPurchase = false.obs;

  // Observable variable for make payment loading
  var isMakingPayment = false.obs;

  // Observable variable for cancel purchase loading
  var isCancellingPurchase = false.obs;

  // Observable variable for delete inventory item loading
  var isDeletingInventoryItem = false.obs;

  // Observable variable for transfer to kitchen loading
  var isTransferringToKitchen = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Load initial data
    getCurrentInventory();
    getPurchaseHistory();
    getSupplierLedger();
  }

  /// Get current inventory
  Future<void> getCurrentInventory({
    int page = 1,
    int limit = 13,
    String section = 'all',
    bool showLoading = true,
  }) async {
    try {
      if (showLoading) {
        isLoadingInventory.value = true;
      }

      final result = await StoreService.getCurrentInventory(
        page: page,
        limit: limit,
        section: section,
      );

      if (result['success']) {
        final getInventoryModel = GetInventoryModel.fromJson(result['data']);
        
        // Update observable variables
        currentInventory.value = getInventoryModel.data.currentInventory;
        inventoryCurrentPage.value = getInventoryModel.data.pagination.page;
        inventoryTotalPages.value = getInventoryModel.data.pagination.totalPages;
        inventoryHasNext.value = getInventoryModel.data.pagination.hasNext;
        inventoryHasPrev.value = getInventoryModel.data.pagination.hasPrev;
        inventoryTotal.value = getInventoryModel.data.pagination.total;
        
        print('Current inventory loaded successfully: ${currentInventory.length} items');
      } else {
        print('Failed to load current inventory: ${result['data']['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      print('Get current inventory error: $e');
    } finally {
      if (showLoading) {
        isLoadingInventory.value = false;
      }
    }
  }

  /// Get purchase history
  Future<void> getPurchaseHistory({
    int page = 1,
    int limit = 13,
    bool showLoading = true,
  }) async {
    try {
      if (showLoading) {
        isLoadingPurchaseHistory.value = true;
      }

      final result = await StoreService.getPurchaseHistory(
        page: page,
        limit: limit,
      );

      if (result['success']) {
        final getPurchaseHistoryModel = GetPurchaseHistoryModel.fromJson(result['data']);
        
        // Update observable variables
        purchaseHistory.value = getPurchaseHistoryModel.data.purchaseHistory;
        purchaseCurrentPage.value = getPurchaseHistoryModel.data.pagination.page;
        purchaseTotalPages.value = getPurchaseHistoryModel.data.pagination.totalPages;
        purchaseHasNext.value = getPurchaseHistoryModel.data.pagination.hasNext;
        purchaseHasPrev.value = getPurchaseHistoryModel.data.pagination.hasPrev;
        purchaseTotal.value = getPurchaseHistoryModel.data.pagination.total;
        
        print('Purchase history loaded successfully: ${purchaseHistory.length} items');
      } else {
        print('Failed to load purchase history: ${result['data']['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      print('Get purchase history error: $e');
    } finally {
      if (showLoading) {
        isLoadingPurchaseHistory.value = false;
      }
    }
  }

  /// Get supplier ledger
  Future<void> getSupplierLedger({
    int page = 1,
    int limit = 9,
    bool showLoading = true,
  }) async {
    try {
      if (showLoading) {
        isLoadingSupplierLedger.value = true;
      }

      final result = await StoreService.getSupplierLedger(
        page: page,
        limit: limit,
      );

      if (result['success']) {
        final getSupplierLedgerModel = GetSupplierLedgerModel.fromJson(result['data']);
        
        // Update observable variables
        supplierLedger.value = getSupplierLedgerModel.data.ledger;
        supplierCurrentPage.value = getSupplierLedgerModel.data.pagination.page;
        supplierTotalPages.value = getSupplierLedgerModel.data.pagination.totalPages;
        supplierHasNext.value = getSupplierLedgerModel.data.pagination.hasNext;
        supplierHasPrev.value = getSupplierLedgerModel.data.pagination.hasPrev;
        supplierTotal.value = getSupplierLedgerModel.data.pagination.total;
        
        print('Supplier ledger loaded successfully: ${supplierLedger.length} suppliers');
      } else {
        print('Failed to load supplier ledger: ${result['data']['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      print('Get supplier ledger error: $e');
    } finally {
      if (showLoading) {
        isLoadingSupplierLedger.value = false;
      }
    }
  }

  // Pagination methods for inventory
  Future<void> loadNextInventoryPage() async {
    if (inventoryHasNext.value && !isLoadingInventory.value) {
      await getCurrentInventory(
        page: inventoryCurrentPage.value + 1,
        showLoading: false,
      );
    }
  }

  Future<void> loadPreviousInventoryPage() async {
    if (inventoryHasPrev.value && !isLoadingInventory.value && inventoryCurrentPage.value > 1) {
      await getCurrentInventory(
        page: inventoryCurrentPage.value - 1,
        showLoading: false,
      );
    }
  }

  // Pagination methods for purchase history
  Future<void> loadNextPurchasePage() async {
    if (purchaseHasNext.value && !isLoadingPurchaseHistory.value) {
      await getPurchaseHistory(
        page: purchaseCurrentPage.value + 1,
        showLoading: false,
      );
    }
  }

  Future<void> loadPreviousPurchasePage() async {
    if (purchaseHasPrev.value && !isLoadingPurchaseHistory.value && purchaseCurrentPage.value > 1) {
      await getPurchaseHistory(
        page: purchaseCurrentPage.value - 1,
        showLoading: false,
      );
    }
  }

  // Pagination methods for supplier ledger
  Future<void> loadNextSupplierPage() async {
    if (supplierHasNext.value && !isLoadingSupplierLedger.value) {
      await getSupplierLedger(
        page: supplierCurrentPage.value + 1,
        showLoading: false,
      );
    }
  }

  Future<void> loadPreviousSupplierPage() async {
    if (supplierHasPrev.value && !isLoadingSupplierLedger.value && supplierCurrentPage.value > 1) {
      await getSupplierLedger(
        page: supplierCurrentPage.value - 1,
        showLoading: false,
      );
    }
  }

  /// Refresh methods
  Future<void> refreshInventory() async {
    await getCurrentInventory(page: 1);
  }

  Future<void> refreshPurchaseHistory() async {
    await getPurchaseHistory(page: 1);
  }

  Future<void> refreshSupplierLedger() async {
    await getSupplierLedger(page: 1);
  }

  /// Add purchase
  Future<bool> addPurchase({
    required String itemName,
    required String supplierName,
    required String category,
    required String measuringUnit,
    required double pricePerUnit,
    required int quantity,
    required String paymentMethod,
    required BuildContext context
  }) async {
    try {
      isAddingPurchase.value = true;
      

      // Map category from UI to API format
      String apiCategory = category == 'Kitchen Inventory' ? 'kitchen' : 'packing';

      final result = await StoreService.addPurchase(
        itemName: itemName,
        supplierName: supplierName,
        category: apiCategory,
        measuringUnit: measuringUnit,
        pricePerUnit: pricePerUnit,
        quantity: quantity,
        paymentMethod: paymentMethod.toLowerCase(),
      );

      if (result['success']) {
        // Show success message
        showNativeSuccessSnackbar(context!, 'Inventory added successfully');
        
        // Refresh inventory and purchase history to reflect the new item
        await refreshInventory();
        await refreshPurchaseHistory();
        
        print('Purchase added successfully: ${result['data']}');
        return true;
      } else {
        // Show error message
        String errorMessage = result['data']['message'] ?? 'Failed to add purchase';
        showNativeErrorSnackbar(context!, errorMessage);
        print('Failed to add purchase: $errorMessage');
        return false;
      }
    } catch (e) {
      showNativeErrorSnackbar(context!, 'Error adding purchase: $e');
      print('Add purchase error: $e');
      return false;
    } finally {
      isAddingPurchase.value = false;
    }
  }

  /// Make payment to supplier
  Future<bool> makePayment({
    required String supplierId,
    required double amount,
    required BuildContext context
  }) async {
    try {
      isMakingPayment.value = true;

      final result = await StoreService.makePayment(
        supplierId: supplierId,
        amount: amount,
      );

      if (result['success']) {
        // Show success message
        showNativeSuccessSnackbar(context!, 'Payment made successfully');
        
        // Refresh supplier ledger to reflect the updated outstanding amount
        await refreshSupplierLedger();
        
        print('Payment made successfully: ${result['data']}');
        return true;
      } else {
        // Show error message
        String errorMessage = result['data']['message'] ?? 'Failed to make payment';
        showNativeErrorSnackbar(context!, errorMessage);
        print('Failed to make payment: $errorMessage');
        return false;
      }
    } catch (e) {
      showNativeErrorSnackbar(context!, 'Error making payment: $e');
      print('Make payment error: $e');
      return false;
    } finally {
      isMakingPayment.value = false;
    }
  }

  /// Cancel purchase
  Future<bool> cancelPurchase({
    required String purchaseId,
    required BuildContext context
  }) async {
    try {
      isCancellingPurchase.value = true;

      final result = await StoreService.cancelPurchase(
        purchaseId: purchaseId,
      );

      if (result['success']) {
        // Show success message
        showNativeSuccessSnackbar(context!, 'Purchase cancelled successfully');
        
        // Refresh inventory and purchase history to reflect the changes
        await refreshInventory();
        await refreshPurchaseHistory();
        
        print('Purchase cancelled successfully: ${result['data']}');
        return true;
      } else {
        // Show error message
        String errorMessage = result['data']['message'] ?? 'Failed to cancel purchase';
        showNativeErrorSnackbar(context!, errorMessage);
        print('Failed to cancel purchase: $errorMessage');
        return false;
      }
    } catch (e) {
      showNativeErrorSnackbar(context!, 'Error cancelling purchase: $e');
      print('Cancel purchase error: $e');
      return false;
    } finally {
      isCancellingPurchase.value = false;
    }
  }

  /// Delete inventory item
  Future<bool> deleteInventoryItem({
    required String itemId,
    required BuildContext context
  }) async {
    try {
      isDeletingInventoryItem.value = true;

      final result = await StoreService.deleteInventoryItem(
        itemId: itemId,
      );

      if (result['success']) {
        // Show success message
        showNativeSuccessSnackbar(context!, 'Item deleted successfully');
        
        // Refresh inventory to reflect the changes
        await refreshInventory();
        
        print('Item deleted successfully: ${result['data']}');
        return true;
      } else {
        // Show error message
        String errorMessage = result['data']['message'] ?? 'Failed to delete item';
        showNativeErrorSnackbar(context!, errorMessage);
        print('Failed to delete item: $errorMessage');
        return false;
      }
    } catch (e) {
      showNativeErrorSnackbar(context!, 'Error deleting item: $e');
      print('Delete item error: $e');
      return false;
    } finally {
      isDeletingInventoryItem.value = false;
    }
  }

  /// Transfer to kitchen
  Future<bool> transferToKitchen({
    required String itemId,
    required int quantity,
    required String kitchenSection,
    required BuildContext context
  }) async {
    try {
      isTransferringToKitchen.value = true;

      final result = await StoreService.transferToKitchen(
        itemId: itemId,
        quantity: quantity,
        kitchenSection: kitchenSection,
      );

      if (result['success']) {
        // Show success message
        showNativeSuccessSnackbar(context!, 'Item transferred to kitchen successfully');
        
        // Refresh inventory to reflect the changes
        await refreshInventory();
        
        print('Item transferred successfully: ${result['data']}');
        return true;
      } else {
        // Show error message
        String errorMessage = result['data']['message'] ?? 'Failed to transfer item';
        showNativeErrorSnackbar(context!, errorMessage);
        print('Failed to transfer item: $errorMessage');
        return false;
      }
    } catch (e) {
      showNativeErrorSnackbar(context!, 'Error transferring item: $e');
      print('Transfer item error: $e');
      return false;
    } finally {
      isTransferringToKitchen.value = false;
    }
  }

  /// Clear all data
  void clearData() {
    // Clear inventory data
    currentInventory.clear();
    inventoryCurrentPage.value = 1;
    inventoryTotalPages.value = 1;
    inventoryHasNext.value = false;
    inventoryHasPrev.value = false;
    inventoryTotal.value = 0;

    // Clear purchase history data
    purchaseHistory.clear();
    purchaseCurrentPage.value = 1;
    purchaseTotalPages.value = 1;
    purchaseHasNext.value = false;
    purchaseHasPrev.value = false;
    purchaseTotal.value = 0;

    // Clear supplier ledger data
    supplierLedger.clear();
    supplierCurrentPage.value = 1;
    supplierTotalPages.value = 1;
    supplierHasNext.value = false;
    supplierHasPrev.value = false;
    supplierTotal.value = 0;
  }
}