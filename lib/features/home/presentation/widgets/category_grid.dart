import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPaddingH,
        ),
        child: Column(
          children: categories.asMap().entries.map((entry) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: entry.key < categories.length - 1 ? 16 : 0,
              ),
              child: SizedBox(
                height: 180,
                width: double.infinity,
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

    return SizedBox(
      height: 240,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPaddingH,
        ),
        child: Row(
          children: categories.asMap().entries.map((entry) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: entry.key < categories.length - 1 ? 16 : 0,
                ),
                child: _CategoryCard(
                  category: entry.value,
                  index: entry.key,
                ),
              ),
            );
          }).toList(),
        ),
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
      onTap: () {
        context.push('/search?category=${Uri.encodeComponent(widget.category.name)}');
      },
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
            borderRadius: AppSpacing.borderRadiusLg,
            boxShadow: _isHovered
                ? AppSpacing.elevationMd
                : AppSpacing.elevationSm,
          ),
          child: ClipRRect(
            borderRadius: AppSpacing.borderRadiusLg,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ShimmerImage(
                  imageUrl: widget.category.imageUrl,
                  fit: BoxFit.cover,
                ),
                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppColors.primary.withValues(alpha: 0.1),
                        AppColors.primary.withValues(alpha: 0.8),
                      ],
                      stops: const [0.0, 0.4, 1.0],
                    ),
                  ),
                ),
                // Labels
                Positioned(
                  left: 20,
                  bottom: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.category.subtitle.toUpperCase(),
                        style: AppTypography.overline.copyWith(
                          color: AppColors.onPrimary.withValues(alpha: 0.8),
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.category.name,
                        style: AppTypography.headlineLg.copyWith(
                          color: AppColors.onPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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
