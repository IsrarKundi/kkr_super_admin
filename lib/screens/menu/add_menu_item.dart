import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:khaabd_web/models/utils/snackbars.dart';
import 'package:khaabd_web/widgets/custom_textfield.dart';
import 'package:khaabd_web/widgets/gradient_button.dart';
import 'package:khaabd_web/widgets/outlined_button.dart';
import 'package:khaabd_web/controller/getx_controllers/menu_controller.dart';
import 'package:khaabd_web/models/models/kitchen_models/get_items_by_section_model.dart';
import 'package:khaabd_web/models/models/kitchen_models/get_menu_items.dart';

class AddMenuItemModal extends StatefulWidget {
   final VoidCallback onClose;
   final Datum? editingItem;
   const AddMenuItemModal({
     Key? key,
     required this.onClose,
     this.editingItem,
   }) : super(key: key);

  @override
  State<AddMenuItemModal> createState() => _AddMenuItemModalState();
}

class _AddMenuItemModalState extends State<AddMenuItemModal> {
  final MenuGetxController menuController = Get.find();
  final TextEditingController _menuItemNameController = TextEditingController();
  final TextEditingController _sellingPriceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  late Datum? editingItem;

  String? _selectedSection;
  String? _selectedPacking;
  List<Map<String, dynamic>> _ingredients = [];

  // These lists are dynamically populated after section fetch
  List<IngredientsDatum> _packingOptions = [];
  List<IngredientsDatum> _kitchenOptions = [];

  bool _isFetchingSectionItems = false;
  bool _isAddingMenuItem = false; // for button/loading control

  @override
  void initState() {
    super.initState();
    editingItem = widget.editingItem;
    if (editingItem != null) {
      _menuItemNameController.text = editingItem!.name;
      _sellingPriceController.text = editingItem!.sellingPrice.toString();
      _descriptionController.text = editingItem!.description;
      // Capitalize first letter for dropdown
      _selectedSection = editingItem!.section[0].toUpperCase() + editingItem!.section.substring(1);
      // Note: takeAwayPacking is not in the model, so skip for now
      _editingIngredients = editingItem!.ingredients.map((ing) => {
        'itemId': ing.itemId,
        'quantity': ing.quantity,
      }).toList();
      // Trigger section select to populate dropdowns
      if (_selectedSection != null) {
        _onSectionSelect(_selectedSection!);
      }
    }
  }

  String? _editingTakeAwayPackingId;
  List<Map<String, dynamic>> _editingIngredients = [];

  @override
  void dispose() {
    _menuItemNameController.dispose();
    _sellingPriceController.dispose();
    _descriptionController.dispose();
    for (var ing in _ingredients) {
      if (ing['quantity'] is TextEditingController) ing['quantity'].dispose();
      if (ing['unitCost'] is TextEditingController) ing['unitCost'].dispose();
      if (ing['totalCost'] is TextEditingController) ing['totalCost'].dispose();
    }
    super.dispose();
  }

  Future<void> _onSectionSelect(String section) async {
    setState(() {
      _selectedSection = section;
      _isFetchingSectionItems = true;
      _selectedPacking = null;
      _packingOptions = [];
      _kitchenOptions = [];
      _ingredients = [];
    });

    await menuController.getItemsBySection(
      kitchenSection: section.toLowerCase().replaceAll(' ', '-'),
      limit: 50,
      showLoading: false,
      context: context,
    );
    final list = menuController.itemsBySection;
    setState(() {
      _packingOptions = list.where((item) => (item.category?.toLowerCase() ?? '') == 'packing').toList();
      _kitchenOptions = list.where((item) => (item.category?.toLowerCase() ?? '') == 'kitchen').toList();
      _isFetchingSectionItems = false;
      // If editing, populate ingredients
      if (editingItem != null) {
        _populateEditingData();
      }
    });
  }

  void _populateEditingData() {
    if (editingItem == null) return;
    // Populate ingredients
    _ingredients.clear();
    for (var ing in _editingIngredients) {
      final itemId = ing['itemId'];
      final quantity = ing['quantity'];
      final kitchenItem = _kitchenOptions.firstWhere(
        (item) => item.kitchenItemId == itemId,
        orElse: () => _kitchenOptions.first,
      );
      if (kitchenItem.kitchenItemId != null) {
        _ingredients.add({
          'kitchenItem': kitchenItem,
          'quantity': TextEditingController(text: quantity.toString()),
          'unitCost': TextEditingController(),
          'totalCost': TextEditingController(),
        });
        _onKitchenItemChanged(_ingredients.length - 1, kitchenItem);
      }
    }
    // Note: Packing not populated since not in model
  }

  void _addIngredient() {
    if (_kitchenOptions.isEmpty) return;
    setState(() {
      _ingredients.add({
        'kitchenItem': null,
        'quantity': TextEditingController(),
        'unitCost': TextEditingController(),    // Will always be set by ingredient selection
        'totalCost': TextEditingController(),   // Will always be calculated
      });
    });
  }

  void _removeIngredient(int idx) {
    (_ingredients[idx]['quantity'] as TextEditingController).dispose();
    (_ingredients[idx]['unitCost'] as TextEditingController).dispose();
    (_ingredients[idx]['totalCost'] as TextEditingController).dispose();
    setState(() {
      _ingredients.removeAt(idx);
    });
  }

  void _onKitchenItemChanged(int idx, IngredientsDatum? selected) {
    setState(() {
      _ingredients[idx]['kitchenItem'] = selected;
      // Retrieve cost from ingredient field (`selected.cost` or similar)
      int? unitCost;
      // Try: searching for field name for cost - let's assume field is called unitCost (adjust as per model)
      try {
        // If cost is not 'unitCost', update here:
        if (selected != null) {
          unitCost = selected.pricePerUnit ?? 0;
        } else {
          unitCost = 0;
        }
      } catch (_) {
        unitCost = 0;
      }
      (_ingredients[idx]['unitCost'] as TextEditingController).text = unitCost == null ? "0" : unitCost.toStringAsFixed(2);
      _calculateTotal(idx);
    });
  }

  void _calculateTotal(int idx) {
    final q = double.tryParse((_ingredients[idx]['quantity'] as TextEditingController).text) ?? 0;
    final uc = double.tryParse((_ingredients[idx]['unitCost'] as TextEditingController).text) ?? 0;
    (_ingredients[idx]['totalCost'] as TextEditingController).text = (q * uc).toStringAsFixed(2);
    setState(() {});
  }

  double _getTotalPrice() =>
    _ingredients.fold(0, (sum, x) =>
      sum + (double.tryParse((x['totalCost'] as TextEditingController).text) ?? 0));

  double _getProfitMargin() {
    final selling = double.tryParse(_sellingPriceController.text) ?? 0;
    return selling - _getTotalPrice();
  }

  bool get _canSubmit =>
    _selectedSection != null &&
    _selectedPacking != null &&
    _menuItemNameController.text.trim().isNotEmpty &&
    _sellingPriceController.text.trim().isNotEmpty &&
    _descriptionController.text.trim().isNotEmpty &&
    _ingredients.isNotEmpty &&
    _ingredients.every((x) => x['kitchenItem'] != null && (x['quantity'] as TextEditingController).text.trim().isNotEmpty);

  Future<void> _handleAddMenuItem() async {
    if (!_canSubmit) {
      showNativeErrorSnackbar(context, 'Please fill all required fields and add at least one ingredient.');
      return;
    }
    setState(() => _isAddingMenuItem = true);

    final packingId = _packingOptions.firstWhere(
      (e) => e.itemName == _selectedPacking,
      orElse: () => _packingOptions.first,
    ).kitchenItemId ?? '';
    final ingredientsApiList = _ingredients.map((x) => {
      'item': (x['kitchenItem'] as IngredientsDatum).kitchenItemId,
      'quantity': int.tryParse((x['quantity'] as TextEditingController).text) ?? 0
    }).toList();

    bool success;
    if (editingItem != null) {
      success = await menuController.updateMenuItem(
        itemId: editingItem!.id,
        menuItemName: _menuItemNameController.text.trim(),
        foodSection: _selectedSection!.toLowerCase().replaceAll(' ', '-'),
        sellingPrice: int.tryParse(_sellingPriceController.text) ?? 0,
        description: _descriptionController.text.trim(),
        takeAwayPacking: packingId,
        ingredients: ingredientsApiList,
        context: context,
      );
    } else {
      success = await menuController.addMenuItem(
        menuItemName: _menuItemNameController.text.trim(),
        foodSection: _selectedSection!.toLowerCase().replaceAll(' ', '-'),
        sellingPrice: int.tryParse(_sellingPriceController.text) ?? 0,
        description: _descriptionController.text.trim(),
        takeAwayPacking: packingId,
        ingredients: ingredientsApiList,
        context: context,
      );
    }

    if (success) {
      await menuController.getMenuItems(); // refresh list
      widget.onClose(); // close modal
    }
    setState(() => _isAddingMenuItem = false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Dimmed background
        Positioned.fill(
          child: GestureDetector(
            onTap: widget.onClose,
            child: Container(color: Colors.black.withOpacity(0.50)),
          ),
        ),
        Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 600,
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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Spacer(),
                        Text(
                          editingItem != null ? "Update Menu Item" : "Add New Menu Item",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red, size: 24),
                          onPressed: widget.onClose,
                          tooltip: 'Close',
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Section selection and name
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Menu Item Name',
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              CustomTextField(
                                controller: _menuItemNameController,
                                hintText: 'Enter menu item name',
                                borderRadius: 8,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Food Section',
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                value: _selectedSection,
                                isDense: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
                                ),
                                hint: const Text('Select Section'),
                                items: const ['Desi', 'Continental', 'Fast Food']
                                    .map((e) => DropdownMenuItem(child: Text(e), value: e))
                                    .toList(),
                                onChanged: (val) {
                                  if (val != null) _onSectionSelect(val);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Selling price and packing
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Selling Price',
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              CustomTextField(
                                controller: _sellingPriceController,
                                hintText: 'Enter selling price',
                                borderRadius: 8,
                                keyboardType: TextInputType.number,
                                onChanged: (_) => setState(() {}),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Takeaway Packing',
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              _isFetchingSectionItems
                                  ? Container(
                                      height: 48,
                                      alignment: Alignment.center,
                                      child: const CircularProgressIndicator(),
                                    )
                                  : DropdownButtonFormField<String>(
                                      value: _selectedPacking,
                                      isDense: true,
                                      hint: const Text('Select Packing'),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
                                      ),
                                      items: _packingOptions
                                          .map((e) => DropdownMenuItem<String>(
                                                child: Text(e.itemName ?? ''),
                                                value: e.itemName,
                                              ))
                                          .toList(),
                                      onChanged: (val) {
                                        setState(() => _selectedPacking = val);
                                      },
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Description
                    const Text('Description', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _descriptionController,
                      hintText: 'Enter description',
                      borderRadius: 8,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),
                    // Ingredients List
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Ingredients & Recipe', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                        ElevatedButton(
                          onPressed: _kitchenOptions.isEmpty ? null : _addIngredient,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                          child: const Text('Add Ingredient'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ..._ingredients.asMap().entries.map((entry) {
                      final idx = entry.key;
                      return Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Kitchen Item Dropdown
                            Expanded(
                              flex: 2,
                              child: DropdownButtonFormField<IngredientsDatum>(
                                value: _ingredients[idx]['kitchenItem'],
                                isDense: true,
                                hint: const Text('Select Item'),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                ),
                                items: _kitchenOptions
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(
                                          e.itemName ?? '',
                                          style: TextStyle(fontSize: 13),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (val) {
                                  _onKitchenItemChanged(idx, val);
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: CustomTextField(
                                controller: _ingredients[idx]['quantity'],
                                hintText: 'Qty',
                                borderRadius: 6,
                                keyboardType: TextInputType.number,
                                onChanged: (_) => _calculateTotal(idx),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: CustomTextField(
                                controller: _ingredients[idx]['unitCost'],
                                hintText: 'Unit Cost',
                                borderRadius: 6,
                                keyboardType: TextInputType.number,
                                readOnly: true, // <-- read only
                                enabled: false, // disables editing, but still readable
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: CustomTextField(
                                controller: _ingredients[idx]['totalCost'],
                                hintText: 'Total',
                                borderRadius: 6,
                                readOnly: true, // <-- read only
                                enabled: false, // disables editing, but still readable
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => _removeIngredient(idx),
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: SvgPicture.asset(
                                  "assets/svgs/delete_icon.svg",
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 20),
                    // Cost Analysis
                    const Text('Cost Analysis', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    const Divider(thickness: 1, color: Colors.grey),
                    const SizedBox(height: 12),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Price', style: TextStyle(fontWeight: FontWeight.w500)),
                        Text('Selling Price', style: TextStyle(fontWeight: FontWeight.w500)),
                        Text('Profit Margin', style: TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('\$${_getTotalPrice().toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.red, fontSize: 16)),
                        Text('\$${_sellingPriceController.text.isEmpty ? "00" : double.tryParse(_sellingPriceController.text)?.toStringAsFixed(2) ?? "00"}',
                            style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.green, fontSize: 16)),
                        Text('\$${_getProfitMargin().toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.blue, fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 24),
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
                            text: _isAddingMenuItem ? (editingItem != null ? 'Updating Menu Item...' : 'Adding Menu Item...') : (editingItem != null ? 'Update Menu Item' : 'Add Menu Item'),
                            onPressed: _isAddingMenuItem ? null : _handleAddMenuItem,
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
        ),
      ],
    );
  }
}