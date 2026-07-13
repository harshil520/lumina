import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
      onTap: () {
        setState(() => _isFocused = true);
        context.push('/search');
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) setState(() => _isFocused = false);
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        height: 64,
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
            const SizedBox(width: 24),
            const Icon(
              Icons.search,
              color: AppColors.outline,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'Search for rare emeralds, lab diamonds...',
                style: AppTypography.bodyMd.copyWith(
                  color: AppColors.outline.withValues(alpha: 0.6),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 24),
          ],
        ),
      ),
    );
  }
}
