import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/app_responsive.dart';
import '../../providers/category_provider.dart';
import '../../data/models/category_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    R.init(context);
    final catProvider = context.watch<CategoryProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Settings', style: AppTextStyles.heading3),
      ),
      body: ListView(
        padding: EdgeInsets.all(R.w(20)),
        children: [
          // App Info Card
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
            child: Row(
              children: [
                Container(
                  width: R.w(56),
                  height: R.w(56),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(R.r(16)),
                  ),
                  child: Center(
                      child: Text('💰',
                          style: TextStyle(fontSize: R.sp(28)))),
                ),
                Gap(R.w(16)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Kharchabook',
                        style: AppTextStyles.heading3
                            .copyWith(color: Colors.white)),
                    Text('Version 1.0.0',
                        style: AppTextStyles.caption
                            .copyWith(color: Colors.white70)),
                  ],
                ),
              ],
            ),
          ),

          Gap(R.h(24)),
          Text('Categories', style: AppTextStyles.heading3),
          Gap(R.h(12)),

          // Categories List
          ...catProvider.categories.map((cat) => Container(
                margin: EdgeInsets.only(bottom: R.h(8)),
                padding: EdgeInsets.symmetric(
                    horizontal: R.w(16), vertical: R.h(12)),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(R.r(12)),
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.shadow, blurRadius: R.r(4))
                  ],
                ),
                child: Row(
                  children: [
                    Text(cat.icon,
                        style: TextStyle(fontSize: R.sp(22))),
                    Gap(R.w(12)),
                    Expanded(
                        child: Text(cat.name, style: AppTextStyles.body)),
                    IconButton(
                      icon: Icon(Iconsax.trash,
                          color: AppColors.expense, size: R.sp(18)),
                      onPressed: () =>
                          catProvider.delete(cat.id!),
                    ),
                  ],
                ),
              )),

          Gap(R.h(12)),

          // Add Category Button
          OutlinedButton.icon(
            onPressed: () => _showAddCategorySheet(context, catProvider),
            icon: Icon(Iconsax.add, size: R.sp(18)),
            label: Text('Add Category', style: AppTextStyles.body),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(R.r(12))),
              padding: EdgeInsets.symmetric(vertical: R.h(14)),
            ),
          ),

          Gap(R.h(24)),

          // About Tile
          _settingTile(
              icon: Iconsax.info_circle,
              title: 'About',
              subtitle: 'Kharchabook v1.0.0',
              onTap: () {}),
        ],
      ),
    );
  }

  Widget _settingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(R.w(16)),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(R.r(14)),
          boxShadow: [
            BoxShadow(color: AppColors.shadow, blurRadius: R.r(4))
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: R.sp(22)),
            Gap(R.w(14)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.body),
                  Text(subtitle, style: AppTextStyles.caption),
                ],
              ),
            ),
            Icon(Icons.chevron_right,
                color: AppColors.textHint, size: R.sp(20)),
          ],
        ),
      ),
    );
  }

  void _showAddCategorySheet(
      BuildContext context, CategoryProvider provider) {
    final nameCtrl = TextEditingController();
    final icons = ['🏠', '🎮', '📚', '✈️', '💪', '🎵', '🐾', '💼'];
    String selectedIcon = '🏠';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(R.r(24)))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => Padding(
          padding: EdgeInsets.only(
            left: R.w(20),
            right: R.w(20),
            top: R.h(20),
            bottom: MediaQuery.of(ctx).viewInsets.bottom + R.h(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: R.w(40),
                  height: R.h(4),
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(R.r(4)),
                  ),
                ),
              ),
              Gap(R.h(16)),
              Text('Add Category', style: AppTextStyles.heading3),
              Gap(R.h(16)),
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  hintText: 'Category name',
                  hintStyle: AppTextStyles.caption,
                ),
              ),
              Gap(R.h(16)),
              Text('Pick Icon', style: AppTextStyles.bodySecondary),
              Gap(R.h(8)),
              Wrap(
                spacing: R.w(10),
                children: icons.map((icon) {
                  final sel = selectedIcon == icon;
                  return GestureDetector(
                    onTap: () => setModal(() => selectedIcon = icon),
                    child: Container(
                      width: R.w(44),
                      height: R.w(44),
                      decoration: BoxDecoration(
                        color: sel
                            ? AppColors.primary
                            : AppColors.background,
                        borderRadius: BorderRadius.circular(R.r(10)),
                      ),
                      child: Center(
                          child: Text(icon,
                              style: TextStyle(fontSize: R.sp(22)))),
                    ),
                  );
                }).toList(),
              ),
              Gap(R.h(20)),
              SizedBox(
                width: double.infinity,
                height: R.h(50),
                child: ElevatedButton(
                  onPressed: () {
                    if (nameCtrl.text.trim().isNotEmpty) {
                      provider.add(CategoryModel(
                        name: nameCtrl.text.trim(),
                        icon: selectedIcon,
                        color: 'primary',
                      ));
                      Navigator.pop(ctx);
                    }
                  },
                  child: Text('Add', style: AppTextStyles.button),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}