import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/app_responsive.dart';
import '../../core/utils/date_formatter.dart';
import '../../data/models/transaction_model.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const TransactionCard({
    super.key,
    required this.transaction,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == 'income';
    final color = isIncome ? AppColors.income : AppColors.expense;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: R.h(10)),
        padding: EdgeInsets.symmetric(
            horizontal: R.w(16), vertical: R.h(12)),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(R.r(14)),
          boxShadow: [
            BoxShadow(
                color: AppColors.shadow,
                blurRadius: R.r(8),
                offset: Offset(0, R.h(2)))
          ],
        ),
        child: Row(
          children: [
            Container(
              width: R.w(46),
              height: R.w(46),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(R.r(12)),
              ),
              child: Center(
                child: Text(transaction.categoryIcon,
                    style: TextStyle(fontSize: R.sp(22))),
              ),
            ),
            Gap(R.w(12)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(transaction.title,
                      style: AppTextStyles.body
                          .copyWith(fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  Gap(R.h(2)),
                  Text(
                      '${transaction.category} • ${DateFormatter.dayMonth(transaction.date)}',
                      style: AppTextStyles.caption),
                ],
              ),
            ),
            Gap(R.w(8)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isIncome ? '+' : '-'} Rs ${transaction.amount.toStringAsFixed(0)}',
                  style: AppTextStyles.body
                      .copyWith(color: color, fontWeight: FontWeight.w600),
                ),
                if (onDelete != null)
                  GestureDetector(
                    onTap: onDelete,
                    child: Icon(Icons.delete_outline,
                        size: R.sp(18), color: AppColors.textHint),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}