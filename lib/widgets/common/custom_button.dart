import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/app_responsive.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isOutlined;
  final Color? color;
  final double? width;
  final Widget? icon;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isOutlined = false,
    this.color,
    this.width,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: R.h(52),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isOutlined ? Colors.transparent : (color ?? AppColors.primary),
          foregroundColor:
              isOutlined ? AppColors.primary : Colors.white,
          side: isOutlined
              ? const BorderSide(color: AppColors.primary)
              : null,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(R.r(12))),
          elevation: isOutlined ? 0 : 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[icon!, SizedBox(width: R.w(8))],
            Text(text,
                style: AppTextStyles.button.copyWith(
                    color: isOutlined ? AppColors.primary : Colors.white)),
          ],
        ),
      ),
    );
  }
}