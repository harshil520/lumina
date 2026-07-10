import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/shimmer_image.dart';
import '../../../home/domain/models/gemstone_summary.dart';

/// Horizontal list of similar stone cards at the bottom of the detail screen.
///
/// Enhanced with GIVA-inspired card styling and interactive hover effects.
class SimilarStonesSection extends StatelessWidget {
  const SimilarStonesSection({super.key, required this.stones});

  final List<GemstoneSummary> stones;

  @override
  Widget build(BuildContext context) {
    if (stones.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 260,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPaddingH,
        ),
        itemCount: stones.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) => _SimilarStoneCard(
          stone: stones[index],
        ),
      ),
    );
  }
}

class _SimilarStoneCard extends StatefulWidget {
  const _SimilarStoneCard({required this.stone});

  final GemstoneSummary stone;

  @override
  State<_SimilarStoneCard> createState() => _SimilarStoneCardState();
}

class _SimilarStoneCardState extends State<_SimilarStoneCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          RouteNames.gemstoneDetail,
          pathParameters: {'id': widget.stone.id},
        );
      },
      onTapDown: (_) => setState(() => _isHovered = true),
      onTapUp: (_) => setState(() => _isHovered = false),
      onTapCancel: () => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: SizedBox(
          width: 170,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: AppSpacing.borderRadiusMd,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ShimmerImage(
                        imageUrl: widget.stone.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                      // Certification badge
                      Positioned(
                        top: 6,
                        left: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryContainer,
                            borderRadius: AppSpacing.borderRadiusPill,
                          ),
                          child: Text(
                            widget.stone.certificationBadge,
                            style: AppTypography.badge.copyWith(
                              color: AppColors.onSecondaryContainer,
                              fontSize: 8,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.stone.name,
                style: AppTypography.bodyMd.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                '${widget.stone.weight} · ${widget.stone.cut}',
                style: AppTypography.overline.copyWith(
                  color: AppColors.outline,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                '\$${widget.stone.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                style: AppTypography.priceSm.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
