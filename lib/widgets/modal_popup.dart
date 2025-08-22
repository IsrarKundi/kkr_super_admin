import 'package:flutter/material.dart';

class ModalPopup extends StatelessWidget {
  final Widget child;
  final VoidCallback onClose;
  const ModalPopup({Key? key, required this.child, required this.onClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Overlay
        Positioned.fill(
          child: GestureDetector(
            onTap: onClose,
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
        ),
        // Centered popup
        Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 420,
                minWidth: 320,
                maxHeight: 520,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
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
              child: child,
            ),
          ),
        ),
      ],
    );
  }
} 