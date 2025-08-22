import 'package:flutter/material.dart';
import 'package:khaabd_web/screens/finance/add_new_finance.dart';
import 'package:khaabd_web/screens/widgets/dashboard_header.dart';
import 'package:khaabd_web/utils/colors.dart';
import 'package:khaabd_web/widgets/gradient_button.dart';

class FinanceManagementScreen extends StatefulWidget {
  final void Function(Map<String, dynamic>)? onShowDetail;
  const FinanceManagementScreen({Key? key, this.onShowDetail}) : super(key: key);

  @override
  State<FinanceManagementScreen> createState() => _FinanceManagementScreenState();
}

class _FinanceManagementScreenState extends State<FinanceManagementScreen> {
  int _tab = 0;
  bool _showAddExpenseModal = false;
  bool _showEditExpenseModal = false;
  Map<String, String>? _editingItem;

  // Mock data for Recent Expenses
  final List<Map<String, String>> _recentExpenses = List.generate(15, (i) => {
    'title': [
      'Kitchen Equipment Purchase',
      'Ingredient Supplies',
      'Utility Bills',
      'Staff Salaries',
      'Maintenance & Repairs',
      'Marketing Campaign',
      'Insurance Premium',
      'Rent Payment',
      'Cleaning Supplies',
      'Gas & Fuel',
      'Office Supplies',
      'Equipment Rental',
      'Professional Services',
      'Transportation',
      'Miscellaneous'
    ][i],
    'amount': [
      '₹25,000',
      '₹18,500',
      '₹12,300',
      '₹45,000',
      '₹8,750',
      '₹15,200',
      '₹22,000',
      '₹35,000',
      '₹3,500',
      '₹9,800',
      '₹4,200',
      '₹11,000',
      '₹16,500',
      '₹7,300',
      '₹5,900'
    ][i],
    'date': [
      '2024-01-${15 + i}',
      '2024-01-${14 + i}',
      '2024-01-${13 + i}',
      '2024-01-${12 + i}',
      '2024-01-${11 + i}',
      '2024-01-${10 + i}',
      '2024-01-${9 + i}',
      '2024-01-${8 + i}',
      '2024-01-${7 + i}',
      '2024-01-${6 + i}',
      '2024-01-${5 + i}',
      '2024-01-${4 + i}',
      '2024-01-${3 + i}',
      '2024-01-${2 + i}',
      '2024-01-${1 + i}'
    ][i],
    'paymentMethod': [
      'Debt',
      'Bank',
      'Cash',
      'Bank',
      'Debt',
      'Cash',
      'Bank',
      'Bank',
      'Cash',
      'Debt',
      'Cash',
      'Bank',
      'Debt',
      'Cash',
      'Cash'
    ][i],
  });

  // Add expense modal methods
  void _showAddExpenseModalMethod() {
    setState(() {
      _showAddExpenseModal = true;
    });
  }

  void _closeAddExpenseModal() {
    setState(() {
      _showAddExpenseModal = false;
    });
  }

  void _handleAddExpense(String title, String amount, String paymentMethod) {
    setState(() {
      _recentExpenses.insert(0, {
        'title': title,
        'amount': amount.startsWith('₹') ? amount : '₹$amount',
        'date': DateTime.now().toString().split(' ')[0],
        'paymentMethod': paymentMethod,
      });
    });
    print('Added new expense: $title, $amount, $paymentMethod');
  }

  // Edit expense modal methods
  void _showEditExpenseModalMethod(Map<String, String> item) {
    setState(() {
      _editingItem = item;
      _showEditExpenseModal = true;
    });
  }

  void _closeEditExpenseModal() {
    setState(() {
      _showEditExpenseModal = false;
      _editingItem = null;
    });
  }

  void _handleEditExpense(String title, String amount, String paymentMethod) {
    if (_editingItem != null) {
      final index = _recentExpenses.indexOf(_editingItem!);
      if (index != -1) {
        setState(() {
          _recentExpenses[index] = {
            'title': title,
            'amount': amount.startsWith('₹') ? amount : '₹$amount',
            'date': _editingItem!['date']!, // Keep original date
            'paymentMethod': paymentMethod,
          };
        });
      }
      print('Updated expense: $title, $amount, $paymentMethod');
    }
  }

  void _handleDeleteItem(Map<String, String> item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Item'),
          content: Text('Are you sure you want to delete ${item['title']}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _recentExpenses.remove(item);
                });
                Navigator.of(context).pop();
                print('Deleted item: ${item['title']}');
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  List<TableColumn> get _columns {
    switch (_tab) {
      case 0: // Recent Expenses
        return [
          TableColumn('Title', flex: 3),
          TableColumn('Amount', flex: 2),
          TableColumn('Date', flex: 2),
          TableColumn('Payment Method', flex: 2),
          TableColumn('Action', flex: 2),
        ];
      case 1: // Profit & Loss - not used as we have custom layout
        return [];
      default:
        return [];
    }
  }

  List<String> _getRowData(Map<String, String> item) {
    switch (_tab) {
      case 0: // Recent Expenses
        return [
          item['title']!,
          item['amount']!,
          item['date']!,
          item['paymentMethod']!,
          ''
        ];
      default:
        return [];
    }
  }

  List<Map<String, String>> get _currentData {
    switch (_tab) {
      case 0:
        return _recentExpenses;
      case 1:
        return []; // Not used for P&L
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final rows = _currentData;

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
              // Tabs
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Row(
                  children: [
                    _TabButton(
                      label: 'Expense Management',
                      selected: _tab == 0,
                      onTap: () => setState(() {
                        _tab = 0;
                      }),
                      position: TabPosition.left,
                    ),
                    Container(
                      width: 1,
                      height: 44,
                      color: goldenColor1,
                    ),
                    _TabButton(
                      label: 'Profit & Loss',
                      selected: _tab == 1,
                      onTap: () => setState(() {
                        _tab = 1;
                      }),
                      position: TabPosition.right,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  _tab == 0 ? "Recent Expenses" : "Profit & Loss Statement",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _tab == 0 
                  ? _buildTable(rows)
                  : _buildProfitLossStatement(),
              ),
            ],
          ),
        ),
        // Add New Expense Modal
        if (_showAddExpenseModal)
          AddExpenseModal(
            onClose: _closeAddExpenseModal,
            onSave: _handleAddExpense,
          ),
        // Edit Expense Modal
        if (_showEditExpenseModal)
          AddExpenseModal(
            onClose: _closeEditExpenseModal,
            onSave: _handleEditExpense,
            isEditMode: true,
            initialTitle: _editingItem?['title'],
            initialAmount: _editingItem?['amount']?.replaceAll('₹', ''),
            initialPaymentMethod: _editingItem?['paymentMethod'],
          ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          const Text('Financial Management', style: TextStyle(color: Colors.black, fontSize: 32, fontWeight: FontWeight.w700)),
          const Spacer(),
          SizedBox(
            height: 42,
            child: GradientButton(
              height: 32,
              text: "Add New Expense",
              icon: Icons.add,
              onPressed: _showAddExpenseModalMethod,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfitLossStatement() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Revenue Section
              _buildSectionHeader('Revenue'),
              const SizedBox(height: 12),
              _buildPLRow('Total Sales Revenue', '₹2,50,000', false),
              _buildDivider(),
              
              // Cost of Goods Sold Section
              _buildSectionHeader('Cost of Goods Sold'),
              const SizedBox(height: 12),
              _buildPLRow('Kitchen/Ingredients Cost', '₹85,000', true),
              _buildDivider(),
              
              // Gross Profit
              _buildPLRow('Gross Profit', '₹1,65,000', true, isTotal: true),
              _buildDivider(),
              
              // Operating Expenses Section
              _buildSectionHeader('Operating Expenses'),
              const SizedBox(height: 12),
              _buildPLRow('Utilities', '₹15,000', true),
              _buildPLRow('Salaries', '₹45,000', true),
              _buildPLRow('Maintenance', '₹8,500', true),
              _buildDivider(),
              
              // Total Operating Expenses
              _buildPLRow('Total Operating Expenses', '₹68,500', true, isTotal: true),
              _buildDivider(),
              
              // Tax Section
              _buildSectionHeader('Total Tax'),
              const SizedBox(height: 12),
              _buildPLRow('16% GST', '₹15,440', true),
              _buildDivider(),
              
              // Net Profit
              _buildPLRow('Net Profit', '₹81,060', false, isProfit: true, isTotal: true),
              const SizedBox(height: 8),
              _buildPLRow('Profit Margin', '32.4%', false, isProfit: true, isPercentage: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
    );
  }

  Widget _buildPLRow(String label, String amount, bool isExpense, {bool isTotal = false, bool isProfit = false, bool isPercentage = false}) {
    Color amountColor;
    if (isProfit) {
      amountColor = Colors.green;
    } else if (isExpense) {
      amountColor = Colors.red;
    } else {
      amountColor = Colors.black;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
              color: amountColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      height: 1,
      color: Colors.grey[300],
    );
  }

  Widget _buildTable(List<Map<String, String>> items) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _buildTableHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: items.map((item) => _buildTableRow(item)).toList(),
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

  Widget _buildTableRow(Map<String, String> item) {
    final rowData = _getRowData(item);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: List.generate(_columns.length, (i) => 
          Expanded(
            flex: _columns[i].flex,
            child: _buildTableCell(i, rowData, item),
          ),
        ),
      ),
    );
  }

  Widget _buildTableCell(int index, List<String> rowData, Map<String, String> item) {
    // Handle action columns
    if (index == _columns.length - 1) {
      return _buildInventoryActionButtons(item);
    }

    // Regular text cell
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        rowData[index],
        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildInventoryActionButtons(Map<String, String> item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => _showEditExpenseModalMethod(item),
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(Icons.edit_outlined, color: Color(0xFFc89849), size: 18),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () => _handleDeleteItem(item),
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(Icons.delete_outline, color: Colors.red, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

enum TabPosition { left, middle, right }

class _TabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final TabPosition position;

  const _TabButton({
    Key? key,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.position,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            gradient: selected
                ? LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [goldenColor2, goldenColor1, goldenColor2],
                  )
                : null,
            color: selected ? null : Colors.white,
            borderRadius: _getBorderRadius(),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 17,
              ),
            ),
          ),
        ),
      ),
    );
  }

  BorderRadius _getBorderRadius() {
    switch (position) {
      case TabPosition.left:
        return const BorderRadius.only(
          topLeft: Radius.circular(22),
          bottomLeft: Radius.circular(22),
        );
      case TabPosition.right:
        return const BorderRadius.only(
          topRight: Radius.circular(22),
          bottomRight: Radius.circular(22),
        );
      case TabPosition.middle:
        return BorderRadius.zero;
    }
  }
}

class TableColumn {
  final String title;
  final int flex;
  const TableColumn(this.title, {required this.flex});
}