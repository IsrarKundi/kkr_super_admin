import 'package:flutter/material.dart';
import 'package:khaabd_web/screens/widgets/dashboard_header.dart';
import 'package:khaabd_web/screens/user_management/add_new_user.dart';
import 'package:khaabd_web/utils/colors.dart';
import 'package:khaabd_web/widgets/gradient_button.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({Key? key}) : super(key: key);

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  int _tab = 0;
  bool _showDetails = false;
  bool _showAddUser = false;
  Map<String, String>? _selectedUser;

  // Generate mock data
  final List<Map<String, String>> _activeUsers = List.generate(15, (i) => {
    'id': '456',
    'name': ['Mohsin Zulfiqar', 'Ahmad Ali', 'Sara Ahmed', 'Hassan Khan', 'Fatima Sheikh', 'Ali Raza', 'Zara Malik', 'Omar Farooq', 'Ayesha Tariq', 'Bilal Ahmed', 'Mariam Hussain', 'Faisal Iqbal', 'Nadia Saleem', 'Usman Ghani', 'Rabia Nawaz'][i],
    'role': ['Admin', 'Manager', 'Staff', 'Viewer', 'Editor'][i % 5],
    'email': 'user${i + 1}@example.com',
    'lastActive': ['5m','5s','36s','3w','1y','59m','1h','12m','3h','21h','18h','2w','5d','12y','1d'][i],
    'phone': '0300-1234567',
    'status': 'Active',
  });

  final List<Map<String, String>> _inactiveUsers = List.generate(8, (i) => {
    'id': '789',
    'name': 'Inactive User ${i + 1}',
    'email': 'inactive${i + 1}@example.com',
    'lastActive': ['30d','45d','60d','90d','120d','180d','1y','2y'][i],
    'phone': '0300-9876543',
    'status': 'Inactive',
  });

  List<TableColumn> get _columns => _tab == 0 
    ? [
        TableColumn('User Name', flex: 3),
        TableColumn('Role', flex: 2),
        TableColumn('Last Active', flex: 2),
        TableColumn('Action', flex: 1),
      ]
    : [
        TableColumn('User ID', flex: 2),
        TableColumn('Name', flex: 3),
        TableColumn('Email', flex: 4),
        TableColumn('Phone', flex: 2),
        TableColumn('', flex: 1),
      ];

  List<String> _getRowData(Map<String, String> user) => _tab == 0
    ? [user['name']!, user['role']!, user['lastActive']!, '']
    : [user['id']!, user['name']!, user['email']!, user['phone']!, ''];

  void _handleAddUser(String name, String role, String password) {
    // Add your logic here to save the new user
    print('Adding user: $name, Role: $role, Password: $password');
    // You can add the user to your list or send to API
  }

  @override
  Widget build(BuildContext context) {
    final users = _tab == 0 ? _activeUsers : _inactiveUsers;

    return Stack(
      children: [
        Container(
          color: greyScaffoldBackgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DashboardHeader(),
              const SizedBox(height: 22),
              _buildHeader(),
              const SizedBox(height: 16),
              Expanded(child: _buildTable(users)),
            ],
          ),
        ),
        if (_showDetails && _selectedUser != null)
          _UserDetailsModal(
            data: _selectedUser!,
            onClose: () => setState(() => _showDetails = false),
            isActive: _tab == 0,
          ),
        if (_showAddUser)
          AddUserModal(
            onClose: () => setState(() => _showAddUser = false),
            onSave: _handleAddUser,
          ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          const Text('Users Management', style: TextStyle(color: Colors.black, fontSize: 32, fontWeight: FontWeight.w700)),
          const Spacer(),
          SizedBox(
            height: 42, 
            child: GradientButton( 
              height: 32, 
              text: "Add User", 
              icon: Icons.add, 
              onPressed: () => setState(() => _showAddUser = true),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(List<Map<String, String>> users) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _buildTableHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: users.map((user) => _buildTableRow(user)).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      ),
      child: Row(
        children: _columns.map((col) => Expanded(
          flex: col.flex,
          child: Row(
            children: [
              const SizedBox(width: 12),
              Text(col.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
              if (col.title.isNotEmpty) const Icon(Icons.arrow_drop_down, color: Colors.white, size: 20),
            ],
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildTableRow(Map<String, String> user) {
    final rowData = _getRowData(user);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: List.generate(_columns.length, (i) => 
          Expanded(
            flex: _columns[i].flex,
            child: i == _columns.length - 1 
              ? _buildActionButtons()
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(rowData[i], style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14), overflow: TextOverflow.ellipsis),
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
IconButton(
  icon: const Icon(Icons.edit_outlined, color: Color(0xFFc89849), size: 20),
  onPressed: () {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AddUserModal(
          onClose: () => Navigator.pop(context),
          onSave: (name, role, password) {
            // Handle update logic here
            // You can update your user list or call an API
            print('Updated user: $name, $role, $password');
            Navigator.pop(context);
          },
          isEditMode: true,
          initialName: "John Doe", // Replace with actual user data
          initialRole: "Admin",    // Replace with actual user data
          initialPassword: "existing_password", // Replace with actual user data
        );
      },
    );
  },
  tooltip: 'Edit',
),
        IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20), onPressed: () {}, tooltip: 'Delete'),
        SizedBox(width: 56,)
      ],
    );
  }
}

class TableColumn {
  final String title;
  final int flex;
  const TableColumn(this.title, {required this.flex});
}

class _UserDetailsModal extends StatelessWidget {
  final Map<String, String> data;
  final VoidCallback onClose;
  final bool isActive;

  const _UserDetailsModal({Key? key, required this.data, required this.onClose, required this.isActive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: GestureDetector(onTap: onClose, child: Container(color: Colors.black.withOpacity(0.5)))),
        Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 420,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 24, offset: const Offset(0, 8))],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('User Details', style: TextStyle(color: Color(0xFFc89849), fontWeight: FontWeight.w700, fontSize: 26)),
                      IconButton(icon: const Icon(Icons.close, color: Colors.red, size: 28), onPressed: onClose, tooltip: 'Close'),
                    ],
                  ),
                  const SizedBox(height: 18),
                  ...[
                    ('User Name', data['name'] ?? ''),
                    ('Email Address', data['email'] ?? ''),
                    ('Phone Number', data['phone'] ?? '0300-1234567'),
                    ('Status', data['status'] ?? 'Active'),
                    ('Last Active', data['lastActive'] ?? '5m'),
                    ('Join Date', '15 Mar 2023'),
                  ].map((item) => _DetailRow(item.$1, item.$2)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isActive ? Colors.red : const Color(0xFFc89849),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(isActive ? 'Block User' : 'Activate User', 
                                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow(this.label, this.value, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 160, child: Text(label, style: const TextStyle(color: Color(0xFFc89849), fontWeight: FontWeight.w700, fontSize: 17))),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16))),
        ],
      ),
    );
  }
}