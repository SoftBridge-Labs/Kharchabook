import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/app_responsive.dart';

class BarChartWidget extends StatelessWidget {
  final double income;
  final double expense;

  const BarChartWidget({
    super.key,
    required this.income,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    R.init(context);
    return SizedBox(
      height: R.h(200),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: (income > expense ? income : expense) * 1.2,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  final labels = ['Income', 'Expense'];
                  return Text(labels[value.toInt()],
                      style: AppTextStyles.caption);
                },
              ),
            ),
            leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: [
            BarChartGroupData(x: 0, barRods: [
              BarChartRodData(
                  toY: income,
                  color: AppColors.income,
                  width: R.w(40),
                  borderRadius: BorderRadius.circular(R.r(6)))
            ]),
            BarChartGroupData(x: 1, barRods: [
              BarChartRodData(
                  toY: expense,
                  color: AppColors.expense,
                  width: R.w(40),
                  borderRadius: BorderRadius.circular(R.r(6)))
            ]),
          ],
        ),
      ),
    );
  }
}