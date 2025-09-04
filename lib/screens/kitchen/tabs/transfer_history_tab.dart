import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khaabd_web/controller/getx_controllers/kitchen_controller.dart';
import 'package:khaabd_web/models/models/kitchen_models/get_kitchen_transfer_history_model.dart';

class TransferHistoryTab extends StatelessWidget {
  final KitchenController kitchenController;
  final Function(dynamic) onDeleteItem;

  const TransferHistoryTab({
    Key? key,
    required this.kitchenController,
    required this.onDeleteItem,
  }) : super(key: key);

  final List<TableColumn> _columns = const [
    TableColumn('Transfer Date', flex: 2),
    TableColumn('Item Name', flex: 3),
    TableColumn('Quantity', flex: 2),
    TableColumn('From', flex: 2),
    TableColumn('To Section', flex: 2),
  ];

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

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
          if (kitchenController.transferHistory.isNotEmpty) _buildPagination(),
        ],
      ),
    ));
  }

  Widget _buildTableContent() {
    if (kitchenController.isLoadingTransferHistory.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (kitchenController.transferHistory.isEmpty) {
      return const Center(
        child: Text(
          'No transfer history found',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: kitchenController.transferHistory.map((item) => _buildTransferHistoryRow(item)).toList(),
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

  Widget _buildTransferHistoryRow(History item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                _formatDate(item.createdAt),
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
                item.itemName,
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
                '${item.quantity} ${item.measuringUnit}',
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
                item.from,
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
                item.to,
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
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
                onPressed: kitchenController.transferHasPrev.value
                    ? () => kitchenController.loadPreviousTransferPage()
                    : null,
              ),
              Text(
                'Page ${kitchenController.transferCurrentPage.value} of ${kitchenController.transferTotalPages.value}',
                style: const TextStyle(fontSize: 14),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: kitchenController.transferHasNext.value
                    ? () => kitchenController.loadNextTransferPage()
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