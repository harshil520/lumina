import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/shimmer_image.dart';
import '../../domain/models/search_result.dart';

/// Card widget for displaying a search result item in a horizontal list tile format.
///
/// Implements the premium, high-trust design of the CaratVault ecosystem
/// with a 1:1 image, certification badge, favorite toggle, title, price,
/// and a horizontal specification row.
class SearchResultListTile extends StatefulWidget {
  const SearchResultListTile({
    required this.result,
    required this.onTap,
    super.key,
  });

  final SearchResult result;
  final VoidCallback onTap;

  @override
  State<SearchResultListTile> createState() => _SearchResultListTileState();
}

class _SearchResultListTileState extends State<SearchResultListTile> {
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
        scale: _isHovered ? 1.01 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(10),
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1:1 Image Container
              SizedBox(
                width: 90,
                height: 90,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: AppSpacing.borderRadiusMd,
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
                        top: 6,
                        right: 6,
                        child: GestureDetector(
                          onTap: () {
                            setState(() => _isFavorited = !_isFavorited);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.8),
                              shape: BoxShape.circle,
                              boxShadow: AppSpacing.elevationSm,
                            ),
                            child: Icon(
                              _isFavorited ? Icons.favorite : Icons.favorite_border,
                              color: _isFavorited ? AppColors.error : AppColors.primary,
                              size: 14,
                            ),
                          ),
                        ),
                      ),
                      // Certification Badge
                      if (widget.result.badge != null)
                        Positioned(
                          bottom: 6,
                          left: 6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _getBadgeBgColor(),
                              borderRadius: AppSpacing.borderRadiusSm,
                            ),
                            child: Text(
                              widget.result.badge!.toUpperCase(),
                              style: AppTypography.labelSm.copyWith(
                                color: _getBadgeTextColor(),
                                fontSize: 8,
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
              const SizedBox(width: 12),
              // Content Area
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Title & Price
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
                        const SizedBox(width: 8),
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
                    Text(
                      widget.result.subtitle,
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    // Specifications Row
                    Row(
                      children: [
                        Expanded(child: _buildSpecItem(displaySpecs[0].key, displaySpecs[0].value)),
                        Expanded(child: _buildSpecItem(displaySpecs[1].key, displaySpecs[1].value)),
                        Expanded(child: _buildSpecItem(displaySpecs[2].key, displaySpecs[2].value)),
                        Expanded(child: _buildSpecItem(displaySpecs[3].key, displaySpecs[3].value)),
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
            fontSize: 10,
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
