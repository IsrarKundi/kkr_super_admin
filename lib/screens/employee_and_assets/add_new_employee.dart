import 'package:flutter/material.dart';
import 'package:khaabd_web/widgets/custom_textfield.dart';
import 'package:khaabd_web/widgets/gradient_button.dart';
import 'package:khaabd_web/widgets/outlined_button.dart';

class AddEmployeeModal extends StatefulWidget {
  final VoidCallback onClose;
  final Function(String fullName, String phoneNo, String cnic, String role, String salary, String joiningDate) onSave;
  // Optional parameters for editing existing employee
  final String? initialFullName;
  final String? initialPhoneNo;
  final String? initialCnic;
  final String? initialRole;
  final String? initialSalary;
  final String? initialJoiningDate;
  final bool isEditMode;

  const AddEmployeeModal({
    Key? key,
    required this.onClose,
    required this.onSave,
    this.initialFullName,
    this.initialPhoneNo,
    this.initialCnic,
    this.initialRole,
    this.initialSalary,
    this.initialJoiningDate,
    this.isEditMode = false,
  }) : super(key: key);

  @override
  State<AddEmployeeModal> createState() => _AddEmployeeModalState();
}

class _AddEmployeeModalState extends State<AddEmployeeModal> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _cnicController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _joiningDateController = TextEditingController();
  
  String _selectedRole = 'Select Role';
  bool _showDropdown = false;
  final List<String> _roles = ['Chef', 'Waiter', 'Kitchen Helper', 'Cashier', 'Manager', 'Cleaner', 'Cook', 'Security', 'Delivery Boy'];

  @override
  void initState() {
    super.initState();
    // Pre-fill fields if in edit mode
    if (widget.isEditMode) {
      _fullNameController.text = widget.initialFullName ?? '';
      _phoneNoController.text = widget.initialPhoneNo ?? '';
      _cnicController.text = widget.initialCnic ?? '';
      _selectedRole = widget.initialRole ?? 'Select Role';
      _salaryController.text = widget.initialSalary?.replaceAll('₹', '').replaceAll(',', '') ?? '';
      _joiningDateController.text = widget.initialJoiningDate ?? '';
    } else {
      // Set current date for new employee
      _joiningDateController.text = DateTime.now().toString().split(' ')[0];
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneNoController.dispose();
    _cnicController.dispose();
    _salaryController.dispose();
    _joiningDateController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_fullNameController.text.isNotEmpty && 
        _phoneNoController.text.isNotEmpty &&
        _cnicController.text.isNotEmpty &&
        _selectedRole != 'Select Role' && 
        _salaryController.text.isNotEmpty &&
        _joiningDateController.text.isNotEmpty) {
      widget.onSave(
        _fullNameController.text, 
        _phoneNoController.text,
        _cnicController.text,
        _selectedRole, 
        _salaryController.text,
        _joiningDateController.text
      );
      widget.onClose();
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _joiningDateController.text = picked.toString().split(' ')[0];
      });
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
                        widget.isEditMode ? 'Edit Employee' : 'Add New Employee',
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
                  const SizedBox(height: 20),
                  
                  // Full Name Field
                  const Text(
                    'Full Name',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: _fullNameController,
                    hintText: 'Enter full name',
                    borderRadius: 8,
                  ),
                  const SizedBox(height: 16),
                  
                  // Phone Number Field
                  const Text(
                    'Phone Number',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: _phoneNoController,
                    hintText: 'Enter phone number',
                    borderRadius: 8,
                  ),
                  const SizedBox(height: 16),
                  
                  // CNIC Field
                  const Text(
                    'CNIC',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: _cnicController,
                    hintText: 'Enter CNIC (e.g., 12345-6789012-3)',
                    borderRadius: 8,
                  ),
                  const SizedBox(height: 16),
                  
                  // Role Selection
                  const Text(
                    'Role',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildRoleDropdown(),
                  const SizedBox(height: 16),
                  
                  // Salary Field
                  const Text(
                    'Salary',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: _salaryController,
                    hintText: 'Enter salary amount',
                    borderRadius: 8,
                  ),
                  const SizedBox(height: 16),
                  
                  // Joining Date Field
                  const Text(
                    'Joining Date',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _selectDate,
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
                              _joiningDateController.text.isEmpty 
                                  ? 'Select joining date' 
                                  : _joiningDateController.text,
                              style: TextStyle(
                                color: _joiningDateController.text.isEmpty 
                                    ? Colors.grey[600] 
                                    : Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Icon(Icons.calendar_today, color: Colors.grey[600], size: 20),
                        ],
                      ),
                    ),
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
                        const SizedBox(height: 280), // Offset to position dropdown correctly
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
                              children: _roles.map((role) => 
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedRole = role;
                                      _showDropdown = false;
                                    });
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    decoration: BoxDecoration(
                                      border: role != _roles.last 
                                        ? Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1))
                                        : null,
                                    ),
                                    child: Text(
                                      role,
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

  Widget _buildRoleDropdown() {
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
                _selectedRole,
                style: TextStyle(
                  color: _selectedRole == 'Select Role' 
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