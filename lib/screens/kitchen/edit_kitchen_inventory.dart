import 'package:flutter/material.dart';
import 'package:khaabd_web/widgets/custom_textfield.dart';
import 'package:khaabd_web/widgets/gradient_button.dart';
import 'package:khaabd_web/widgets/outlined_button.dart';

class EditKitchenInventoryModal extends StatefulWidget {
  final VoidCallback onClose;
  final Function(String itemName, String foodSection, String quantity, String measuring, String transferDate, String status) onSave;
  
  // Parameters for editing existing inventory
  final String? initialItemName;
  final String? initialFoodSection;
  final String? initialQuantity;
  final String? initialMeasuring;
  final String? initialTransferDate;
  final String? initialStatus;

  const EditKitchenInventoryModal({
    Key? key,
    required this.onClose,
    required this.onSave,
    this.initialItemName,
    this.initialFoodSection,
    this.initialQuantity,
    this.initialMeasuring,
    this.initialTransferDate,
    this.initialStatus,
  }) : super(key: key);

  @override
  State<EditKitchenInventoryModal> createState() => _EditKitchenInventoryModalState();
}

class _EditKitchenInventoryModalState extends State<EditKitchenInventoryModal> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _transferDateController = TextEditingController();
  
  String _selectedFoodSection = 'Select Food Section';
  String _selectedMeasuring = 'Select Unit';
  String _selectedStatus = 'Select Status';
  
  bool _showFoodSectionDropdown = false;
  bool _showMeasuringDropdown = false;
  bool _showStatusDropdown = false;

  final List<String> _foodSections = ['Desi', 'Chinese', 'Afghani', 'Fast Food'];
  final List<String> _measuringUnits = ['kg', 'g', 'L', 'ml', 'pcs', 'dozen', 'pack'];
  final List<String> _statusOptions = ['Stock In', 'Stock Out'];

  @override
  void initState() {
    super.initState();
    // Pre-fill fields with initial values
    _itemNameController.text = widget.initialItemName ?? '';
    _quantityController.text = widget.initialQuantity?.replaceAll(RegExp(r'[^0-9]'), '') ?? '';
    _transferDateController.text = widget.initialTransferDate ?? '';
    _selectedFoodSection = widget.initialFoodSection ?? 'Select Food Section';
    _selectedMeasuring = widget.initialMeasuring ?? 'Select Unit';
    _selectedStatus = widget.initialStatus ?? 'Select Status';
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _quantityController.dispose();
    _transferDateController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_itemNameController.text.isNotEmpty && 
        _selectedFoodSection != 'Select Food Section' &&
        _quantityController.text.isNotEmpty &&
        _selectedMeasuring != 'Select Unit' &&
        _transferDateController.text.isNotEmpty &&
        _selectedStatus != 'Select Status') {
      widget.onSave(
        _itemNameController.text,
        _selectedFoodSection,
        _quantityController.text,
        _selectedMeasuring,
        _transferDateController.text,
        _selectedStatus,
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
              } else if (_showMeasuringDropdown) {
                setState(() => _showMeasuringDropdown = false);
              } else if (_showStatusDropdown) {
                setState(() => _showStatusDropdown = false);
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Spacer(),
                      const Text(
                        'Edit Kitchen Inventory',
                        style: TextStyle(
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
                  // Food Section Field
                  const Text(
                    'Food Section',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildFoodSectionDropdown(),
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
                  // Transfer Date Field
                  const Text(
                    'Transfer Date',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: _transferDateController,
                    hintText: 'Enter transfer date (YYYY-MM-DD)',
                    borderRadius: 12.0,
                  ),
                  const SizedBox(height: 20),
                  // Status Field
                  const Text(
                    'Status',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildStatusDropdown(),
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
                          text: 'Update',
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
        // Food Section Dropdown overlay
        if (_showFoodSectionDropdown)
          _buildDropdownOverlay(_foodSections, (section) {
            setState(() {
              _selectedFoodSection = section;
              _showFoodSectionDropdown = false;
            });
          }, 24 + 26 + 24 + 16 + 8 + 50 + 20 + 16 + 8),
        // Measuring Dropdown overlay
        if (_showMeasuringDropdown)
          _buildDropdownOverlay(_measuringUnits, (unit) {
            setState(() {
              _selectedMeasuring = unit;
              _showMeasuringDropdown = false;
            });
          }, 24 + 26 + 24 + 16 + 8 + 50 + 20 + 16 + 8 + 50 + 20 + 16 + 8),
        // Status Dropdown overlay
        if (_showStatusDropdown)
          _buildDropdownOverlay(_statusOptions, (status) {
            setState(() {
              _selectedStatus = status;
              _showStatusDropdown = false;
            });
          }, 24 + 26 + 24 + 16 + 8 + 50 + 20 + 16 + 8 + 50 + 20 + 70 + 20 + 16 + 8 + 50 + 20 + 16 + 8),
      ],
    );
  }

  Widget _buildFoodSectionDropdown() {
    return GestureDetector(
      onTap: () => setState(() => _showFoodSectionDropdown = !_showFoodSectionDropdown),
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
                _selectedFoodSection,
                style: TextStyle(
                  color: _selectedFoodSection == 'Select Food Section' 
                      ? Colors.grey[600] 
                      : Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            Icon(
              _showFoodSectionDropdown ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.black,
              size: 24,
            ),
          ],
        ),
      ),
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

  Widget _buildStatusDropdown() {
    return GestureDetector(
      onTap: () => setState(() => _showStatusDropdown = !_showStatusDropdown),
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
                _selectedStatus,
                style: TextStyle(
                  color: _selectedStatus == 'Select Status' 
                      ? Colors.grey[600] 
                      : Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            Icon(
              _showStatusDropdown ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
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
          _showFoodSectionDropdown = false;
          _showMeasuringDropdown = false;
          _showStatusDropdown = false;
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