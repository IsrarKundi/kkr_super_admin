import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:khaabd_web/utils/colors.dart';
import 'package:khaabd_web/controller/getx_controllers/menu_controller.dart';
import 'package:khaabd_web/models/models/kitchen_models/get_menu_items.dart';

class MenuItemsTab extends StatefulWidget {
  final MenuGetxController menuController;
  final Function(Datum) onEditItem;
  final Function(dynamic) onDeleteItem;

  const MenuItemsTab({
    Key? key,
    required this.menuController,
    required this.onEditItem,
    required this.onDeleteItem,
  }) : super(key: key);

  @override
  State<MenuItemsTab> createState() => _MenuItemsTabState();
}

class _MenuItemsTabState extends State<MenuItemsTab> {
  final List<TableColumn> _columns = [
    TableColumn('Menu Item', flex: 3),
    TableColumn('Food Section', flex: 2),
    TableColumn('Cost', flex: 2),
    TableColumn('Selling Price', flex: 2),
    TableColumn('Profit Margin', flex: 2),
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
          if (widget.menuController.menuItems.isNotEmpty) _buildPagination(),
        ],
      ),
    ));
  }

  Widget _buildTableContent() {
    if (widget.menuController.isLoadingMenuItems.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.menuController.menuItems.isEmpty) {
      return const Center(
        child: Text(
          'No menu items found',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: widget.menuController.menuItems.map((item) => _buildMenuItemRow(item)).toList(),
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

  Widget _buildMenuItemRow(Datum item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Menu Item Name
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
          // Food Section
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                _formatSection(item.section),
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          // Cost
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Rs. ${item.totalCost}',
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          // Selling Price
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Rs. ${item.sellingPrice}',
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          // Profit Margin
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(right: 72),
              child: Container(
                width: 20,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  '${item.profitMargin.profitMarginPercent.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
          // Action Buttons
          Expanded(
            flex: 2,
            child: _buildActionButtons(item),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(Datum item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => _handleEditItem(item),
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: SvgPicture.asset("assets/svgs/edit_icon.svg"),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () => widget.onDeleteItem(item),
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: SvgPicture.asset("assets/svgs/delete_icon.svg"),
            ),
          ),
        ],
      ),
    );
  }

  void _handleEditItem(Datum item) {
    widget.onEditItem(item);
  }

  String _formatSection(String section) {
    // Convert section names to display format
    switch (section.toLowerCase()) {
      case 'desi':
        return 'Desi';
      case 'continental':
        return 'Continental';
      case 'fast_food':
        return 'Fast Food';
      case 'chinese':
        return 'Chinese';
      case 'afghani':
        return 'Afghani';
      default:
        return section;
    }
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
                onPressed: widget.menuController.menuHasPrev.value
                    ? () => widget.menuController.loadPreviousMenuPage()
                    : null,
              ),
              Text(
                'Page ${widget.menuController.menuCurrentPage.value} of ${((widget.menuController.menuTotal.value - 1) / 8).ceil() + 1}',
                style: const TextStyle(fontSize: 14),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: widget.menuController.menuHasNext.value
                    ? () => widget.menuController.loadNextMenuPage()
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