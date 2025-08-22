import 'package:flutter/material.dart';
import 'package:khaabd_web/screens/store/add_purchase.dart';
import 'package:khaabd_web/screens/widgets/dashboard_header.dart';
import 'package:khaabd_web/screens/store/transfer_to_kitchen.dart';
import 'package:khaabd_web/utils/colors.dart';
import 'package:khaabd_web/widgets/gradient_button.dart';

class StoreScreen extends StatefulWidget {
  final void Function(Map<String, dynamic>)? onShowDetail;
  const StoreScreen({Key? key, this.onShowDetail}) : super(key: key);

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  int _tab = 0;
  bool _showDetails = false;
  bool _showTransferModal = false;
  bool _showPurchaseModal = false; // Add this state variable
  Map<String, String>? _selectedItem;
  Map<String, String>? _editingItem; // Add this for edit mode

  // Mock data for Current Inventory
  final List<Map<String, String>> _currentInventory = List.generate(15, (i) => {
    'itemName': ['Rice Basmati', 'Chicken Breast', 'Tomatoes', 'Onions', 'Cooking Oil', 'Salt', 'Black Pepper', 'Garlic', 'Ginger', 'Potatoes', 'Carrots', 'Bell Peppers', 'Yogurt', 'Milk', 'Eggs'][i],
    'category': ['Grains', 'Meat', 'Vegetables', 'Vegetables', 'Oil', 'Spices', 'Spices', 'Vegetables', 'Vegetables', 'Vegetables', 'Vegetables', 'Vegetables', 'Dairy', 'Dairy', 'Dairy'][i],
    'quantity': ['50 kg', '25 kg', '30 kg', '20 kg', '10 L', '5 kg', '2 kg', '3 kg', '2 kg', '40 kg', '15 kg', '10 kg', '20 L', '15 L', '200 pcs'][i],
    'totalPrice': ['₹5000', '₹3750', '₹900', '₹600', '₹1200', '₹100', '₹400', '₹150', '₹200', '₹800', '₹450', '₹500', '₹800', '₹600', '₹400'][i],
    'unitCost': '₹${(i + 1) * 10}',
    'supplier': ['ABC Suppliers', 'Fresh Meat Co', 'Green Valley', 'Local Farm', 'Oil Mills', 'Spice House', 'Spice House', 'Green Valley', 'Green Valley', 'Local Farm', 'Green Valley', 'Green Valley', 'Dairy Fresh', 'Dairy Fresh', 'Poultry Farm'][i],
    'status': i % 3 == 0 ? 'Out of Stock' : 'In Stock',
    'measuring': ['kg', 'kg', 'kg', 'kg', 'L', 'kg', 'kg', 'kg', 'kg', 'kg', 'kg', 'kg', 'L', 'L', 'pcs'][i],
    'paymentMethod': ['Cash', 'Bank', 'Debt', 'Cash', 'Bank', 'Debt', 'Cash', 'Bank', 'Debt', 'Cash', 'Bank', 'Debt', 'Cash', 'Bank', 'Debt'][i],
  });

  // Mock data for Purchase History
  final List<Map<String, String>> _purchaseHistory = List.generate(12, (i) => {
    'itemName': ['Rice Basmati', 'Chicken Breast', 'Tomatoes', 'Onions', 'Cooking Oil', 'Salt', 'Black Pepper', 'Garlic', 'Ginger', 'Potatoes', 'Carrots', 'Bell Peppers'][i],
    'quantity': ['50 kg', '25 kg', '30 kg', '20 kg', '10 L', '5 kg', '2 kg', '3 kg', '2 kg', '40 kg', '15 kg', '10 kg'][i],
    'unitCost': '₹${(i + 1) * 10}',
    'totalCost': '₹${(i + 1) * 500}',
    'supplier': ['ABC Suppliers', 'Fresh Meat Co', 'Green Valley', 'Local Farm', 'Oil Mills', 'Spice House', 'Spice House', 'Green Valley', 'Green Valley', 'Local Farm', 'Green Valley', 'Green Valley'][i],
    'paymentMethod': ['Cash', 'Bank', 'Debt', 'Cash', 'Bank', 'Debt', 'Cash', 'Bank', 'Debt', 'Cash', 'Bank', 'Debt'][i],
    'date': ['2024-01-15', '2024-01-14', '2024-01-13', '2024-01-12', '2024-01-11', '2024-01-10', '2024-01-09', '2024-01-08', '2024-01-07', '2024-01-06', '2024-01-05', '2024-01-04'][i],
  });

  // Mock data for Supplier Ledger
  final List<Map<String, String>> _supplierLedger = List.generate(8, (i) => {
    'supplierName': ['ABC Suppliers', 'Fresh Meat Co', 'Green Valley', 'Local Farm', 'Oil Mills', 'Spice House', 'Dairy Fresh', 'Poultry Farm'][i],
    'totalOutstanding': '₹${(i + 1) * 2500}',
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

  // Purchase modal methods
  void _showAddPurchaseModal() {
    setState(() {
      _editingItem = null; // Clear editing item for add mode
      _showPurchaseModal = true;
    });
  }

  void _showEditPurchaseModal(Map<String, String> item) {
    setState(() {
      _editingItem = item; // Set the item to edit
      _showPurchaseModal = true;
    });
  }

  void _closePurchaseModal() {
    setState(() {
      _showPurchaseModal = false;
      _editingItem = null;
    });
  }

  void _handlePurchaseSave(String itemName, String supplierName, String quantity, String measuring, String category, String pricePerUnit, String paymentMethod) {
    if (_editingItem != null) {
      // Edit mode - update existing item
      print('Updating purchase: $itemName, $supplierName, $quantity $measuring, $category, $pricePerUnit, $paymentMethod');
      // Find and update the item in your data structure
      // For example, update _currentInventory or _purchaseHistory
    } else {
      // Add mode - create new item
      print('Adding new purchase: $itemName, $supplierName, $quantity $measuring, $category, $pricePerUnit, $paymentMethod');
      // Add new item to your data structure
      // For example, add to _currentInventory or _purchaseHistory
    }
    // You can add your save logic here (API calls, local storage, etc.)
  }

  void _handleDeleteItem(Map<String, String> item) {
    // Show confirmation dialog
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
                // Remove item from data structure
                setState(() {
                  _currentInventory.remove(item);
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
      case 0: // Current Inventory
        return [
          TableColumn('Item Name', flex: 3),
          TableColumn('Category', flex: 2),
          TableColumn('Quantity', flex: 2),
          TableColumn('Total Price', flex: 2),
          TableColumn('Unit Cost', flex: 2),
          TableColumn('Supplier', flex: 3),
          TableColumn('Status', flex: 2),
          TableColumn('Action', flex: 2),
        ];
      case 1: // Purchase History
        return [
          TableColumn('Item Name', flex: 2),
          TableColumn('Quantity', flex: 2),
          TableColumn('Unit Cost', flex: 2),
          TableColumn('Total Cost', flex: 2),
          TableColumn('Supplier', flex: 2),
          TableColumn('Payment Method', flex: 2),
          TableColumn('Date', flex: 2),
        ];
      case 2: // Supplier Ledger
        return [
          TableColumn('Supplier Name', flex: 4),
          TableColumn('Total Outstanding', flex: 3),
          TableColumn('Action', flex: 2),
        ];
      default:
        return [];
    }
  }

  List<String> _getRowData(Map<String, String> item) {
    switch (_tab) {
      case 0: // Current Inventory
        return [
          item['itemName']!,
          item['category']!,
          item['quantity']!,
          item['totalPrice']!,
          item['unitCost']!,
          item['supplier']!,
          item['status']!,
          ''
        ];
      case 1: // Purchase History
        return [
          item['itemName']!,
          item['quantity']!,
          item['unitCost']!,
          item['totalCost']!,
          item['supplier']!,
          item['paymentMethod']!,
          item['date']!,
        ];
      case 2: // Supplier Ledger
        return [
          item['supplierName']!,
          item['totalOutstanding']!,
          ''
        ];
      default:
        return [];
    }
  }

  List<Map<String, String>> get _currentData {
    switch (_tab) {
      case 0:
        return _currentInventory;
      case 1:
        return _purchaseHistory;
      case 2:
        return _supplierLedger;
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
        // Add/Edit Purchase Modal
        if (_showPurchaseModal)
          AddPurchaseModal(
            onClose: _closePurchaseModal,
            onSave: _handlePurchaseSave,
            isEditMode: _editingItem != null,
            // Pass initial values for edit mode
            initialItemName: _editingItem?['itemName'],
            initialSupplierName: _editingItem?['supplier'],
            initialQuantity: _editingItem?['quantity']?.replaceAll(RegExp(r'[^0-9]'), ''), // Extract number only
            initialMeasuring: _editingItem?['measuring'],
            initialCategory: _editingItem?['category'],
            initialPricePerUnit: _editingItem?['unitCost']?.replaceAll('₹', ''),
            initialPaymentMethod: _editingItem?['paymentMethod'],
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
              onPressed: _showAddPurchaseModal, // Fixed this line
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
    if (_tab == 0 && index == _columns.length - 1) {
      return _buildInventoryActionButtons(item); // Pass the item
    } else if (_tab == 2 && index == _columns.length - 1) {
      return _buildSupplierActionButton();
    }
    
    // Handle status column for inventory
    if (_tab == 0 && index == 6) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          rowData[index],
          style: TextStyle(
            color: rowData[index] == 'In Stock' ? Colors.green : Colors.red,
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

  Widget _buildInventoryActionButtons(Map<String, String> item) { // Accept item parameter
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => _showEditPurchaseModal(item), // Pass the item to edit
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(Icons.edit_outlined, color: Color(0xFFc89849), size: 18),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () => _handleDeleteItem(item), // Pass the item to delete
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

  Widget _buildSupplierActionButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 110),
      child: SizedBox(
        height: 32,
        child: GradientButton(
          borderRadius: 10,
          textStyle: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          text: "Make Payment",
          onPressed: () {},
          height: 32,
        ),
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