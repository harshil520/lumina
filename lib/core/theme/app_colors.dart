import 'package:flutter/material.dart';

/// All color tokens from the CaratVault / Diamond Marketplace design system.
///
/// Mirrors DESIGN.md: Deep Vault Blue for primary, Emerald Green for
/// secondary (certifications), Champagne Gold for tertiary (premium tiers).
/// Enhanced with gradient palette and accent tones inspired by premium
/// jewelry marketplace design patterns.
class AppColors {
  AppColors._();

  // ── Primary ───────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF0A2540);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFE2F1FF);
  static const Color onPrimaryContainer = Color(0xFF001833);
  static const Color inversePrimary = Color(0xFF9BCAFF);
  static const Color primaryFixed = Color(0xFFD2E7FF);
  static const Color primaryFixedDim = Color(0xFF9BCAFF);
  static const Color onPrimaryFixed = Color(0xFF001C3D);
  static const Color onPrimaryFixedVariant = Color(0xFF004791);

  // ── Secondary (Emerald Green – certifications / compliance) ───────────
  static const Color secondary = Color(0xFF008060);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFD3F4EA);
  static const Color onSecondaryContainer = Color(0xFF002014);
  static const Color secondaryFixed = Color(0xFFB6EEDB);
  static const Color secondaryFixedDim = Color(0xFF6DE2BC);
  static const Color onSecondaryFixed = Color(0xFF002116);
  static const Color onSecondaryFixedVariant = Color(0xFF00523C);

  // ── Tertiary (Champagne Gold – premium / bespoke) ─────────────────────
  static const Color tertiary = Color(0xFFB39250);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFFBF3DB);
  static const Color onTertiaryContainer = Color(0xFF2C1E00);
  static const Color tertiaryFixed = Color(0xFFF4E2B9);
  static const Color tertiaryFixedDim = Color(0xFFD7C28E);
  static const Color onTertiaryFixed = Color(0xFF271900);
  static const Color onTertiaryFixedVariant = Color(0xFF574319);

  // ── Error ─────────────────────────────────────────────────────────────
  static const Color error = Color(0xFFDC2626);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFEE2E2);
  static const Color onErrorContainer = Color(0xFF450A0A);

  // ── Surfaces ──────────────────────────────────────────────────────────
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDim = Color(0xFFF4F6F8);
  static const Color surfaceBright = Color(0xFFFFFFFF);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF8FAFC);
  static const Color surfaceContainer = Color(0xFFF1F5F9);
  static const Color surfaceContainerHigh = Color(0xFFE2E8F0);
  static const Color surfaceContainerHighest = Color(0xFFCBD5E1);
  static const Color onSurface = Color(0xFF0F172A);
  static const Color onSurfaceVariant = Color(0xFF334155);
  static const Color inverseSurface = Color(0xFF0F172A);
  static const Color inverseOnSurface = Color(0xFFFFFFFF);
  static const Color surfaceTint = Color(0xFF0A2540);
  static const Color surfaceVariant = Color(0xFFF8FAFC);
  static const Color background = Color(0xFFFFFFFF);
  static const Color onBackground = Color(0xFF0F172A);

  // ── Outline ───────────────────────────────────────────────────────────
  static const Color outline = Color(0xFF64748B);
  static const Color outlineVariant = Color(0xFF94A3B8);

  // ── Gradient Palette (inspired by premium jewelry design) ─────────────
  /// Primary gradient: Deep Vault Blue to slightly lighter blue.
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0A2540), Color(0xFF133959)],
  );

  /// Tertiary gradient: Champagne Gold warm sweep.
  static const LinearGradient tertiaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFB39250), Color(0xFFD4B06A)],
  );

  /// Surface gradient: subtle warm white sweep for cards.
  static const LinearGradient surfaceGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC)],
  );

  /// Hero gradient overlay: for image overlays on hero banners.
  static LinearGradient heroOverlayGradient({
    double topAlpha = 0.0,
    double bottomAlpha = 0.85,
  }) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        primary.withValues(alpha: topAlpha),
        primary.withValues(alpha: bottomAlpha),
      ],
    );
  }

  /// Section background gradient: subtle warm tint for alternating sections.
  static const LinearGradient sectionBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9)],
  );

  // ── Warm Accents (rose gold / plum tones for interactive highlights) ──
  /// Rose Gold accent for wishlist hearts, sale indicators.
  static const Color accentRoseGold = Color(0xFFC77D5A);
  /// Deep Plum accent for premium badges, featured tags.
  static const Color accentPlum = Color(0xFF6B2D5B);
  /// Warm Amber for price highlights and call-to-action emphasis.
  static const Color accentAmber = Color(0xFFD4940A);

  // ── Semantic Colors ───────────────────────────────────────────────────
  /// Success green (slightly warmer than secondary for notifications).
  static const Color success = Color(0xFF16A34A);
  /// Warning amber for limited stock / urgency indicators.
  static const Color warning = Color(0xFFEAB308);
  /// Info blue for informational badges.
  static const Color info = Color(0xFF2563EB);
}
