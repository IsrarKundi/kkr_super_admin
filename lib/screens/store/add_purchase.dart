import 'package:flutter/material.dart';
import 'package:khaabd_web/widgets/custom_textfield.dart';
import 'package:khaabd_web/widgets/gradient_button.dart';
import 'package:khaabd_web/widgets/outlined_button.dart';

class AddPurchaseModal extends StatefulWidget {
  final VoidCallback onClose;
  final Function(String itemName, String supplierName, String quantity, String measuring, String category, String pricePerUnit, String paymentMethod) onSave;
  
  // Optional parameters for editing existing purchase
  final String? initialItemName;
  final String? initialSupplierName;
  final String? initialQuantity;
  final String? initialMeasuring;
  final String? initialCategory;
  final String? initialPricePerUnit;
  final String? initialPaymentMethod;
  final bool isEditMode;

  const AddPurchaseModal({
    Key? key,
    required this.onClose,
    required this.onSave,
    this.initialItemName,
    this.initialSupplierName,
    this.initialQuantity,
    this.initialMeasuring,
    this.initialCategory,
    this.initialPricePerUnit,
    this.initialPaymentMethod,
    this.isEditMode = false,
  }) : super(key: key);

  @override
  State<AddPurchaseModal> createState() => _AddPurchaseModalState();
}

class _AddPurchaseModalState extends State<AddPurchaseModal> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _supplierNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _pricePerUnitController = TextEditingController();
  
  String _selectedMeasuring = 'Select Unit';
  String _selectedCategory = 'Select Category';
  String _selectedPaymentMethod = 'Select Payment Method';
  
  bool _showMeasuringDropdown = false;
  bool _showCategoryDropdown = false;
  bool _showPaymentMethodDropdown = false;

  final List<String> _measuringUnits = ['kg', 'g', 'L', 'ml', 'pcs', 'dozen', 'pack'];
  final List<String> _categories = ['Kitchen Inventory', 'Packing Inventory'];
  final List<String> _paymentMethods = ['Cash', 'Bank', 'Debt'];

  @override
  void initState() {
    super.initState();
    // Pre-fill fields if in edit mode
    if (widget.isEditMode) {
      _itemNameController.text = widget.initialItemName ?? '';
      _supplierNameController.text = widget.initialSupplierName ?? '';
      _quantityController.text = widget.initialQuantity ?? '';
      _pricePerUnitController.text = widget.initialPricePerUnit ?? '';
      _selectedMeasuring = widget.initialMeasuring ?? 'Select Unit';
      _selectedCategory = widget.initialCategory ?? 'Select Category';
      _selectedPaymentMethod = widget.initialPaymentMethod ?? 'Select Payment Method';
    }
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _supplierNameController.dispose();
    _quantityController.dispose();
    _pricePerUnitController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_itemNameController.text.isNotEmpty && 
        _supplierNameController.text.isNotEmpty &&
        _quantityController.text.isNotEmpty &&
        _selectedMeasuring != 'Select Unit' &&
        _selectedCategory != 'Select Category' &&
        _pricePerUnitController.text.isNotEmpty &&
        _selectedPaymentMethod != 'Select Payment Method') {
      widget.onSave(
        _itemNameController.text,
        _supplierNameController.text,
        _quantityController.text,
        _selectedMeasuring,
        _selectedCategory,
        _pricePerUnitController.text,
        _selectedPaymentMethod,
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
              if (_showMeasuringDropdown) {
                setState(() => _showMeasuringDropdown = false);
              } else if (_showCategoryDropdown) {
                setState(() => _showCategoryDropdown = false);
              } else if (_showPaymentMethodDropdown) {
                setState(() => _showPaymentMethodDropdown = false);
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
              width: 450,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
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
                          widget.isEditMode ? 'Edit Purchase' : 'Add New Inventory',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 26,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red, size: 28),
                          onPressed: widget.onClose,
                          tooltip: 'Close',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Item Name Field
                    const Text(
                      'Item Name',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _itemNameController,
                      hintText: 'Enter item name',
                      borderRadius: 12.0,
                    ),
                    const SizedBox(height: 20),
                    // Supplier Name Field
                    const Text(
                      'Supplier Name',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _supplierNameController,
                      hintText: 'Enter supplier name',
                      borderRadius: 12.0,
                    ),
                    const SizedBox(height: 20),
                    // Quantity and Measuring Row
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Quantity',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              CustomTextField(
                                controller: _quantityController,
                                hintText: 'Enter quantity',
                                borderRadius: 12.0,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Unit',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildMeasuringDropdown(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Category Field
                    const Text(
                      'Category',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildCategoryDropdown(),
                    const SizedBox(height: 20),
                    // Price Per Unit Field
                    const Text(
                      'Price Per Unit',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _pricePerUnitController,
                      hintText: 'Enter price per unit',
                      borderRadius: 12.0,
                    ),
                    const SizedBox(height: 20),
                    // Payment Method Field
                    const Text(
                      'Payment Method',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildPaymentMethodDropdown(),
                    const SizedBox(height: 32),
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
                            text: widget.isEditMode ? 'Update' : 'Save',
                            onPressed: _handleSave,
                            height: 50,
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
        // Measuring Dropdown overlay
        if (_showMeasuringDropdown)
          _buildDropdownOverlay(_measuringUnits, (unit) {
            setState(() {
              _selectedMeasuring = unit;
              _showMeasuringDropdown = false;
            });
          }, 24 + 26 + 24 + 16 + 8 + 50 + 20 + 16 + 8 + 50 + 20 + 16 + 8),
        // Category Dropdown overlay
        if (_showCategoryDropdown)
          _buildDropdownOverlay(_categories, (category) {
            setState(() {
              _selectedCategory = category;
              _showCategoryDropdown = false;
            });
          }, 24 + 26 + 24 + 16 + 8 + 50 + 20 + 16 + 8 + 50 + 20 + 70 + 20 + 16 + 8),
        // Payment Method Dropdown overlay
        if (_showPaymentMethodDropdown)
          _buildDropdownOverlay(_paymentMethods, (method) {
            setState(() {
              _selectedPaymentMethod = method;
              _showPaymentMethodDropdown = false;
            });
          }, 24 + 26 + 24 + 16 + 8 + 50 + 20 + 16 + 8 + 50 + 20 + 70 + 20 + 16 + 8 + 50 + 20 + 16 + 8 + 50 + 20 + 16 + 8),
      ],
    );
  }

  Widget _buildMeasuringDropdown() {
    return GestureDetector(
      onTap: () => setState(() => _showMeasuringDropdown = !_showMeasuringDropdown),
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1.0),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _selectedMeasuring,
                style: TextStyle(
                  color: _selectedMeasuring == 'Select Unit' 
                      ? Colors.grey[600] 
                      : Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            Icon(
              _showMeasuringDropdown ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.black,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return GestureDetector(
      onTap: () => setState(() => _showCategoryDropdown = !_showCategoryDropdown),
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1.0),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _selectedCategory,
                style: TextStyle(
                  color: _selectedCategory == 'Select Category' 
                      ? Colors.grey[600] 
                      : Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            Icon(
              _showCategoryDropdown ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.black,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodDropdown() {
    return GestureDetector(
      onTap: () => setState(() => _showPaymentMethodDropdown = !_showPaymentMethodDropdown),
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1.0),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _selectedPaymentMethod,
                style: TextStyle(
                  color: _selectedPaymentMethod == 'Select Payment Method' 
                      ? Colors.grey[600] 
                      : Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            Icon(
              _showPaymentMethodDropdown ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.black,
              size: 24,
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
          _showMeasuringDropdown = false;
          _showCategoryDropdown = false;
          _showPaymentMethodDropdown = false;
        }),
        child: Container(
          color: Colors.transparent,
          child: Center(
            child: Container(
              width: 450,
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: topOffset),
                  Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!, width: 1),
                      ),
                      child: Column(
                        children: items.map((item) => 
                          InkWell(
                            onTap: () => onSelect(item),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                border: item != items.last 
                                  ? Border(bottom: BorderSide(color: Colors.grey[200]!, width: 1))
                                  : null,
                              ),
                              child: Text(
                                item,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
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
        ),
      ),
    );
  }
}