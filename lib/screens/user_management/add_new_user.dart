import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khaabd_web/widgets/custom_textfield.dart';
import 'package:khaabd_web/widgets/gradient_button.dart';
import 'package:khaabd_web/widgets/outlined_button.dart';
import 'package:khaabd_web/controller/getx_controllers/user_controller.dart';

class AddUserModal extends StatefulWidget {
  final VoidCallback onClose;
  final Function(String name, String role, String password) onSave;
  
  // Optional parameters for editing existing user
  final String? initialName;
  final String? initialRole;
  final String? initialPassword;
  final String? userId;
  final bool isEditMode;

  const AddUserModal({
    Key? key,
    required this.onClose,
    required this.onSave,
    this.initialName,
    this.initialRole,
    this.initialPassword,
    this.userId,
    this.isEditMode = false,
  }) : super(key: key);

  @override
  State<AddUserModal> createState() => _AddUserModalState();
}

class _AddUserModalState extends State<AddUserModal> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final UserController userController = Get.find<UserController>();
  
  String _selectedRole = 'Select Role';
  bool _showDropdown = false;
  bool _obscurePassword = true;
  String? _nameError;
  String? _roleError;
  String? _passwordError;
  
  final List<String> _roles = ['kitchen', 'HR', 'Store', 'Finance'];
  
  // Password regex pattern: at least 8 characters, 1 uppercase, 1 lowercase, 1 number, 1 special character
  final RegExp _passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');

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

  void _validateFields() {
    setState(() {
      _nameError = null;
      _roleError = null;
      _passwordError = null;
    });

    // Validate name
    if (_nameController.text.trim().isEmpty) {
      setState(() {
        _nameError = 'User name is required';
      });
      return;
    }

    // Validate role
    if (_selectedRole == 'Select Role') {
      setState(() {
        _roleError = 'Please select a role';
      });
      return;
    }

    // Validate password
    if (_passwordController.text.isEmpty) {
      setState(() {
        _passwordError = 'Password is required';
      });
      return;
    }

    if (!_passwordRegex.hasMatch(_passwordController.text)) {
      setState(() {
        _passwordError = 'Password must be at least 8 characters with uppercase, lowercase, number and special character';
      });
      return;
    }

    // If all validations pass, proceed with save
    _handleSave();
  }

  void _handleSave() async {
    try {
      await widget.onSave(_nameController.text.trim(), _selectedRole, _passwordController.text);
      // Don't close here - let the parent handle closing after successful API call
    } catch (e) {
      // Handle any errors from the save operation
      print('Error saving user: $e');
      // Don't close the modal if there was an error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isLoading = widget.isEditMode 
          ? userController.isUpdatingUser.value 
          : userController.isAddingUser.value;
      
      return Stack(
        children: [
          // Background overlay
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                if (_showDropdown) {
                  setState(() => _showDropdown = false);
                } else if (!isLoading) {
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
                          onPressed: isLoading ? null : widget.onClose,
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
                      enabled: !isLoading,
                    ),
                    if (_nameError != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        _nameError!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ],
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
                    _buildRoleDropdown(isLoading),
                    if (_roleError != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        _roleError!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ],
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
                    _buildPasswordField(isLoading),
                    if (_passwordError != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        _passwordError!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ],
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
                            text: isLoading 
                                ? 'Saving...' 
                                : (widget.isEditMode ? 'Update' : 'Save'),
                            onPressed: isLoading ? null : _validateFields,
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
                                        _roleError = null; // Clear role error when selected
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
    });
  }

  Widget _buildRoleDropdown(bool isLoading) {
    return GestureDetector(
      onTap: isLoading ? null : () => setState(() => _showDropdown = !_showDropdown),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isLoading ? Colors.grey[100] : Colors.transparent,
          border: Border.all(
            color: _roleError != null ? Colors.red : Colors.black, 
            width: 1.0
          ),
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
              color: isLoading ? Colors.grey : Colors.black,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(bool isLoading) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: _passwordError != null ? Colors.red : Colors.black,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              enabled: !isLoading,
              onChanged: (value) {
                // Clear password error when user starts typing and the password meets requirements
                if (_passwordError != null && _passwordRegex.hasMatch(value)) {
                  setState(() {
                    _passwordError = null;
                  });
                }
              },
              decoration: InputDecoration(
                hintText: 'Enter password',
                hintStyle: TextStyle(color: Colors.grey[600]),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: isLoading ? Colors.grey : Colors.grey[600],
            ),
            onPressed: isLoading ? null : () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
            tooltip: _obscurePassword ? 'Show password' : 'Hide password',
          ),
        ],
      ),
    );
  }
}