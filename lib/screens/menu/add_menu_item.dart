import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:khaabd_web/widgets/custom_textfield.dart';
import 'package:khaabd_web/widgets/gradient_button.dart';
import 'package:khaabd_web/widgets/outlined_button.dart';

class AddMenuItemModal extends StatefulWidget {
  final VoidCallback onClose;
  final Function(String menuItemName, String foodSection, String sellingPrice, String takeawayPacking, String description, List<Map<String, String>> ingredients) onSave;
  
  // Optional parameters for editing existing menu item
  final String? initialMenuItemName;
  final String? initialFoodSection;
  final String? initialSellingPrice;
  final String? initialTakeawayPacking;
  final String? initialDescription;
  final List<Map<String, String>>? initialIngredients;
  final bool isEditMode;

  const AddMenuItemModal({
    Key? key,
    required this.onClose,
    required this.onSave,
    this.initialMenuItemName,
    this.initialFoodSection,
    this.initialSellingPrice,
    this.initialTakeawayPacking,
    this.initialDescription,
    this.initialIngredients,
    this.isEditMode = false,
  }) : super(key: key);

  @override
  State<AddMenuItemModal> createState() => _AddMenuItemModalState();
}

class _AddMenuItemModalState extends State<AddMenuItemModal> {
  final TextEditingController _menuItemNameController = TextEditingController();
  final TextEditingController _sellingPriceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  String _selectedFoodSection = 'Select Food Section';
  String _selectedTakeawayPacking = 'Select Packing';
  
  bool _showFoodSectionDropdown = false;
  bool _showTakeawayPackingDropdown = false;
  
  final List<String> _foodSections = ['Desi', 'Afghani', 'Chinese', 'Fast Food'];
  final List<String> _takeawayPackingOptions = ['Small Box', 'Medium Box', 'Large Box'];
  final List<String> _kitchenItems = ['Rice', 'Chicken', 'Beef', 'Vegetables', 'Spices', 'Oil', 'Onions', 'Tomatoes'];
  
  List<Map<String, dynamic>> _ingredients = [];
  
  @override
  void initState() {
    super.initState();
    // Pre-fill fields if in edit mode
    if (widget.isEditMode) {
      _menuItemNameController.text = widget.initialMenuItemName ?? '';
      _sellingPriceController.text = widget.initialSellingPrice ?? '';
      _descriptionController.text = widget.initialDescription ?? '';
      _selectedFoodSection = widget.initialFoodSection ?? 'Select Food Section';
      _selectedTakeawayPacking = widget.initialTakeawayPacking ?? 'Select Packing';
      
      if (widget.initialIngredients != null) {
        _ingredients = widget.initialIngredients!.map((ingredient) => {
          'kitchenItem': ingredient['kitchenItem'] ?? 'Select Item',
          'quantity': TextEditingController(text: ingredient['quantity'] ?? ''),
          'unitCost': TextEditingController(text: ingredient['unitCost'] ?? ''),
          'totalCost': TextEditingController(text: ingredient['totalCost'] ?? ''),
          'showDropdown': false,
        }).toList();
      }
    }
  }

  @override
  void dispose() {
    _menuItemNameController.dispose();
    _sellingPriceController.dispose();
    _descriptionController.dispose();
    
    for (var ingredient in _ingredients) {
      ingredient['quantity'].dispose();
      ingredient['unitCost'].dispose();
      ingredient['totalCost'].dispose();
    }
    super.dispose();
  }

  void _addIngredient() {
    setState(() {
      _ingredients.add({
        'kitchenItem': 'Select Item',
        'quantity': TextEditingController(),
        'unitCost': TextEditingController(),
        'totalCost': TextEditingController(),
        'showDropdown': false,
      });
    });
  }

  void _removeIngredient(int index) {
    setState(() {
      _ingredients[index]['quantity'].dispose();
      _ingredients[index]['unitCost'].dispose();
      _ingredients[index]['totalCost'].dispose();
      _ingredients.removeAt(index);
    });
  }

  void _calculateTotalCost(int index) {
    final quantity = double.tryParse(_ingredients[index]['quantity'].text) ?? 0;
    final unitCost = double.tryParse(_ingredients[index]['unitCost'].text) ?? 0;
    final totalCost = quantity * unitCost;
    _ingredients[index]['totalCost'].text = totalCost.toStringAsFixed(2);
  }

  double _getTotalPrice() {
    double total = 0;
    for (var ingredient in _ingredients) {
      total += double.tryParse(ingredient['totalCost'].text) ?? 0;
    }
    return total;
  }

  double _getProfitMargin() {
    final sellingPrice = double.tryParse(_sellingPriceController.text) ?? 0;
    final totalPrice = _getTotalPrice();
    return sellingPrice - totalPrice;
  }

  void _handleSave() {
    if (_menuItemNameController.text.isNotEmpty && 
        _selectedFoodSection != 'Select Food Section' &&
        _sellingPriceController.text.isNotEmpty &&
        _selectedTakeawayPacking != 'Select Packing' &&
        _descriptionController.text.isNotEmpty) {
      
      // Fixed: Properly cast to Map<String, String>
      List<Map<String, String>> ingredientsList = _ingredients.map((ingredient) => <String, String>{
        'kitchenItem': ingredient['kitchenItem'] as String,
        'quantity': (ingredient['quantity'] as TextEditingController).text,
        'unitCost': (ingredient['unitCost'] as TextEditingController).text,
        'totalCost': (ingredient['totalCost'] as TextEditingController).text,
      }).toList();
      
      widget.onSave(
        _menuItemNameController.text,
        _selectedFoodSection,
        _sellingPriceController.text,
        _selectedTakeawayPacking,
        _descriptionController.text,
        ingredientsList,
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
              if (_showFoodSectionDropdown) {
                setState(() => _showFoodSectionDropdown = false);
              } else if (_showTakeawayPackingDropdown) {
                setState(() => _showTakeawayPackingDropdown = false);
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
                          widget.isEditMode ? 'Edit Menu Item' : 'Add New Menu Item',
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
                    
                    // Menu Item Name and Food Section Row
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Menu Item Name',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                      fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              CustomTextField(
                                controller: _menuItemNameController,
                                hintText: 'Enter menu item name',
                                borderRadius: 8,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Food Section',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                      fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildFoodSectionDropdown(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Selling Price and Takeaway Packing Row
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Selling Price',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                      fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              CustomTextField(
                                controller: _sellingPriceController,
                                hintText: 'Enter selling price',
                                borderRadius: 8,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Takeaway Packing',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                      fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildTakeawayPackingDropdown(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Description Field
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _descriptionController,
                      hintText: 'Enter description',
                      borderRadius: 8,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),
                    
                    // Ingredients & Recipe Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Ingredients & Recipe',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _addIngredient,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                          child: const Text('Add Ingredient'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    // Ingredients List
                    ..._ingredients.asMap().entries.map((entry) {
                      int index = entry.key;
                      return _buildIngredientRow(index);
                    }).toList(),
                    
                    const SizedBox(height: 20),
                    
                    // Cost Analysis
                    const Text(
                      'Cost Analysis',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const Divider(thickness: 1, color: Colors.grey),
                    const SizedBox(height: 12),
                    
                    // Cost Analysis Labels
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Price', style: TextStyle(fontWeight: FontWeight.w500)),
                        Text('Selling Price', style: TextStyle(fontWeight: FontWeight.w500)),
                        Text('Profit Margin', style: TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Cost Analysis Values
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${_getTotalPrice().toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '\$${_sellingPriceController.text.isEmpty ? "0.00" : double.tryParse(_sellingPriceController.text)?.toStringAsFixed(2) ?? "0.00"}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '\$${_getProfitMargin().toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                            fontSize: 16,
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
                            text: widget.isEditMode ? 'Update' : 'Add Menu Item',
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
        
        // Food Section Dropdown overlay
        if (_showFoodSectionDropdown)
          _buildDropdownOverlay(_foodSections, (section) {
            setState(() {
              _selectedFoodSection = section;
              _showFoodSectionDropdown = false;
            });
          }, 200),
          
        // Takeaway Packing Dropdown overlay
        if (_showTakeawayPackingDropdown)
          _buildDropdownOverlay(_takeawayPackingOptions, (packing) {
            setState(() {
              _selectedTakeawayPacking = packing;
              _showTakeawayPackingDropdown = false;
            });
          }, 200),
      ],
    );
  }

  Widget _buildFoodSectionDropdown() {
    return GestureDetector(
      onTap: () => setState(() => _showFoodSectionDropdown = !_showFoodSectionDropdown),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedFoodSection,
              style: TextStyle(
                color: _selectedFoodSection == 'Select Food Section' 
                    ? Colors.grey[600] 
                    : Colors.black,
              ),
            ),
            Icon(
              _showFoodSectionDropdown ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTakeawayPackingDropdown() {
    return GestureDetector(
      onTap: () => setState(() => _showTakeawayPackingDropdown = !_showTakeawayPackingDropdown),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedTakeawayPacking,
              style: TextStyle(
                color: _selectedTakeawayPacking == 'Select Packing' 
                    ? Colors.grey[600] 
                    : Colors.black,
              ),
            ),
            Icon(
              _showTakeawayPackingDropdown ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientRow(int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Kitchen Item Dropdown
          Expanded(
            flex: 2,
            child: _buildKitchenItemDropdown(index),
          ),
          const SizedBox(width: 8),
          
          // Quantity Field
          Expanded(
            child: CustomTextField(
              controller: _ingredients[index]['quantity'],
              hintText: 'Qty',
              borderRadius: 6,
              onChanged: (value) => _calculateTotalCost(index),
            ),
          ),
          const SizedBox(width: 8),
          
          // Unit Cost Field
          Expanded(
            child: CustomTextField(
              controller: _ingredients[index]['unitCost'],
              hintText: 'Unit Cost',
              borderRadius: 6,
              onChanged: (value) => _calculateTotalCost(index),
            ),
          ),
          const SizedBox(width: 8),
          
          // Total Cost Field
          Expanded(
            child: CustomTextField(
              controller: _ingredients[index]['totalCost'],
              hintText: 'Total',
              borderRadius: 6,
              readOnly: true,
            ),
          ),
          const SizedBox(width: 8),
          
          // Delete Button
          GestureDetector(
            onTap: () => _removeIngredient(index),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(4),
              ),
              child: SvgPicture.asset("assets/svgs/delete_icon.svg", color: Colors.white,),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKitchenItemDropdown(int index) {
    return GestureDetector(
      onTap: () => setState(() => _ingredients[index]['showDropdown'] = !_ingredients[index]['showDropdown']),
      child: Container(
        height: 49,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                _ingredients[index]['kitchenItem'],
                style: TextStyle(
                  color: _ingredients[index]['kitchenItem'] == 'Select Item' 
                      ? Colors.grey[600] 
                      : Colors.black,
                  fontSize: 12,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              _ingredients[index]['showDropdown'] ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownOverlay(List<String> items, Function(String) onSelect, double topOffset) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () => setState(() {
          _showFoodSectionDropdown = false;
          _showTakeawayPackingDropdown = false;
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