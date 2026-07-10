import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/shimmer_image.dart';
import '../../application/home_providers.dart';
import '../../domain/models/featured_collection.dart';

/// Horizontal snap-scrolling carousel for featured collections.
///
/// Inspired by GIVA's collection showcase with image backgrounds and
/// action buttons. Enhanced with richer overlays and promotional tags.
class FeaturedCollectionsCarousel extends ConsumerWidget {
  const FeaturedCollectionsCarousel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collectionsAsync = ref.watch(featuredCollectionsProvider);

    return collectionsAsync.when(
      data: (collections) =>
          _CarouselContent(collections: collections),
      loading: () => const SizedBox(
        height: 280,
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 2,
          ),
        ),
      ),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

class _CarouselContent extends StatelessWidget {
  const _CarouselContent({required this.collections});

  final List<FeaturedCollection> collections;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPaddingH,
        ),
        physics: const BouncingScrollPhysics(),
        itemCount: collections.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (context, index) => _CollectionCard(
          collection: collections[index],
          index: index,
        ),
      ),
    );
  }
}

class _CollectionCard extends StatefulWidget {
  const _CollectionCard({required this.collection, required this.index});

  final FeaturedCollection collection;
  final int index;

  @override
  State<_CollectionCard> createState() => _CollectionCardState();
}

class _CollectionCardState extends State<_CollectionCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth < 600 ? screenWidth * 0.78 : 340.0;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isHovered = true),
      onTapUp: (_) => setState(() => _isHovered = false),
      onTapCancel: () => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: SizedBox(
          width: cardWidth,
          child: ClipRRect(
            borderRadius: AppSpacing.borderRadiusCard,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background image
                ShimmerImage(
                  imageUrl: widget.collection.imageUrl,
                  fit: BoxFit.cover,
                ),
                // Multi-layer gradient overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.primary.withValues(alpha: 0.05),
                        AppColors.primary.withValues(alpha: 0.3),
                        AppColors.primary.withValues(alpha: 0.85),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Promotional tag
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.tertiary.withValues(alpha: 0.9),
                          borderRadius: AppSpacing.borderRadiusPill,
                        ),
                        child: Text(
                          widget.collection.title.split(' ').first.toUpperCase(),
                          style: AppTypography.badge.copyWith(
                            color: AppColors.onPrimary,
                            fontSize: 9,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.collection.title,
                        style: AppTypography.titleLg.copyWith(
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.collection.subtitle,
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.onPrimary.withValues(alpha: 0.75),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.onPrimary,
                              borderRadius: AppSpacing.borderRadiusDefault,
                            ),
                            child: Text(
                              widget.collection.actionLabel,
                              style: AppTypography.labelSm.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: AppSpacing.borderRadiusMd,
                            ),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: AppColors.onPrimary.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
