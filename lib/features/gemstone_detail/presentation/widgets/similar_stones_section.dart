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
      height: 310,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPaddingH,
        ),
        itemCount: stones.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
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
          width: 180,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 0.8,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: AppSpacing.borderRadiusCard,
                    border: Border.all(
                      color: AppColors.outlineVariant.withValues(alpha: 0.15),
                    ),
                    boxShadow: AppSpacing.elevationSm,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: ShimmerImage(
                    imageUrl: widget.stone.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.stone.name,
                style: AppTypography.titleLg.copyWith(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                widget.stone.certificationBadge,
                style: AppTypography.labelSm.copyWith(
                  color: AppColors.outline,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                '\$${widget.stone.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                style: AppTypography.dataMono.copyWith(
                  color: AppColors.primary,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
