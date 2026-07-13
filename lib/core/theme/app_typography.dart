import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Typography tokens from the CaratVault design system.
///
/// Playfair Display for editorial/prestige display headers.
/// Inter for body, labels, and data-dense UI elements.
/// Enhanced with additional styles for prices, badges, and promotional text.
class AppTypography {
  AppTypography._();

  /// Display — 40px Playfair Display Bold
  static TextStyle get display => GoogleFonts.playfairDisplay(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        height: 48 / 40,
        letterSpacing: -0.02 * 40,
      );

  /// Headline Large — 26px Playfair Display SemiBold
  static TextStyle get headlineLg => GoogleFonts.playfairDisplay(
        fontSize: 26,
        fontWeight: FontWeight.w600,
        height: 34 / 26,
        letterSpacing: -0.01 * 26,
      );

  /// Headline Medium — 20px Inter SemiBold
  static TextStyle get headlineMd => GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 28 / 20,
        letterSpacing: 0,
      );

  /// Title Large — 17px Inter SemiBold
  static TextStyle get titleLg => GoogleFonts.inter(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        height: 24 / 17,
        letterSpacing: 0.01 * 17,
      );

  /// Body Large — 14px Inter Regular
  static TextStyle get bodyLg => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 22 / 14,
      );

  /// Body Medium — 13px Inter Regular
  static TextStyle get bodyMd => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 20 / 13,
      );

  /// Body Small — 12px Inter Regular
  static TextStyle get bodySm => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 18 / 12,
      );

  /// Label Medium — 13px Inter SemiBold, 0.05em tracking
  static TextStyle get labelMd => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        height: 18 / 13,
        letterSpacing: 0.05 * 13,
      );

  /// Label Small — 11px Inter Medium, 0.08em tracking
  static TextStyle get labelSm => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 16 / 11,
        letterSpacing: 0.08 * 11,
      );

  /// Data Mono — 13px Inter Medium, -0.01em tracking (for numbers/specs)
  static TextStyle get dataMono => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        height: 18 / 13,
        letterSpacing: -0.01 * 13,
      );

  // ── Extended Styles ──────────────────────────────────────────────────

  /// Price display — 17px Inter Bold for prominent pricing.
  static TextStyle get priceLg => GoogleFonts.inter(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        height: 24 / 17,
        letterSpacing: -0.01 * 17,
      );

  /// Price medium — 14px Inter SemiBold for card-level pricing.
  static TextStyle get priceMd => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 20 / 14,
        letterSpacing: -0.01 * 14,
      );

  /// Price small — 13px Inter Medium for inline pricing.
  static TextStyle get priceSm => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        height: 18 / 13,
        letterSpacing: -0.01 * 13,
      );

  /// Strikethrough price — 12px Inter Regular for original/discounted prices.
  static TextStyle get priceStrikethrough => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 16 / 12,
        color: AppColors.outline,
        decoration: TextDecoration.lineThrough,
      );

  /// Section eyebrow — 11px Inter SemiBold uppercase with wide tracking.
  static TextStyle get eyebrow => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        height: 16 / 11,
        letterSpacing: 0.1 * 11,
      );

  /// Badge text — 10px Inter Bold for small badges and tags.
  static TextStyle get badge => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        height: 14 / 10,
        letterSpacing: 0.06 * 10,
      );

  /// Chip text — 13px Inter Medium for filter chips and tags.
  static TextStyle get chip => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        height: 18 / 13,
        letterSpacing: 0.02 * 13,
      );

  /// Promotional callout — 16px Playfair Display SemiBold for hero text.
  static TextStyle get promoCallout => GoogleFonts.playfairDisplay(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 24 / 16,
        letterSpacing: 0,
      );

  /// Overline — 10px Inter SemiBold uppercase, maximum tracking.
  static TextStyle get overline => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        height: 14 / 10,
        letterSpacing: 0.12 * 10,
      );
}
