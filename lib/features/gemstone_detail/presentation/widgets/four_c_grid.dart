import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// 2x2 bento grid displaying the 4Cs (Carat, Color, Clarity, Cut).
///
/// Designed to exactly match the look of the luxury HTML layout.
class FourCGrid extends StatelessWidget {
  const FourCGrid({
    super.key,
    required this.caratWeight,
    required this.colorGrade,
    required this.clarityGrade,
    required this.cutGrade,
  });

  final String caratWeight;
  final String colorGrade;
  final String clarityGrade;
  final String cutGrade;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _CellCard(
                label: 'Carat Weight',
                value: caratWeight,
              ),
            ),
            const SizedBox(width: AppSpacing.unit),
            Expanded(
              child: _CellCard(
                label: 'Color Grade',
                value: colorGrade,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.unit),
        Row(
          children: [
            Expanded(
              child: _CellCard(
                label: 'Clarity Grade',
                value: clarityGrade,
              ),
            ),
            const SizedBox(width: AppSpacing.unit),
            Expanded(
              child: _CellCard(
                label: 'Cut Grade',
                value: cutGrade,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CellCard extends StatelessWidget {
  const _CellCard({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: AppSpacing.borderRadiusCard,
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: AppTypography.labelSm.copyWith(
              color: AppColors.outline,
              fontSize: 11,
              letterSpacing: 0.8,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTypography.bodyLg.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
