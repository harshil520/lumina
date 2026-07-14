import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../cart/application/cart_provider.dart';
import '../../../gemstone_detail/domain/models/gemstone_detail.dart';
import '../../application/profile_providers.dart';
import '../../domain/models/wishlist_item.dart';

/// Interactive wishlist screen with add-to-cart and remove.
class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistAsync = ref.watch(wishlistProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
        title: Text('Wishlist', style: AppTypography.titleLg.copyWith(color: AppColors.primary)),
      ),
      body: SafeArea(
        child: wishlistAsync.when(
          data: (items) {
            if (items.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.favorite_border, size: 64, color: AppColors.outline),
                    SizedBox(height: AppSpacing.md),
                    Text('Your wishlist is empty', style: TextStyle(color: AppColors.outline, fontSize: 16)),
                    SizedBox(height: AppSpacing.sm),
                    Text('Save items you love for later', style: TextStyle(color: AppColors.outline, fontSize: 13)),
                  ],
                ),
              );
            }
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
              itemCount: items.length,
              itemBuilder: (context, index) => _WishlistCard(
                item: items[index],
                onAddToCart: () => _addToCart(context, ref, items[index]),
                onRemove: () => _removeFromWishlist(context, ref, items[index]),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text('Could not load wishlist: $err',
                  style: AppTypography.bodyMd.copyWith(color: AppColors.error)),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addToCart(BuildContext context, WidgetRef ref, WishlistItem item) async {
    final cartNotifier = ref.read(cartProvider.notifier);
    final productId = item.productId;

    GemstoneDetail? existingDetail;
    final cartItems = ref.read(cartProvider).valueOrNull ?? [];
    for (final ci in cartItems) {
      if (ci.gemstone.id == productId) {
        existingDetail = ci.gemstone;
        break;
      }
    }

    final gemstone = existingDetail ?? _toGemstoneDetail(item);
    try {
      await cartNotifier.addItem(gemstone);
      await ref.read(profileRepositoryProvider).removeFromWishlist(item.id);
      ref.invalidate(wishlistProvider);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${item.title} moved to cart'),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(label: 'View Cart', onPressed: () => context.pushNamed('cart')),
        ),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not add item to cart'), behavior: SnackBarBehavior.floating),
      );
    }
  }

  Future<void> _removeFromWishlist(BuildContext context, WidgetRef ref, WishlistItem item) async {
    try {
      await ref.read(profileRepositoryProvider).removeFromWishlist(item.id);
      ref.invalidate(wishlistProvider);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${item.title} removed from wishlist'),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () async {
              await ref.read(profileRepositoryProvider).addToWishlist(item);
              ref.invalidate(wishlistProvider);
            },
          ),
        ),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not remove item'), behavior: SnackBarBehavior.floating),
      );
    }
  }

  GemstoneDetail _toGemstoneDetail(WishlistItem item) {
    final caratMatch = RegExp(r'(\d+\.?\d*)\s*ct', caseSensitive: false).firstMatch(item.title);
    final caratStr = caratMatch != null ? '${caratMatch.group(1)}ct' : 'N/A';
    return GemstoneDetail(
      id: item.productId,
      name: item.title,
      collectionLabel: 'Gemstone Collection',
      price: item.price,
      imageUrls: [item.imageUrl],
      certificationBadge: 'GIA',
      caratWeight: caratStr,
      colorGrade: 'F',
      clarityGrade: 'VS1',
      cutGrade: 'Excellent',
      polish: 'Excellent',
      symmetry: 'Excellent',
      fluorescence: 'None',
      giaReportNumber: 'GIA${item.productId.hashCode.abs().toString().padLeft(10, '0')}',
      description: item.title,
      seller: const SellerInfo(
        name: 'Lumina Gems',
        avatarUrl: '',
        rating: 4.8,
        reviewCount: 1247,
        tagline: 'Premium Gemstones & Fine Jewelry',
      ),
      similarStoneIds: [],
    );
  }
}

class _WishlistCard extends StatelessWidget {
  const _WishlistCard({
    required this.item,
    required this.onAddToCart,
    required this.onRemove,
  });
  final WishlistItem item;
  final VoidCallback onAddToCart;
  final VoidCallback onRemove;

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusCard,
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.15)),
        boxShadow: AppSpacing.elevationSm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: AppSpacing.borderRadiusMd,
            child: Image.network(
              item.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                width: 80,
                height: 80,
                color: AppColors.surfaceContainerHigh,
                child: const Icon(Icons.image, color: AppColors.outline, size: 32),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodyMd.copyWith(fontWeight: FontWeight.w600, color: AppColors.onSurface),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${item.price.toStringAsFixed(2)}',
                  style: AppTypography.priceMd.copyWith(color: AppColors.tertiary),
                ),
                const SizedBox(height: 2),
                Text(
                  'Added ${_formatDate(item.addedAt)}',
                  style: AppTypography.badge.copyWith(color: AppColors.outline),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 34,
                        child: FilledButton.icon(
                          onPressed: onAddToCart,
                          icon: const Icon(Icons.shopping_cart_outlined, size: 14),
                          label: const Text('Add to Cart', style: TextStyle(fontSize: 11)),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 34,
                      child: OutlinedButton.icon(
                        onPressed: onRemove,
                        icon: const Icon(Icons.delete_outline, size: 14),
                        label: const Text('Remove', style: TextStyle(fontSize: 11)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          side: const BorderSide(color: AppColors.error),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
