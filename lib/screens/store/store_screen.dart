import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khaabd_web/screens/store/add_purchase.dart';
import 'package:khaabd_web/screens/widgets/dashboard_header.dart';
import 'package:khaabd_web/screens/store/transfer_to_kitchen.dart';
import 'package:khaabd_web/screens/store/tabs/current_inventory_tab.dart';
import 'package:khaabd_web/screens/store/tabs/purchase_history_tab.dart';
import 'package:khaabd_web/screens/store/tabs/supplier_ledger_tab.dart';
import 'package:khaabd_web/utils/colors.dart';
import 'package:khaabd_web/widgets/gradient_button.dart';
import 'package:khaabd_web/controller/getx_controllers/store_controller.dart';
import 'package:khaabd_web/models/models/store_models/get_inventory_model.dart';

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
  CurrentInventory? _editingInventoryItem;

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

  void _handleTransfer(String item, String quantity, String section) {
    print('Transferring $quantity of $item to $section section');
    // Add your transfer logic here
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

  void _handlePurchaseSave(String itemName, String supplierName, String quantity, String measuring, String category, String pricePerUnit, String paymentMethod) {
    if (_editingInventoryItem != null) {
      // Edit mode - update existing item
      print('Updating purchase: $itemName, $supplierName, $quantity $measuring, $category, $pricePerUnit, $paymentMethod');
    } else {
      // Add mode - create new item
      print('Adding new purchase: $itemName, $supplierName, $quantity $measuring, $category, $pricePerUnit, $paymentMethod');
    }
    // You can add your save logic here (API calls, local storage, etc.)
  }

  void _handleDeleteInventoryItem(CurrentInventory item) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Item'),
          content: Text('Are you sure you want to delete ${item.name}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                print('Deleted item: ${item.name}');
                // Add delete API call here
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
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
        );
      case 2:
        return SupplierLedgerTab(
          storeController: storeController,
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