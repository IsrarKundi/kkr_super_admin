import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class EarningChart extends StatelessWidget {
  const EarningChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<FlSpot> spots = [
      FlSpot(10, 45),
      FlSpot(11, 50),
      FlSpot(12, 65),
      FlSpot(13, 55),
      FlSpot(14, 80),
      FlSpot(15, 60),
      FlSpot(16, 95),
      FlSpot(17, 80.234), // Highlighted
      FlSpot(18, 70),
      FlSpot(19, 75),
      FlSpot(20, 60),
      FlSpot(21, 70),
      FlSpot(22, 65),
      FlSpot(23, 68),
      FlSpot(24, 62),
      FlSpot(25, 66),
    ];
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      
      margin: const EdgeInsets.only(left: 32, right: 10, top: 32),
      padding: const EdgeInsets.all(24),
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
          Row(
            children: [
              const Text(
                'Earning Revenue',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  children: const [
                    Text(
                      'This Month',
                      style: TextStyle(
                        color: Color(0xFFc89849),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: Color(0xFFc89849)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: LineChart(
              LineChartData(
                minY: 40,
                maxY: 100,
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            value.toInt().toString(),
                            style: const TextStyle(color: Colors.black54, fontSize: 12),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey[300]!, width: 1),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: const Color(0xFFc89849),
                    barWidth: 4,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, bar, index) {
                        if (index == 7) {
                          // Highlighted dot
                          return FlDotCirclePainter(
                            radius: 8,
                            color: const Color(0xFFc89849),
                            strokeWidth: 3,
                            strokeColor: Colors.white,
                          );
                        }
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.white,
                          strokeWidth: 2,
                          strokeColor: const Color(0xFFc89849),
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFc89849).withOpacity(0.18),
                          Colors.transparent,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
                extraLinesData: ExtraLinesData(horizontalLines: [
                  HorizontalLine(
                    y: 80.234,
                    color: const Color(0xFFc89849),
                    strokeWidth: 1.5,
                    dashArray: [6, 4],
                    label: HorizontalLineLabel(
                      show: true,
                      alignment: Alignment.topCenter,
                      style: const TextStyle(
                        color: Color(0xFFc89849),
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                      labelResolver: (line) => '80,234',
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 