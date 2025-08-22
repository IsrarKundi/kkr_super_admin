import 'package:flutter/material.dart';
import 'package:khaabd_web/screens/kitchen/transfer_to_store.dart';
import 'package:khaabd_web/screens/kitchen/edit_kitchen_inventory.dart';
import 'package:khaabd_web/screens/widgets/dashboard_header.dart';
import 'package:khaabd_web/screens/store/transfer_to_kitchen.dart';
import 'package:khaabd_web/utils/colors.dart';
import 'package:khaabd_web/widgets/gradient_button.dart';

class KitchenScreen extends StatefulWidget {
  final void Function(Map<String, dynamic>)? onShowDetail;
  const KitchenScreen({Key? key, this.onShowDetail}) : super(key: key);

  @override
  State<KitchenScreen> createState() => _KitchenScreenState();
}

class _KitchenScreenState extends State<KitchenScreen> {
  int _tab = 0;
  bool _showDetails = false;
  bool _showTransferModal = false;
  bool _showEditInventoryModal = false; // Add this state variable
  Map<String, String>? _selectedItem;
  Map<String, String>? _editingItem; // Add this for edit mode

  // Mock data for Kitchen Inventory
  final List<Map<String, String>> _kitchenInventory = List.generate(15, (i) => {
    'itemName': ['Rice Basmati', 'Chicken Breast', 'Tomatoes', 'Onions', 'Cooking Oil', 'Salt', 'Black Pepper', 'Garlic', 'Ginger', 'Potatoes', 'Carrots', 'Bell Peppers', 'Yogurt', 'Milk', 'Eggs'][i],
    'foodSection': ['Desi', 'Chinese', 'Afghani', 'Fast Food', 'Desi', 'Chinese', 'Afghani', 'Fast Food', 'Desi', 'Chinese', 'Afghani', 'Fast Food', 'Desi', 'Chinese', 'Fast Food'][i],
    'quantity': ['50 kg', '25 kg', '30 kg', '20 kg', '10 L', '5 kg', '2 kg', '3 kg', '2 kg', '40 kg', '15 kg', '10 kg', '20 L', '15 L', '200 pcs'][i],
    'transferDate': ['2024-01-15', '2024-01-14', '2024-01-13', '2024-01-12', '2024-01-11', '2024-01-10', '2024-01-09', '2024-01-08', '2024-01-07', '2024-01-06', '2024-01-05', '2024-01-04', '2024-01-03', '2024-01-02', '2024-01-01'][i],
    'status': i % 3 == 0 ? 'Stock Out' : 'Stock In',
    'measuring': ['kg', 'kg', 'kg', 'kg', 'L', 'kg', 'kg', 'kg', 'kg', 'kg', 'kg', 'kg', 'L', 'L', 'pcs'][i],
  });

  // Mock data for Transfer History
  final List<Map<String, String>> _transferHistory = List.generate(20, (i) => {
    'transferDate': ['2024-01-${20-i}', '2024-01-${19-i}', '2024-01-${18-i}', '2024-01-${17-i}', '2024-01-${16-i}', '2024-01-${15-i}', '2024-01-${14-i}', '2024-01-${13-i}', '2024-01-${12-i}', '2024-01-${11-i}', '2024-01-${10-i}', '2024-01-${9-i}', '2024-01-${8-i}', '2024-01-${7-i}', '2024-01-${6-i}', '2024-01-${5-i}', '2024-01-${4-i}', '2024-01-${3-i}', '2024-01-${2-i}', '2024-01-${1-i}'][i],
    'itemName': ['Rice Basmati', 'Chicken Breast', 'Tomatoes', 'Onions', 'Cooking Oil', 'Salt', 'Black Pepper', 'Garlic', 'Ginger', 'Potatoes', 'Carrots', 'Bell Peppers', 'Yogurt', 'Milk', 'Eggs', 'Flour', 'Sugar', 'Tea', 'Coffee', 'Spices'][i],
    'quantity': ['50 kg', '25 kg', '30 kg', '20 kg', '10 L', '5 kg', '2 kg', '3 kg', '2 kg', '40 kg', '15 kg', '10 kg', '20 L', '15 L', '200 pcs', '25 kg', '10 kg', '5 kg', '3 kg', '2 kg'][i],
    'from': i % 4 == 0 ? 'Store' : ['Desi', 'Chinese', 'Afghani', 'Fast Food'][i % 4],
    'toSection': i % 4 == 0 ? ['Desi', 'Chinese', 'Afghani', 'Fast Food'][i % 4] : 'Store',
    'status': i % 5 == 0 ? 'Stock Out' : 'Stock In',
  });

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
    if (_editingItem != null) {
      // Find and update the item in the inventory
      final index = _kitchenInventory.indexOf(_editingItem!);
      if (index != -1) {
        setState(() {
          _kitchenInventory[index] = {
            'itemName': itemName,
            'foodSection': foodSection,
            'quantity': '$quantity $measuring',
            'transferDate': transferDate,
            'status': status,
            'measuring': measuring,
          };
        });
      }
      print('Updated inventory: $itemName, $foodSection, $quantity $measuring, $transferDate, $status');
    }
  }

  void _handleDeleteItem(Map<String, String> item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Item'),
          content: Text('Are you sure you want to delete ${item['itemName']}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  if (_tab == 0) {
                    _kitchenInventory.remove(item);
                  } else if (_tab == 1) {
                    _transferHistory.remove(item);
                  }
                });
                Navigator.of(context).pop();
                print('Deleted item: ${item['itemName']}');
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  List<TableColumn> get _columns {
    switch (_tab) {
      case 0: // Kitchen Inventory
        return [
          TableColumn('Item Name', flex: 3),
          TableColumn('Food Section', flex: 2),
          TableColumn('Quantity', flex: 2),
          TableColumn('Transfer Date', flex: 2),
          TableColumn('Status', flex: 2),
          TableColumn('Action', flex: 2),
        ];
      case 1: // Transfer History
        return [
          TableColumn('Transfer Date', flex: 2),
          TableColumn('Item Name', flex: 3),
          TableColumn('Quantity', flex: 2),
          TableColumn('From', flex: 2),
          TableColumn('To Section', flex: 2),
          TableColumn('Status', flex: 2),
          TableColumn('Action', flex: 2),
        ];
      default:
        return [];
    }
  }

  List<String> _getRowData(Map<String, String> item) {
    switch (_tab) {
      case 0: // Kitchen Inventory
        return [
          item['itemName']!,
          item['foodSection']!,
          item['quantity']!,
          item['transferDate']!,
          item['status']!,
          ''
        ];
      case 1: // Transfer History
        return [
          item['transferDate']!,
          item['itemName']!,
          item['quantity']!,
          item['from']!,
          item['toSection']!,
          item['status']!,
          ''
        ];
      default:
        return [];
    }
  }

  List<Map<String, String>> get _currentData {
    switch (_tab) {
      case 0:
        return _kitchenInventory;
      case 1:
        return _transferHistory;
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final rows = _currentData;

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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  _tab == 0 ? "Kitchen Inventory" : "Transfer History",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  _tab == 0 
                    ? "Items currently available in kitchen sections"
                    : "Recent Inventory Transfers",
                  style: TextStyle(
                    color: Colors.black, 
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(child: _buildTable(rows)),
            ],
          ),
        ),
        // Transfer to Kitchen Modal
        if (_showTransferModal)
          TransferToKitchenModal(
            onClose: _closeTransferModal,
            onTransfer: _handleTransfer,
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

  Widget _buildTable(List<Map<String, String>> items) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _buildTableHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: items.map((item) => _buildTableRow(item)).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      ),
      child: Row(
        children: _columns.map((col) => Expanded(
          flex: col.flex,
          child: Row(
            children: [
              const SizedBox(width: 12),
              Text(col.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
              if (col.title.isNotEmpty) const Icon(Icons.arrow_drop_down, color: Colors.white, size: 20),
            ],
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildTableRow(Map<String, String> item) {
    final rowData = _getRowData(item);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: List.generate(_columns.length, (i) => 
          Expanded(
            flex: _columns[i].flex,
            child: _buildTableCell(i, rowData, item),
          ),
        ),
      ),
    );
  }

  Widget _buildTableCell(int index, List<String> rowData, Map<String, String> item) {
    // Handle action columns
    if (index == _columns.length - 1) {
      return _buildInventoryActionButtons(item);
    }
    
    // Handle status column
    if ((_tab == 0 && index == 4) || (_tab == 1 && index == 5)) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          rowData[index],
          style: TextStyle(
            color: rowData[index] == 'Stock In' ? Colors.green : Colors.red,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    // Regular text cell
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        rowData[index],
        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildInventoryActionButtons(Map<String, String> item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => _showEditInventoryModalMethod(item), // Updated this line
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(Icons.edit_outlined, color: Color(0xFFc89849), size: 18),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () => _handleDeleteItem(item),
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(Icons.delete_outline, color: Colors.red, size: 18),
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