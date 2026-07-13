import '../../../../features/gemstone_detail/domain/models/gemstone_detail.dart';
import '../models/cart_item.dart';

/// Repository interface for Portfolio Cart operations.
abstract class CartRepository {
  /// Retrieves all items currently in the portfolio cart.
  Future<List<CartItem>> getCartItems();

  /// Adds a gemstone to the portfolio cart.
  Future<void> addToCart(GemstoneDetail gemstone);

  /// Updates the quantity of a gemstone in the portfolio cart.
  Future<void> updateQuantity(String id, int quantity);

  /// Removes a gemstone from the portfolio cart by ID.
  Future<void> removeFromCart(String id);

  /// Clears all gemstones from the portfolio cart.
  Future<void> clearCart();
}
