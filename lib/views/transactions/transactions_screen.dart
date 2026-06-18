import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/app_responsive.dart';
import '../../providers/transaction_provider.dart';
import '../../widgets/cards/transaction_card.dart';
import '../../widgets/common/loading_widget.dart';
import 'add_transaction_screen.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    R.init(context);
    final provider = context.watch<TransactionProvider>();
    final filtered = provider.monthly.where((t) {
      if (_filter == 'all') return true;
      return t.type == _filter;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Transactions', style: AppTextStyles.heading3),
        actions: [
          IconButton(
            icon: Icon(Iconsax.add_circle, color: AppColors.primary,
                size: R.sp(26)),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(
                    builder: (_) => const AddTransactionScreen())),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Tabs
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: R.w(20), vertical: R.h(12)),
            child: Container(
              padding: EdgeInsets.all(R.w(4)),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(R.r(12)),
                boxShadow: [
                  BoxShadow(color: AppColors.shadow, blurRadius: R.r(6))
                ],
              ),
              child: Row(
                children: ['all', 'income', 'expense'].map((f) {
                  final isSelected = _filter == f;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _filter = f),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(vertical: R.h(10)),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(R.r(10)),
                        ),
                        child: Text(
                          f[0].toUpperCase() + f.substring(1),
                          textAlign: TextAlign.center,
                          style: AppTextStyles.body.copyWith(
                            color: isSelected
                                ? Colors.white
                                : AppColors.textSecondary,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            fontSize: R.sp(13),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // List
          Expanded(
            child: provider.loading
                ? const LoadingWidget()
                : filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('🧾',
                                style: TextStyle(fontSize: R.sp(48))),
                            Gap(R.h(12)),
                            Text('No transactions found',
                                style: AppTextStyles.bodySecondary),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: R.w(20)),
                        itemCount: filtered.length,
                        itemBuilder: (_, i) => TransactionCard(
                          transaction: filtered[i],
                          onDelete: () => provider.deleteTransaction(
                              filtered[i].id!, filtered[i].date),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}