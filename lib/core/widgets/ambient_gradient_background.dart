import 'package:flutter/material.dart';

/// Reusable soft gradient background wrapper.
///
/// Provides the warm, inviting ambient gradient wash seen in premium jewelry
/// marketplaces like GIVA — subtle blush, cream, and champagne tones that
/// shift gently across the screen, replacing flat white backgrounds.
class AmbientGradientBackground extends StatelessWidget {
  const AmbientGradientBackground({
    super.key,
    required this.child,
    this.colors,
    this.begin = Alignment.topCenter,
    this.end = Alignment.bottomCenter,
  });

  final Widget child;
  final List<Color>? colors;
  final Alignment begin;
  final Alignment end;

  /// Default home screen gradient: soft cream to blush to warm white.
  static const _homeColors = [
    Color(0xFFFFFBF7), // warm white cream
    Color(0xFFFFF8F3), // barely-there peach
    Color(0xFFF8F6F3), // soft warm grey
    Color(0xFFFFF5EE), // blush
    Color(0xFFFDF9F5), // warm ivory
  ];

  /// Detail screen gradient: clean warm white with subtle gold hint.
  static const _detailColors = [
    Color(0xFFFFFDF9), // warm cream top
    Color(0xFFFFFBF5), // soft peach
    Color(0xFFF9F7F4), // warm neutral
  ];

  /// Section alternating gradient: soft champagne wash.
  static const _sectionColors = [
    Color(0xFFFFF9F2), // warm blush
    Color(0xFFFFFDF8), // cream white
  ];

  /// For creating ambient background on any screen.
  const AmbientGradientBackground.home({
    super.key,
    required this.child,
  })  : colors = _homeColors,
        begin = Alignment.topCenter,
        end = Alignment.bottomCenter;

  const AmbientGradientBackground.detail({
    super.key,
    required this.child,
  })  : colors = _detailColors,
        begin = Alignment.topCenter,
        end = Alignment.bottomCenter;

  const AmbientGradientBackground.section({
    super.key,
    required this.child,
  })  : colors = _sectionColors,
        begin = Alignment.topCenter,
        end = Alignment.bottomCenter;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: colors ?? _homeColors,
        ),
      ),
      child: child,
    );
  }
}
