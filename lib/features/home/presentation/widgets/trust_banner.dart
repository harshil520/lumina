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
              Text(
                'Investment-Grade Assurance',
                style: AppTypography.headlineLg.copyWith(
                  color: AppColors.onPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Every stone at Lumina is meticulously graded by GIA or IGI. Full digital certification history available for every purchase.',
                style: AppTypography.bodyMd.copyWith(
                  color: AppColors.onPrimary.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.unit,
                children: const [
                  _CertBadge(label: 'GIA CERTIFIED'),
                  _CertBadge(label: 'IGI GRADED'),
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
  const _CertBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: AppSpacing.borderRadiusPill,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.25),
        ),
      ),
      child: Text(
        label,
        style: AppTypography.labelSm.copyWith(
          color: AppColors.onPrimary,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}
