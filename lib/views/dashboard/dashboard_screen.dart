import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/app_responsive.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../providers/transaction_provider.dart';
import '../../widgets/cards/summary_card.dart';
import '../../widgets/cards/transaction_card.dart';
import '../../widgets/charts/pie_chart_widget.dart';
import '../transactions/add_transaction_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final now = DateTime.now();
      context.read<TransactionProvider>().loadByMonth(now.month, now.year);
    });
  }

  @override
  Widget build(BuildContext context) {
    R.init(context);
    final provider = context.watch<TransactionProvider>();
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Header
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(R.w(20)),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Assalam o Alaikum 👋',
                                style: AppTextStyles.bodySecondary
                                    .copyWith(color: Colors.white70)),
                            Gap(R.h(4)),
                            Text('Kharchabook',
                                style: AppTextStyles.heading2
                                    .copyWith(color: Colors.white)),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.all(R.w(10)),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(R.r(12)),
                          ),
                          child: Icon(Iconsax.notification,
                              color: Colors.white, size: R.sp(22)),
                        ),
                      ],
                    ),
                    Gap(R.h(24)),
                    // Balance Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(R.w(20)),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(R.r(20)),
                      ),
                      child: Column(
                        children: [
                          Text('Total Balance',
                              style: AppTextStyles.bodySecondary
                                  .copyWith(color: Colors.white70)),
                          Gap(R.h(8)),
                          Text(
                            CurrencyFormatter.format(provider.balance),
                            style: AppTextStyles.amount
                                .copyWith(color: Colors.white, fontSize: R.sp(36)),
                          ),
                          Gap(R.h(4)),
                          Text(DateFormatter.monthYear(now),
                              style: AppTextStyles.caption
                                  .copyWith(color: Colors.white60)),
                          Gap(R.h(20)),
                          Row(
                            children: [
                              Expanded(
                                child: SummaryCard(
                                  title: 'Income',
                                  amount: CurrencyFormatter.format(
                                      provider.totalIncome),
                                  isIncome: true,
                                ),
                              ),
                              Gap(R.w(12)),
                              Expanded(
                                child: SummaryCard(
                                  title: 'Expense',
                                  amount: CurrencyFormatter.format(
                                      provider.totalExpense),
                                  isIncome: false,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Gap(R.h(16)),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(child: Gap(R.h(20))),

            // ── Pie Chart
            if (provider.expenseByCategory.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: R.w(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Spending by Category',
                          style: AppTextStyles.heading3),
                      Gap(R.h(12)),
                      PieChartWidget(data: provider.expenseByCategory),
                    ],
                  ),
                ),
              ),

            SliverToBoxAdapter(child: Gap(R.h(24))),

            // ── Recent Transactions
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: R.w(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Recent Transactions', style: AppTextStyles.heading3),
                    Text('See all',
                        style: AppTextStyles.bodySecondary
                            .copyWith(color: AppColors.primary)),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(child: Gap(R.h(12))),

            provider.monthly.isEmpty
                ? SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(R.w(40)),
                        child: Column(
                          children: [
                            Text('💸',
                                style: TextStyle(fontSize: R.sp(48))),
                            Gap(R.h(12)),
                            Text('No transactions yet',
                                style: AppTextStyles.bodySecondary),
                          ],
                        ),
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        final t = provider.monthly
                            .take(5)
                            .toList()[i];
                        return Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: R.w(20)),
                          child: TransactionCard(
                            transaction: t,
                            onDelete: () => provider.deleteTransaction(
                                t.id!, t.date),
                          ),
                        );
                      },
                      childCount: provider.monthly.length > 5
                          ? 5
                          : provider.monthly.length,
                    ),
                  ),

            SliverToBoxAdapter(child: Gap(R.h(100))),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const AddTransactionScreen())),
        backgroundColor: AppColors.primary,
        icon: Icon(Iconsax.add, color: Colors.white, size: R.sp(20)),
        label: Text('Add', style: AppTextStyles.button),
      ),
    );
  }
}