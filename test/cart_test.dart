import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lumina/features/cart/application/cart_provider.dart';
import 'package:lumina/features/cart/domain/models/cart_item.dart';
import 'package:lumina/features/cart/domain/repositories/cart_repository.dart';
import 'package:lumina/features/gemstone_detail/domain/models/gemstone_detail.dart';

class FakeCartRepository implements CartRepository {
  final List<CartItem> _items = [];

  @override
  Future<List<CartItem>> getCartItems() async => List.unmodifiable(_items);

  @override
  Future<void> addToCart(GemstoneDetail gemstone) async {
    final index = _items.indexWhere((item) => item.gemstone.id == gemstone.id);
    if (index != -1) {
      _items[index] = _items[index].copyWith(quantity: _items[index].quantity + 1);
    } else {
      _items.add(CartItem(gemstone: gemstone, addedAt: DateTime.now(), quantity: 1));
    }
  }

  @override
  Future<void> updateQuantity(String id, int quantity) async {
    final index = _items.indexWhere((item) => item.gemstone.id == id);
    if (index != -1) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index] = _items[index].copyWith(quantity: quantity);
      }
    }
  }

  @override
  Future<void> removeFromCart(String id) async {
    _items.removeWhere((item) => item.gemstone.id == id);
  }

  @override
  Future<void> clearCart() async {
    _items.clear();
  }
}

void main() {
  group('Portfolio Cart Provider Unit Tests', () {
    late ProviderContainer container;

    const mockStone1 = GemstoneDetail(
      id: 'stone-1',
      name: 'Round Diamond 1.50ct',
      collectionLabel: 'Private Collection',
      price: 12500.00,
      imageUrls: [],
      certificationBadge: 'GIA NATURAL',
      caratWeight: '1.50 ct',
      colorGrade: 'D',
      clarityGrade: 'IF',
      cutGrade: 'Ideal',
      polish: 'Excellent',
      symmetry: 'Excellent',
      fluorescence: 'None',
      giaReportNumber: '#GIA1102948',
      description: 'Mock stone 1',
      seller: SellerInfo(
        name: 'Alexander Sterling',
        avatarUrl: '',
        rating: 4.9,
        reviewCount: 120,
        tagline: 'Seller tagline',
      ),
      similarStoneIds: [],
    );

    const mockStone2 = GemstoneDetail(
      id: 'stone-2',
      name: 'Sapphire 2.0ct',
      collectionLabel: 'Rare Stones',
      price: 7200.00,
      imageUrls: [],
      certificationBadge: 'IGI Certified',
      caratWeight: '2.00 ct',
      colorGrade: 'Royal Blue',
      clarityGrade: 'Eye Clean',
      cutGrade: 'Oval',
      polish: 'Excellent',
      symmetry: 'Very Good',
      fluorescence: 'None',
      giaReportNumber: '#IGI882039',
      description: 'Mock stone 2',
      seller: SellerInfo(
        name: 'Victoria Ashworth',
        avatarUrl: '',
        rating: 4.8,
        reviewCount: 90,
        tagline: 'Seller tagline',
      ),
      similarStoneIds: [],
    );

    setUp(() {
      container = ProviderContainer(
        overrides: [
          cartRepositoryProvider.overrideWith((ref) => FakeCartRepository()),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('Initial state is empty list', () async {
      final cartState = await container.read(cartProvider.future);
      expect(cartState, isEmpty);
      expect(container.read(cartCountProvider), equals(0));
      expect(container.read(cartTotalProvider), equals(0.0));
    });

    test('Add item updates list state and derived totals', () async {
      final notifier = container.read(cartProvider.notifier);

      // Add first item
      await notifier.addItem(mockStone1);
      var cartState = await container.read(cartProvider.future);

      expect(cartState.length, equals(1));
      expect(cartState[0].gemstone.id, equals('stone-1'));
      expect(cartState[0].quantity, equals(1));
      expect(container.read(cartCountProvider), equals(1));
      expect(container.read(cartTotalProvider), equals(12500.00));

      // Add second item
      await notifier.addItem(mockStone2);
      cartState = await container.read(cartProvider.future);

      expect(cartState.length, equals(2));
      expect(cartState[1].gemstone.id, equals('stone-2'));
      expect(cartState[1].quantity, equals(1));
      expect(container.read(cartCountProvider), equals(2));
      expect(container.read(cartTotalProvider), equals(19700.00));
    });

    test('Duplicate additions increments quantity instead of adding new line item', () async {
      final notifier = container.read(cartProvider.notifier);

      await notifier.addItem(mockStone1);
      await notifier.addItem(mockStone1); // Duplicate addition

      final cartState = await container.read(cartProvider.future);
      expect(cartState.length, equals(1));
      expect(cartState[0].quantity, equals(2));
      expect(container.read(cartCountProvider), equals(2));
      expect(container.read(cartTotalProvider), equals(25000.00));
    });

    test('Manual quantity update recalculates totals and drops item at 0', () async {
      final notifier = container.read(cartProvider.notifier);

      await notifier.addItem(mockStone1);
      
      // Update quantity to 3
      await notifier.updateQuantity('stone-1', 3);
      var cartState = await container.read(cartProvider.future);
      expect(cartState[0].quantity, equals(3));
      expect(container.read(cartCountProvider), equals(3));
      expect(container.read(cartTotalProvider), equals(37500.00));

      // Update quantity to 0 removes item
      await notifier.updateQuantity('stone-1', 0);
      cartState = await container.read(cartProvider.future);
      expect(cartState, isEmpty);
      expect(container.read(cartCountProvider), equals(0));
      expect(container.read(cartTotalProvider), equals(0.0));
    });

    test('Remove item updates list state and derived totals', () async {
      final notifier = container.read(cartProvider.notifier);

      await notifier.addItem(mockStone1);
      await notifier.addItem(mockStone2);

      // Remove first item
      await notifier.removeItem('stone-1');
      var cartState = await container.read(cartProvider.future);

      expect(cartState.length, equals(1));
      expect(cartState[0].gemstone.id, equals('stone-2'));
      expect(container.read(cartCountProvider), equals(1));
      expect(container.read(cartTotalProvider), equals(7200.00));
    });

    test('Clear cart empties state and resets derived totals', () async {
      final notifier = container.read(cartProvider.notifier);

      await notifier.addItem(mockStone1);
      await notifier.addItem(mockStone2);

      await notifier.clearCart();
      final cartState = await container.read(cartProvider.future);

      expect(cartState, isEmpty);
      expect(container.read(cartCountProvider), equals(0));
      expect(container.read(cartTotalProvider), equals(0.0));
    });
  });
}
