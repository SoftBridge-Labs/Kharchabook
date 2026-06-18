import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../utils/app_responsive.dart';

class AppTextStyles {
  static TextStyle get heading1 => GoogleFonts.poppins(
    fontSize: R.sp(26), fontWeight: FontWeight.bold, color: AppColors.textPrimary);

  static TextStyle get heading2 => GoogleFonts.poppins(
    fontSize: R.sp(20), fontWeight: FontWeight.w600, color: AppColors.textPrimary);

  static TextStyle get heading3 => GoogleFonts.poppins(
    fontSize: R.sp(16), fontWeight: FontWeight.w600, color: AppColors.textPrimary);

  static TextStyle get body => GoogleFonts.poppins(
    fontSize: R.sp(14), fontWeight: FontWeight.w400, color: AppColors.textPrimary);

  static TextStyle get bodySecondary => GoogleFonts.poppins(
    fontSize: R.sp(13), fontWeight: FontWeight.w400, color: AppColors.textSecondary);

  static TextStyle get caption => GoogleFonts.poppins(
    fontSize: R.sp(11), fontWeight: FontWeight.w400, color: AppColors.textHint);

  static TextStyle get button => GoogleFonts.poppins(
    fontSize: R.sp(15), fontWeight: FontWeight.w600, color: Colors.white);

  static TextStyle get amount => GoogleFonts.poppins(
    fontSize: R.sp(30), fontWeight: FontWeight.bold, color: AppColors.textPrimary);
}