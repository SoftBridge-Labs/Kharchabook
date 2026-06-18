import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_responsive.dart';
import '../dashboard/dashboard_screen.dart';
import '../transactions/transactions_screen.dart';
import '../budget/budget_screen.dart';
import '../reports/reports_screen.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    TransactionsScreen(),
    BudgetScreen(),
    ReportsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    R.init(context);
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: AppColors.shadow,
                blurRadius: R.r(12),
                offset: Offset(0, -R.h(2)))
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: [
            BottomNavigationBarItem(
                icon: Icon(Iconsax.home, size: R.sp(22)),
                activeIcon: Icon(Iconsax.home5, size: R.sp(22)),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Iconsax.receipt, size: R.sp(22)),
                activeIcon: Icon(Iconsax.receipt5, size: R.sp(22)),
                label: 'Transactions'),
            BottomNavigationBarItem(
                icon: Icon(Iconsax.wallet, size: R.sp(22)),
                activeIcon: Icon(Iconsax.wallet5, size: R.sp(22)),
                label: 'Budget'),
            BottomNavigationBarItem(
                icon: Icon(Iconsax.chart, size: R.sp(22)),
                activeIcon: Icon(Iconsax.chart5, size: R.sp(22)),
                label: 'Reports'),
            BottomNavigationBarItem(
                icon: Icon(Iconsax.setting, size: R.sp(22)),
                activeIcon: Icon(Iconsax.setting5, size: R.sp(22)),
                label: 'Settings'),
          ],
        ),
      ),
    );
  }
}