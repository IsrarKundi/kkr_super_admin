import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khaabd_web/controller/getx_controllers/store_controller.dart';
import 'package:khaabd_web/models/models/store_models/get_supplier_ledger_model.dart';
import 'package:khaabd_web/widgets/gradient_button.dart';

class SupplierLedgerTab extends StatelessWidget {
  final StoreController storeController;
  final Function(Ledger)? onMakePayment;

  const SupplierLedgerTab({
    Key? key,
    required this.storeController,
    this.onMakePayment,
  }) : super(key: key);

  String _formatCurrency(int amount) {
    return 'RS ${amount.toString()}';
  }

  Color _getAmountColor(int amount) {
    // If amount is negative, show green (credit/money owed to us)
    // If amount is positive, show red (debt/money we owe)
    return amount < 0 ? Colors.green : Colors.red;
  }

  List<TableColumn> get _columns => [
    TableColumn('Supplier Name', flex: 4),
    TableColumn('Total Outstanding', flex: 3),
    TableColumn('Action', flex: 2),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _buildTableHeader(),
          Expanded(
            child: _buildTableContent(),
          ),
          if (storeController.supplierLedger.isNotEmpty) _buildPagination(),
        ],
      ),
    ));
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

  Widget _buildTableContent() {
    if (storeController.isLoadingSupplierLedger.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (storeController.supplierLedger.isEmpty) {
      return const Center(
        child: Text(
          'No supplier ledger data found',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: storeController.supplierLedger.map((item) => _buildSupplierLedgerRow(item)).toList(),
      ),
    );
  }

  Widget _buildSupplierLedgerRow(Ledger item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                item.supplierName,
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                _formatCurrency(item.totalOutstanding),
                style: TextStyle(
                  color: _getAmountColor(item.totalOutstanding),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: _buildActionButton(item),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(Ledger item) {
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
          onPressed: () {
            if (onMakePayment != null) {
              onMakePayment!(item);
            }
          },
          height: 32,
        ),
      ),
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
                onPressed: storeController.supplierHasPrev.value
                    ? () => storeController.loadPreviousSupplierPage()
                    : null,
              ),
              Text(
                'Page ${storeController.supplierCurrentPage.value} of ${storeController.supplierTotalPages.value}',
                style: const TextStyle(fontSize: 14),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: storeController.supplierHasNext.value
                    ? () => storeController.loadNextSupplierPage()
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