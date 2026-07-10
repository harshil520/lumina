import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
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
        _DetailRow(label: 'Polish', value: polish, icon: Icons.auto_fix_high),
        const SizedBox(height: 2),
        _DetailRow(label: 'Symmetry', value: symmetry, icon: Icons.grid_view),
        const SizedBox(height: 2),
        _DetailRow(
            label: 'Fluorescence', value: fluorescence, icon: Icons.wb_sunny_outlined),
        const SizedBox(height: 2),
        _DetailRow(
          label: 'GIA Report',
          value: giaReportNumber,
          isLink: true,
          icon: Icons.description_outlined,
        ),
      ],
    );
  }
}

class _DetailRow extends StatefulWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    required this.icon,
    this.isLink = false,
  });

  final String label;
  final String value;
  final IconData icon;
  final bool isLink;

  @override
  State<_DetailRow> createState() => _DetailRowState();
}

class _DetailRowState extends State<_DetailRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: _isHovered
              ? AppColors.surfaceContainerLow
              : Colors.transparent,
          borderRadius: AppSpacing.borderRadiusMd,
        ),
        child: Row(
          children: [
            Icon(
              widget.icon,
              size: 14,
              color: AppColors.outline,
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                widget.label,
                style: AppTypography.bodyMd.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                widget.value,
                style: AppTypography.dataMono.copyWith(
                  color: widget.isLink ? AppColors.secondary : AppColors.primary,
                  decoration: widget.isLink ? TextDecoration.underline : null,
                  decorationColor:
                      widget.isLink ? AppColors.secondary.withValues(alpha: 0.3) : null,
                  fontWeight: widget.isLink ? FontWeight.w600 : FontWeight.w500,
                ),
                textAlign: TextAlign.end,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (widget.isLink) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.open_in_new,
                size: 12,
                color: AppColors.secondary.withValues(alpha: 0.6),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
