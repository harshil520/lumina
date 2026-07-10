import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/shimmer_image.dart';

/// Image gallery with large hero image and thumbnail strip.
///
/// Enhanced with GIVA-inspired gradient overlays and interactive elements.
class GemstoneImageGallery extends StatefulWidget {
  const GemstoneImageGallery({
    super.key,
    required this.imageUrls,
    required this.certificationBadge,
  });

  final List<String> imageUrls;
  final String certificationBadge;

  @override
  State<GemstoneImageGallery> createState() => _GemstoneImageGalleryState();
}

class _GemstoneImageGalleryState extends State<GemstoneImageGallery> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Hero image
        AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: AppSpacing.borderRadiusLg,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ShimmerImage(
                  imageUrl: widget.imageUrls.isNotEmpty
                      ? widget.imageUrls[_selectedIndex]
                      : '',
                  fit: BoxFit.cover,
                ),
                // Bottom gradient for depth
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.3),
                        ],
                      ),
                    ),
                  ),
                ),
                // Certification badge
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryContainer.withValues(alpha: 0.95),
                      borderRadius: AppSpacing.borderRadiusPill,
                      boxShadow: AppSpacing.elevationSm,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.verified,
                          size: 14,
                          color: AppColors.secondary,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            widget.certificationBadge,
                            style: AppTypography.labelSm.copyWith(
                              color: AppColors.onSecondaryContainer,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // 360 View button
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(alpha: 0.92),
                      borderRadius: AppSpacing.borderRadiusPill,
                      boxShadow: AppSpacing.elevationMd,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.threesixty,
                            size: 12,
                            color: AppColors.onPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '360° VIEW',
                          style: AppTypography.labelSm.copyWith(
                            color: AppColors.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Image counter
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: AppSpacing.borderRadiusPill,
                    ),
                    child: Text(
                      '${_selectedIndex + 1}/${widget.imageUrls.length}',
                      style: AppTypography.badge.copyWith(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.unit),
        // Thumbnails
        SizedBox(
          height: 72,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: widget.imageUrls.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.unit),
            itemBuilder: (context, index) {
              final isSelected = index == _selectedIndex;
              return GestureDetector(
                onTap: () => setState(() => _selectedIndex = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 72,
                  decoration: BoxDecoration(
                    borderRadius: AppSpacing.borderRadiusMd,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.outlineVariant.withValues(alpha: 0.3),
                      width: isSelected ? 2.5 : 1,
                    ),
                    boxShadow: isSelected ? AppSpacing.elevationGlow : null,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: ShimmerImage(
                    imageUrl: widget.imageUrls[index],
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
