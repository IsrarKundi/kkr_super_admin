import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khaabd_web/models/models/store_models/get_inventory_model.dart';
import 'package:khaabd_web/widgets/gradient_button.dart';
import 'package:khaabd_web/widgets/outlined_button.dart';
import 'package:khaabd_web/controller/getx_controllers/store_controller.dart';

class DeleteInventoryItemModal extends StatelessWidget {
  final CurrentInventory item;
  final VoidCallback onClose;
  final VoidCallback onConfirm;

  const DeleteInventoryItemModal({
    Key? key,
    required this.item,
    required this.onClose,
    required this.onConfirm,
  }) : super(key: key);

  String _formatCurrency(int amount) {
    return 'RS ${amount.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    final StoreController storeController = Get.find<StoreController>();
    
    return Obx(() {
      final bool isLoading = storeController.isDeletingInventoryItem.value;
      
      return Stack(
        children: [
          // Background overlay
          Positioned.fill(
            child: GestureDetector(
              onTap: isLoading ? null : onClose,
              child: Container(color: Colors.black.withOpacity(0.5)),
            ),
          ),
          // Modal content
          Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 420,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Delete Inventory Item',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w700,
                            fontSize: 26,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red, size: 28),
                          onPressed: isLoading ? null : onClose,
                          tooltip: 'Close',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Warning Icon
                    const Center(
                      child: Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.red,
                        size: 64,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Confirmation Message
                    const Text(
                      'Are you sure you want to delete this inventory item?',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    
                    // Item Details
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!, width: 1),
                      ),
                      child: Column(
                        children: [
                          _buildDetailRow('Item Name:', item.name),
                          const SizedBox(height: 8),
                          _buildDetailRow('Category:', item.category),
                          const SizedBox(height: 8),
                          _buildDetailRow('Current Stock:', '${item.currentStock} ${item.measuringUnit}'),
                          const SizedBox(height: 8),
                          _buildDetailRow('Unit Cost:', _formatCurrency(item.pricePerUnit)),
                          const SizedBox(height: 8),
                          _buildDetailRow('Total Value:', _formatCurrency(item.totalValue)),
                          const SizedBox(height: 8),
                          _buildDetailRow('Status:', item.status, 
                            valueColor: item.status.toLowerCase() == 'in-stock' ? Colors.green : Colors.red),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Warning Text
                    const Text(
                      '⚠️ Warning: This will permanently remove the item from your inventory.',
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    
                    Text(
                      'This action cannot be undone.',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: OutlinedGradientButton(
                              borderRadius: 50,
                              text: "Cancel",
                              onPressed: isLoading ? null : onClose,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : onConfirm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                elevation: 0,
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'Delete',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFc89849),
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: valueColor ?? Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}