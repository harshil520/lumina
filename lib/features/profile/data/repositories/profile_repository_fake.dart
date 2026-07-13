import '../../domain/models/user_profile.dart';
import '../../domain/models/order.dart';
import '../../domain/models/saved_address.dart';
import '../../domain/models/payment_method.dart';
import '../../domain/models/wishlist_item.dart';
import '../../domain/repositories/profile_repository.dart';

/// Fake in-memory implementation of [ProfileRepository] for development.
///
/// Replace with a real API-backed implementation when the backend is available.
class ProfileRepositoryFake implements ProfileRepository {
  UserProfile _profile = UserProfile(
    id: 'user_001',
    name: 'Alexander Sterling',
    email: 'alexander@sterlinggems.com',
    phone: '+1 (555) 789-0123',
    avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&q=80',
    memberSince: DateTime(2023, 6, 1),
  );

  final List<Order> _orders = [
    Order(id: 'ORD-2024-001', orderDate: DateTime(2024, 12, 15), status: OrderStatus.delivered, total: 2450.00, itemCount: 1, trackingNumber: '1Z999AA10123456784', imageUrl: 'https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=100&q=80'),
    Order(id: 'ORD-2024-002', orderDate: DateTime(2024, 12, 10), status: OrderStatus.shipped, total: 890.00, itemCount: 2, trackingNumber: '1Z999AA10123456785', imageUrl: 'https://images.unsplash.com/photo-1603561596112-0a132b757442?w=100&q=80'),
    Order(id: 'ORD-2024-003', orderDate: DateTime(2024, 12, 5), status: OrderStatus.processing, total: 3200.00, itemCount: 1, imageUrl: 'https://images.unsplash.com/photo-1515562141589-87f0171981f1?w=100&q=80'),
    Order(id: 'ORD-2024-004', orderDate: DateTime(2024, 11, 28), status: OrderStatus.confirmed, total: 675.50, itemCount: 3, imageUrl: 'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=100&q=80'),
  ];

  final List<SavedAddress> _addresses = [
    SavedAddress(id: 'addr_001', label: 'Home', street: '742 Evergreen Terrace', city: 'New York', state: 'NY', zipCode: '10001', country: 'United States', isDefault: true),
    SavedAddress(id: 'addr_002', label: 'Office', street: '350 Fifth Avenue', city: 'New York', state: 'NY', zipCode: '10118', country: 'United States'),
  ];

  final List<PaymentMethod> _paymentMethods = [
    PaymentMethod(id: 'pm_001', brand: CardBrand.visa, lastFourDigits: '4242', expiryDate: '12/27', isDefault: true),
    PaymentMethod(id: 'pm_002', brand: CardBrand.mastercard, lastFourDigits: '8888', expiryDate: '08/26'),
  ];

  final List<WishlistItem> _wishlist = [
    WishlistItem(id: 'wish_001', productId: 'gm_001', title: '4.02 Carat Cushion Cut Diamond', imageUrl: 'https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=200&q=80', price: 24500.00, addedAt: DateTime(2024, 12, 1)),
    WishlistItem(id: 'wish_002', productId: 'gm_002', title: '2.5 Carat Emerald Cut Sapphire Ring', imageUrl: 'https://images.unsplash.com/photo-1603561596112-0a132b757442?w=200&q=80', price: 18900.00, addedAt: DateTime(2024, 11, 20)),
    WishlistItem(id: 'wish_003', productId: 'gm_003', title: 'Pear Shaped Rose Gold Pendant', imageUrl: 'https://images.unsplash.com/photo-1515562141589-87f0171981f1?w=200&q=80', price: 3200.00, addedAt: DateTime(2024, 11, 15)),
  ];

  @override
  Future<UserProfile> getProfile() async => _profile;

  @override
  Future<UserProfile> updateProfile(UserProfile profile) async {
    _profile = profile;
    return _profile;
  }

  @override
  Future<List<Order>> getOrders() async => List.unmodifiable(_orders);

  @override
  Future<List<SavedAddress>> getAddresses() async => List.unmodifiable(_addresses);

  @override
  Future<SavedAddress> addAddress(SavedAddress address) async {
    final newAddr = SavedAddress(
      id: 'addr_${DateTime.now().millisecondsSinceEpoch}',
      label: address.label,
      street: address.street,
      city: address.city,
      state: address.state,
      zipCode: address.zipCode,
      country: address.country,
      isDefault: address.isDefault,
    );
    _addresses.add(newAddr);
    return newAddr;
  }

  @override
  Future<SavedAddress> updateAddress(SavedAddress address) async {
    final idx = _addresses.indexWhere((a) => a.id == address.id);
    if (idx != -1) _addresses[idx] = address;
    return address;
  }

  @override
  Future<void> deleteAddress(String id) async {
    _addresses.removeWhere((a) => a.id == id);
  }

  @override
  Future<List<PaymentMethod>> getPaymentMethods() async => List.unmodifiable(_paymentMethods);

  @override
  Future<void> deletePaymentMethod(String id) async {
    _paymentMethods.removeWhere((p) => p.id == id);
  }

  @override
  Future<List<WishlistItem>> getWishlist() async => List.unmodifiable(_wishlist);

  @override
  Future<void> removeFromWishlist(String id) async {
    _wishlist.removeWhere((w) => w.id == id);
  }

  @override
  Future<void> logout() async {}
}
