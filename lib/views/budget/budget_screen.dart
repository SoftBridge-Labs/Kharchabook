import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/app_responsive.dart';
import '../../core/utils/currency_formatter.dart';
import '../../providers/transaction_provider.dart';
import '../../widgets/common/custom_snackbar.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final Map<String, TextEditingController> _controllers = {};

  // Saved budgets — ye final limits hain
  final Map<String, double> _savedBudgets = {
    'Food': 15000,
    'Transport': 5000,
    'Bills': 10000,
    'Health': 5000,
    'Shopping': 8000,
    'Other': 5000,
  };

  // Draft budgets — input field mein type karte waqt
  final Map<String, double> _draftBudgets = {};

  @override
  void initState() {
    super.initState();
    for (final key in _savedBudgets.keys) {
      _draftBudgets[key] = _savedBudgets[key]!;
      _controllers[key] = TextEditingController(
          text: _savedBudgets[key]!.toStringAsFixed(0));
    }
  }

  @override
  void dispose() {
    for (final c in _controllers.values) c.dispose();
    super.dispose();
  }

  
  bool _canSpend(String category, double spent) {
    return spent < _savedBudgets[category]!;
  }

  void _saveBudget(String category) {
    final val = _draftBudgets[category] ?? 0;
    if (val <= 0) {
      CustomSnackbar.show(context, 'Budget Should be greater than 0 ',
          isError: true);
      return;
    }
    setState(() => _savedBudgets[category] = val);
    CustomSnackbar.show(
        context, '$category Budget Saved Successfully: ${CurrencyFormatter.format(val)}');
  }

  @override
  Widget build(BuildContext context) {
    R.init(context);
    final provider = context.watch<TransactionProvider>();
    final expMap = provider.expenseByCategory;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Budget Manager', style: AppTextStyles.heading3),
      ),
      body: ListView(
        padding: EdgeInsets.all(R.w(20)),
        children: [
          // Header Card
          Container(
            padding: EdgeInsets.all(R.w(20)),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(R.r(20)),
            ),
            child: Column(
              children: [
                Text('Monthly Budget Overview',
                    style: AppTextStyles.body
                        .copyWith(color: Colors.white70)),
                Gap(R.h(8)),
                Text(
                  CurrencyFormatter.format(
                      _savedBudgets.values.fold(0, (a, b) => a + b)),
                  style: AppTextStyles.amount.copyWith(color: Colors.white),
                ),
                Gap(R.h(4)),
                Text('Total Budget Set',
                    style: AppTextStyles.caption
                        .copyWith(color: Colors.white60)),
              ],
            ),
          ),

          Gap(R.h(24)),
          Text('Category Budgets', style: AppTextStyles.heading3),
          Gap(R.h(4)),
          Text(
            'You cannot spend more once the budget limit is reached.',
            style: AppTextStyles.caption,
          ),
          Gap(R.h(12)),

          ..._savedBudgets.keys.map((category) {
            final budget = _savedBudgets[category] ?? 0;
            final spent = expMap[category] ?? 0;
            final percent =
                budget > 0 ? (spent / budget).clamp(0.0, 1.0) : 0.0;
            final isOver = spent >= budget;
            final isWarning = percent >= 0.8 && !isOver;
            final Color statusColor = isOver
                ? AppColors.expense
                : isWarning
                    ? Colors.orange
                    : AppColors.primary;

            return Container(
              margin: EdgeInsets.only(bottom: R.h(14)),
              padding: EdgeInsets.all(R.w(16)),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(R.r(16)),
                border: isOver
                    ? Border.all(color: AppColors.expense, width: 1.5)
                    : isWarning
                        ? Border.all(color: Colors.orange, width: 1)
                        : null,
                boxShadow: [
                  BoxShadow(
                      color: AppColors.shadow, blurRadius: R.r(6))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category name + status badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(category,
                          style: AppTextStyles.body
                              .copyWith(fontWeight: FontWeight.w600)),
                      if (isOver)
                        _badge('🚫 budget already reached.', AppColors.expense)
                      else if (isWarning)
                        _badge('⚠️ Close to limit', Colors.orange),
                    ],
                  ),

                  Gap(R.h(10)),

                  // Budget input + save button
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controllers[category],
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          style: AppTextStyles.bodySecondary,
                          decoration: InputDecoration(
                            prefixText: 'Rs ',
                            prefixStyle: AppTextStyles.bodySecondary
                                .copyWith(color: AppColors.primary),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: R.w(12), vertical: R.h(8)),
                            isDense: true,
                            hintText: ' Set Budget ',
                          ),
                          onChanged: (v) {
                            final val = double.tryParse(v);
                            if (val != null) {
                              _draftBudgets[category] = val;
                            }
                          },
                        ),
                      ),
                      Gap(R.w(10)),
                      // Save button
                      GestureDetector(
                        onTap: () => _saveBudget(category),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: R.w(14), vertical: R.h(10)),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(R.r(10)),
                          ),
                          child: Text('Save',
                              style: AppTextStyles.caption.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),

                  Gap(R.h(12)),

                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(R.r(8)),
                    child: LinearProgressIndicator(
                      value: percent,
                      backgroundColor: statusColor.withOpacity(0.1),
                      valueColor:
                          AlwaysStoppedAnimation<Color>(statusColor),
                      minHeight: R.h(8),
                    ),
                  ),

                  Gap(R.h(8)),

                  // Spent / Left / Percent
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          'Kharch: ${CurrencyFormatter.format(spent)}',
                          style: AppTextStyles.caption),
                      Text(
                        isOver
                            ? '🚫 Rs ${(spent - budget).toStringAsFixed(0)} zyada'
                            : 'Remaning: ${CurrencyFormatter.format(budget - spent)}',
                        style: AppTextStyles.caption.copyWith(
                          color: isOver
                              ? AppColors.expense
                              : AppColors.income,
                        ),
                      ),
                    ],
                  ),

                  // Block message
                  if (isOver) ...[
                    Gap(R.h(8)),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(R.w(10)),
                      decoration: BoxDecoration(
                        color: AppColors.expense.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(R.r(8)),
                      ),
                      child: Text(
                        '$category The budget has been exhausted. Increase the budget to spend more.',
                        style: AppTextStyles.caption
                            .copyWith(color: AppColors.expense),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: R.w(8), vertical: R.h(3)),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(R.r(8)),
      ),
      child: Text(text,
          style:
              AppTextStyles.caption.copyWith(color: color)),
    );
  }
}