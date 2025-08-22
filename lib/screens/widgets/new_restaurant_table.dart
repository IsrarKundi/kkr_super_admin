import 'package:flutter/material.dart';

class RecentSalesTable extends StatelessWidget {
  const RecentSalesTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rows = [
      {
        'label': 'Tuesday, 01 Aug 2023',
        'amount': 'RS 21,000',
      },
      {
        'label': 'Monday, 31 Jul 2023',
        'amount': 'RS 15,450',
      },
      {
        'label': 'Saturday, 29 Jul 2023',
        'amount': 'RS 8,320',
      },
      {
        'label': 'Friday, 28 Jul 2023',
        'amount': 'RS 12,780',
      },
    ];
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 32, right: 32, top: 32, bottom: 32),
      padding: const EdgeInsets.only(top: 24, left: 0, right: 0, bottom: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 0),
            child: Text(
              'Recent Sales',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Divider(
            height: 1,
            color: const Color(0xFFE0E0E0),
          ),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: rows.map((row) {
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          row['label']!,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        row['amount']!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
} 