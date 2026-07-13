import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
      height: 360,
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
    final cardWidth = screenWidth < 600 ? screenWidth * 0.78 : 360.0;

    return GestureDetector(
      onTap: () {
        context.push('/search?query=${Uri.encodeComponent(widget.collection.title)}');
      },
      onTapDown: (_) => setState(() => _isHovered = true),
      onTapUp: (_) => setState(() => _isHovered = false),
      onTapCancel: () => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: Container(
          width: cardWidth,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: AppSpacing.borderRadiusLg,
            boxShadow: _isHovered ? AppSpacing.elevationMd : AppSpacing.elevationSm,
          ),
          child: ClipRRect(
            borderRadius: AppSpacing.borderRadiusLg,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background image with 60% opacity
                Opacity(
                  opacity: 0.6,
                  child: ShimmerImage(
                    imageUrl: widget.collection.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.collection.title,
                        style: AppTypography.headlineLg.copyWith(
                          color: AppColors.primary,
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.collection.subtitle,
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: AppSpacing.borderRadiusPill,
                        ),
                        child: Text(
                          widget.collection.actionLabel.toUpperCase(),
                          style: AppTypography.labelSm.copyWith(
                            color: AppColors.onPrimary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
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
