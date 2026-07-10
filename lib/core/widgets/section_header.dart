import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Reusable section header with a title and optional trailing action.
///
/// Used across home sections: "Shop by Category", "Featured Collections", etc.
/// Enhanced with gradient accent line and premium typography.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onActionTap,
    this.showAccentLine = true,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;
  final bool showAccentLine;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                title,
                style: AppTypography.headlineMd.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (actionLabel != null)
              GestureDetector(
                onTap: onActionTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer.withValues(alpha: 0.5),
                    borderRadius: AppSpacing.borderRadiusPill,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        actionLabel!.toUpperCase(),
                        style: AppTypography.labelSm.copyWith(
                          color: AppColors.primary,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 8,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        if (showAccentLine) ...[
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 3,
            decoration: BoxDecoration(
              gradient: AppColors.tertiaryGradient,
              borderRadius: AppSpacing.borderRadiusPill,
            ),
          ),
        ],
      ],
    );
  }
}
