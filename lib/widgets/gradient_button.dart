import 'package:flutter/material.dart';
import 'package:khaabd_web/utils/colors.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool enabled;
  final double height;
  final TextStyle? textStyle;
  final IconData? icon;
  final double? borderRadius;

  const GradientButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.enabled = true,
    this.height = 56,
    this.icon,
    this.textStyle,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
  end: Alignment.bottomRight,
          colors: [
            goldenColor2,
            goldenColor1,
            goldenColor2,
            
          ],
        ),
        borderRadius: BorderRadius.circular( borderRadius ?? 16), 
        // boxShadow: [
        //   BoxShadow(
        //     color: const Color(0xFFc89849).withOpacity(0.3),
        //     blurRadius: 8,
        //     offset: const Offset(0, 4),
        //   ),
        // ],
      ),
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), 
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon != null
            ?
              Icon(icon, color: Colors.black, size: 20)
              : const SizedBox.shrink()
            ,
            Text(
              text,
              style: textStyle ?? const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 