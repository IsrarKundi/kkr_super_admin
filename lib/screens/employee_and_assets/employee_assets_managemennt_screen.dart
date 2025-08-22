import 'package:flutter/material.dart';
import 'package:khaabd_web/screens/employee_and_assets/add_attendance.dart';
import 'package:khaabd_web/screens/employee_and_assets/add_new_employee.dart';
import 'package:khaabd_web/screens/store/add_purchase.dart';
import 'package:khaabd_web/screens/widgets/dashboard_header.dart';
import 'package:khaabd_web/screens/store/transfer_to_kitchen.dart';
import 'package:khaabd_web/utils/colors.dart';
import 'package:khaabd_web/widgets/gradient_button.dart';

class EmployeeAssetsManagementScreen extends StatefulWidget {
  final void Function(Map<String, dynamic>)? onShowDetail;
  const EmployeeAssetsManagementScreen({Key? key, this.onShowDetail}) : super(key: key);

  @override
  State<EmployeeAssetsManagementScreen> createState() => _EmployeeAssetsManagementScreenState();
}

class _EmployeeAssetsManagementScreenState extends State<EmployeeAssetsManagementScreen> {
  int _tab = 0;
  bool _showDetails = false;
  bool _showTransferModal = false;
  bool _showPurchaseModal = false;
  bool _showEmployeeModal = false;
  bool _showAttendanceModal = false;
  Map<String, String>? _selectedItem;
  Map<String, String>? _editingItem;
  Map<String, String>? _editingEmployee;
  Map<String, String>? _editingAttendance;

  // Mock data for Employees
  List<Map<String, String>> _employees = List.generate(15, (i) => {
    'fullName': ['Ahmed Ali', 'Fatima Khan', 'Muhammad Hassan', 'Ayesha Malik', 'Omar Sheikh', 'Zainab Ahmed', 'Ali Raza', 'Sara Qureshi', 'Hassan Mahmood', 'Mariam Siddique', 'Usman Tariq', 'Nadia Iqbal', 'Bilal Ahmad', 'Hina Bashir', 'Faisal Javed'][i],
    'role': ['Chef', 'Waiter', 'Kitchen Helper', 'Cashier', 'Manager', 'Cleaner', 'Cook', 'Waiter', 'Kitchen Helper', 'Cashier', 'Security', 'Waiter', 'Cook', 'Cleaner', 'Delivery Boy'][i],
    'phoneNo': ['0300-1234567', '0301-2345678', '0302-3456789', '0303-4567890', '0304-5678901', '0305-6789012', '0306-7890123', '0307-8901234', '0308-9012345', '0309-0123456', '0310-1234567', '0311-2345678', '0312-3456789', '0313-4567890', '0314-5678901'][i],
    'cnic': ['12345-6789012-3', '23456-7890123-4', '34567-8901234-5', '45678-9012345-6', '56789-0123456-7', '67890-1234567-8', '78901-2345678-9', '89012-3456789-0', '90123-4567890-1', '01234-5678901-2', '12345-6789012-3', '23456-7890123-4', '34567-8901234-5', '45678-9012345-6', '56789-0123456-7'][i],
    'salary': ['₹25,000', '₹18,000', '₹15,000', '₹20,000', '₹35,000', '₹12,000', '₹22,000', '₹18,000', '₹15,000', '₹20,000', '₹16,000', '₹18,000', '₹22,000', '₹12,000', '₹14,000'][i],
    'joiningDate': ['2023-01-15', '2023-02-20', '2023-03-10', '2023-04-05', '2022-12-01', '2023-05-12', '2023-01-25', '2023-03-18', '2023-04-22', '2023-02-14', '2023-06-01', '2023-03-30', '2023-01-08', '2023-05-20', '2023-04-15'][i],
  });

  // Mock data for Attendance
  List<Map<String, String>> _attendance = List.generate(12, (i) => {
    'employee': ['Ahmed Ali', 'Fatima Khan', 'Muhammad Hassan', 'Ayesha Malik', 'Omar Sheikh', 'Zainab Ahmed', 'Ali Raza', 'Sara Qureshi', 'Hassan Mahmood', 'Mariam Siddique', 'Usman Tariq', 'Nadia Iqbal'][i],
    'presentDays': ['22', '20', '25', '18', '24', '21', '23', '19', '26', '22', '20', '24'][i],
    'absentDays': ['3', '5', '0', '7', '1', '4', '2', '6', '0', '3', '5', '1'][i],
    'leaveDays': ['2', '2', '3', '1', '2', '2', '3', '2', '1', '2', '2', '2'][i],
    'publicHolidays': ['3', '3', '2', '4', '3', '3', '2', '3', '3', '3', '3', '3'][i],
    'total': ['30', '30', '30', '30', '30', '30', '30', '30', '30', '30', '30', '30'][i],
    'date': ['2024-01-31', '2024-01-31', '2024-01-31', '2024-01-31', '2024-01-31', '2024-01-31', '2024-01-31', '2024-01-31', '2024-01-31', '2024-01-31', '2024-01-31', '2024-01-31'][i],
  });

  // Mock data for Salary
  final List<Map<String, String>> _salary = List.generate(8, (i) => {
    'employee': ['Ahmed Ali', 'Fatima Khan', 'Muhammad Hassan', 'Ayesha Malik', 'Omar Sheikh', 'Zainab Ahmed', 'Ali Raza', 'Sara Qureshi'][i],
    'reason': ['Monthly Salary', 'Overtime Payment', 'Bonus', 'Monthly Salary', 'Performance Bonus', 'Monthly Salary', 'Overtime Payment', 'Monthly Salary'][i],
    'amount': ['₹25,000', '₹3,000', '₹5,000', '₹20,000', '₹4,000', '₹12,000', '₹2,500', '₹18,000'][i],
  });

  // Mock data for Assets
  final List<Map<String, String>> _assets = List.generate(10, (i) => {
    'assetName': ['Laptop Dell XPS', 'Office Chair', 'Desktop Computer', 'Printer HP LaserJet', 'Mobile Phone', 'Tablet iPad', 'Monitor Samsung', 'Keyboard Wireless', 'Mouse Optical', 'Headphones Sony'][i],
    'type': ['Electronics', 'Furniture', 'Electronics', 'Electronics', 'Electronics', 'Electronics', 'Electronics', 'Electronics', 'Electronics', 'Electronics'][i],
    'purchaseValue': ['₹85,000', '₹12,000', '₹45,000', '₹25,000', '₹35,000', '₹55,000', '₹18,000', '₹3,500', '₹2,000', '₹8,000'][i],
    'assignment': ['Ahmed Ali', 'Fatima Khan', 'Muhammad Hassan', 'Ayesha Malik', 'Omar Sheikh', 'Zainab Ahmed', 'Ali Raza', 'Sara Qureshi', 'Hassan Mahmood', 'Mariam Siddique'][i],
  });

  // Employee modal methods
  void _showAddEmployeeModal() {
    setState(() {
      _editingEmployee = null;
      _showEmployeeModal = true;
    });
  }

  void _showEditEmployeeModal(Map<String, String> employee) {
    setState(() {
      _editingEmployee = employee;
      _showEmployeeModal = true;
    });
  }

  void _closeEmployeeModal() {
    setState(() {
      _showEmployeeModal = false;
      _editingEmployee = null;
    });
  }

  void _handleEmployeeSave(String fullName, String phoneNo, String cnic, String role, String salary, String joiningDate) {
    if (_editingEmployee != null) {
      // Update existing employee
      setState(() {
        int index = _employees.indexOf(_editingEmployee!);
        if (index != -1) {
          _employees[index] = {
            'fullName': fullName,
            'phoneNo': phoneNo,
            'cnic': cnic,
            'role': role,
            'salary': '₹$salary',
            'joiningDate': joiningDate,
          };
        }
      });
      print('Updated employee: $fullName');
    } else {
      // Add new employee
      setState(() {
        _employees.add({
          'fullName': fullName,
          'phoneNo': phoneNo,
          'cnic': cnic,
          'role': role,
          'salary': '₹$salary',
          'joiningDate': joiningDate,
        });
      });
      print('Added new employee: $fullName');
    }
  }

  // Attendance modal methods
  void _showAddAttendanceModal() {
    setState(() {
      _editingAttendance = null;
      _showAttendanceModal = true;
    });
  }

  void _showEditAttendanceModal(Map<String, String> attendance) {
    setState(() {
      _editingAttendance = attendance;
      _showAttendanceModal = true;
    });
  }

  void _closeAttendanceModal() {
    setState(() {
      _showAttendanceModal = false;
      _editingAttendance = null;
    });
  }

  void _handleAttendanceSave(String month, String year, String publicHolidays, List<Map<String, String>> attendanceData) {
    if (_editingAttendance != null) {
      // Update existing attendance (single employee)
      setState(() {
        int index = _attendance.indexWhere((item) => item['employee'] == _editingAttendance!['employee']);
        if (index != -1 && attendanceData.isNotEmpty) {
          _attendance[index] = attendanceData.first;
        }
      });
      print('Updated attendance for: ${_editingAttendance!['employee']}');
    } else {
      // Add new attendance entries
      setState(() {
        _attendance.addAll(attendanceData);
      });
      print('Added attendance entries for $month $year');
    }
  }

  // Transfer modal methods
  void _showTransferToKitchenModal() {
    setState(() {
      _showTransferModal = true;
    });
  }

  void _closeTransferModal() {
    setState(() {
      _showTransferModal = false;
    });
  }

  void _handleTransfer(String item, String quantity, String section) {
    print('Transferring $quantity of $item to $section section');
    // Add your transfer logic here
  }

  // Purchase modal methods
  void _showAddPurchaseModal() {
    setState(() {
      _editingItem = null;
      _showPurchaseModal = true;
    });
  }

  void _showEditPurchaseModal(Map<String, String> item) {
    setState(() {
      _editingItem = item;
      _showPurchaseModal = true;
    });
  }

  void _closePurchaseModal() {
    setState(() {
      _showPurchaseModal = false;
      _editingItem = null;
    });
  }

  void _handlePurchaseSave(String itemName, String supplierName, String quantity, String measuring, String category, String pricePerUnit, String paymentMethod) {
    if (_editingItem != null) {
      print('Updating purchase: $itemName, $supplierName, $quantity $measuring, $category, $pricePerUnit, $paymentMethod');
    } else {
      print('Adding new purchase: $itemName, $supplierName, $quantity $measuring, $category, $pricePerUnit, $paymentMethod');
    }
  }

  void _handleDeleteItem(Map<String, String> item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Item'),
          content: Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  if (_tab == 0) {
                    _employees.remove(item);
                  } else if (_tab == 1) {
                    _attendance.remove(item);
                  } else {
                    _currentData.remove(item);
                  }
                });
                Navigator.of(context).pop();
                print('Deleted item');
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
      case 0: // Employees
        return [
          TableColumn('Full Name', flex: 3),
          TableColumn('Role', flex: 2),
          TableColumn('Phone No.', flex: 2),
          TableColumn('CNIC', flex: 2),
          TableColumn('Salary', flex: 2),
          TableColumn('Joining Date', flex: 3),
          TableColumn('Action', flex: 2),
        ];
      case 1: // Attendance
        return [
          TableColumn('Employee', flex: 2),
          TableColumn('Present Days', flex: 2),
          TableColumn('Absent Days', flex: 2),
          TableColumn('Leave Days', flex: 2),
          TableColumn('Public Holidays', flex: 2),
          TableColumn('Total', flex: 2),
          TableColumn('Date', flex: 2),
          TableColumn('Action', flex: 2),
        ];
      case 2: // Salary
        return [
          TableColumn('Employee', flex: 2),
          TableColumn('Reason', flex: 3),
          TableColumn('Amount', flex: 2),
          TableColumn('Action', flex: 2),
        ];
      case 3: // Assets
        return [
          TableColumn('Asset Name', flex: 3),
          TableColumn('Type', flex: 2),
          TableColumn("Purchase Value", flex: 2),
          TableColumn('Assignment', flex: 2),
          TableColumn('Action', flex: 2),
        ];
      default:
        return [];
    }
  }

  List<String> _getRowData(Map<String, String> item) {
    switch (_tab) {
      case 0: // Employees
        return [
          item['fullName']!,
          item['role']!,
          item['phoneNo']!,
          item['cnic']!,
          item['salary']!,
          item['joiningDate']!,
          ''
        ];
      case 1: // Attendance
        return [
          item['employee']!,
          item['presentDays']!,
          item['absentDays']!,
          item['leaveDays']!,
          item['publicHolidays']!,
          item['total']!,
          item['date']!,
          ''
        ];
      case 2: // Salary
        return [
          item['employee']!,
          item['reason']!,
          item['amount']!,
          ''
        ];
      case 3: // Assets
        return [
          item['assetName']!,
          item['type']!,
          item['purchaseValue']!,
          item['assignment']!,
          ''
        ];
      default:
        return [];
    }
  }

  List<Map<String, String>> get _currentData {
    switch (_tab) {
      case 0:
        return _employees;
      case 1:
        return _attendance;
      case 2:
        return _salary;
      case 3:
        return _assets;
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
                      label: 'Employees',
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
                      label: 'Attendance',
                      selected: _tab == 1,
                      onTap: () => setState(() {
                        _tab = 1;
                      }),
                      position: TabPosition.middle,
                    ),
                    Container(
                      width: 1,
                      height: 44,
                      color: goldenColor1,
                    ),
                    _TabButton(
                      label: 'Salary',
                      selected: _tab == 2,
                      onTap: () => setState(() {
                        _tab = 2;
                      }),
                      position: TabPosition.middle,
                    ),
                    Container(
                      width: 1,
                      height: 44,
                      color: goldenColor1,
                    ),
                    _TabButton(
                      label: 'Assets',
                      selected: _tab == 3,
                      onTap: () => setState(() {
                        _tab = 3;
                      }),
                      position: TabPosition.right,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(child: _buildTable(rows)),
            ],
          ),
        ),
        // Add Employee Modal
        if (_showEmployeeModal)
          AddEmployeeModal(
            onClose: _closeEmployeeModal,
            onSave: _handleEmployeeSave,
            isEditMode: _editingEmployee != null,
            initialFullName: _editingEmployee?['fullName'],
            initialPhoneNo: _editingEmployee?['phoneNo'],
            initialCnic: _editingEmployee?['cnic'],
            initialRole: _editingEmployee?['role'],
            initialSalary: _editingEmployee?['salary'],
            initialJoiningDate: _editingEmployee?['joiningDate'],
          ),
        // Add Attendance Modal
        if (_showAttendanceModal)
          AddAttendanceModal(
            onClose: _closeAttendanceModal,
            onSave: _handleAttendanceSave,
            employees: _employees,
            isEditMode: _editingAttendance != null,
            editingEmployee: _editingAttendance != null ? 
              _employees.firstWhere((emp) => emp['fullName'] == _editingAttendance!['employee'], 
                orElse: () => {}) : null,
            initialMonth: _editingAttendance != null ? 
              ['January', 'February', 'March', 'April', 'May', 'June',
               'July', 'August', 'September', 'October', 'November', 'December']
              [DateTime.parse(_editingAttendance!['date']!).month - 1] : null,
            initialYear: _editingAttendance?['date']?.split('-')[0],
            initialPublicHolidays: _editingAttendance?['publicHolidays'],
          ),
        // Transfer to Kitchen Modal
        if (_showTransferModal)
          TransferToKitchenModal(
            onClose: _closeTransferModal,
            onTransfer: _handleTransfer,
          ),
        // Add/Edit Purchase Modal
        if (_showPurchaseModal)
          AddPurchaseModal(
            onClose: _closePurchaseModal,
            onSave: _handlePurchaseSave,
            isEditMode: _editingItem != null,
            initialItemName: _editingItem?['itemName'],
            initialSupplierName: _editingItem?['supplier'],
            initialQuantity: _editingItem?['quantity']?.replaceAll(RegExp(r'[^0-9]'), ''),
            initialMeasuring: _editingItem?['measuring'],
            initialCategory: _editingItem?['category'],
            initialPricePerUnit: _editingItem?['unitCost']?.replaceAll('₹', ''),
            initialPaymentMethod: _editingItem?['paymentMethod'],
          ),
      ],
    );
  }

  Widget _buildHeader() {
    String headerTitle = '';
    switch (_tab) {
      case 0:
        headerTitle = 'Employee Management';
        break;
      case 1:
        headerTitle = 'Attendance Management';
        break;
      case 2:
        headerTitle = 'Salary Management';
        break;
      case 3:
        headerTitle = 'Assets Management';
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          Text(headerTitle, style: TextStyle(color: Colors.black, fontSize: 32, fontWeight: FontWeight.w700)),
          const Spacer(),
          if (_tab == 0) // Employee tab
            GradientButton(
              text: "Add New Employee",
              icon: Icons.add,
              onPressed: _showAddEmployeeModal,
            ),
          if (_tab == 1) // Attendance tab
            GradientButton(
              text: "Add Attendance",
              icon: Icons.add,
              onPressed: _showAddAttendanceModal,
            ),
          if (_tab == 2) // Salary tab
            Row(
              children: [
                GradientButton(
                  text: "Add Advance",
                  icon: Icons.add,
                  onPressed: () {},
                ),
                const SizedBox(width: 16),
                GradientButton(
                  text: "Generate Salaries",
                  icon: Icons.add,
                  onPressed: () {},
                ),
              ],
            ),
          if (_tab == 3) // Assets tab
            GradientButton(
              text: "Add New Asset",
              icon: Icons.add,
              onPressed: () {},
            ),
        ],
      ),
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
              if (col.title.isNotEmpty && col.title != 'Action') const Icon(Icons.arrow_drop_down, color: Colors.white, size: 20),
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
    if ((_tab == 0 || _tab == 1 || _tab == 2 || _tab == 3) && index == _columns.length - 1) {
      return _buildActionButtons(item);
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

  Widget _buildActionButtons(Map<String, String> item) {
    if (_tab == 2) { // Salary tab
      return Padding(
        padding: const EdgeInsets.only(right: 110),
        child: SizedBox(
          height: 32,
          child: GradientButton(
            borderRadius: 10,
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            text: "Make Payment",
            onPressed: () {},
            height: 32,
          ),
        ),
      );
    } else {
      // Edit and Delete buttons for other tabs
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                if (_tab == 0) {
                  _showEditEmployeeModal(item);
                } else if (_tab == 1) {
                  _showEditAttendanceModal(item);
                } else {
                  _showEditPurchaseModal(item);
                }
              },
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