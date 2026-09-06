import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../duration.dart';
import '../style.dart';

const weeklySeconds = <int>[
  18_000,
  21_600,
  14_400,
  25_200,
  28_800,
  10_800,
  21_600,
];

const weekDays = <String>['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

class Stats extends StatefulWidget {
  const Stats({super.key, required this.data});
  final List<int> data;

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final maxSeconds = widget.data.reduce((a, b) => a > b ? a : b);
    final maxHours = (maxSeconds / 3600).ceil().toDouble();

    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.only(top: 20),
          child: BarChart(
            BarChartData(
              minY: 0,
              maxY: maxHours,
              alignment: BarChartAlignment.spaceBetween,

              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (group) => colors.surface,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      Duration(
                        seconds: widget.data[groupIndex],
                      ).toStopwatchString(),
                      bodySmall,
                    );
                  },
                ),
              ),

              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      return Text('${value.toInt()}h', style: bodySmall);
                    },
                  ),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),

                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      return SideTitleWidget(
                        meta: meta,
                        child: Text(weekDays[index], style: bodySmall),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),

              gridData: FlGridData(show: false),

              barGroups: List.generate(widget.data.length, (index) {
                final hours = widget.data[index] / 3600;

                return BarChartGroupData(
                  x: index,
                  barsSpace: 0,
                  barRods: [
                    BarChartRodData(
                      toY: hours,
                      width: constraints.constrainWidth() / 15,
                      color: Colors.deepPurpleAccent,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                  ],
                );
              }),
            ),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          ),
        );
      },
    );
  }
}
