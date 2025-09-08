import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khaabd_web/screens/kitchen/edit_kitchen_inventory.dart';
import 'package:khaabd_web/screens/kitchen/transfer_to_store.dart';
import 'package:khaabd_web/screens/kitchen/tabs/kitchen_inventory_tab.dart';
import 'package:khaabd_web/screens/kitchen/tabs/transfer_history_tab.dart';
import 'package:khaabd_web/screens/widgets/dashboard_header.dart';
import 'package:khaabd_web/utils/colors.dart';
import 'package:khaabd_web/widgets/gradient_button.dart';
import 'package:khaabd_web/controller/getx_controllers/kitchen_controller.dart';
import 'package:khaabd_web/models/models/kitchen_models/get_kitchen_inventory_model.dart';
import 'package:khaabd_web/models/models/kitchen_models/get_kitchen_transfer_history_model.dart';

class KitchenScreen extends StatefulWidget {
  final void Function(Map<String, dynamic>)? onShowDetail;
  const KitchenScreen({Key? key, this.onShowDetail}) : super(key: key);

  @override
  State<KitchenScreen> createState() => _KitchenScreenState();
}

class _KitchenScreenState extends State<KitchenScreen> {
  final KitchenController kitchenController = Get.put(KitchenController());
  int _tab = 0;
  bool _showDetails = false;
  bool _showTransferModal = false;
  bool _showEditInventoryModal = false;
  Map<String, String>? _selectedItem;
  Map<String, String>? _editingItem;
  Inventory? _editingInventoryItem;

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

  // Transfer logic is now handled in the modal itself

  // Edit inventory modal methods
  void _showEditInventoryModalMethod(Map<String, String> item) {
    setState(() {
      _editingItem = item;
      _showEditInventoryModal = true;
    });
  }

  void _closeEditInventoryModal() {
    setState(() {
      _showEditInventoryModal = false;
      _editingItem = null;
    });
  }

  void _handleInventoryUpdate(String itemName, String foodSection, String quantity, String measuring, String transferDate, String status) {
    // TODO: Implement API call to update inventory item
    print('Updated inventory: $itemName, $foodSection, $quantity $measuring, $transferDate, $status');
  }

  void _handleDeleteItem(dynamic item) {
    String itemName = '';
    if (item is Inventory) {
      itemName = item.itemName;
    } else if (item is History) {
      itemName = item.itemName;
    } else if (item is Map<String, String>) {
      itemName = item['itemName'] ?? '';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Item'),
          content: Text('Are you sure you want to delete $itemName?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // TODO: Implement API call to delete item
                Navigator.of(context).pop();
                print('Deleted item: $itemName');
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
    return Stack(
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
                      label: 'Kitchen Inventory',
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
                      label: 'Transfer History',
                      selected: _tab == 1,
                      onTap: () => setState(() {
                        _tab = 1;
                      }),
                      position: TabPosition.right,
                    ),
                  ],
                ),
              ),
             
              const SizedBox(height: 16),
              Expanded(child: _buildTabContent()),
            ],
          ),
        ),
        // Transfer to Store Modal
        if (_showTransferModal)
          TransferToStoreModal(
            onClose: _closeTransferModal,
          ),
        // Edit Kitchen Inventory Modal
        if (_showEditInventoryModal)
          EditKitchenInventoryModal(
            onClose: _closeEditInventoryModal,
            onSave: _handleInventoryUpdate,
            initialItemName: _editingItem?['itemName'],
            initialFoodSection: _editingItem?['foodSection'],
            initialQuantity: _editingItem?['quantity']?.replaceAll(RegExp(r'[^0-9]'), ''),
            initialMeasuring: _editingItem?['measuring'],
            initialTransferDate: _editingItem?['transferDate'],
            initialStatus: _editingItem?['status'],
          ),
      ],
    );
  }

  Widget _buildTabContent() {
    switch (_tab) {
      case 0:
        return KitchenInventoryTab(
          kitchenController: kitchenController,
          onEditItem: _showEditInventoryModalMethod,
          onDeleteItem: _handleDeleteItem,
          onInventoryUpdate: _handleInventoryUpdate,
        );
      case 1:
        return TransferHistoryTab(
          kitchenController: kitchenController,
          onDeleteItem: _handleDeleteItem,
        );
      default:
        return Container();
    }
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          const Text('Kitchen Operations', style: TextStyle(color: Colors.black, fontSize: 32, fontWeight: FontWeight.w700)),
          const Spacer(),
          SizedBox(
            height: 42,
            child: GradientButton(
              height: 32,
              text: "Transfer to store",
              icon: Icons.arrow_upward_outlined,
              onPressed: _showTransferToKitchenModal,
            ),
          ),
        ],
      ),
    );
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

class TableColumn {
  final String title;
  final int flex;
  const TableColumn(this.title, {required this.flex});
}