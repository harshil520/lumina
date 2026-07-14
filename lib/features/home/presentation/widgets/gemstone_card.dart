import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/shimmer_image.dart';
import '../../../../features/profile/application/profile_providers.dart';
import '../../../../features/profile/domain/models/wishlist_item.dart';
import '../../domain/models/gemstone_summary.dart';

/// Individual product card for trending gemstones with wishlist integration.
class GemstoneCard extends ConsumerStatefulWidget {
  const GemstoneCard({super.key, required this.gemstone});

  final GemstoneSummary gemstone;

  @override
  ConsumerState<GemstoneCard> createState() => _GemstoneCardState();
}

class _GemstoneCardState extends ConsumerState<GemstoneCard> {
  bool _isHovered = false;

  bool _isInWishlist(List<WishlistItem> items) {
    return items.any((item) => item.productId == widget.gemstone.id);
  }

  Future<void> _toggleWishlist(List<WishlistItem> items) async {
    final repo = ref.read(profileRepositoryProvider);
    final isFav = _isInWishlist(items);

    if (isFav) {
      final item = items.firstWhere((i) => i.productId == widget.gemstone.id);
      await repo.removeFromWishlist(item.id);
    } else {
      await repo.addToWishlist(WishlistItem(
        id: 'wish_${DateTime.now().millisecondsSinceEpoch}',
        productId: widget.gemstone.id,
        title: widget.gemstone.name,
        imageUrl: widget.gemstone.imageUrl,
        price: widget.gemstone.price,
        addedAt: DateTime.now(),
      ));
    }
    ref.invalidate(wishlistProvider);
  }

  @override
  Widget build(BuildContext context) {
    final wishlistAsync = ref.watch(wishlistProvider);
    final wishlistItems = wishlistAsync.valueOrNull ?? [];
    final isFavorited = _isInWishlist(wishlistItems);

    return GestureDetector(
      onTap: () {
        context.pushNamed(
          RouteNames.gemstoneDetail,
          pathParameters: {'id': widget.gemstone.id},
        );
      },
      onTapDown: (_) => setState(() => _isHovered = true),
      onTapUp: (_) => setState(() => _isHovered = false),
      onTapCancel: () => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppSpacing.borderRadiusCard,
            border: Border.all(
              color: _isHovered
                  ? AppColors.primary.withValues(alpha: 0.2)
                  : AppColors.outlineVariant.withValues(alpha: 0.3),
            ),
            boxShadow: _isHovered ? AppSpacing.elevationMd : AppSpacing.elevationSm,
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1.0,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ShimmerImage(
                      imageUrl: widget.gemstone.imageUrl,
                      fit: BoxFit.cover,
                    ),
                    AnimatedOpacity(
                      opacity: _isHovered ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppColors.primary.withValues(alpha: 0.3),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: AppSpacing.borderRadiusSm,
                          border: Border.all(
                            color: AppColors.outlineVariant.withValues(alpha: 0.4),
                            width: 0.5,
                          ),
                        ),
                        child: Text(
                          widget.gemstone.certificationBadge,
                          style: AppTypography.labelSm.copyWith(
                            color: AppColors.primary,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.gemstone.name,
                            style: AppTypography.bodyLg.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _toggleWishlist(wishlistItems),
                          child: Icon(
                            isFavorited ? Icons.favorite : Icons.favorite_border,
                            color: isFavorited ? AppColors.error : AppColors.outline,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _SpecItem(label: 'WEIGHT', value: widget.gemstone.weight),
                        Container(
                          width: 1,
                          height: 24,
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          color: AppColors.outlineVariant.withValues(alpha: 0.3),
                        ),
                        _SpecItem(label: 'CUT', value: widget.gemstone.cut),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '\$${widget.gemstone.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                      style: AppTypography.headlineLg.copyWith(
                        color: AppColors.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SpecItem extends StatelessWidget {
  const _SpecItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.overline.copyWith(color: AppColors.outline),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTypography.dataMono.copyWith(
            color: AppColors.primary,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
