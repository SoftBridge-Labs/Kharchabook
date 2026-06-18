import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/app_responsive.dart';
import '../../core/utils/currency_formatter.dart';
import '../../providers/transaction_provider.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    R.init(context);
    final provider = context.watch<TransactionProvider>();
    final expMap = provider.expenseByCategory;
    final colors = AppColors.categoryColors;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Reports', style: AppTextStyles.heading3),
      ),
      body: ListView(
        padding: EdgeInsets.all(R.w(20)),
        children: [
          // Summary Row
          Row(
            children: [
              _statCard('Total Income',
                  CurrencyFormatter.format(provider.totalIncome),
                  AppColors.income),
              Gap(R.w(12)),
              _statCard('Total Expense',
                  CurrencyFormatter.format(provider.totalExpense),
                  AppColors.expense),
            ],
          ),

          Gap(R.h(24)),

          // Bar Chart
          Text('Monthly Overview', style: AppTextStyles.heading3),
          Gap(R.h(12)),
          Container(
            height: R.h(200),
            padding: EdgeInsets.all(R.w(16)),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(R.r(16)),
              boxShadow: [
                BoxShadow(color: AppColors.shadow, blurRadius: R.r(6))
              ],
            ),
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: (provider.totalIncome > provider.totalExpense
                        ? provider.totalIncome
                        : provider.totalExpense) *
                    1.2,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
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
                        toY: provider.totalIncome,
                        color: AppColors.income,
                        width: R.w(40),
                        borderRadius: BorderRadius.circular(R.r(6)))
                  ]),
                  BarChartGroupData(x: 1, barRods: [
                    BarChartRodData(
                        toY: provider.totalExpense,
                        color: AppColors.expense,
                        width: R.w(40),
                        borderRadius: BorderRadius.circular(R.r(6)))
                  ]),
                ],
              ),
            ),
          ),

          Gap(R.h(24)),

          // Category Breakdown
          Text('Expense Breakdown', style: AppTextStyles.heading3),
          Gap(R.h(12)),

          expMap.isEmpty
              ? Center(
                  child: Padding(
                  padding: EdgeInsets.all(R.w(20)),
                  child: Text('No expenses this month',
                      style: AppTextStyles.bodySecondary),
                ))
              : Column(
                  children: expMap.entries.toList().asMap().entries.map((e) {
                    final idx = e.key;
                    final entry = e.value;
                    final color = colors[idx % colors.length];
                    final total = expMap.values
                        .fold(0.0, (a, b) => a + b);
                    final percent = total > 0
                        ? (entry.value / total * 100).toStringAsFixed(1)
                        : '0';
                    return Container(
                      margin: EdgeInsets.only(bottom: R.h(10)),
                      padding: EdgeInsets.all(R.w(14)),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(R.r(14)),
                        boxShadow: [
                          BoxShadow(
                              color: AppColors.shadow,
                              blurRadius: R.r(4))
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: R.w(12),
                            height: R.w(12),
                            decoration: BoxDecoration(
                                color: color, shape: BoxShape.circle),
                          ),
                          Gap(R.w(12)),
                          Expanded(
                              child: Text(entry.key,
                                  style: AppTextStyles.body)),
                          Text('$percent%',
                              style: AppTextStyles.bodySecondary),
                          Gap(R.w(12)),
                          Text(CurrencyFormatter.format(entry.value),
                              style: AppTextStyles.body.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.expense)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }

  Widget _statCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(R.w(16)),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(R.r(16)),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: AppTextStyles.caption.copyWith(color: color)),
            Gap(R.h(6)),
            Text(value,
                style: AppTextStyles.heading3.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}