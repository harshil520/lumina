/// Clean domain representation of a wishlist item.
class WishlistItem {
  const WishlistItem({
    required this.id,
    required this.productId,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.addedAt,
  });

  final String id;
  final String productId;
  final String title;
  final String imageUrl;
  final double price;
  final DateTime addedAt;
}
