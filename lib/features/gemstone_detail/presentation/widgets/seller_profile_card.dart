import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: AppSpacing.borderRadiusXl,
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'LISTED BY',
            style: AppTypography.labelSm.copyWith(
              color: AppColors.outline,
              fontSize: 12,
              letterSpacing: 0.8,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Avatar
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.outlineVariant.withValues(alpha: 0.4),
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: ShimmerImage(
                  imageUrl: seller.avatarUrl,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      seller.name,
                      style: AppTypography.titleLg.copyWith(
                        color: AppColors.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 16,
                          color: AppColors.tertiary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${seller.rating} (${seller.reviewCount} reviews)',
                          style: AppTypography.dataMono.copyWith(
                            color: AppColors.outline,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            '"${seller.tagline}"',
            style: AppTypography.bodySm.copyWith(
              color: AppColors.onSurfaceVariant,
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () {
              context.push('/seller-listings?name=${Uri.encodeComponent(seller.name)}');
            },
            child: Container(
              height: 48,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary, width: 1),
                borderRadius: AppSpacing.borderRadiusDefault,
              ),
              alignment: Alignment.center,
              child: Text(
                'VIEW ALL LISTINGS',
                style: AppTypography.labelSm.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
