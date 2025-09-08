import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khaabd_web/widgets/custom_textfield.dart';
import 'package:khaabd_web/widgets/gradient_button.dart';
import 'package:khaabd_web/widgets/outlined_button.dart';
import 'package:khaabd_web/controller/getx_controllers/store_controller.dart';
import 'package:khaabd_web/models/models/store_models/get_inventory_model.dart';

class TransferToKitchenModal extends StatefulWidget {
  final VoidCallback onClose;
  final Function(String itemId, String quantity, String section) onTransfer;

  const TransferToKitchenModal({
    Key? key,
    required this.onClose,
    required this.onTransfer,
  }) : super(key: key);

  @override
  State<TransferToKitchenModal> createState() => _TransferToKitchenModalState();
}

class _TransferToKitchenModalState extends State<TransferToKitchenModal> {
  final TextEditingController _quantityController = TextEditingController();
  CurrentInventory? _selectedItem;
  String _selectedSection = 'Select Section';
  bool _showItemDropdown = false;
  bool _showSectionDropdown = false;

  final List<String> _sections = ['Desi', 'Kabuli', 'Chinese', 'Fast Food'];

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _handleTransfer() {
    if (_selectedItem != null && 
        _quantityController.text.isNotEmpty && 
        _selectedSection != 'Select Section') {
      widget.onTransfer(_selectedItem!.itemId, _quantityController.text, _selectedSection);
    }
  }

  @override
  Widget build(BuildContext context) {
    final StoreController storeController = Get.put(StoreController());
    
    return Obx(() {
      final bool isLoading = storeController.isTransferringToKitchen.value;
      
      return Stack(
        children: [
          // Background overlay
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                if (isLoading) return;
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
                          'Transfer to Kitchen',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 26,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red, size: 28),
                          onPressed: isLoading ? null : widget.onClose,
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
                    _buildItemDropdown(storeController, isLoading),
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
                      enabled: !isLoading,
                    ),
                    if (_selectedItem != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Available: ${_selectedItem!.currentStock} ${_selectedItem!.measuringUnit}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
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
                    _buildSectionDropdown(isLoading),
                    const SizedBox(height: 32),
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedGradientButton(
                            text: "Cancel",
                            onPressed: isLoading ? null : widget.onClose,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: GradientButton(
                            text: isLoading ? 'Transferring...' : 'Transfer',
                            onPressed: isLoading ? null : _handleTransfer,
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
          if (_showItemDropdown && !isLoading)
            _buildItemDropdownOverlay(storeController),
          // Section Dropdown overlay
          if (_showSectionDropdown && !isLoading)
            _buildSectionDropdownOverlay(),
        ],
      );
    });
  }

  Widget _buildItemDropdown(StoreController storeController, bool isLoading) {
    return GestureDetector(
      onTap: isLoading ? null : () => setState(() => _showItemDropdown = !_showItemDropdown),
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: isLoading ? Colors.grey : Colors.black, width: 1.0),
          borderRadius: BorderRadius.circular(12.0),
          color: isLoading ? Colors.grey[50] : Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _selectedItem?.name ?? 'Choose item to transfer',
                style: TextStyle(
                  color: _selectedItem == null 
                      ? Colors.grey[600] 
                      : (isLoading ? Colors.grey : Colors.black),
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            Icon(
              _showItemDropdown ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: isLoading ? Colors.grey : Colors.black,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionDropdown(bool isLoading) {
    return GestureDetector(
      onTap: isLoading ? null : () => setState(() => _showSectionDropdown = !_showSectionDropdown),
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: isLoading ? Colors.grey : Colors.black, width: 1.0),
          borderRadius: BorderRadius.circular(12.0),
          color: isLoading ? Colors.grey[50] : Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _selectedSection,
                style: TextStyle(
                  color: _selectedSection == 'Select Section' 
                      ? Colors.grey[600] 
                      : (isLoading ? Colors.grey : Colors.black),
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            Icon(
              _showSectionDropdown ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: isLoading ? Colors.grey : Colors.black,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemDropdownOverlay(StoreController storeController) {
    return Positioned.fill(
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
                  // const SizedBox(height: 24 + 26 + 24 + 16 + 8 + 50 + 20 + 16 + 8), // Offset to position dropdown correctly
                  Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 200),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!, width: 1),
                      ),
                      child: storeController.currentInventory.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                'No items available',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : Scrollbar(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: storeController.currentInventory.length,
                                itemBuilder: (context, index) {
                                  final item = storeController.currentInventory[index];
                                  return InkWell(
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
                                        border: index != storeController.currentInventory.length - 1
                                            ? Border(bottom: BorderSide(color: Colors.grey[200]!, width: 1))
                                            : null,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.name,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Available: ${item.currentStock} ${item.measuringUnit}',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
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

  Widget _buildSectionDropdownOverlay() {
    return Positioned.fill(
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
                  const SizedBox(height: 24 + 26 + 24 + 16 + 8 + 50 + 20 + 16 + 8 +120 + 50 + 20 + 16 + 8), // Offset to position dropdown correctly
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
    );
  }
}