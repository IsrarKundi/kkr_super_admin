import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:khaabd_web/widgets/custom_textfield.dart';
import 'package:khaabd_web/widgets/gradient_button.dart';
import 'package:khaabd_web/widgets/outlined_button.dart';

class AddSaleModal extends StatefulWidget {
  final VoidCallback onClose;
  final Function(String orderDate, String totalSales, String cost, String profit, String customer, String orderType, List<Map<String, String>> orderItems) onSave;
  
  // Optional parameters for editing existing sale
  final String? initialOrderDate;
  final String? initialTotalSales;
  final String? initialCost;
  final String? initialCustomer;
  final String? initialOrderType;
  final List<Map<String, String>>? initialOrderItems;
  final bool isEditMode;

  const AddSaleModal({
    Key? key,
    required this.onClose,
    required this.onSave,
    this.initialOrderDate,
    this.initialTotalSales,
    this.initialCost,
    this.initialCustomer,
    this.initialOrderType,
    this.initialOrderItems,
    this.isEditMode = false,
  }) : super(key: key);

  @override
  State<AddSaleModal> createState() => _AddSaleModalState();
}

class _AddSaleModalState extends State<AddSaleModal> {
  final TextEditingController _customerController = TextEditingController();
  
  String _selectedItem = 'Select Item';
  String _selectedOrderType = 'Select Order Type';
  bool _showItemDropdown = false;
  bool _showOrderTypeDropdown = false;
  
  final List<String> _menuItems = ['Chicken Biryani', 'Beef Karahi', 'Mutton Pulao', 'Fish Curry', 'Vegetable Rice', 'Chicken Tikka', 'Seekh Kebab', 'Dal Makhani'];
  final List<String> _orderTypes = ['Dining In', 'Take Away'];
  
  final TextEditingController _quantityController = TextEditingController();
  List<Map<String, dynamic>> _orderItems = [];

  @override
  void initState() {
    super.initState();
    // Pre-fill fields if in edit mode
    if (widget.isEditMode) {
      _customerController.text = widget.initialCustomer ?? '';
      _selectedOrderType = widget.initialOrderType ?? 'Select Order Type';
      
      if (widget.initialOrderItems != null) {
        _orderItems = widget.initialOrderItems!.map((item) => {
          'itemName': item['itemName'] ?? '',
          'quantity': item['quantity'] ?? '',
          'price': item['price'] ?? '',
          'totalPrice': item['totalPrice'] ?? '',
        }).toList();
      }
    }
  }

  @override
  void dispose() {
    _customerController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _addOrderItem() {
    if (_selectedItem != 'Select Item' && _quantityController.text.isNotEmpty) {
      final quantity = int.tryParse(_quantityController.text) ?? 0;
      final price = _getItemPrice(_selectedItem);
      final totalPrice = quantity * price;
      
      setState(() {
        _orderItems.add({
          'itemName': _selectedItem,
          'quantity': _quantityController.text,
          'price': price.toStringAsFixed(2),
          'totalPrice': totalPrice.toStringAsFixed(2),
        });
        _selectedItem = 'Select Item';
        _quantityController.clear();
      });
    }
  }

  void _removeOrderItem(int index) {
    setState(() {
      _orderItems.removeAt(index);
    });
  }

  double _getItemPrice(String itemName) {
    // Mock prices for menu items
    final prices = {
      'Chicken Biryani': 450.0,
      'Beef Karahi': 650.0,
      'Mutton Pulao': 550.0,
      'Fish Curry': 400.0,
      'Vegetable Rice': 250.0,
      'Chicken Tikka': 350.0,
      'Seekh Kebab': 300.0,
      'Dal Makhani': 200.0,
    };
    return prices[itemName] ?? 0.0;
  }

  double _getTotalSales() {
    double total = 0;
    for (var item in _orderItems) {
      total += double.tryParse(item['totalPrice']) ?? 0;
    }
    return total;
  }

  double _getTotalCost() {
    // Assuming cost is 60% of sales price
    return _getTotalSales() * 0.6;
  }

  double _getProfit() {
    return _getTotalSales() - _getTotalCost();
  }

  void _handleSave() {
    if (_customerController.text.isNotEmpty && 
        _selectedOrderType != 'Select Order Type' &&
        _orderItems.isNotEmpty) {
      
      List<Map<String, String>> orderItemsList = _orderItems.map((item) => <String, String>{
        'itemName': item['itemName'] as String,
        'quantity': item['quantity'] as String,
        'price': item['price'] as String,
        'totalPrice': item['totalPrice'] as String,
      }).toList();

      widget.onSave(
        DateTime.now().toString().split(' ')[0], // Current date
        _getTotalSales().toStringAsFixed(2),
        _getTotalCost().toStringAsFixed(2),
        _getProfit().toStringAsFixed(2),
        _customerController.text,
        _selectedOrderType,
        orderItemsList,
      );
      widget.onClose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background overlay
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              if (_showItemDropdown) {
                setState(() => _showItemDropdown = false);
              } else if (_showOrderTypeDropdown) {
                setState(() => _showOrderTypeDropdown = false);
              } else {
                widget.onClose();
              }
            },
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
        ),
        // Modal content
        Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 600,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Spacer(),
                        Text(
                          widget.isEditMode ? 'Edit Sale Entry' : 'New Sale Entry',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red, size: 24),
                          onPressed: widget.onClose,
                          tooltip: 'Close',
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    

                    // Add Items & Deals Section
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: const Text(
                            'Add Items & Deals',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                                            Expanded(
                                              flex: 3,
                                              child:  Divider(thickness: 1, color: Colors.grey.shade300),
                                            )
                    
                      ],
                    ),
                    // const SizedBox(height: 8),
                    const SizedBox(height: 12),

                    // Item Selection Row
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildItemDropdown(),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomTextField(
                            controller: _quantityController,
                            hintText: 'Quantity',
                            borderRadius: 8,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: _buildOrderTypeDropdown(),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          height: 49,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.black
                          ),
                          child: ElevatedButton(
                            onPressed: _addOrderItem,
                            
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                            child: const Text('Add Item'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Order Items & Deals Section
                     Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: const Text(
                            'Order Items & Deals',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                                            Expanded(
                                              flex: 5,
                                              child:  Divider(thickness: 1, color: Colors.grey.shade300),
                                            )
                    
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Order Items List
                    ..._orderItems.asMap().entries.map((entry) {
                      int index = entry.key;
                      Map<String, dynamic> item = entry.value;
                      return _buildOrderItemRow(item, index);
                    }).toList(),

                    const SizedBox(height: 20),

                    // Sales Analysis
                    const Text(
                      'Sales Analysis',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(thickness: 1, color: Colors.grey),
                    const SizedBox(height: 12),

                    // Sales Analysis Labels
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Sales', style: TextStyle(fontWeight: FontWeight.w500)),
                        Text('Total Cost', style: TextStyle(fontWeight: FontWeight.w500)),
                        Text('Profit', style: TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Sales Analysis Values
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Rs. ${_getTotalSales().toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                        Text(
                          'Rs. ${_getTotalCost().toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                        Text(
                          'Rs. ${_getProfit().toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedGradientButton(
                            text: "Cancel",
                            onPressed: widget.onClose,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: GradientButton(
                            text: widget.isEditMode ? 'Update Sale' : 'Save Sale',
                            onPressed: _handleSave,
                            height: 48,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Item Dropdown overlay
        if (_showItemDropdown)
          _buildDropdownOverlay(_menuItems, (item) {
            setState(() {
              _selectedItem = item;
              _showItemDropdown = false;
            });
          }, 200),
        // Order Type Dropdown overlay
        if (_showOrderTypeDropdown)
          _buildDropdownOverlay(_orderTypes, (orderType) {
            setState(() {
              _selectedOrderType = orderType;
              _showOrderTypeDropdown = false;
            });
          }, 300),
      ],
    );
  }

  Widget _buildItemDropdown() {
    return GestureDetector(
      onTap: () => setState(() => _showItemDropdown = !_showItemDropdown),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                _selectedItem,
                style: TextStyle(
                  color: _selectedItem == 'Select Item' 
                      ? Colors.grey[600] 
                      : Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              _showItemDropdown ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderTypeDropdown() {
    return GestureDetector(
      onTap: () => setState(() => _showOrderTypeDropdown = !_showOrderTypeDropdown),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                _selectedOrderType,
                style: TextStyle(
                  color: _selectedOrderType == 'Select Order Type' 
                      ? Colors.grey[600] 
                      : Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              _showOrderTypeDropdown ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItemRow(Map<String, dynamic> item, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${item['itemName']} x ${item['quantity']}',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          Text(
            'Rs. ${item['totalPrice']}',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => _removeOrderItem(index),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(4),
              ),
              child: SvgPicture.asset(
                "assets/svgs/delete_icon.svg", 
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownOverlay(List<String> items, Function(String) onSelect, double topOffset) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () => setState(() {
          _showItemDropdown = false;
          _showOrderTypeDropdown = false;
        }),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: topOffset),
              Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 200),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!, width: 1),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: items.map((item) => 
                      InkWell(
                        onTap: () => onSelect(item),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            border: item != items.last 
                              ? Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1))
                              : null,
                          ),
                          child: Text(
                            item,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}