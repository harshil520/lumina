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
          aspectRatio: 1.0,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: AppSpacing.borderRadiusLg,
              border: Border.all(
                color: AppColors.outlineVariant.withValues(alpha: 0.15),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ShimmerImage(
                  imageUrl: widget.imageUrls.isNotEmpty
                      ? widget.imageUrls[_selectedIndex]
                      : '',
                  fit: BoxFit.cover,
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
                      color: AppColors.tertiaryContainer.withValues(alpha: 0.15),
                      borderRadius: AppSpacing.borderRadiusPill,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.tertiary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.certificationBadge.toUpperCase(),
                          style: AppTypography.labelSm.copyWith(
                            color: AppColors.tertiary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // 360 View Button
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(alpha: 0.9),
                      borderRadius: AppSpacing.borderRadiusPill,
                      border: Border.all(
                        color: AppColors.outlineVariant.withValues(alpha: 0.3),
                      ),
                      boxShadow: AppSpacing.elevationSm,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.rotate_right_rounded,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Interactive 360° View',
                          style: AppTypography.labelSm.copyWith(
                            color: AppColors.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
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
          child: Row(
            children: List.generate(widget.imageUrls.length, (index) {
              final isSelected = index == _selectedIndex;
              final isVideoPlaceholder = index == widget.imageUrls.length - 1;

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: index == widget.imageUrls.length - 1 ? 0 : AppSpacing.unit,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      if (!isVideoPlaceholder) {
                        setState(() => _selectedIndex = index);
                      } else {
                        // Action for video placeholder
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Playing 3D Video render...'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      }
                    },
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: isVideoPlaceholder
                              ? AppColors.surfaceContainer
                              : Colors.transparent,
                          borderRadius: AppSpacing.borderRadiusMd,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.outlineVariant.withValues(alpha: 0.3),
                            width: isSelected ? 2.0 : 1.0,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        alignment: Alignment.center,
                        child: isVideoPlaceholder
                            ? const Icon(
                                Icons.play_circle_outline_rounded,
                                color: AppColors.outline,
                                size: 28,
                              )
                            : ShimmerImage(
                                imageUrl: widget.imageUrls[index],
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
