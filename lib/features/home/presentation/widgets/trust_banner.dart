import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Trust & Certification banner — GIA/IGI compliance callout.
///
/// Deep Vault Blue background with certification badges, matching the
/// reference HTML design's trust section.
/// Enhanced with GIVA-inspired gradient overlays and interactive elements.
class TrustBanner extends StatelessWidget {
  const TrustBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPaddingH,
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.95),
            const Color(0xFF133959),
          ],
        ),
        borderRadius: AppSpacing.borderRadiusLg,
        boxShadow: AppSpacing.elevationPrimary,
      ),
      child: Stack(
        children: [
          // Decorative glow elements
          Positioned(
            top: -40,
            right: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.tertiary.withValues(alpha: 0.12),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -15,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.tertiary.withValues(alpha: 0.2),
                      borderRadius: AppSpacing.borderRadiusMd,
                    ),
                    child: const Icon(
                      Icons.shield_outlined,
                      color: AppColors.tertiary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Investment-Grade Assurance',
                      style: AppTypography.titleLg.copyWith(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Every stone is meticulously graded by GIA or IGI. Full digital certification history available for every purchase.',
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.onPrimary.withValues(alpha: 0.75),
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.unit,
                children: [
                  _CertBadge(
                    icon: Icons.verified,
                    label: 'GIA CERTIFIED',
                    color: AppColors.secondary,
                  ),
                  _CertBadge(
                    icon: Icons.verified_outlined,
                    label: 'IGI GRADED',
                    color: AppColors.tertiary,
                  ),
                  _CertBadge(
                    icon: Icons.lock_outline,
                    label: 'SECURE',
                    color: AppColors.onPrimary,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CertBadge extends StatelessWidget {
  const _CertBadge({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: AppSpacing.borderRadiusPill,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTypography.labelSm.copyWith(
              color: AppColors.onPrimary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
