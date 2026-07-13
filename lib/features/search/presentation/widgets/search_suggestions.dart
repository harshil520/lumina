import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Widget for displaying search suggestions and popular searches.
///
/// Shows popular searches when no query is entered, and suggestions as user types.
class SearchSuggestions extends StatelessWidget {
  const SearchSuggestions({
    required this.popularSearches,
    required this.onSuggestionTap,
    super.key,
  });

  final List<String> popularSearches;
  final ValueChanged<String> onSuggestionTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPaddingH,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.md),
          // Popular Searches Header
          Text(
            'Popular Searches',
            style: AppTypography.titleLg.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          // Popular Search Tags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: popularSearches.map((search) {
              return _buildSearchTag(search);
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.lg),
          // Quick Categories
          Text(
            'Browse Categories',
            style: AppTypography.titleLg.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildCategoryGrid(),
        ],
      ),
    );
  }

  Widget _buildSearchTag(String search) {
    return GestureDetector(
      onTap: () => onSuggestionTap(search),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: AppSpacing.borderRadiusPill,
          border: Border.all(
            color: AppColors.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.trending_up_rounded,
              size: 14,
              color: AppColors.primary,
            ),
            const SizedBox(width: 6),
            Text(
              search,
              style: AppTypography.chip.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    final categories = [
      ('Rings', Icons.favorite_rounded, AppColors.accentRoseGold),
      ('Necklaces', Icons.diamond_rounded, AppColors.primary),
      ('Earrings', Icons.style_rounded, AppColors.tertiary),
      ('Bracelets', Icons.watch_rounded, AppColors.secondary),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return GestureDetector(
          onTap: () => onSuggestionTap(category.$1.toLowerCase()),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppSpacing.borderRadiusCard,
              boxShadow: AppSpacing.elevationSm,
              border: Border.all(
                color: AppColors.surfaceContainerHigh,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: category.$3.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    category.$2,
                    color: category.$3,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  category.$1,
                  style: AppTypography.labelMd.copyWith(
                    color: AppColors.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
