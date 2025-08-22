import 'package:flutter/material.dart';
import 'package:khaabd_web/widgets/custom_textfield.dart';
import 'package:khaabd_web/widgets/gradient_button.dart';
import 'package:khaabd_web/widgets/outlined_button.dart';

class AddAttendanceModal extends StatefulWidget {
  final VoidCallback onClose;
  final Function(String month, String year, String publicHolidays,
      List<Map<String, String>> attendanceData) onSave;
  final List<Map<String, String>> employees;
  // Optional parameters for editing existing attendance
  final String? initialMonth;
  final String? initialYear;
  final String? initialPublicHolidays;
  final Map<String, String>? editingEmployee; // If editing single employee
  final bool isEditMode;

  const AddAttendanceModal({
    Key? key,
    required this.onClose,
    required this.onSave,
    required this.employees,
    this.initialMonth,
    this.initialYear,
    this.initialPublicHolidays,
    this.editingEmployee,
    this.isEditMode = false,
  }) : super(key: key);

  @override
  State<AddAttendanceModal> createState() => _AddAttendanceModalState();
}

class _AddAttendanceModalState extends State<AddAttendanceModal> {
  final TextEditingController _publicHolidaysController =
      TextEditingController();

  String _selectedMonth = 'Select Month';
  String _selectedYear = 'Select Year';
  bool _showMonthDropdown = false;
  bool _showYearDropdown = false;

  final List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  final List<String> _years = List.generate(
      10, (index) => (DateTime.now().year - 5 + index).toString());

  List<Map<String, String>> _attendanceData = [];
  Map<String, TextEditingController> _presentDaysControllers = {};
  Map<String, TextEditingController> _absentDaysControllers = {};
  Map<String, TextEditingController> _leaveDaysControllers = {};

  @override
  void initState() {
    super.initState();

    // Pre-fill fields if in edit mode
    if (widget.isEditMode) {
      _selectedMonth = widget.initialMonth ?? 'Select Month';
      _selectedYear = widget.initialYear ?? 'Select Year';
      _publicHolidaysController.text = widget.initialPublicHolidays ?? '0';
    } else {
      // Set current month and year for new attendance
      _selectedMonth = _months[DateTime.now().month - 1];
      _selectedYear = DateTime.now().year.toString();
      _publicHolidaysController.text = '0';
    }

    // Initialize attendance data
    _initializeAttendanceData();
  }

  void _initializeAttendanceData() {
    if (widget.editingEmployee != null) {
      // Edit mode - single employee
      _attendanceData = [widget.editingEmployee!];
    } else {
      // Add mode - all employees
      _attendanceData = List.from(widget.employees);
    }

    // Initialize controllers for each employee
    for (var employee in _attendanceData) {
      String employeeName = employee['fullName'] ?? '';
      _presentDaysControllers[employeeName] = TextEditingController();
      _absentDaysControllers[employeeName] = TextEditingController();
      _leaveDaysControllers[employeeName] = TextEditingController();
    }
  }

  @override
  void dispose() {
    _publicHolidaysController.dispose();
    _presentDaysControllers.values
        .forEach((controller) => controller.dispose());
    _absentDaysControllers.values.forEach((controller) => controller.dispose());
    _leaveDaysControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  int get _totalDaysInMonth {
    if (_selectedMonth == 'Select Month' || _selectedYear == 'Select Year')
      return 0;

    int monthIndex = _months.indexOf(_selectedMonth) + 1;
    int year = int.parse(_selectedYear);
    return DateTime(year, monthIndex + 1, 0).day;
  }

  int get _workingDays {
    int publicHolidays = int.tryParse(_publicHolidaysController.text) ?? 0;
    return _totalDaysInMonth - publicHolidays;
  }

  int _getTotalDaysForEmployee(String employeeName) {
    int presentDays =
        int.tryParse(_presentDaysControllers[employeeName]?.text ?? '0') ?? 0;
    int absentDays =
        int.tryParse(_absentDaysControllers[employeeName]?.text ?? '0') ?? 0;
    int leaveDays =
        int.tryParse(_leaveDaysControllers[employeeName]?.text ?? '0') ?? 0;
    return presentDays + absentDays + leaveDays;
  }

  void _handleSave() {
    if (_selectedMonth != 'Select Month' &&
        _selectedYear != 'Select Year' &&
        _publicHolidaysController.text.isNotEmpty) {
      List<Map<String, String>> attendanceEntries = [];

      for (var employee in _attendanceData) {
        String employeeName = employee['fullName'] ?? '';
        attendanceEntries.add({
          'employee': employeeName,
          'presentDays': _presentDaysControllers[employeeName]?.text ?? '0',
          'absentDays': _absentDaysControllers[employeeName]?.text ?? '0',
          'leaveDays': _leaveDaysControllers[employeeName]?.text ?? '0',
          'publicHolidays': _publicHolidaysController.text,
          'total': _totalDaysInMonth.toString(),
          'date':
              '$_selectedYear-${(_months.indexOf(_selectedMonth) + 1).toString().padLeft(2, '0')}-${_totalDaysInMonth.toString().padLeft(2, '0')}',
        });
      }

      widget.onSave(_selectedMonth, _selectedYear,
          _publicHolidaysController.text, attendanceEntries);
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
              if (_showMonthDropdown || _showYearDropdown) {
                setState(() {
                  _showMonthDropdown = false;
                  _showYearDropdown = false;
                });
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
              width: 800,
              height: 600,
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Spacer(),
                      Text(
                        widget.isEditMode
                            ? 'Edit Attendance Entry'
                            : 'Add Attendance Entry',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close,
                            color: Colors.red, size: 24),
                        onPressed: widget.onClose,
                        tooltip: 'Close',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Row of fields
                  Row(
                    children: [
                      // Month dropdown
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Month',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildMonthDropdown(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Year dropdown
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Year',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildYearDropdown(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Public holidays field
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Public Holidays',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            CustomTextField(
                              controller: _publicHolidaysController,
                              hintText: 'Enter number',
                              borderRadius: 8,
                              onChanged: (value) => setState(() {}),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Working days container
                      Container(
                        width: 120,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Total Days: $_totalDaysInMonth',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Working Days: $_workingDays',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Attendance table
                  Expanded(
                    child: _buildAttendanceTable(),
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
        // Dropdown overlays
        if (_showMonthDropdown) _buildMonthDropdownOverlay(),
        if (_showYearDropdown) _buildYearDropdownOverlay(),
      ],
    );
  }

  Widget _buildMonthDropdown() {
    return GestureDetector(
      onTap: () => setState(() {
        _showMonthDropdown = !_showMonthDropdown;
        _showYearDropdown = false;
      }),
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
                _selectedMonth,
                style: TextStyle(
                  color: _selectedMonth == 'Select Month'
                      ? Colors.grey[600]
                      : Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            Icon(
              _showMonthDropdown
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              color: Colors.grey[600],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYearDropdown() {
    return GestureDetector(
      onTap: () => setState(() {
        _showYearDropdown = !_showYearDropdown;
        _showMonthDropdown = false;
      }),
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
                _selectedYear,
                style: TextStyle(
                  color: _selectedYear == 'Select Year'
                      ? Colors.grey[600]
                      : Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            Icon(
              _showYearDropdown
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              color: Colors.grey[600],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthDropdownOverlay() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () => setState(() => _showMonthDropdown = false),
        child: Container(
          color: Colors.transparent,
          child: Center(
            child: Container(
              width: 800,
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                      height: 120), // Offset to position dropdown correctly
                  Row(
                    children: [
                      Expanded(
                        child: Material(
                          elevation: 8,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: Colors.grey[300]!, width: 1),
                            ),
                            child: Column(
                              children: _months
                                  .map(
                                    (month) => InkWell(
                                      onTap: () {
                                        setState(() {
                                          _selectedMonth = month;
                                          _showMonthDropdown = false;
                                        });
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 12),
                                        decoration: BoxDecoration(
                                          border: month != _months.last
                                              ? Border(
                                                  bottom: BorderSide(
                                                      color: Colors.grey[300]!,
                                                      width: 1))
                                              : null,
                                        ),
                                        child: Text(
                                          month,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(child: Container()),
                      const SizedBox(width: 16),
                      Expanded(child: Container()),
                      const SizedBox(width: 16),
                      Container(width: 120),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildYearDropdownOverlay() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () => setState(() => _showYearDropdown = false),
        child: Container(
          color: Colors.transparent,
          child: Center(
            child: Container(
              width: 800,
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                      height: 120), // Offset to position dropdown correctly
                  Row(
                    children: [
                      Expanded(child: Container()),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Material(
                          elevation: 8,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: Colors.grey[300]!, width: 1),
                            ),
                            child: Column(
                              children: _years
                                  .map(
                                    (year) => InkWell(
                                      onTap: () {
                                        setState(() {
                                          _selectedYear = year;
                                          _showYearDropdown = false;
                                        });
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 12),
                                        decoration: BoxDecoration(
                                          border: year != _years.last
                                              ? Border(
                                                  bottom: BorderSide(
                                                      color: Colors.grey[300]!,
                                                      width: 1))
                                              : null,
                                        ),
                                        child: Text(
                                          year,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(child: Container()),
                      const SizedBox(width: 16),
                      Container(width: 120),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Column(
        children: [
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Employee',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Present Days',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Absent Days',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Leave Days',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Total',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Table rows
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: _attendanceData
                    .map((employee) => _buildAttendanceRow(employee))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceRow(Map<String, String> employee) {
    String employeeName = employee['fullName'] ?? '';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Employee name
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                employeeName,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          // Present days input
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(right: 62),
              child: CustomTextField(
                controller: _presentDaysControllers[employeeName]!,
                hintText: '0',
                borderRadius: 6,
                onChanged: (value) => setState(() {}),
              ),
            ),
          ),
          // Absent days input
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(right: 62),
              child: CustomTextField(
                controller: _absentDaysControllers[employeeName]!,
                hintText: '0',
                borderRadius: 6,
                onChanged: (value) => setState(() {}),
              ),
            ),
          ),
          // Leave days input
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(right: 62),
              child: CustomTextField(
                controller: _leaveDaysControllers[employeeName]!,
                hintText: '0',
                borderRadius: 6,
                onChanged: (value) => setState(() {}),
              ),
            ),
          ),
          // Total display
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '${_getTotalDaysForEmployee(employeeName)}/$_totalDaysInMonth',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
