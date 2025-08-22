import 'package:flutter/material.dart';
import 'package:khaabd_web/screens/sales/add_new_sale.dart';
import 'package:khaabd_web/screens/widgets/dashboard_header.dart';
import 'package:khaabd_web/utils/colors.dart';
import 'package:khaabd_web/widgets/gradient_button.dart';

class SalesManagementScreen extends StatefulWidget {
  const SalesManagementScreen({Key? key}) : super(key: key);

  @override
  State<SalesManagementScreen> createState() => _SalesManagementScreenState();
}

class _SalesManagementScreenState extends State<SalesManagementScreen> {
  int _tab = 0;
  bool _showDetails = false;
  bool _showAddSale = false;
  Map<String, String>? _selectedUser;

  // Generate mock sales data
  final List<Map<String, String>> _activeUsers = List.generate(15, (i) => {
    'id': 'ORD-${1000 + i}',
    'orderDate': ['2024-01-15', '2024-01-14', '2024-01-13', '2024-01-12', '2024-01-11', '2024-01-10', '2024-01-09', '2024-01-08', '2024-01-07', '2024-01-06', '2024-01-05', '2024-01-04', '2024-01-03', '2024-01-02', '2024-01-01'][i],
    'totalSales': ['\$2,450', '\$1,890', '\$3,200', '\$890', '\$4,560', '\$1,200', '\$2,780', '\$3,450', '\$1,670', '\$2,340', '\$5,600', '\$980', '\$2,100', '\$3,890', '\$1,450'][i],
    'cost': ['\$1,470', '\$1,134', '\$1,920', '\$534', '\$2,736', '\$720', '\$1,668', '\$2,070', '\$1,002', '\$1,404', '\$3,360', '\$588', '\$1,260', '\$2,334', '\$870'][i],
    'profit': ['\$980', '\$756', '\$1,280', '\$356', '\$1,824', '\$480', '\$1,112', '\$1,380', '\$668', '\$936', '\$2,240', '\$392', '\$840', '\$1,556', '\$580'][i],
    'customer': ['John Smith', 'Sarah Johnson', 'Mike Brown', 'Lisa Davis', 'Tom Wilson', 'Emma Garcia', 'David Miller', 'Anna Taylor', 'Chris Anderson', 'Maria Rodriguez', 'James Martinez', 'Jennifer Lee', 'Robert Clark', 'Michelle Lewis', 'Kevin Walker'][i],
    'name': ['John Smith', 'Sarah Johnson', 'Mike Brown', 'Lisa Davis', 'Tom Wilson', 'Emma Garcia', 'David Miller', 'Anna Taylor', 'Chris Anderson', 'Maria Rodriguez', 'James Martinez', 'Jennifer Lee', 'Robert Clark', 'Michelle Lewis', 'Kevin Walker'][i],
    'role': 'Customer',
    'email': 'customer${i + 1}@example.com',
    'lastActive': ['5m','5s','36s','3w','1y','59m','1h','12m','3h','21h','18h','2w','5d','12y','1d'][i],
    'phone': '0300-1234567',
    'status': 'Completed',
  });

  final List<Map<String, String>> _inactiveUsers = List.generate(8, (i) => {
    'id': 'ORD-${900 + i}',
    'orderDate': ['2023-12-28', '2023-12-25', '2023-12-20', '2023-12-15', '2023-12-10', '2023-12-05', '2023-11-30', '2023-11-25'][i],
    'totalSales': ['\$1,200', '\$2,800', '\$950', '\$3,400', '\$1,750', '\$2,200', '\$890', '\$4,100'][i],
    'cost': ['\$720', '\$1,680', '\$570', '\$2,040', '\$1,050', '\$1,320', '\$534', '\$2,460'][i],
    'profit': ['\$480', '\$1,120', '\$380', '\$1,360', '\$700', '\$880', '\$356', '\$1,640'][i],
    'customer': 'Archived Customer ${i + 1}',
    'name': 'Archived Customer ${i + 1}',
    'email': 'archived${i + 1}@example.com',
    'lastActive': ['30d','45d','60d','90d','120d','180d','1y','2y'][i],
    'phone': '0300-9876543',
    'status': 'Archived',
  });

  List<TableColumn> get _columns =>  [
        TableColumn('Order Date', flex: 3),
        TableColumn('Total Sales', flex: 2),
        TableColumn('Cost', flex: 2),
        TableColumn('Profit', flex: 2),
        TableColumn('Action', flex:2),
      ];
  

  List<String> _getRowData(Map<String, String> user) => [
    user['orderDate']!,
    user['totalSales']!,
    user['cost']!,
    user['profit']!,
    ''
  ];

  void _handleAddSale(String orderDate, String totalSales, String cost, String profit, String customer, String orderType, List<Map<String, String>> orderItems) {
    // Add your logic here to save the new sale
    print('Adding sale: Order Date: $orderDate, Total Sales: $totalSales, Cost: $cost, Profit: $profit, Customer: $customer, Order Type: $orderType');
    print('Order Items: $orderItems');
    // You can add the sale to your list or send to API
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
        if (_showAddSale)
          AddSaleModal(
            onClose: () => setState(() => _showAddSale = false),
            onSave: _handleAddSale,
          ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          const Text('Sales Management', style: TextStyle(color: Colors.black, fontSize: 32, fontWeight: FontWeight.w700)),
          const Spacer(),
          SizedBox(
            height: 42, 
            child: GradientButton( 
              height: 32, 
              text: "Add New Sale", 
              icon: Icons.add, 
              onPressed: () => setState(() => _showAddSale = true),
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
              ? _buildActionButtons(user)
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(rowData[i], style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14), overflow: TextOverflow.ellipsis),
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(Map<String, String> user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(Icons.edit_outlined, color: Color(0xFFc89849), size: 20),
          onPressed: () {
            setState(() => _showAddSale = true);
          },
          tooltip: 'Edit',
        ),
        IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20), onPressed: () {}, tooltip: 'Delete'),
        const SizedBox(width: 136,)
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