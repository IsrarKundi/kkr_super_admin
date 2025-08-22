import 'package:flutter/material.dart';
import 'package:khaabd_web/widgets/custom_textfield.dart';
import 'package:khaabd_web/widgets/gradient_button.dart';
import 'package:khaabd_web/widgets/outlined_button.dart';

class TransferToStoreModal extends StatefulWidget {
  final VoidCallback onClose;
  final Function(String item, String quantity, String section) onTransfer;

  const TransferToStoreModal({
    Key? key,
    required this.onClose,
    required this.onTransfer,
  }) : super(key: key);

  @override
  State<TransferToStoreModal> createState() => _TransferToStoreModalState();
}

class _TransferToStoreModalState extends State<TransferToStoreModal> {
  final TextEditingController _quantityController = TextEditingController();
  String _selectedItem = 'Choose item to transfer';
  String _selectedSection = 'Select Section';
  bool _showItemDropdown = false;
  bool _showSectionDropdown = false;

  final List<String> _items = [
    'Rice Basmati',
    'Chicken Breast',
    'Tomatoes',
    'Onions',
    'Cooking Oil',
    'Salt',
    'Black Pepper',
    'Garlic',
    'Ginger',
    'Potatoes',
    'Carrots',
    'Bell Peppers',
    'Yogurt',
    'Milk',
    'Eggs'
  ];

  final List<String> _sections = ['Desi', 'Kabuli', 'Chinese', 'Fast Food'];

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _handleTransfer() {
    if (_selectedItem != 'Choose item to transfer' && 
        _quantityController.text.isNotEmpty && 
        _selectedSection != 'Select Section') {
      widget.onTransfer(_selectedItem, _quantityController.text, _selectedSection);
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
              } else if (_showSectionDropdown) {
                setState(() => _showSectionDropdown = false);
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
                        'Transfer to Store',
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
                  // Select Item Field
                  const Text(
                    'Select Item',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildItemDropdown(),
                  const SizedBox(height: 20),
                  // Quantity Field
                  const Text(
                    'Quantity to Transfer',
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
                  const SizedBox(height: 20),
                  // Transfer to Section Field
                  const Text(
                    'Transfer to Section',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildSectionDropdown(),
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
                          text: 'Transfer',
                          onPressed: _handleTransfer,
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
        // Item Dropdown overlay
        if (_showItemDropdown)
          Positioned.fill(
            child: GestureDetector(
              onTap: () => setState(() => _showItemDropdown = false),
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
                        const SizedBox(height: 24 + 26 + 24 + 16 + 8 + 50 + 20 + 16 + 8), // Offset to position dropdown correctly
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
                              children: _items.map((item) => 
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedItem = item;
                                      _showItemDropdown = false;
                                    });
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    decoration: BoxDecoration(
                                      border: item != _items.last 
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
          ),
        // Section Dropdown overlay
        if (_showSectionDropdown)
          Positioned.fill(
            child: GestureDetector(
              onTap: () => setState(() => _showSectionDropdown = false),
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
                        const SizedBox(height: 24 + 26 + 24 + 16 + 8 + 50 + 20 + 16 + 8 + 50 + 20 + 16 + 8), // Offset to position dropdown correctly
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
                              children: _sections.map((section) => 
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedSection = section;
                                      _showSectionDropdown = false;
                                    });
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    decoration: BoxDecoration(
                                      border: section != _sections.last 
                                        ? Border(bottom: BorderSide(color: Colors.grey[200]!, width: 1))
                                        : null,
                                    ),
                                    child: Text(
                                      section,
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
          ),
      ],
    );
  }

  Widget _buildItemDropdown() {
    return GestureDetector(
      onTap: () => setState(() => _showItemDropdown = !_showItemDropdown),
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
                _selectedItem,
                style: TextStyle(
                  color: _selectedItem == 'Choose item to transfer' 
                      ? Colors.grey[600] 
                      : Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            Icon(
              _showItemDropdown ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.black,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionDropdown() {
    return GestureDetector(
      onTap: () => setState(() => _showSectionDropdown = !_showSectionDropdown),
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
                _selectedSection,
                style: TextStyle(
                  color: _selectedSection == 'Select Section' 
                      ? Colors.grey[600] 
                      : Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            Icon(
              _showSectionDropdown ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.black,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}