import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/shimmer_image.dart';
import '../../domain/models/search_result.dart';

/// Card widget for displaying a search result item in a multi-column grid.
///
/// Implements the premium, high-trust design of the CaratVault ecosystem
/// with an aspect-square image container, certification badge, favorite toggle,
/// title, price, and a dense 2x2 specification grid.
class SearchResultCard extends StatefulWidget {
  const SearchResultCard({
    required this.result,
    required this.onTap,
    super.key,
  });

  final SearchResult result;
  final VoidCallback onTap;

  @override
  State<SearchResultCard> createState() => _SearchResultCardState();
}

class _SearchResultCardState extends State<SearchResultCard> {
  bool _isHovered = false;
  bool _isFavorited = false;

  @override
  Widget build(BuildContext context) {
    // Generate the list of display specs from the SearchResult
    final specsList = widget.result.specs?.entries.toList() ?? [];
    final displaySpecs = <MapEntry<String, String>>[];
    
    if (specsList.isNotEmpty) {
      displaySpecs.addAll(specsList.take(4));
    } else {
      // Sane default fallback specs
      displaySpecs.add(MapEntry('CLARITY', widget.result.cut ?? 'VVS1'));
      displaySpecs.add(MapEntry('COLOR', widget.result.cut ?? 'D'));
      displaySpecs.add(MapEntry('CUT', widget.result.cut ?? 'Excellent'));
      displaySpecs.add(MapEntry('FLUORESCENCE', widget.result.certification ?? 'None'));
    }

    // Pad with empty entries if less than 4 to avoid out of bounds
    while (displaySpecs.length < 4) {
      displaySpecs.add(const MapEntry('', ''));
    }

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _isHovered = true),
      onTapUp: (_) => setState(() => _isHovered = false),
      onTapCancel: () => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: AppSpacing.borderRadiusLg,
            border: Border.all(
              color: _isHovered
                  ? AppColors.primary.withValues(alpha: 0.2)
                  : AppColors.outlineVariant.withValues(alpha: 0.15),
              width: 1,
            ),
            boxShadow: _isHovered ? AppSpacing.elevationMd : AppSpacing.elevationSm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Aspect-Square Image Container
              AspectRatio(
                aspectRatio: 1.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: AppSpacing.borderRadiusLg,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Gemstone Image
                      ShimmerImage(
                        imageUrl: widget.result.imageUrl,
                        fit: BoxFit.cover,
                      ),
                      // Favorite Toggle Button
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () {
                            setState(() => _isFavorited = !_isFavorited);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.8),
                              shape: BoxShape.circle,
                              boxShadow: AppSpacing.elevationSm,
                            ),
                            child: Icon(
                              _isFavorited ? Icons.favorite : Icons.favorite_border,
                              color: _isFavorited ? AppColors.error : AppColors.primary,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                      // Certification / Provenance Badge
                      if (widget.result.badge != null)
                        Positioned(
                          bottom: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: _getBadgeBgColor(),
                              borderRadius: AppSpacing.borderRadiusSm,
                            ),
                            child: Text(
                              widget.result.badge!.toUpperCase(),
                              style: AppTypography.labelSm.copyWith(
                                color: _getBadgeTextColor(),
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 4),
              // Title & Price Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      widget.result.title,
                      style: AppTypography.titleLg.copyWith(
                        fontFamily: 'Playfair Display',
                        fontSize: 13,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      '\$${widget.result.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                      style: AppTypography.titleLg.copyWith(
                        fontFamily: 'Playfair Display',
                        fontSize: 13,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              // Specification Grid (2 columns x 2 rows)
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildSpecItem(displaySpecs[0].key, displaySpecs[0].value)),
                      Expanded(child: _buildSpecItem(displaySpecs[1].key, displaySpecs[1].value)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Expanded(child: _buildSpecItem(displaySpecs[2].key, displaySpecs[2].value)),
                      Expanded(child: _buildSpecItem(displaySpecs[3].key, displaySpecs[3].value)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecItem(String label, String value) {
    if (label.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTypography.labelSm.copyWith(
            color: AppColors.onSurfaceVariant,
            fontSize: 8,
            letterSpacing: 0.5,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 1),
        Text(
          value,
          style: AppTypography.dataMono.copyWith(
            color: AppColors.primary,
            fontSize: 11,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Color _getBadgeBgColor() {
    final badgeText = widget.result.badge?.toUpperCase() ?? '';
    if (badgeText.contains('GIA') || badgeText.contains('IGI')) {
      return AppColors.tertiaryFixed;
    } else if (badgeText.contains('LAB')) {
      return AppColors.secondaryFixed;
    }
    return AppColors.primaryFixed;
  }

  Color _getBadgeTextColor() {
    final badgeText = widget.result.badge?.toUpperCase() ?? '';
    if (badgeText.contains('GIA') || badgeText.contains('IGI')) {
      return AppColors.onTertiaryFixed;
    } else if (badgeText.contains('LAB')) {
      return AppColors.onSecondaryFixed;
    }
    return AppColors.onPrimaryFixed;
  }
}
