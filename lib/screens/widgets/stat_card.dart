import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:khaabd_web/utils/colors.dart';

class StatCard extends StatelessWidget {
  final String icon;
  final Color iconBgColor;
  final String title;
  final String value;
  final String date;
  final String trend;
  final Color trendColor;
  final String trendText;
  final Color cardBgColor;

  const StatCard({
    Key? key,
    required this.icon,
    required this.iconBgColor,
    required this.title,
    required this.value,
    required this.date,
    required this.trend,
    required this.trendColor,
    required this.trendText,
    required this.cardBgColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(child:  Container(
      width: 280,
      height: 100,
      margin: const EdgeInsets.only(right: 24),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBgColor.withOpacity(0.2),
              border: Border.all(color: iconBgColor, width: 1.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SvgPicture.asset(icon, color: iconBgColor,),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      date,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      value,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(width: 78),
                    // Icon(
                    //   trend == '+' ? Icons.arrow_upward : Icons.arrow_downward,
                    //   color: trendColor,
                    //   size: 18,
                    // ),
                    // Text(
                    //   trendText,
                    //   style: TextStyle(
                    //     color: trendColor,
                    //     fontSize: 13,
                    //     fontWeight: FontWeight.w500,
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
    
   
  }
} 

class StatCard2 extends StatelessWidget {
  final String icon;
  final Color iconBgColor;
  final String title;
  final String value;
  // final String date;
  final String trend;
  final Color trendColor;
  final String trendText;
  final Color cardBgColor;

  const StatCard2({
    Key? key,
    required this.icon,
    required this.iconBgColor,
    required this.title,
    required this.value,
    // required this.date,
    required this.trend,
    required this.trendColor,
    required this.trendText,
    required this.cardBgColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(child:  Container(
      width: 280,
      height: 100,
      margin: const EdgeInsets.only(right: 24),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: greenColor, width: 1.5),
            ),
            child: SvgPicture.asset(
              icon,
              // color: Colors.white.withOpacity(0.6),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    // const Spacer(),
                    SizedBox(width: 16),
                    Text(
                      value,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Text(
                    //   value,
                    //   style: const TextStyle(
                    //     color: Colors.black,
                    //     fontWeight: FontWeight.w700,
                    //     fontSize: 22,
                    //   ),
                    // ),
                    // const SizedBox(width: 8),
                    Icon(
                      trend == '+' ? Icons.arrow_upward : Icons.arrow_downward,
                      color: greenColor,
                      size: 18,
                    ),
                    Text(
                      trendText,
                      style: TextStyle(
                        color: greenColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
    
   
  }
} 