import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_responsive.dart';
import 'views/splash/splash_screen.dart';

class KharchabookApp extends StatelessWidget {
  const KharchabookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kharchabook',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: Builder(
        builder: (context) {
          R.init(context);
          return const SplashScreen();
        },
      ),
    );
  }
}