import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Wrapper around [CachedNetworkImage] with a shimmer-style loading placeholder.
///
/// Used wherever network images are displayed — product cards, category
/// backgrounds, detail galleries.
class ShimmerImage extends StatelessWidget {
  const ShimmerImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    Widget image = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => _ShimmerPlaceholder(
        width: width,
        height: height,
      ),
      errorWidget: (context, url, error) => Container(
        width: width,
        height: height,
        color: AppColors.surfaceContainerLow,
        child: const Center(
          child: Icon(
            Icons.diamond_outlined,
            color: AppColors.outlineVariant,
            size: 32,
          ),
        ),
      ),
    );

    if (borderRadius != null) {
      image = ClipRRect(
        borderRadius: borderRadius!,
        child: image,
      );
    }

    return image;
  }
}

class _ShimmerPlaceholder extends StatefulWidget {
  const _ShimmerPlaceholder({this.width, this.height});

  final double? width;
  final double? height;

  @override
  State<_ShimmerPlaceholder> createState() => _ShimmerPlaceholderState();
}

class _ShimmerPlaceholderState extends State<_ShimmerPlaceholder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-1.0 + 2.0 * _controller.value, 0),
              end: Alignment(-1.0 + 2.0 * _controller.value + 1.0, 0),
              colors: const [
                AppColors.surfaceContainerLow,
                AppColors.surfaceContainerHigh,
                AppColors.surfaceContainerLow,
              ],
            ),
          ),
        );
      },
    );
  }
}
