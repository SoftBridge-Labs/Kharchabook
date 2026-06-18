import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/app_responsive.dart';
import '../../core/utils/currency_formatter.dart';

class PieChartWidget extends StatelessWidget {
  final Map<String, double> data;

  const PieChartWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    R.init(context);
    final colors = AppColors.categoryColors;
    final entries = data.entries.toList();
    final total = data.values.fold(0.0, (a, b) => a + b);

    return Container(
      padding: EdgeInsets.all(R.w(16)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(R.r(16)),
        boxShadow: [
          BoxShadow(color: AppColors.shadow, blurRadius: R.r(8))
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: R.h(180),
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: R.w(36),
                sections: entries.asMap().entries.map((e) {
                  final color = colors[e.key % colors.length];
                  final percent = total > 0
                      ? (e.value.value / total * 100)
                      : 0.0;
                  return PieChartSectionData(
                    color: color,
                    value: e.value.value,
                    title: '${percent.toStringAsFixed(0)}%',
                    radius: R.w(50),
                    titleStyle: AppTextStyles.caption
                        .copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                  );
                }).toList(),
              ),
            ),
          ),
          Gap(R.h(16)),
          Wrap(
            spacing: R.w(16),
            runSpacing: R.h(8),
            children: entries.asMap().entries.map((e) {
              final color = colors[e.key % colors.length];
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: R.w(10),
                    height: R.w(10),
                    decoration:
                        BoxDecoration(color: color, shape: BoxShape.circle),
                  ),
                  Gap(R.w(6)),
                  Text(
                    '${e.value.key} • ${CurrencyFormatter.format(e.value.value)}',
                    style: AppTextStyles.caption,
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}