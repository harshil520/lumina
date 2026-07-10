import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/shimmer_image.dart';
import '../../application/home_providers.dart';
import '../../domain/models/category.dart';

/// 3-card category grid with image backgrounds, gradient overlays, and labels.
///
/// Responsive: stacks vertically on narrow screens, side-by-side on wider ones.
/// Enhanced with GIVA-inspired rounded styling, hover effects, and richer overlays.
class CategoryGrid extends ConsumerWidget {
  const CategoryGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return categoriesAsync.when(
      data: (categories) => _CategoryGridContent(categories: categories),
      loading: () => const SizedBox(
        height: 200,
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 2,
          ),
        ),
      ),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

class _CategoryGridContent extends StatelessWidget {
  const _CategoryGridContent({required this.categories});

  final List<Category> categories;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 600) {
      return SizedBox(
        height: 200,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPaddingH,
          ),
          itemCount: categories.length,
          separatorBuilder: (_, _) => const SizedBox(width: 12),
          itemBuilder: (context, index) => SizedBox(
            width: screenWidth * 0.72,
            child: _CategoryCard(
              category: categories[index],
              index: index,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPaddingH,
      ),
      child: Row(
        children: categories.asMap().entries.map((entry) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: entry.key < categories.length - 1 ? 12 : 0,
              ),
              child: _CategoryCard(
                category: entry.value,
                index: entry.key,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _CategoryCard extends StatefulWidget {
  const _CategoryCard({required this.category, required this.index});

  final Category category;
  final int index;

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isHovered = true),
      onTapUp: (_) => setState(() => _isHovered = false),
      onTapCancel: () => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: AppSpacing.borderRadiusCard,
            boxShadow: _isHovered
                ? AppSpacing.elevationMd
                : AppSpacing.elevationSm,
          ),
          child: ClipRRect(
            borderRadius: AppSpacing.borderRadiusCard,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ShimmerImage(
                  imageUrl: widget.category.imageUrl,
                  fit: BoxFit.cover,
                ),
                // Gradient overlay — richer, more layered
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.transparent,
                        AppColors.primary.withValues(alpha: 0.6),
                        AppColors.primary.withValues(alpha: 0.92),
                      ],
                      stops: const [0.0, 0.35, 0.7, 1.0],
                    ),
                  ),
                ),
                // Labels
                Positioned(
                  left: 16,
                  bottom: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.tertiary.withValues(alpha: 0.9),
                          borderRadius: AppSpacing.borderRadiusPill,
                        ),
                        child: Text(
                          widget.category.subtitle.toUpperCase(),
                          style: AppTypography.badge.copyWith(
                            color: AppColors.onPrimary,
                            fontSize: 9,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.category.name,
                        style: AppTypography.titleLg.copyWith(
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            'Explore',
                            style: AppTypography.labelSm.copyWith(
                              color: AppColors.onPrimary.withValues(alpha: 0.7),
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 10,
                            color: AppColors.onPrimary.withValues(alpha: 0.7),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Top-right accent dot
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.tertiary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.5),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
