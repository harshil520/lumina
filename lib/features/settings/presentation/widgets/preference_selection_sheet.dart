import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// A bottom sheet that presents a list of selectable options with the
/// currently selected value visually marked. Used for language and currency
/// selection in settings.
class PreferenceSelectionSheet<T> extends StatelessWidget {
  const PreferenceSelectionSheet({
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.labelBuilder,
    required this.onSelected,
    super.key,
  });

  final String title;
  final List<T> options;
  final T selectedValue;
  final String Function(T option) labelBuilder;
  final ValueChanged<T> onSelected;

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required List<T> options,
    required T selectedValue,
    required String Function(T option) labelBuilder,
    required ValueChanged<T> onSelected,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLg)),
      ),
      builder: (_) => PreferenceSelectionSheet<T>(
        title: title,
        options: options,
        selectedValue: selectedValue,
        labelBuilder: labelBuilder,
        onSelected: onSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.35,
      maxChildSize: 0.85,
      expand: false,
      builder: (context, scrollController) => Column(
        children: [
          const SizedBox(height: AppSpacing.sm),
          Container(
            width: 32,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.outlineVariant,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
            child: Text(
              title,
              style: AppTypography.titleLg.copyWith(color: AppColors.primary),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const Divider(height: 1, color: AppColors.surfaceContainerHigh),
          Expanded(
            child: ListView.separated(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              itemCount: options.length,
              separatorBuilder: (_, _) => const Divider(height: 1, indent: AppSpacing.gutter, endIndent: AppSpacing.gutter, color: AppColors.surfaceContainerHighest),
              itemBuilder: (context, index) {
                final option = options[index];
                final isSelected = option == selectedValue;
                return _OptionTile(
                  label: labelBuilder(option),
                  isSelected: isSelected,
                  onTap: isSelected
                      ? null
                      : () {
                          onSelected(option);
                          Navigator.of(context).pop();
                        },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({required this.label, required this.isSelected, this.onTap});

  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.bodyLg.copyWith(
                    color: isSelected ? AppColors.primary : AppColors.onSurface,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              if (isSelected)
                Icon(Icons.check_circle, color: AppColors.tertiary, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}
