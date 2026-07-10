import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Search bar widget styled per DESIGN.md input-field tokens.
///
/// Enhanced with gradient border glow and GIVA-inspired rounded styling.
class HomeSearchBar extends StatefulWidget {
  const HomeSearchBar({super.key});

  @override
  State<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _isFocused = true),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        height: 56,
        decoration: BoxDecoration(
          color: _isFocused
              ? AppColors.surface
              : AppColors.surfaceContainerLow,
          borderRadius: AppSpacing.borderRadiusLg,
          boxShadow: _isFocused ? AppSpacing.elevationPrimary : AppSpacing.elevationSm,
          border: Border.all(
            color: _isFocused
                ? AppColors.primary.withValues(alpha: 0.3)
                : AppColors.outlineVariant.withValues(alpha: 0.2),
            width: _isFocused ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 18),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: AppSpacing.borderRadiusMd,
              ),
              child: const Icon(
                Icons.search,
                color: AppColors.primary,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Search diamonds, gemstones...',
                style: AppTypography.bodyMd.copyWith(
                  color: AppColors.outline.withValues(alpha: 0.5),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: AppSpacing.borderRadiusMd,
              ),
              child: const Icon(
                Icons.tune,
                color: AppColors.onPrimary,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
