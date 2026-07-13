import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../features/gemstone_detail/domain/models/gemstone_detail.dart';
import '../data/repositories/cart_repository_impl.dart';
import '../domain/models/cart_item.dart';
import '../domain/repositories/cart_repository.dart';

/// Provides a single instance of [CartRepository].
final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepositoryImpl();
});

/// Notifier to manage the portfolio cart state reactively.
class CartNotifier extends AsyncNotifier<List<CartItem>> {
  @override
  Future<List<CartItem>> build() async {
    return ref.read(cartRepositoryProvider).getCartItems();
  }

  /// Adds a gemstone to the portfolio cart and updates state.
  Future<void> addItem(GemstoneDetail gemstone) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(cartRepositoryProvider);
      await repository.addToCart(gemstone);
      return repository.getCartItems();
    });
  }

  /// Updates the quantity of an item in the cart.
  Future<void> updateQuantity(String gemstoneId, int quantity) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(cartRepositoryProvider);
      await repository.updateQuantity(gemstoneId, quantity);
      return repository.getCartItems();
    });
  }

  /// Removes a gemstone from the portfolio cart by ID.
  Future<void> removeItem(String gemstoneId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(cartRepositoryProvider);
      await repository.removeFromCart(gemstoneId);
      return repository.getCartItems();
    });
  }

  /// Clears the entire portfolio cart.
  Future<void> clearCart() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(cartRepositoryProvider);
      await repository.clearCart();
      return repository.getCartItems();
    });
  }
}

/// Provider for [CartNotifier] state.
final cartProvider = AsyncNotifierProvider<CartNotifier, List<CartItem>>(
  CartNotifier.new,
);

/// Computed provider for the total price of all assets in the cart (price * quantity).
final cartTotalProvider = Provider<double>((ref) {
  final cartItemsAsync = ref.watch(cartProvider);
  return cartItemsAsync.maybeWhen(
    data: (items) => items.fold(0.0, (sum, item) => sum + (item.gemstone.price * item.quantity)),
    orElse: () => 0.0,
  );
});

/// Computed provider for the count of items in the cart (sum of quantities).
final cartCountProvider = Provider<int>((ref) {
  final cartItemsAsync = ref.watch(cartProvider);
  return cartItemsAsync.maybeWhen(
    data: (items) => items.fold(0, (sum, item) => sum + item.quantity),
    orElse: () => 0,
  );
});
