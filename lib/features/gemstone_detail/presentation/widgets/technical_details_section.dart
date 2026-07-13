import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Technical specification rows: Polish, Symmetry, Fluorescence, GIA Report.
///
/// Enhanced with GIVA-inspired styling and subtle visual hierarchy.
class TechnicalDetailsSection extends StatelessWidget {
  const TechnicalDetailsSection({
    super.key,
    required this.polish,
    required this.symmetry,
    required this.fluorescence,
    required this.giaReportNumber,
  });

  final String polish;
  final String symmetry;
  final String fluorescence;
  final String giaReportNumber;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _DetailRow(label: 'Polish', value: polish),
        const SizedBox(height: 10),
        _DetailRow(label: 'Symmetry', value: symmetry),
        const SizedBox(height: 10),
        _DetailRow(label: 'Fluorescence', value: fluorescence),
        const SizedBox(height: 10),
        _DetailRow(
          label: 'GIA Report',
          value: giaReportNumber,
          isLink: true,
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.isLink = false,
  });

  final String label;
  final String value;
  final bool isLink;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.bodyMd.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: AppTypography.dataMono.copyWith(
              color: AppColors.primary,
              decoration: isLink ? TextDecoration.underline : null,
              decorationColor: isLink ? AppColors.primary.withValues(alpha: 0.4) : null,
              fontWeight: isLink ? FontWeight.w600 : FontWeight.w500,
            ),
            textAlign: TextAlign.end,
          ),
        ],
      ),
    );
  }
}
