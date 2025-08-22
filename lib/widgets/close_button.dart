import 'package:flutter/material.dart';

class PopupCloseButton extends StatelessWidget {
  final VoidCallback onPressed;
  const PopupCloseButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        icon: const Icon(Icons.close, color: Color(0xFFFF3B30), size: 28),
        onPressed: onPressed,
        splashRadius: 24,
        tooltip: 'Close',
      ),
    );
  }
} 