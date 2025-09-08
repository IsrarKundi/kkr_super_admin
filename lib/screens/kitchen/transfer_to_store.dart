import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khaabd_web/widgets/custom_textfield.dart';
import 'package:khaabd_web/widgets/gradient_button.dart';
import 'package:khaabd_web/widgets/outlined_button.dart';
import 'package:khaabd_web/controller/getx_controllers/kitchen_controller.dart';
import 'package:khaabd_web/models/models/kitchen_models/get_kitchen_inventory_model.dart';

class TransferToStoreModal extends StatefulWidget {
  final VoidCallback onClose;

  const TransferToStoreModal({
    Key? key,
    required this.onClose,
  }) : super(key: key);

  @override
  State<TransferToStoreModal> createState() => _TransferToStoreModalState();
}

class _TransferToStoreModalState extends State<TransferToStoreModal> {
  final TextEditingController _quantityController = TextEditingController();
  final KitchenController kitchenController = Get.find<KitchenController>();
  
  Inventory? _selectedItem;
  String _selectedSection = 'Select Section';
  bool _showItemDropdown = false;
  bool _showSectionDropdown = false;

  final List<String> _sections = ['desi', 'continental', 'fast_food'];
  final Map<String, String> _sectionDisplayNames = {
    'desi': 'Desi',
    'continental': 'Continental', 
    'fast_food': 'Fast Food'
  };

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _handleTransfer() async {
    if (_selectedItem != null && 
        _quantityController.text.isNotEmpty && 
        _selectedSection != 'Select Section') {
      
      final quantity = int.tryParse(_quantityController.text);
      if (quantity == null || quantity <= 0) {
        Get.snackbar(
          'Invalid Quantity',
          'Please enter a valid quantity',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      if (quantity > _selectedItem!.currentStock) {
        Get.snackbar(
          'Insufficient Stock',
          'Available stock: ${_selectedItem!.currentStock} ${_selectedItem!.measuringUnit}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
      log("kitchen section: $_selectedSection");
      log("item id: ${_selectedItem!.id}");
      log("quantity: $quantity");
      final success = await kitchenController.transferToStore(
        itemId: _selectedItem!.itemId,
        kitchenSection: _selectedSection,
        quantity: quantity,
        context: context
      );

      if (success) {
        widget.onClose();
      }
    } else {
      Get.snackbar(
        'Missing Information',
        'Please fill all required fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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
                    hintText: _selectedItem != null 
                        ? 'Enter quantity (Available: ${_selectedItem!.currentStock} ${_selectedItem!.measuringUnit})'
                        : 'Enter quantity',
                    borderRadius: 12.0,
                  ),
                  const SizedBox(height: 20),
                  // Transfer from Section Field
                  const Text(
                    'Transfer from Section',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildSectionDropdown(),
                  const SizedBox(height: 32),
                  // Action Buttons
                  Obx(() => Row(
                    children: [
                      Expanded(
                        child: OutlinedGradientButton(
                          text: "Cancel",
                          onPressed: kitchenController.isTransferringToStore.value 
                              ? null 
                              : widget.onClose,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GradientButton(
                          text: kitchenController.isTransferringToStore.value 
                              ? 'Transferring...' 
                              : 'Transfer',
                          onPressed: kitchenController.isTransferringToStore.value 
                              ? null 
                              : _handleTransfer,
                          height: 50,
                        ),
                      ),
                    ],
                  )),
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
                            constraints: const BoxConstraints(maxHeight: 200),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!, width: 1),
                            ),
                            child: Obx(() {
                              final items = kitchenController.kitchenInventory
                                  .where((item) => item.currentStock > 0)
                                  .toList();
                              
                              if (items.isEmpty) {
                                return const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text(
                                    'No items available for transfer',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              }

                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  final item = items[index];
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
                                        border: index != items.length - 1
                                            ? Border(bottom: BorderSide(color: Colors.grey[200]!, width: 1))
                                            : null,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.itemName,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            'Stock: ${item.currentStock} ${item.measuringUnit} | Section: ${item.kitchenSection}',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }),
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
                                      _sectionDisplayNames[section] ?? section,
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
                _selectedItem?.itemName ?? 'Choose item to transfer',
                style: TextStyle(
                  color: _selectedItem == null 
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
                _selectedSection == 'Select Section' 
                    ? _selectedSection
                    : _sectionDisplayNames[_selectedSection] ?? _selectedSection,
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