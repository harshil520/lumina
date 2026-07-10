import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/shimmer_image.dart';
import '../../domain/models/gemstone_detail.dart';

/// Seller profile card with avatar, name, rating, and tagline.
///
/// Enhanced with GIVA-inspired premium styling and gradient accents.
class SellerProfileCard extends StatelessWidget {
  const SellerProfileCard({super.key, required this.seller});

  final SellerInfo seller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusCard,
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.3),
        ),
        boxShadow: AppSpacing.elevationSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: AppSpacing.borderRadiusPill,
                ),
                child: Text(
                  'LISTED BY',
                  style: AppTypography.overline.copyWith(
                    color: AppColors.outline,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
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
                    const SizedBox(width: 3),
                    Text(
                      'VERIFIED',
                      style: AppTypography.badge.copyWith(
                        color: AppColors.onSecondaryContainer,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Avatar with ring
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.tertiaryGradient,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: ShimmerImage(
                      imageUrl: seller.avatarUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      seller.name,
                      style: AppTypography.bodyMd.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            index < seller.rating.round()
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            size: 14,
                            color: AppColors.accentAmber,
                          );
                        }),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            '${seller.rating} (${seller.reviewCount} reviews)',
                            style: AppTypography.dataMono.copyWith(
                              color: AppColors.onSurfaceVariant,
                              fontSize: 11,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: AppSpacing.borderRadiusMd,
            ),
            child: Text(
              '"${seller.tagline}"',
              style: AppTypography.bodySm.copyWith(
                color: AppColors.onSurfaceVariant,
                fontStyle: FontStyle.italic,
                height: 1.5,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary, width: 1.5),
                borderRadius: AppSpacing.borderRadiusDefault,
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'VIEW ALL LISTINGS',
                    style: AppTypography.labelSm.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
