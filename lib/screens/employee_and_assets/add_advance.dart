import 'package:flutter/material.dart';
import 'package:khaabd_web/widgets/custom_textfield.dart';
import 'package:khaabd_web/widgets/gradient_button.dart';
import 'package:khaabd_web/widgets/outlined_button.dart';

class AddAdvanceModal extends StatefulWidget {
  final VoidCallback onClose;
  final Function(String employee, String reason, String amount) onSave;
  final List<Map<String, String>> employees;
  // Optional parameters for editing existing advance
  final String? initialEmployee;
  final String? initialReason;
  final String? initialAmount;
  final bool isEditMode;

  const AddAdvanceModal({
    Key? key,
    required this.onClose,
    required this.onSave,
    required this.employees,
    this.initialEmployee,
    this.initialReason,
    this.initialAmount,
    this.isEditMode = false,
  }) : super(key: key);

  @override
  State<AddAdvanceModal> createState() => _AddAdvanceModalState();
}

class _AddAdvanceModalState extends State<AddAdvanceModal> {
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  
  String _selectedEmployee = 'Select Employee';
  bool _showDropdown = false;
  List<String> _employeeNames = [];

  @override
  void initState() {
    super.initState();
    
    // Extract employee names from the employees list
    _employeeNames = widget.employees.map((emp) => emp['fullName'] ?? '').toList();
    
    // Pre-fill fields if in edit mode
    if (widget.isEditMode) {
      _selectedEmployee = widget.initialEmployee ?? 'Select Employee';
      _reasonController.text = widget.initialReason ?? '';
      _amountController.text = widget.initialAmount?.replaceAll('₹', '').replaceAll(',', '') ?? '';
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_selectedEmployee != 'Select Employee' && 
        _reasonController.text.isNotEmpty &&
        _amountController.text.isNotEmpty) {
      widget.onSave(
        _selectedEmployee,
        _reasonController.text,
        _amountController.text,
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
              if (_showDropdown) {
                setState(() => _showDropdown = false);
              } else {
                widget.onClose();
              }
            },
            child: Container(color: Colors.black.withOpacity(0.5)),
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
                        widget.isEditMode ? 'Edit Advance' : 'Add Advance',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
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
                  const SizedBox(height: 20),
                  
                  // Employee Selection
                  const Text(
                    'Employee',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildEmployeeDropdown(),
                  const SizedBox(height: 16),
                  
                  // Reason Field
                  const Text(
                    'Reason',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: _reasonController,
                    hintText: 'Enter reason for advance',
                    borderRadius: 8,
                  ),
                  const SizedBox(height: 16),
                  
                  // Amount Field
                  const Text(
                    'Amount',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: _amountController,
                    hintText: 'Enter advance amount',
                    borderRadius: 8,
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
                        const SizedBox(height: 140), // Offset to position dropdown correctly
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
                              children: _employeeNames.map((employee) => 
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedEmployee = employee;
                                      _showDropdown = false;
                                    });
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    decoration: BoxDecoration(
                                      border: employee != _employeeNames.last 
                                        ? Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1))
                                        : null,
                                    ),
                                    child: Text(
                                      employee,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
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

  Widget _buildEmployeeDropdown() {
    return GestureDetector(
      onTap: () => setState(() => _showDropdown = !_showDropdown),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _selectedEmployee,
                style: TextStyle(
                  color: _selectedEmployee == 'Select Employee' 
                      ? Colors.grey[600] 
                      : Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            Icon(
              _showDropdown ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.grey[600],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}