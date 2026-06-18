import 'package:flutter/material.dart';

class R {
  static late double _w;
  static late double _h;
  static const double _baseWidth = 390.0;
  static const double _baseHeight = 844.0;

  static void init(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _w = size.width;
    _h = size.height;
  }

  static double w(double val) => val * (_w / _baseWidth);
  static double h(double val) => val * (_h / _baseHeight);
  static double sp(double val) => val * (_w / _baseWidth);
  static double r(double val) => val * (_w / _baseWidth);

  static bool get isMobile => _w < 600;
  static bool get isTablet => _w >= 600;

  static double get screenWidth => _w;
  static double get screenHeight => _h;
}