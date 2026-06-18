import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/app_responsive.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final String amount;
  final bool isIncome;

  const SummaryCard({
    super.key,
    required this.title,
    required this.amount,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    final color = isIncome ? AppColors.income : AppColors.expense;
    return Container(
      padding: EdgeInsets.all(R.w(16)),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(R.r(16)),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: R.w(44),
            height: R.w(44),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(R.r(12)),
            ),
            child: Icon(
              isIncome
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
              color: color,
              size: R.sp(20),
            ),
          ),
          Gap(R.w(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.caption),
                Gap(R.h(2)),
                Text(amount,
                    style: AppTextStyles.heading3.copyWith(color: color)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}