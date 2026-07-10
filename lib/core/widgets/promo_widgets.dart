import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Reusable promotional banner with gradient background and call-to-action.
///
/// Used for hero sections, flash sales, and featured collection highlights.
class PromotionalBanner extends StatelessWidget {
  const PromotionalBanner({
    super.key,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onActionTap,
    this.gradient,
    this.child,
    this.padding,
  });

  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onActionTap;
  final Gradient? gradient;
  final Widget? child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: gradient ?? AppColors.primaryGradient,
        borderRadius: AppSpacing.borderRadiusLg,
        boxShadow: AppSpacing.elevationPrimary,
      ),
      child: Stack(
        children: [
          // Decorative glow element
          Positioned(
            top: -30,
            right: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Positioned(
            bottom: -20,
            left: 30,
            child: Container(
              width: 60,
              height: 60,
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
                title,
                style: AppTypography.titleLg.copyWith(
                  color: AppColors.onPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.onPrimary.withValues(alpha: 0.8),
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              if (actionLabel != null) ...[
                const SizedBox(height: AppSpacing.sm),
                GestureDetector(
                  onTap: onActionTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.onPrimary,
                      borderRadius: AppSpacing.borderRadiusDefault,
                    ),
                    child: Text(
                      actionLabel!,
                      style: AppTypography.labelSm.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
              if (child != null) ...[
                const SizedBox(height: AppSpacing.sm),
                child!,
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// Small inline badge for tags like "NEW", "SALE", "BESTSELLER".
class PromoBadge extends StatelessWidget {
  const PromoBadge({
    super.key,
    required this.label,
    this.backgroundColor,
    this.foregroundColor,
    this.isSmall = false,
  });

  final String label;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isSmall;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 6 : 10,
        vertical: isSmall ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.tertiaryContainer,
        borderRadius: AppSpacing.borderRadiusPill,
      ),
      child: Text(
        label.toUpperCase(),
        style: (isSmall ? AppTypography.badge : AppTypography.labelSm).copyWith(
          color: foregroundColor ?? AppColors.onTertiaryContainer,
          fontSize: isSmall ? 9 : null,
        ),
      ),
    );
  }
}

/// Rating display with star icon and numeric value.
class RatingBadge extends StatelessWidget {
  const RatingBadge({
    super.key,
    required this.rating,
    this.reviewCount,
    this.size = BadgeSize.small,
  });

  final double rating;
  final int? reviewCount;
  final BadgeSize size;

  @override
  Widget build(BuildContext context) {
    final starSize = size == BadgeSize.small ? 12.0 : 16.0;
    final textStyle = size == BadgeSize.small
        ? AppTypography.dataMono.copyWith(fontSize: 11, color: AppColors.onSurfaceVariant)
        : AppTypography.dataMono.copyWith(color: AppColors.onSurfaceVariant);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.star_rounded,
          size: starSize,
          color: AppColors.accentAmber,
        ),
        const SizedBox(width: 3),
        Text(
          rating.toStringAsFixed(1),
          style: textStyle,
        ),
        if (reviewCount != null) ...[
          const SizedBox(width: 3),
          Text(
            '($reviewCount)',
            style: textStyle.copyWith(
              color: AppColors.outline,
            ),
          ),
        ],
      ],
    );
  }
}

enum BadgeSize { small, large }

/// Price display with optional original price (strikethrough).
class PriceTag extends StatelessWidget {
  const PriceTag({
    super.key,
    required this.price,
    this.originalPrice,
    this.style = PriceTagStyle.regular,
    this.showCurrency = true,
  });

  final double price;
  final double? originalPrice;
  final PriceTagStyle style;
  final bool showCurrency;

  String _formatPrice(double value) {
    final formatted = value
        .toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
    return showCurrency ? '\$$formatted' : formatted;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle mainStyle;
    switch (style) {
      case PriceTagStyle.large:
        mainStyle = AppTypography.priceLg.copyWith(color: AppColors.primary);
        break;
      case PriceTagStyle.regular:
        mainStyle = AppTypography.priceMd.copyWith(color: AppColors.primary);
        break;
      case PriceTagStyle.small:
        mainStyle = AppTypography.priceSm.copyWith(color: AppColors.primary);
        break;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          _formatPrice(price),
          style: mainStyle,
        ),
        if (originalPrice != null && originalPrice! > price) ...[
          const SizedBox(width: 6),
          Padding(
            padding: const EdgeInsets.only(bottom: 1),
            child: Text(
              _formatPrice(originalPrice!),
              style: AppTypography.priceStrikethrough,
            ),
          ),
          const SizedBox(width: 4),
          Padding(
            padding: const EdgeInsets.only(bottom: 1),
            child: _DiscountBadge(
              discount: ((originalPrice! - price) / originalPrice! * 100).round(),
            ),
          ),
        ],
      ],
    );
  }
}

enum PriceTagStyle { large, regular, small }

class _DiscountBadge extends StatelessWidget {
  const _DiscountBadge({required this.discount});

  final int discount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.08),
        borderRadius: AppSpacing.borderRadiusPill,
      ),
      child: Text(
        '-$discount%',
        style: AppTypography.badge.copyWith(
          color: AppColors.error,
          fontSize: 9,
        ),
      ),
    );
  }
}

/// Trust indicator badge with icon and label.
class TrustBadge extends StatelessWidget {
  const TrustBadge({
    super.key,
    required this.icon,
    required this.label,
    this.iconColor,
    this.backgroundColor,
  });

  final IconData icon;
  final String label;
  final Color? iconColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surfaceContainerLow,
        borderRadius: AppSpacing.borderRadiusPill,
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: iconColor ?? AppColors.secondary,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: AppTypography.labelSm.copyWith(
                fontSize: 10,
                color: AppColors.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// Gradient divider with optional label in center.
class GradientDivider extends StatelessWidget {
  const GradientDivider({
    super.key,
    this.label,
    this.color,
    this.height = 1,
  });

  final String? label;
  final Color? color;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (label == null) {
      return Container(
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              (color ?? AppColors.outlineVariant).withValues(alpha: 0.5),
              Colors.transparent,
            ],
          ),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: Container(
            height: height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  (color ?? AppColors.outlineVariant).withValues(alpha: 0.5),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label!,
            style: AppTypography.overline.copyWith(
              color: AppColors.outline,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  (color ?? AppColors.outlineVariant).withValues(alpha: 0.5),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
