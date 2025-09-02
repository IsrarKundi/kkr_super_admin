import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:khaabd_web/controller/getx_controllers/store_controller.dart';
import 'package:khaabd_web/models/models/store_models/get_inventory_model.dart';

class CurrentInventoryTab extends StatelessWidget {
  final StoreController storeController;
  final Function(CurrentInventory) onEdit;
  final Function(CurrentInventory) onDelete;

  const CurrentInventoryTab({
    Key? key,
    required this.storeController,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  String _formatCurrency(int amount) {
    return 'RS ${amount.toString()}';
  }

  List<TableColumn> get _columns => [
    TableColumn('Item Name', flex: 3),
    TableColumn('Category', flex: 2),
    TableColumn('Quantity', flex: 2),
    TableColumn('Total Price', flex: 2),
    TableColumn('Unit Cost', flex: 2),
    TableColumn('Status', flex: 2),
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
          if (storeController.currentInventory.isNotEmpty) _buildPagination(),
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
    if (storeController.isLoadingInventory.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (storeController.currentInventory.isEmpty) {
      return const Center(
        child: Text(
          'No inventory data found',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: storeController.currentInventory.map((item) => _buildInventoryRow(item)).toList(),
      ),
    );
  }

  Widget _buildInventoryRow(CurrentInventory item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                item.name,
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
                item.category,
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
                '${item.currentStock} ${item.measuringUnit}',
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
                _formatCurrency(item.totalValue),
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
                _formatCurrency(item.pricePerUnit),
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
                item.status,
                style: TextStyle(
                  color: item.status.toLowerCase() == 'in-stock' ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: _buildActionButtons(item),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(CurrentInventory item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => onEdit(item),
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: SvgPicture.asset('assets/svgs/edit_icon.svg', width: 18, height: 18),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () => onDelete(item),
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: SvgPicture.asset('assets/svgs/delete_icon.svg', width: 18, height: 18),
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
                onPressed: storeController.inventoryHasPrev.value
                    ? () => storeController.loadPreviousInventoryPage()
                    : null,
              ),
              Text(
                'Page ${storeController.inventoryCurrentPage.value} of ${storeController.inventoryTotalPages.value}',
                style: const TextStyle(fontSize: 14),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: storeController.inventoryHasNext.value
                    ? () => storeController.loadNextInventoryPage()
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