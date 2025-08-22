import 'package:flutter/material.dart';
import 'package:khaabd_web/widgets/custom_textfield.dart';
import 'package:khaabd_web/widgets/gradient_button.dart';
import 'package:khaabd_web/widgets/outlined_button.dart';

class AddUserModal extends StatefulWidget {
  final VoidCallback onClose;
  final Function(String name, String role, String password) onSave;
  
  // Optional parameters for editing existing user
  final String? initialName;
  final String? initialRole;
  final String? initialPassword;
  final bool isEditMode;

  const AddUserModal({
    Key? key,
    required this.onClose,
    required this.onSave,
    this.initialName,
    this.initialRole,
    this.initialPassword,
    this.isEditMode = false,
  }) : super(key: key);

  @override
  State<AddUserModal> createState() => _AddUserModalState();
}

class _AddUserModalState extends State<AddUserModal> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  String _selectedRole = 'Select Role';
  bool _showDropdown = false;
  
  final List<String> _roles = ['Admin', 'Manager', 'Staff', 'Viewer', 'Editor'];

  @override
  void initState() {
    super.initState();
    
    // Pre-fill fields if in edit mode
    if (widget.isEditMode) {
      _nameController.text = widget.initialName ?? '';
      _passwordController.text = widget.initialPassword ?? '';
      _selectedRole = widget.initialRole ?? 'Select Role';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_nameController.text.isNotEmpty && 
        _selectedRole != 'Select Role' && 
        _passwordController.text.isNotEmpty) {
      widget.onSave(_nameController.text, _selectedRole, _passwordController.text);
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
                      Spacer(),
                      Text(
                        widget.isEditMode ? 'Edit User' : 'Add New User',
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
                  
                  // User Name Field
                  const Text(
                    'User Name',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: _nameController,
                    hintText: 'Enter user name',
                    borderRadius: 12.0,
                  ),
                  const SizedBox(height: 20),
                  
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
                  const SizedBox(height: 20),
                  
                  // Password Field
                  const Text(
                    'Password',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: _passwordController,
                    hintText: 'Enter password',
                    borderRadius: 12.0,
                    obscureText: false,
                  ),
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
        // Dropdown overlay - positioned outside the modal to ensure proper z-index
        if (_showDropdown)
          Positioned.fill(
            child: GestureDetector(
              onTap: () => setState(() => _showDropdown = false),
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
                                        ? Border(bottom: BorderSide(color: Colors.grey[200]!, width: 1))
                                        : null,
                                    ),
                                    child: Text(
                                      role,
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

  Widget _buildRoleDropdown() {
    return GestureDetector(
      onTap: () => setState(() => _showDropdown = !_showDropdown),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.black, width: 1.0),
          borderRadius: BorderRadius.circular(12.0),
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
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              _showDropdown ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.black,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}