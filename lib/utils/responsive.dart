import 'package:flutter/material.dart';

class Responsive {
  static double horizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return width * 0.35;
    if (width > 800) return width * 0.2;
    if (width > 600) return width * 0.1;
    return 24;
  }

  static double modalWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 600) return 420;
    return width * 0.9;
  }

  static double fontSize(BuildContext context, double base) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return base + 2;
    if (width > 800) return base + 1;
    return base;
  }
} 