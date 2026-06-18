import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/app_responsive.dart';
import '../../data/models/transaction_model.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/category_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/custom_snackbar.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String _type = 'expense';
  String _selectedCategory = 'Food';
  String _selectedIcon = '🍔';
  DateTime _selectedDate = DateTime.now();

  // Default budgets — BudgetScreen se sync
  static const Map<String, double> _budgets = {
    'Food': 15000,
    'Transport': 5000,
    'Bills': 10000,
    'Health': 5000,
    'Shopping': 8000,
    'Other': 5000,
    'Salary': double.infinity,
  };

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
              primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final newAmount =
        double.parse(_amountController.text.trim());

    // ── Budget check (sirf expense ke liye) ──
    if (_type == 'expense') {
      final provider = context.read<TransactionProvider>();
      final spent =
          provider.expenseByCategory[_selectedCategory] ?? 0;
      final budget =
          _budgets[_selectedCategory] ?? double.infinity;

      // Budget bilkul khatam
      if (spent >= budget) {
        CustomSnackbar.show(
          context,
          '🚫 $_selectedCategory Budget exhausted! Increase the budget first..',
          isError: true,
        );
        return;
      }

      // Naya amount budget cross karega
      if (spent + newAmount > budget) {
        final remaining = budget - spent;
        CustomSnackbar.show(
          context,
          '⚠️ Budget will be exceeded! Only Rs ${remaining.toStringAsFixed(0)} is remaining.',
          isError: true,
        );
        return;
      }
    }

    // ── Save transaction ──
    final t = TransactionModel(
      title: _titleController.text.trim(),
      amount: newAmount,
      type: _type,
      category: _selectedCategory,
      categoryIcon: _selectedIcon,
      note: _noteController.text.trim(),
      date: _selectedDate,
    );
    context.read<TransactionProvider>().addTransaction(t);
    CustomSnackbar.show(context, '✅ Transaction added');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    R.init(context);
    final categories =
        context.watch<CategoryProvider>().categories;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title:
            Text('Add Transaction', style: AppTextStyles.heading3),
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(R.w(20)),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Type Toggle ──
              Container(
                padding: EdgeInsets.all(R.w(4)),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(R.r(12)),
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: R.r(6))
                  ],
                ),
                child: Row(
                  children:
                      ['expense', 'income'].map((type) {
                    final isSelected = _type == type;
                    final color = type == 'income'
                        ? AppColors.income
                        : AppColors.expense;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _type = type),
                        child: AnimatedContainer(
                          duration: const Duration(
                              milliseconds: 200),
                          padding: EdgeInsets.symmetric(
                              vertical: R.h(12)),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? color
                                : Colors.transparent,
                            borderRadius:
                                BorderRadius.circular(
                                    R.r(10)),
                          ),
                          child: Text(
                            type[0].toUpperCase() +
                                type.substring(1),
                            textAlign: TextAlign.center,
                            style:
                                AppTextStyles.body.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              Gap(R.h(24)),

              CustomTextField(
                label: 'Title',
                hint: 'e.g. Grocery shopping',
                controller: _titleController,
                validator: (v) => v == null || v.isEmpty
                    ? 'Title required'
                    : null,
              ),

              Gap(R.h(16)),

              CustomTextField(
                label: 'Amount (Rs)',
                hint: '0',
                controller: _amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ],
                validator: (v) {
                  if (v == null || v.isEmpty)
                    return 'Amount required';
                  if (double.tryParse(v) == null)
                    return 'Invalid amount';
                  if (double.parse(v) <= 0)
                    return 'Amount 0 se zyada hona chahiye';
                  return null;
                },
                prefixIcon: Padding(
                  padding: EdgeInsets.all(R.w(12)),
                  child: Text('Rs',
                      style: AppTextStyles.body.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600)),
                ),
              ),

              Gap(R.h(16)),

              // ── Category Picker ──
              Text('Category',
                  style: AppTextStyles.bodySecondary
                      .copyWith(fontWeight: FontWeight.w500)),
              Gap(R.h(8)),
              SizedBox(
                height: R.h(80),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => Gap(R.w(10)),
                  itemBuilder: (_, i) {
                    final cat = categories[i];
                    final isSelected =
                        _selectedCategory == cat.name;

                    // Budget warning indicator
                    final spent = context
                            .watch<TransactionProvider>()
                            .expenseByCategory[cat.name] ??
                        0;
                    final budget =
                        _budgets[cat.name] ?? double.infinity;
                    final isOver = spent >= budget;

                    return GestureDetector(
                      onTap: () => setState(() {
                        _selectedCategory = cat.name;
                        _selectedIcon = cat.icon;
                      }),
                      child: AnimatedContainer(
                        duration:
                            const Duration(milliseconds: 200),
                        width: R.w(64),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.surface,
                          borderRadius:
                              BorderRadius.circular(R.r(12)),
                          border: Border.all(
                            color: isOver
                                ? AppColors.expense
                                : isSelected
                                    ? AppColors.primary
                                    : AppColors.divider,
                            width: isOver ? 1.5 : 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                      color: AppColors.primary
                                          .withOpacity(0.3),
                                      blurRadius: R.r(8))
                                ]
                              : [],
                        ),
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Text(cat.icon,
                                style: TextStyle(
                                    fontSize: R.sp(20))),
                            Gap(R.h(2)),
                            Text(cat.name,
                                style:
                                    AppTextStyles.caption.copyWith(
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow:
                                    TextOverflow.ellipsis),
                            if (isOver)
                              Text('Full',
                                  style: AppTextStyles.caption
                                      .copyWith(
                                          color:
                                              AppColors.expense,
                                          fontSize: R.sp(9))),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              Gap(R.h(16)),

              // ── Date Picker ──
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: R.w(16), vertical: R.h(14)),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius:
                        BorderRadius.circular(R.r(12)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          color: AppColors.primary,
                          size: R.sp(18)),
                      Gap(R.w(10)),
                      Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        style: AppTextStyles.body,
                      ),
                      const Spacer(),
                      Icon(Icons.chevron_right,
                          color: AppColors.textHint,
                          size: R.sp(20)),
                    ],
                  ),
                ),
              ),

              Gap(R.h(16)),

              CustomTextField(
                label: 'Note (Optional)',
                hint: 'Add a note...',
                controller: _noteController,
                maxLines: 2,
              ),

              Gap(R.h(32)),

              CustomButton(
                  text: 'Save Transaction', onTap: _save),

              Gap(R.h(20)),
            ],
          ),
        ),
      ),
    );
  }
}