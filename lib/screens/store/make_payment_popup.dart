import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khaabd_web/models/utils/snackbars.dart';
import 'package:khaabd_web/widgets/custom_textfield.dart';
import 'package:khaabd_web/widgets/gradient_button.dart';
import 'package:khaabd_web/widgets/outlined_button.dart';
import 'package:khaabd_web/controller/getx_controllers/store_controller.dart';

class MakePaymentModal extends StatefulWidget {
  final VoidCallback onClose;
  final Function(String supplierId, double amount) onSave;
  final String supplierName;
  final String supplierId;

  const MakePaymentModal({
    Key? key,
    required this.onClose,
    required this.onSave,
    required this.supplierName,
    required this.supplierId,
  }) : super(key: key);

  @override
  State<MakePaymentModal> createState() => _MakePaymentModalState();
}

class _MakePaymentModalState extends State<MakePaymentModal> {
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_amountController.text.isNotEmpty) {
      try {
        double amount = double.parse(_amountController.text);
        if (amount > 0) {
          widget.onSave(widget.supplierId, amount);
        } else {
          showNativeErrorSnackbar(context, 'Please enter a valid amount greater than 0');
        }
      } catch (e) {
        showNativeErrorSnackbar(context, 'Please enter a valid numeric amount');
      }
    } else {
      showNativeErrorSnackbar(context, 'Please enter payment amount');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background overlay
        Positioned.fill(
          child: GestureDetector(
            onTap: widget.onClose,
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
        ),
        // Modal content
        Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 450,
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
                        const Text(
                          'Make Payment',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 26,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red, size: 28),
                          onPressed: widget.onClose,
                          tooltip: 'Close',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Supplier Name Field (Read-only)
                    const Text(
                      'Supplier Name',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[400]!, width: 1.0),
                        borderRadius: BorderRadius.circular(12.0),
                        color: Colors.grey[100],
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.supplierName,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Payment Amount Field
                    const Text(
                      'Payment Amount',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _amountController,
                      hintText: 'Enter payment amount',
                      borderRadius: 12.0,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                    ),
                    const SizedBox(height: 32),
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
                          child: Obx(() {
                            final controller = Get.find<StoreController>();
                            return GradientButton(
                              text: controller.isMakingPayment.value 
                                  ? 'Processing...' 
                                  : 'Make Payment',
                              onPressed: controller.isMakingPayment.value 
                                  ? null 
                                  : _handleSave,
                              height: 50,
                            );
                          }),
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