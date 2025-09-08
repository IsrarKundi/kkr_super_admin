import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:khaabd_web/models/models/users_models/get_users_model.dart';
import 'package:khaabd_web/screens/widgets/dashboard_header.dart';
import 'package:khaabd_web/screens/user_management/add_new_user.dart';
import 'package:khaabd_web/screens/user_management/delete_user_modal.dart';
import 'package:khaabd_web/utils/colors.dart';
import 'package:khaabd_web/widgets/gradient_button.dart';
import 'package:khaabd_web/controller/getx_controllers/user_controller.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({Key? key}) : super(key: key);

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final UserController userController = Get.put(UserController());
  int _tab = 0;
  bool _showDetails = false;
  bool _showAddUser = false;
  bool _showEditUser = false;
  bool _showDeleteUser = false;
  User? _selectedUser;
  User? _userToEdit;
  User? _userToDelete;

  List<TableColumn> get _columns => [
    TableColumn('User Name', flex: 3),
    TableColumn('Role', flex: 2),
    TableColumn('Last Active', flex: 2),
    TableColumn('Action', flex: 1),
  ];

  void _handleAddUser(String name, String role, String password, String email) async {
    await userController.addNewUser(
      username: name,
      role: role.toLowerCase(),
      password: password,
      email: email,
      context: context,
    );
    // Close the modal after successful API call
    setState(() => _showAddUser = false);
  }

  void _handleEditUser(String name, String role, String password, String email) async {
    if (_userToEdit != null) {
      await userController.updateUser(
        userId: _userToEdit!.id,
        username: name,
        role: role.toLowerCase(),
        password: password,
        email: email,
        context: context,
      );
      // Close the modal after successful API call
      setState(() {
        _showEditUser = false;
        _userToEdit = null;
      });
    }
  }

  void _handleDeleteUser() async {
    if (_userToDelete != null) {
      await userController.deleteUser(
        userId: _userToDelete!.id,
        context: context,
      );
      // Close the modal after successful API call
      setState(() {
        _showDeleteUser = false;
        _userToDelete = null;
      });
    }
  }

  String _formatLastActive(DateTime? lastActive) {
    if (lastActive == null) return 'Never';
    
    final now = DateTime.now();
    final difference = now.difference(lastActive);
    
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m';
    if (difference.inHours < 24) return '${difference.inHours}h';
    if (difference.inDays < 30) return '${difference.inDays}d';
    if (difference.inDays < 365) return '${(difference.inDays / 30).floor()}mo';
    return '${(difference.inDays / 365).floor()}y';
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Stack(
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
              Expanded(child: _buildTable()),
            ],
          ),
        ),
        if (_showDetails && _selectedUser != null)
          _UserDetailsModal(
            user: _selectedUser!,
            onClose: () => setState(() => _showDetails = false),
          ),
        if (_showAddUser)
          AddUserModal(
            onClose: () => setState(() => _showAddUser = false),
            onSave: _handleAddUser,
          ),
        if (_showEditUser && _userToEdit != null)
          AddUserModal(
            onClose: () => setState(() {
              _showEditUser = false;
              _userToEdit = null;
            }),
            onSave: _handleEditUser,
            isEditMode: true,
            userId: _userToEdit!.id,
            initialName: _userToEdit!.username,
            initialRole: _userToEdit!.role,
            initialPassword: "",
            initialEmail: _userToEdit!.email,
          ),
        if (_showDeleteUser && _userToDelete != null)
          DeleteUserModal(
            user: _userToDelete!,
            onClose: () => setState(() {
              _showDeleteUser = false;
              _userToDelete = null;
            }),
            onConfirm: _handleDeleteUser,
          ),
      ],
    ));
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

  Widget _buildTable() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _buildTableHeader(),
          Expanded(
            child: userController.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : userController.users.isEmpty
                    ? const Center(
                        child: Text(
                          'No users found',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: userController.users.map((user) => _buildTableRow(user)).toList(),
                        ),
                      ),
          ),
          if (userController.users.isNotEmpty) _buildPagination(),
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

  Widget _buildTableRow(User user) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                user.username,
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                user.role.toUpperCase(),
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                _formatLastActive(user.lastActive),
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: _buildActionButtons(user),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(User user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // IconButton(
        //   icon: const Icon(Icons.visibility_outlined, color: Color(0xFFc89849), size: 20),
        //   onPressed: () {
        //     setState(() {
        //       _selectedUser = user;
        //       _showDetails = true;
        //     });
        //   },
        //   tooltip: 'View Details',
        // ),
        IconButton(
          icon: SvgPicture.asset('assets/svgs/edit_icon.svg', width: 20, height: 20),
          onPressed: () {
            setState(() {
              _userToEdit = user;
              _showEditUser = true;
            });
          },
          tooltip: 'Edit',
        ),
        IconButton(
          icon: SvgPicture.asset('assets/svgs/delete_icon.svg', width: 20, height: 20),
          onPressed: () {
            setState(() {
              _userToDelete = user;
              _showDeleteUser = true;
            });
          },
          tooltip: 'Delete',
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildPagination() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '',
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: userController.hasPrev.value
                    ? () => userController.loadPreviousPage()
                    : null,
              ),
              Text(
                'Page ${userController.currentPage.value} of ${userController.totalPages.value}',
                style: const TextStyle(fontSize: 14),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: userController.hasNext.value
                    ? () => userController.loadNextPage()
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TableColumn {
  final String title;
  final int flex;
  const TableColumn(this.title, {required this.flex});
}

class _UserDetailsModal extends StatelessWidget {
  final User user;
  final VoidCallback onClose;

  const _UserDetailsModal({Key? key, required this.user, required this.onClose}) : super(key: key);

  String _formatLastActive(DateTime? lastActive) {
    if (lastActive == null) return 'Never';
    
    final now = DateTime.now();
    final difference = now.difference(lastActive);
    
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m';
    if (difference.inHours < 24) return '${difference.inHours}h';
    if (difference.inDays < 30) return '${difference.inDays}d';
    if (difference.inDays < 365) return '${(difference.inDays / 30).floor()}mo';
    return '${(difference.inDays / 365).floor()}y';
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_getMonthName(date.month)} ${date.year}';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

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
                    ('User ID', user.id),
                    ('User Name', user.username),
                    ('Role', user.role.toUpperCase()),
                    ('Status', 'Active'),
                    ('Last Active', _formatLastActive(user.lastActive)),
                    ('Join Date', _formatDate(user.createdAt)),
                  ].map((item) => _DetailRow(item.$1, item.$2)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      // Handle block/activate user logic here
                      print('Toggle user status: ${user.username}');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFc89849),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Block User', 
                                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
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