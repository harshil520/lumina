import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/shimmer_image.dart';
import '../../domain/models/gemstone_summary.dart';

/// Individual product card for trending gemstones.
///
/// Displays image, certification badge, weight/cut specs, price, and
/// a favorite toggle. Navigates to gemstone detail on tap.
/// Enhanced with GIVA-inspired product card styling, sale badges,
/// and interactive hover effects.
class GemstoneCard extends StatefulWidget {
  const GemstoneCard({super.key, required this.gemstone});

  final GemstoneSummary gemstone;

  @override
  State<GemstoneCard> createState() => _GemstoneCardState();
}

class _GemstoneCardState extends State<GemstoneCard> {
  bool _isHovered = false;
  bool _isFavorited = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          RouteNames.gemstoneDetail,
          pathParameters: {'id': widget.gemstone.id},
        );
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
            color: AppColors.surface,
            borderRadius: AppSpacing.borderRadiusCard,
            border: Border.all(
              color: _isHovered
                  ? AppColors.primary.withValues(alpha: 0.2)
                  : AppColors.outlineVariant.withValues(alpha: 0.3),
            ),
            boxShadow: _isHovered ? AppSpacing.elevationMd : AppSpacing.elevationSm,
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image section
              AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ShimmerImage(
                      imageUrl: widget.gemstone.imageUrl,
                      fit: BoxFit.cover,
                    ),
                    // Subtle gradient overlay on hover
                    AnimatedOpacity(
                      opacity: _isHovered ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppColors.primary.withValues(alpha: 0.3),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Certification badge
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryContainer,
                          borderRadius: AppSpacing.borderRadiusPill,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.verified,
                              size: 10,
                              color: AppColors.secondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.gemstone.certificationBadge,
                              style: AppTypography.badge.copyWith(
                                color: AppColors.onSecondaryContainer,
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Favorite heart
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _isFavorited = !_isFavorited);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: _isFavorited
                                ? AppColors.error.withValues(alpha: 0.9)
                                : AppColors.surface.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                            boxShadow: AppSpacing.elevationSm,
                          ),
                          child: Icon(
                            _isFavorited
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: _isFavorited
                                ? Colors.white
                                : AppColors.onSurfaceVariant,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                    // "New" badge for first item
                    if (widget.gemstone.id == 'nova-brilliant')
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppColors.tertiaryGradient,
                            borderRadius: AppSpacing.borderRadiusPill,
                          ),
                          child: Text(
                            'NEW',
                            style: AppTypography.badge.copyWith(
                              color: AppColors.onPrimary,
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Info section
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.gemstone.name,
                      style: AppTypography.bodyMd.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    // Specs row with dividers
                    Row(
                      children: [
                        _SpecItem(label: 'WEIGHT', value: widget.gemstone.weight),
                        Container(
                          width: 1,
                          height: 24,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          color: AppColors.outlineVariant.withValues(alpha: 0.3),
                        ),
                        _SpecItem(label: 'CUT', value: widget.gemstone.cut),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Price with formatted currency
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${widget.gemstone.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                          style: AppTypography.priceMd.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.08),
                            borderRadius: AppSpacing.borderRadiusPill,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.trending_up,
                                size: 10,
                                color: AppColors.success,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                'In Stock',
                                style: AppTypography.badge.copyWith(
                                  color: AppColors.success,
                                  fontSize: 9,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SpecItem extends StatelessWidget {
  const _SpecItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.overline.copyWith(
            color: AppColors.outline,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTypography.dataMono.copyWith(
            color: AppColors.primary,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
