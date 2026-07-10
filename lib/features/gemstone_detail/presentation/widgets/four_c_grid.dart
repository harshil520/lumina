import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// 2x2 bento grid displaying the 4Cs (Carat, Color, Clarity, Cut).
///
/// Enhanced with GIVA-inspired gradient cells and decorative elements.
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
                label: 'CARAT WEIGHT',
                value: caratWeight,
                icon: Icons.scale_outlined,
                isHighlighted: true,
              ),
            ),
            const SizedBox(width: AppSpacing.unit),
            Expanded(
              child: _CellCard(
                label: 'COLOR GRADE',
                value: colorGrade,
                icon: Icons.palette_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.unit),
        Row(
          children: [
            Expanded(
              child: _CellCard(
                label: 'CLARITY GRADE',
                value: clarityGrade,
                icon: Icons.visibility_outlined,
              ),
            ),
            const SizedBox(width: AppSpacing.unit),
            Expanded(
              child: _CellCard(
                label: 'CUT GRADE',
                value: cutGrade,
                icon: Icons.content_cut_outlined,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CellCard extends StatefulWidget {
  const _CellCard({
    required this.label,
    required this.value,
    required this.icon,
    this.isHighlighted = false,
  });

  final String label;
  final String value;
  final IconData icon;
  final bool isHighlighted;

  @override
  State<_CellCard> createState() => _CellCardState();
}

class _CellCardState extends State<_CellCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isHovered = true),
      onTapUp: (_) => setState(() => _isHovered = false),
      onTapCancel: () => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: widget.isHighlighted
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryContainer,
                    AppColors.primaryContainer.withValues(alpha: 0.5),
                  ],
                )
              : null,
          color: widget.isHighlighted ? null : AppColors.surfaceContainerLow,
          borderRadius: AppSpacing.borderRadiusMd,
          border: Border.all(
            color: _isHovered
                ? AppColors.primary.withValues(alpha: 0.3)
                : widget.isHighlighted
                    ? AppColors.primary.withValues(alpha: 0.15)
                    : AppColors.outlineVariant.withValues(alpha: 0.2),
            width: _isHovered ? 1.5 : 1,
          ),
          boxShadow: _isHovered ? AppSpacing.elevationSm : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  widget.icon,
                  size: 12,
                  color: widget.isHighlighted
                      ? AppColors.primary
                      : AppColors.outline,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    widget.label,
                    style: AppTypography.overline.copyWith(
                      color: AppColors.outline,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.value,
              style: AppTypography.dataMono.copyWith(
                color: widget.isHighlighted
                    ? AppColors.primary
                    : AppColors.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
