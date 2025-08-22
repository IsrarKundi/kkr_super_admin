import 'package:flutter/material.dart';
import 'package:khaabd_web/widgets/custom_textfield.dart';
import 'package:khaabd_web/widgets/gradient_button.dart';
import 'package:khaabd_web/widgets/outlined_button.dart';

class AddExpenseModal extends StatefulWidget {
  final VoidCallback onClose;
  final Function(String title, String amount, String paymentMethod) onSave;
  // Optional parameters for editing existing expense
  final String? initialTitle;
  final String? initialAmount;
  final String? initialPaymentMethod;
  final bool isEditMode;

  const AddExpenseModal({
    Key? key,
    required this.onClose,
    required this.onSave,
    this.initialTitle,
    this.initialAmount,
    this.initialPaymentMethod,
    this.isEditMode = false,
  }) : super(key: key);

  @override
  State<AddExpenseModal> createState() => _AddExpenseModalState();
}

class _AddExpenseModalState extends State<AddExpenseModal> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String _selectedPaymentMethod = 'Select Payment Method';
  bool _showDropdown = false;
  final List<String> _paymentMethods = ['Cash', 'Bank', 'Debt'];

  @override
  void initState() {
    super.initState();
    // Pre-fill fields if in edit mode
    if (widget.isEditMode) {
      _titleController.text = widget.initialTitle ?? '';
      _amountController.text = widget.initialAmount ?? '';
      _selectedPaymentMethod = widget.initialPaymentMethod ?? 'Select Payment Method';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_titleController.text.isNotEmpty && 
        _amountController.text.isNotEmpty &&
        _selectedPaymentMethod != 'Select Payment Method') {
      widget.onSave(_titleController.text, _amountController.text, _selectedPaymentMethod);
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
              if (_showDropdown) {
                setState(() => _showDropdown = false);
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
              width: 500,
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Spacer(),
                      Text(
                        widget.isEditMode ? 'Edit Expense' : 'Add New Expense',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
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
                  const SizedBox(height: 24),
                  
                  // Title Field
                  const Text(
                    'Title',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: _titleController,
                    hintText: 'electricity - bill',
                    borderRadius: 8,
                  ),
                  const SizedBox(height: 20),
                  
                  // Amount Field
                  const Text(
                    'Amount',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: _amountController,
                    hintText: 'Enter amount',
                    borderRadius: 8,
                  ),
                  const SizedBox(height: 20),
                  
                  // Payment Method Selection
                  const Text(
                    'Payment Method',
                    style: TextStyle(
                      color: Colors.black,
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
        // Dropdown overlay - positioned outside the modal to ensure proper z-index
        if (_showDropdown)
          Positioned.fill(
            child: GestureDetector(
              onTap: () => setState(() => _showDropdown = false),
              child: Container(
                color: Colors.transparent,
                child: Center(
                  child: Container(
                    width: 500,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 200), // Offset to position dropdown correctly
                        Material(
                          elevation: 8,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[300]!, width: 1),
                            ),
                            child: Column(
                              children: _paymentMethods.map((method) => 
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedPaymentMethod = method;
                                      _showDropdown = false;
                                    });
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    decoration: BoxDecoration(
                                      border: method != _paymentMethods.last 
                                        ? Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1))
                                        : null,
                                    ),
                                    child: Text(
                                      method,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
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

  Widget _buildPaymentMethodDropdown() {
    return GestureDetector(
      onTap: () => setState(() => _showDropdown = !_showDropdown),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedPaymentMethod,
              style: TextStyle(
                color: _selectedPaymentMethod == 'Select Payment Method' 
                    ? Colors.grey[600] 
                    : Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(
              _showDropdown ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.black,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}