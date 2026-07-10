import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Spacing, border-radius, elevation, and decoration tokens from the CaratVault design system.
///
/// All spacing is based on an 8px unit grid.
/// Enhanced with reusable decoration presets inspired by premium jewelry
/// marketplace design patterns.
class AppSpacing {
  AppSpacing._();

  // ── Spacing (8px grid) ────────────────────────────────────────────────
  static const double unit = 8;
  static const double xs = 4;
  static const double sm = 12;
  static const double md = 24;
  static const double lg = 48;
  static const double xl = 72;
  static const double gutter = 32;

  /// Horizontal padding for mobile screens.
  static const double screenPaddingH = 20;

  // ── Border Radius ("Chiseled Precision" — tight, industrial) ──────────
  static const double radiusSm = 2;
  static const double radiusDefault = 4;
  static const double radiusMd = 6;
  static const double radiusLg = 12;
  static const double radiusXl = 16;
  static const double radiusFull = 9999;

  /// Softer radius for cards that need a more approachable feel.
  static const double radiusCard = 14;
  /// Pill radius for tags, badges, and chips.
  static const double radiusPill = 9999;

  static const BorderRadius borderRadiusSm =
      BorderRadius.all(Radius.circular(radiusSm));
  static const BorderRadius borderRadiusDefault =
      BorderRadius.all(Radius.circular(radiusDefault));
  static const BorderRadius borderRadiusMd =
      BorderRadius.all(Radius.circular(radiusMd));
  static const BorderRadius borderRadiusLg =
      BorderRadius.all(Radius.circular(radiusLg));
  static const BorderRadius borderRadiusXl =
      BorderRadius.all(Radius.circular(radiusXl));

  static final BorderRadius borderRadiusCard =
      BorderRadius.circular(radiusCard);
  static final BorderRadius borderRadiusPill =
      BorderRadius.circular(radiusPill);

  // ── Elevation ─────────────────────────────────────────────────────────
  static const List<BoxShadow> elevationSm = [
    BoxShadow(
      color: Color(0x0D0F172A), // rgba(15,23,42,0.05)
      blurRadius: 3,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> elevationMd = [
    BoxShadow(
      color: Color(0x140F172A), // rgba(15,23,42,0.08)
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> elevationLg = [
    BoxShadow(
      color: Color(0x1F0F172A), // rgba(15,23,42,0.12)
      blurRadius: 32,
      offset: Offset(0, 12),
    ),
  ];

  /// Warm-toned shadow for cards with gold/champagne accents.
  static const List<BoxShadow> elevationWarm = [
    BoxShadow(
      color: Color(0x1AB39250), // rgba(179,146,80,0.10)
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
  ];

  /// Soft colored shadow for featured/highlighted items.
  static const List<BoxShadow> elevationPrimary = [
    BoxShadow(
      color: Color(0x1A0A2540), // rgba(10,37,64,0.10)
      blurRadius: 20,
      offset: Offset(0, 8),
    ),
  ];

  /// Inner glow effect for focused/active elements.
  static const List<BoxShadow> elevationGlow = [
    BoxShadow(
      color: Color(0x1A0A2540),
      blurRadius: 8,
      offset: Offset(0, 2),
      spreadRadius: 2,
    ),
  ];

  // ── Decoration Presets ────────────────────────────────────────────────

  /// Standard card decoration with border and subtle shadow.
  static BoxDecoration get cardDecoration => BoxDecoration(
        color: AppColors.surface,
        borderRadius: borderRadiusCard,
        border: Border.all(
          color: AppColors.surfaceContainerHigh,
        ),
        boxShadow: elevationSm,
      );

  /// Elevated card with stronger shadow (for hover/active states).
  static BoxDecoration get cardElevatedDecoration => BoxDecoration(
        color: AppColors.surface,
        borderRadius: borderRadiusCard,
        border: Border.all(
          color: AppColors.outlineVariant,
        ),
        boxShadow: elevationMd,
      );

  /// Glass-morphism style container (frosted surface).
  static BoxDecoration get glassDecoration => BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.85),
        borderRadius: borderRadiusLg,
        border: Border.all(
          color: AppColors.surfaceContainerHigh.withValues(alpha: 0.5),
        ),
        boxShadow: elevationSm,
      );

  /// Gradient card decoration for premium/featured sections.
  static BoxDecoration get premiumCardDecoration => BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: borderRadiusCard,
        boxShadow: elevationPrimary,
      );

  /// Gold accent card decoration for tertiary/premium items.
  static BoxDecoration get goldAccentDecoration => BoxDecoration(
        color: AppColors.tertiaryContainer,
        borderRadius: borderRadiusCard,
        border: Border.all(
          color: AppColors.tertiaryFixedDim.withValues(alpha: 0.3),
        ),
      );

  /// Badge decoration (pill shape with subtle background).
  static BoxDecoration badgeDecoration({
    required Color backgroundColor,
    Color? borderColor,
  }) =>
      BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadiusPill,
        border: borderColor != null
            ? Border.all(color: borderColor, width: 0.5)
            : null,
      );
}
