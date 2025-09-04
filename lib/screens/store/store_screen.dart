import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khaabd_web/screens/store/add_purchase.dart';
import 'package:khaabd_web/screens/store/make_payment_popup.dart';
import 'package:khaabd_web/screens/store/delete_purchase_modal.dart';
import 'package:khaabd_web/screens/store/delete_inventory_item_modal.dart';
import 'package:khaabd_web/screens/widgets/dashboard_header.dart';
import 'package:khaabd_web/screens/store/transfer_to_kitchen.dart';
import 'package:khaabd_web/screens/store/tabs/current_inventory_tab.dart';
import 'package:khaabd_web/screens/store/tabs/purchase_history_tab.dart';
import 'package:khaabd_web/screens/store/tabs/supplier_ledger_tab.dart';
import 'package:khaabd_web/utils/colors.dart';
import 'package:khaabd_web/widgets/gradient_button.dart';
import 'package:khaabd_web/controller/getx_controllers/store_controller.dart';
import 'package:khaabd_web/models/models/store_models/get_inventory_model.dart';
import 'package:khaabd_web/models/models/store_models/get_supplier_ledger_model.dart';
import 'package:khaabd_web/models/models/store_models/get_purchase_history_model.dart';

class StoreScreen extends StatefulWidget {
  final void Function(Map<String, dynamic>)? onShowDetail;
  const StoreScreen({Key? key, this.onShowDetail}) : super(key: key);

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final StoreController storeController = Get.put(StoreController());
  int _tab = 0;
  bool _showTransferModal = false;
  bool _showPurchaseModal = false;
  bool _showMakePaymentModal = false;
  bool _showDeletePurchaseModal = false;
  bool _showDeleteInventoryItemModal = false;
  CurrentInventory? _editingInventoryItem;
  CurrentInventory? _inventoryItemToDelete;
  Ledger? _selectedSupplier;
  PurchaseHistory? _purchaseToDelete;

  // Transfer modal methods
  void _showTransferToKitchenModal() {
    setState(() {
      _showTransferModal = true;
    });
  }

  void _closeTransferModal() {
    setState(() {
      _showTransferModal = false;
    });
  }

  Future<void> _handleTransfer(String itemId, String quantity, String section) async {
    try {
      // Map section names to API format
      String apiSection = section.toLowerCase().replaceAll(' ', '-');
      
      final success = await storeController.transferToKitchen(
        itemId: itemId,
        quantity: int.parse(quantity),
        kitchenSection: apiSection,
        context: context
      );
      
      if (success) {
        _closeTransferModal();
      }
    } catch (e) {
      print('Error transferring item: $e');
    }
  }

  // Purchase modal methods
  void _showAddPurchaseModal() {
    setState(() {
      _editingInventoryItem = null;
      _showPurchaseModal = true;
    });
  }

  void _showEditInventoryModal(CurrentInventory item) {
    setState(() {
      _editingInventoryItem = item;
      _showPurchaseModal = true;
    });
  }

  void _closePurchaseModal() {
    setState(() {
      _showPurchaseModal = false;
      _editingInventoryItem = null;
    });
  }

  Future<void> _handlePurchaseSave(String itemName, String supplierName, String quantity, String measuring, String category, String pricePerUnit, String paymentMethod) async {
    if (_editingInventoryItem != null) {
      // Edit mode - update existing item
      print('Updating purchase: $itemName, $supplierName, $quantity $measuring, $category, $pricePerUnit, $paymentMethod');
      // TODO: Implement edit functionality when API is available
    } else {
      // Add mode - create new item
      try {
        final success = await storeController.addPurchase(
          itemName: itemName,
          supplierName: supplierName,
          category: category,
          measuringUnit: measuring,
          pricePerUnit: double.parse(pricePerUnit),
          quantity: int.parse(quantity),
          paymentMethod: paymentMethod,
          context: context
        );
        
        if (success) {
          _closePurchaseModal();
        }
      } catch (e) {
        print('Error adding purchase: $e');
      }
    }
  }

  // Delete inventory item modal methods
  void _showDeleteInventoryItemModalMethod(CurrentInventory item) {
    setState(() {
      _inventoryItemToDelete = item;
      _showDeleteInventoryItemModal = true;
    });
  }

  void _closeDeleteInventoryItemModal() {
    setState(() {
      _showDeleteInventoryItemModal = false;
      _inventoryItemToDelete = null;
    });
  }

  void _handleDeleteInventoryItem(CurrentInventory item) {
    _showDeleteInventoryItemModalMethod(item);
  }

  Future<void> _confirmDeleteInventoryItem() async {
    if (_inventoryItemToDelete != null) {
      try {
        final success = await storeController.deleteInventoryItem(
          itemId: _inventoryItemToDelete!.itemId,
          context: context
        );
        
        if (success) {
          _closeDeleteInventoryItemModal();
        }
      } catch (e) {
        print('Error deleting inventory item: $e');
      }
    }
  }

  // Make payment modal methods
  void _showMakePaymentModalMethod(Ledger supplier) {
    setState(() {
      _selectedSupplier = supplier;
      _showMakePaymentModal = true;
    });
  }

  void _closeMakePaymentModal() {
    setState(() {
      _showMakePaymentModal = false;
      _selectedSupplier = null;
    });
  }

  Future<void> _handleMakePayment(String supplierId, double amount) async {
    try {
      final success = await storeController.makePayment(
        supplierId: supplierId,
        amount: amount,
        context: context
      );
      
      if (success) {
        _closeMakePaymentModal();
      }
    } catch (e) {
      print('Error making payment: $e');
    }
  }

  // Delete purchase modal methods
  void _showDeletePurchaseModalMethod(PurchaseHistory purchase) {
    setState(() {
      _purchaseToDelete = purchase;
      _showDeletePurchaseModal = true;
    });
  }

  void _closeDeletePurchaseModal() {
    setState(() {
      _showDeletePurchaseModal = false;
      _purchaseToDelete = null;
    });
  }

  // Delete purchase methods
  void _handleDeletePurchase(PurchaseHistory purchase) {
    _showDeletePurchaseModalMethod(purchase);
  }

  Future<void> _confirmDeletePurchase() async {
    if (_purchaseToDelete != null) {
      try {
        final success = await storeController.cancelPurchase(
          purchaseId: _purchaseToDelete!.purchaseId,
          context: context
        );
        
        if (success) {
          _closeDeletePurchaseModal();
        }
      } catch (e) {
        print('Error cancelling purchase: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return 
    Stack(
      children: [
        Container(
          color: greyScaffoldBackgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DashboardHeader(),
              const SizedBox(height: 22),
              _buildHeader(),
              const SizedBox(height: 16),
              // Tabs
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Row(
                  children: [
                    _TabButton(
                      label: 'Current Inventory',
                      selected: _tab == 0,
                      onTap: () => setState(() {
                        _tab = 0;
                      }),
                      position: TabPosition.left,
                    ),
                    Container(
                      width: 1,
                      height: 44,
                      color: goldenColor1,
                    ),
                    _TabButton(
                      label: 'Purchase History',
                      selected: _tab == 1,
                      onTap: () => setState(() {
                        _tab = 1;
                      }),
                      position: TabPosition.middle,
                    ),
                    Container(
                      width: 1,
                      height: 44,
                      color: goldenColor1,
                    ),
                    _TabButton(
                      label: 'Supplier Ledger',
                      selected: _tab == 2,
                      onTap: () => setState(() {
                        _tab = 2;
                      }),
                      position: TabPosition.right,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(child: _buildCurrentTab()),
            ],
          ),
        ),
        // Transfer to Kitchen Modal
        if (_showTransferModal)
          TransferToKitchenModal(
            onClose: _closeTransferModal,
            onTransfer: _handleTransfer,
          ),
        // Add/Edit Purchase Modal
        if (_showPurchaseModal)
          AddPurchaseModal(
            onClose: _closePurchaseModal,
            onSave: _handlePurchaseSave,
            isEditMode: _editingInventoryItem != null,
            // Pass initial values for edit mode
            initialItemName: _editingInventoryItem?.name,
            initialSupplierName: '', // We don't have supplier in inventory model
            initialQuantity: _editingInventoryItem?.currentStock.toString(),
            initialMeasuring: _editingInventoryItem?.measuringUnit,
            initialCategory: _editingInventoryItem?.category,
            initialPricePerUnit: _editingInventoryItem?.pricePerUnit.toString(),
            initialPaymentMethod: '',
          ),
        // Make Payment Modal
        if (_showMakePaymentModal && _selectedSupplier != null)
          MakePaymentModal(
            onClose: _closeMakePaymentModal,
            onSave: _handleMakePayment,
            supplierName: _selectedSupplier!.supplierName,
            supplierId: _selectedSupplier!.supplierId,
          ),
        // Delete Purchase Modal
        if (_showDeletePurchaseModal && _purchaseToDelete != null)
          DeletePurchaseModal(
            purchase: _purchaseToDelete!,
            onClose: _closeDeletePurchaseModal,
            onConfirm: _confirmDeletePurchase,
          ),
        // Delete Inventory Item Modal
        if (_showDeleteInventoryItemModal && _inventoryItemToDelete != null)
          DeleteInventoryItemModal(
            item: _inventoryItemToDelete!,
            onClose: _closeDeleteInventoryItemModal,
            onConfirm: _confirmDeleteInventoryItem,
          ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          const Text('Store Management', style: TextStyle(color: Colors.black, fontSize: 32, fontWeight: FontWeight.w700)),
          const Spacer(),
          SizedBox(
            height: 42,
            child: GradientButton(
              height: 32,
              text: "Transfer to Kitchen",
              icon: Icons.arrow_upward_outlined,
              onPressed: _showTransferToKitchenModal,
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            height: 42,
            child: GradientButton(
              height: 32,
              text: "Add Purchase",
              icon: Icons.add,
              onPressed: _showAddPurchaseModal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentTab() {
    switch (_tab) {
      case 0:
        return CurrentInventoryTab(
          storeController: storeController,
          onEdit: _showEditInventoryModal,
          onDelete: _handleDeleteInventoryItem,
        );
      case 1:
        return PurchaseHistoryTab(
          storeController: storeController,
          onDeletePurchase: _handleDeletePurchase,
        );
      case 2:
        return SupplierLedgerTab(
          storeController: storeController,
          onMakePayment: _showMakePaymentModalMethod,
        );
      default:
        return Container();
    }
  }
}

enum TabPosition { left, middle, right }

class _TabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final TabPosition position;

  const _TabButton({
    Key? key,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.position,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            gradient: selected
                ? LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [goldenColor2, goldenColor1, goldenColor2],
                  )
                : null,
            color: selected ? null : Colors.white,
            borderRadius: _getBorderRadius(),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 17,
              ),
            ),
          ),
        ),
      ),
    );
  }

  BorderRadius _getBorderRadius() {
    switch (position) {
      case TabPosition.left:
        return const BorderRadius.only(
          topLeft: Radius.circular(22),
          bottomLeft: Radius.circular(22),
        );
      case TabPosition.right:
        return const BorderRadius.only(
          topRight: Radius.circular(22),
          bottomRight: Radius.circular(22),
        );
      case TabPosition.middle:
        return BorderRadius.zero;
    }
  }
}