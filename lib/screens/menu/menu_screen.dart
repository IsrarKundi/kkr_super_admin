import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khaabd_web/controller/getx_controllers/menu_controller.dart';
import 'package:khaabd_web/screens/menu/add_menu_item.dart';
import 'package:khaabd_web/screens/menu/tabs/menu_items_tab.dart';
import 'package:khaabd_web/screens/widgets/dashboard_header.dart';
import 'package:khaabd_web/utils/colors.dart';
import 'package:khaabd_web/widgets/gradient_button.dart';
import 'package:khaabd_web/models/models/kitchen_models/get_menu_items.dart';

class MenuScreen extends StatefulWidget {
  final void Function(Map<String, dynamic>)? onShowDetail;
  const MenuScreen({Key? key, this.onShowDetail}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final MenuGetxController menuController = Get.put(MenuGetxController());
  int _tab = 0;
  bool _showAddMenuItemModal = false;
  bool _showEditMenu = false;
  Map<String, String>? _editingItem;

  // Mock data for Deals (keeping this for deals tab)
  final List<Map<String, String>> _deals = List.generate(12, (i) => {
    'dealItems': [
      'Chicken Biryani, Raita, Salad',
      'Beef Karahi, Naan, Rice, Drink',
      'Mutton Pulao, Raita, Pickle, Dessert',
      'Fish Curry, Rice, Naan, Salad, Drink',
      'Chicken Tikka, Naan, Chutney',
      'Seekh Kebab, Rice, Salad, Drink, Dessert',
      'Chicken Fried Rice, Sweet & Sour Chicken, Spring Rolls',
      'Beef Chow Mein, Chicken Manchurian, Fried Rice, Drink',
      'Vegetable Spring Rolls, Chicken Corn Soup, Fried Rice',
      'Kabuli Pulao, Lamb Karahi, Naan, Salad, Drink, Dessert',
      'Chicken Burger, Fries, Drink',
      'Zinger Burger, Fries, Coleslaw, Drink, Dessert'
    ][i],
    'foodSection': [
      'Desi', 'Desi', 'Desi', 'Desi', 'Desi',
      'Desi', 'Chinese', 'Chinese', 'Chinese', 'Afghani',
      'Fast Food', 'Fast Food'
    ][i],
    'cost': [
      '580', '720', '650', '780', '380',
      '850', '680', '920', '450', '1200',
      '320', '420'
    ][i],
    'sellingPrice': [
      '850', '1050', '950', '1150', '550',
      '1250', '950', '1350', '650', '1750',
      '450', '600'
    ][i],
    'profitMargin': [
      '31.8%', '31.4%', '31.6%', '32.2%', '30.9%',
      '32.0%', '28.4%', '31.9%', '30.8%', '31.4%',
      '28.9%', '30.0%'
    ][i],
  });

  // Transfer modal methods
 void _showAddMenuItemModalMethod() {
  setState(() {
    _showAddMenuItemModal = true;
  });
}

void _closeAddMenuItemModal() {
  setState(() {
    _showAddMenuItemModal = false;
        _editingItem = null;

  });
}

void _handleAddMenuItem(String menuItemName, String foodSection, String sellingPrice, String takeawayPacking, String description, List<Map<String, String>> ingredients) {
  // TODO: Implement API call to add/update menu item
  print(_editingItem != null ? 'Updated menu item: $menuItemName' : 'Added menu item: $menuItemName');
  // For now, just refresh the menu items
  menuController.refreshMenuItems();
}
  // Edit inventory modal methods
  void _showEditInventoryModalMethod(Map<String, String> item) {
    setState(() {
      _editingItem = item;
      _showAddMenuItemModal = true;
    });
  }

  void _closeEditInventoryModal() {
    setState(() {
      _showEditMenu = false;
      _editingItem = null;
    });
  }

  void _handleDeleteItem(dynamic item) {
    String itemName = '';
    if (item is Datum) {
      itemName = item.name;
    } else if (item is Map<String, String>) {
      itemName = item[_tab == 0 ? 'menuItem' : 'dealItems'] ?? '';
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
                if (_tab == 0) {
                  // Refresh menu items after deletion
                  menuController.refreshMenuItems();
                } else {
                  // Handle deals deletion
                  setState(() {
                    if (item is Map<String, String>) {
                      _deals.remove(item);
                    }
                  });
                }
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTabContent() {
    switch (_tab) {
      case 0:
        return MenuItemsTab(
          menuController: menuController,
          onEditItem: _showEditInventoryModalMethod,
          onDeleteItem: _handleDeleteItem,
        );
      case 1:
        return _buildDealsTable();
      default:
        return Container();
    }
  }

  Widget _buildDealsTable() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _buildTableHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: _deals.map((item) => _buildTableRow(item)).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<TableColumn> get _columns {
    return [
      TableColumn('Deal Items', flex: 3),
      TableColumn('Food Section', flex: 2),
      TableColumn('Cost', flex: 2),
      TableColumn('Selling Price', flex: 2),
      TableColumn('Profit Margin', flex: 2),
      TableColumn('Action', flex: 2),
    ];
  }

  List<String> _getRowData(Map<String, String> item) {
    return [
      item['dealItems']!,
      item['foodSection']!,
      'Rs. ${item['cost']!}',
      'Rs. ${item['sellingPrice']!}',
      item['profitMargin']!,
      ''
    ];
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
                      label: 'Menu Items',
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
                      label: 'Deals',
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
        // Transfer to Kitchen Modal
        if (_showAddMenuItemModal)
          AddMenuItemModal(
            onClose: _closeAddMenuItemModal,
            onSave: _handleAddMenuItem,
          ),
        // Edit Kitchen Inventory Modal
        if (_showAddMenuItemModal)
  AddMenuItemModal(
    onClose: _closeAddMenuItemModal,
    onSave: _handleAddMenuItem,
    isEditMode: _editingItem != null,
    initialMenuItemName: _editingItem?[_tab == 0 ? 'menuItem' : 'dealItems'],
    initialFoodSection: _editingItem?['foodSection'],
    initialSellingPrice: _editingItem?['sellingPrice'],
    initialTakeawayPacking: _editingItem?['takeawayPacking'],
    initialDescription: _editingItem?['description'],
    initialIngredients:  null,
  ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          const Text('Menu Management', style: TextStyle(color: Colors.black, fontSize: 32, fontWeight: FontWeight.w700)),
          const Spacer(),
          SizedBox(
            height: 42,
            child: GradientButton(
              height: 32,
              text: "Create Deal",
              icon: Icons.add,
              onPressed: _showAddMenuItemModalMethod,
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            height: 42,
            child: GradientButton(
              height: 32,
              text: "Add Menu Item",
              icon: Icons.add,
              onPressed: _showAddMenuItemModalMethod,
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
      padding: const EdgeInsets.symmetric(vertical: 8),
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
    
    // Handle profit margin column
    if (index == 4) {
      return Padding(
        padding: const EdgeInsets.only(right: 72),
        child: Container(
          width: 20,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            rowData[index],
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      );
    }

    // Handle deal items column (first column for deals tab)
    if (_tab == 1 && index == 0) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: _buildDealItemsCell(rowData[index]),
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

  Widget _buildDealItemsCell(String dealItems) {
    final items = dealItems.split(', ');
    
    // If items are 3 or less, show them normally
    if (items.length <= 10) {
      return Text(
        dealItems,
        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      );
    }
    
    // If more than 3 items, show first 3 and add "..."
    final displayItems = items.take(3).join(', ');
    return RichText(
      maxLines: 3,
      overflow: TextOverflow.visible,
      text: TextSpan(
        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14),
        children: [
          TextSpan(text: displayItems),
          TextSpan(
            text: ', +${items.length - 3} more',
            style: const TextStyle(
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
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
            onTap: () => _showEditInventoryModalMethod(item),
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