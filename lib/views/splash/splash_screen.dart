import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/app_responsive.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/category_provider.dart';
import '../home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _scaleAnim = Tween<double>(begin: 0.8, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _controller.forward();
    _init();
  }

  Future<void> _init() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    await context.read<TransactionProvider>().loadAll();
    await context.read<TransactionProvider>().loadByMonth(
        DateTime.now().month, DateTime.now().year);
    await context.read<CategoryProvider>().load();
    if (!mounted) return;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    R.init(context);
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: ScaleTransition(
            scale: _scaleAnim,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: R.w(90),
                  height: R.w(90),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(R.r(28)),
                  ),
                  child: Center(
                    child: Text('💰', style: TextStyle(fontSize: R.sp(48))),
                  ),
                ),
                SizedBox(height: R.h(24)),
                Text('Kharchabook',
                    style: AppTextStyles.heading1
                        .copyWith(color: Colors.white, fontSize: R.sp(32))),
                SizedBox(height: R.h(8)),
                Text('Apna Kharch Samjho',
                    style: AppTextStyles.bodySecondary
                        .copyWith(color: Colors.white70)),
                SizedBox(height: R.h(60)),
                SizedBox(
                  width: R.w(24),
                  height: R.w(24),
                  child: const CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}