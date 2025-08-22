import 'package:flutter/material.dart';
import 'package:khaabd_web/screens/kitchen/transfer_to_store.dart';
import 'package:khaabd_web/screens/kitchen/edit_kitchen_inventory.dart';
import 'package:khaabd_web/screens/menu/add_menu_item.dart';
import 'package:khaabd_web/screens/widgets/dashboard_header.dart';
import 'package:khaabd_web/screens/store/transfer_to_kitchen.dart';
import 'package:khaabd_web/utils/colors.dart';
import 'package:khaabd_web/widgets/gradient_button.dart';

class MenuScreen extends StatefulWidget {
  final void Function(Map<String, dynamic>)? onShowDetail;
  const MenuScreen({Key? key, this.onShowDetail}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _tab = 0;
bool _showAddMenuItemModal = false;
bool _showEditMenu = false;
  Map<String, String>? _editingItem;

  // Mock data for Menu Items
  final List<Map<String, String>> _menuItems = List.generate(15, (i) => {
    'menuItem': [
      'Chicken Biryani',
      'Beef Karahi',
      'Mutton Pulao',
      'Fish Curry',
      'Chicken Tikka',
      'Seekh Kebab',
      'Chicken Fried Rice',
      'Sweet & Sour Chicken',
      'Beef Chow Mein',
      'Vegetable Spring Rolls',
      'Kabuli Pulao',
      'Lamb Karahi',
      'Chicken Burger',
      'Zinger Burger',
      'Club Sandwich'
    ][i],
    'foodSection': [
      'Desi', 'Desi', 'Desi', 'Desi', 'Desi',
      'Desi', 'Chinese', 'Chinese', 'Chinese', 'Chinese',
      'Afghani', 'Afghani', 'Fast Food', 'Fast Food', 'Fast Food'
    ][i],
    'cost': [
      '450', '520', '380', '350', '280',
      '320', '420', '380', '450', '180',
      '480', '550', '250', '280', '220'
    ][i],
    'sellingPrice': [
      '650', '750', '550', '500', '400',
      '450', '600', '550', '650', '250',
      '700', '800', '350', '400', '300'
    ][i],
    'profitMargin': [
      '30.8%', '30.7%', '30.9%', '30.0%', '30.0%',
      '28.9%', '30.0%', '30.9%', '30.8%', '28.0%',
      '31.4%', '31.3%', '28.6%', '30.0%', '26.7%'
    ][i],
  });

  // Mock data for Deals
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
  // Calculate total cost from ingredients
  double totalCost = 0;
  for (var ingredient in ingredients) {
    totalCost += double.tryParse(ingredient['totalCost'] ?? '0') ?? 0;
  }
  
  // Calculate profit margin
  double selling = double.tryParse(sellingPrice) ?? 0;
  double profitMargin = selling > 0 ? ((selling - totalCost) / selling * 100) : 0;
  
  setState(() {
    if (_editingItem != null) {
      // Edit existing item
      final currentData = _tab == 0 ? _menuItems : _deals;
      final index = currentData.indexOf(_editingItem!);
      if (index != -1) {
        currentData[index] = {
          _tab == 0 ? 'menuItem' : 'dealItems': menuItemName,
          'foodSection': foodSection,
          'cost': totalCost.toStringAsFixed(0),
          'sellingPrice': sellingPrice,
          'profitMargin': '${profitMargin.toStringAsFixed(1)}%',
        };
      }
      _editingItem = null;
    } else {
      // Add new menu item
      _menuItems.add({
        'menuItem': menuItemName,
        'foodSection': foodSection,
        'cost': totalCost.toStringAsFixed(0),
        'sellingPrice': sellingPrice,
        'profitMargin': '${profitMargin.toStringAsFixed(1)}%',
      });
    }
  });
  
  print(_editingItem != null ? 'Updated menu item: $menuItemName' : 'Added menu item: $menuItemName');
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

  void _handleInventoryUpdate(String itemName, String foodSection, String quantity, String measuring, String transferDate, String status) {
    if (_editingItem != null) {
      // Find and update the item in the current data
      final currentData = _tab == 0 ? _menuItems : _deals;
      final index = currentData.indexOf(_editingItem!);
      if (index != -1) {
        setState(() {
          if (_tab == 0) {
            currentData[index]['menuItem'] = itemName;
          } else {
            currentData[index]['dealItems'] = itemName;
          }
          currentData[index]['foodSection'] = foodSection;
          // Update other fields as needed
        });
      }
      print('Updated item: $itemName, $foodSection');
    }
  }

  void _handleDeleteItem(Map<String, String> item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Item'),
          content: Text('Are you sure you want to delete ${_tab == 0 ? item['menuItem'] : item['dealItems']}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  if (_tab == 0) {
                    _menuItems.remove(item);
                  } else if (_tab == 1) {
                    _deals.remove(item);
                  }
                });
                Navigator.of(context).pop();
                print('Deleted item: ${_tab == 0 ? item['menuItem'] : item['dealItems']}');
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
      case 0: // Menu Items
        return [
          TableColumn('Menu Item', flex: 3),
          TableColumn('Food Section', flex: 2),
          TableColumn('Cost', flex: 2),
          TableColumn('Selling Price', flex: 2),
          TableColumn('Profit Margin', flex: 2),
          TableColumn('Action', flex: 2),
        ];
      case 1: // Deals
        return [
          TableColumn('Deal Items', flex: 3),
          TableColumn('Food Section', flex: 2),
          TableColumn('Cost', flex: 2),
          TableColumn('Selling Price', flex: 2),
          TableColumn('Profit Margin', flex: 2),
          TableColumn('Action', flex: 2),
        ];
      default:
        return [];
    }
  }

  List<String> _getRowData(Map<String, String> item) {
    switch (_tab) {
      case 0: // Menu Items
        return [
          item['menuItem']!,
          item['foodSection']!,
          'Rs. ${item['cost']!}',
          'Rs. ${item['sellingPrice']!}',
          item['profitMargin']!,
          ''
        ];
      case 1: // Deals
        return [
          item['dealItems']!,
          item['foodSection']!,
          'Rs. ${item['cost']!}',
          'Rs. ${item['sellingPrice']!}',
          item['profitMargin']!,
          ''
        ];
      default:
        return [];
    }
  }

  List<Map<String, String>> get _currentData {
    switch (_tab) {
      case 0:
        return _menuItems;
      case 1:
        return _deals;
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  _tab == 0 ? "Menu Items" : "Deals",
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
                    ? "All menu items with cost breakdown"
                    : "All deals with cost breakdown",
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