import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khaabd_web/screens/kitchen/edit_kitchen_inventory.dart';
import 'package:khaabd_web/utils/colors.dart';
import 'package:khaabd_web/controller/getx_controllers/kitchen_controller.dart';
import 'package:khaabd_web/models/models/kitchen_models/get_kitchen_inventory_model.dart';

class KitchenInventoryTab extends StatefulWidget {
  final KitchenController kitchenController;
  final Function(Map<String, String>) onEditItem;
  final Function(dynamic) onDeleteItem;
  final Function(String, String, String, String, String, String) onInventoryUpdate;

  const KitchenInventoryTab({
    Key? key,
    required this.kitchenController,
    required this.onEditItem,
    required this.onDeleteItem,
    required this.onInventoryUpdate,
  }) : super(key: key);

  @override
  State<KitchenInventoryTab> createState() => _KitchenInventoryTabState();
}

class _KitchenInventoryTabState extends State<KitchenInventoryTab> {
  bool _showEditInventoryModal = false;
  Map<String, String>? _editingItem;

  final List<TableColumn> _columns = [
    TableColumn('Item Name', flex: 3),
    TableColumn('Food Section', flex: 2),
    TableColumn('Quantity', flex: 2),
    TableColumn('Transfer Date', flex: 2),
    TableColumn('Status', flex: 2),
  ];

  void _showEditInventoryModalMethod(Map<String, String> item) {
    setState(() {
      _editingItem = item;
      _showEditInventoryModal = true;
    });
    widget.onEditItem(item);
  }

  void _closeEditInventoryModal() {
    setState(() {
      _showEditInventoryModal = false;
      _editingItem = null;
    });
  }

  void _handleInventoryUpdate(String itemName, String foodSection, String quantity, String measuring, String transferDate, String status) {
    widget.onInventoryUpdate(itemName, foodSection, quantity, measuring, transferDate, status);
    _closeEditInventoryModal();
  }

  
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
          if (widget.kitchenController.kitchenInventory.isNotEmpty) _buildPagination(),
        ],
      ),
    ));
  }

  Widget _buildTableContent() {
    if (widget.kitchenController.isLoadingKitchenInventory.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.kitchenController.kitchenInventory.isEmpty) {
      return const Center(
        child: Text(
          'No kitchen inventory found',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: widget.kitchenController.kitchenInventory.map((item) => _buildInventoryRow(item)).toList(),
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

  
  Widget _buildInventoryRow(Inventory item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
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
                item.kitchenSection,
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
                _formatDate(item.updatedAt),
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
                onPressed: widget.kitchenController.inventoryHasPrev.value
                    ? () => widget.kitchenController.loadPreviousInventoryPage()
                    : null,
              ),
              Text(
                'Page ${widget.kitchenController.inventoryCurrentPage.value} of ${widget.kitchenController.inventoryTotalPages.value}',
                style: const TextStyle(fontSize: 14),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: widget.kitchenController.inventoryHasNext.value
                    ? () => widget.kitchenController.loadNextInventoryPage()
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