import '../../../gemstone_detail/domain/models/gemstone_detail.dart';

/// Represents a single gemstone asset in the user's Portfolio Cart.
class CartItem {
  const CartItem({
    required this.gemstone,
    required this.addedAt,
    this.quantity = 1,
  });

  /// The gemstone details of this portfolio asset.
  final GemstoneDetail gemstone;

  /// The timestamp when this asset was added to the vault portfolio.
  final DateTime addedAt;

  /// The quantity of this gemstone asset configuration.
  final int quantity;

  CartItem copyWith({
    GemstoneDetail? gemstone,
    DateTime? addedAt,
    int? quantity,
  }) {
    return CartItem(
      gemstone: gemstone ?? this.gemstone,
      addedAt: addedAt ?? this.addedAt,
      quantity: quantity ?? this.quantity,
    );
  }
}
