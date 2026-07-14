import '../../domain/models/message.dart';
import '../../domain/models/order.dart';
import '../../domain/models/order_item.dart';
import '../../domain/models/payment_info.dart';
import '../../domain/models/payment_method.dart';
import '../../domain/models/saved_address.dart';
import '../../domain/models/shipping_info.dart';
import '../../domain/models/timeline_event.dart';
import '../../domain/models/user_profile.dart';
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
    avatarUrl:
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&q=80',
    memberSince: DateTime(2023, 6, 1),
  );

  final List<Order> _orders = [
    Order(
      id: 'ORD-2024-001',
      orderDate: DateTime(2024, 12, 15),
      status: OrderStatus.delivered,
      total: 2450.00,
      itemCount: 1,
      trackingNumber: '1Z999AA10123456784',
      imageUrl:
          'https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=100&q=80',
      subtotal: 2200.00,
      shippingCost: 50.00,
      tax: 200.00,
      carrier: 'FedEx',
      estimatedDelivery: DateTime(2024, 12, 18),
      items: [
        const OrderItem(
          productId: 'gm_001',
          title: '4.02 Carat Cushion Cut Diamond',
          imageUrl:
              'https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=200&q=80',
          price: 2200.00,
          quantity: 1,
          variantLabel: 'Color: F, Clarity: VS1',
        ),
      ],
      shippingAddress: ShippingInfo(
        fullName: 'Alexander Sterling',
        street: '742 Evergreen Terrace',
        city: 'New York',
        state: 'NY',
        zipCode: '10001',
        country: 'United States',
        phone: '+1 (555) 789-0123',
        carrier: 'FedEx',
        trackingNumber: '1Z999AA10123456784',
        estimatedDelivery: DateTime(2024, 12, 18),
      ),
      paymentInfo: const PaymentInfo(
        methodLabel: 'Visa ending in 4242',
        cardBrand: 'Visa',
        lastFourDigits: '4242',
        billingAddress: '742 Evergreen Terrace, New York, NY 10001',
      ),
      timeline: [
        TimelineEvent(
          date: DateTime(2024, 12, 16, 14, 30),
          status: 'Delivered',
          description: 'Package delivered — left at front door',
          isCompleted: true,
        ),
        TimelineEvent(
          date: DateTime(2024, 12, 15, 9, 0),
          status: 'Out for Delivery',
          description: 'Package is out for delivery with FedEx',
          isCompleted: true,
        ),
        TimelineEvent(
          date: DateTime(2024, 12, 15, 2, 0),
          status: 'Shipped',
          description: 'Package departed FedEx sorting facility',
          isCompleted: true,
        ),
        TimelineEvent(
          date: DateTime(2024, 12, 13, 10, 0),
          status: 'Processing',
          description: 'Order confirmed and is being prepared',
          isCompleted: true,
        ),
        TimelineEvent(
          date: DateTime(2024, 12, 12, 15, 30),
          status: 'Confirmed',
          description: 'Payment verified and order confirmed',
          isCompleted: true,
        ),
      ],
    ),
    Order(
      id: 'ORD-2024-002',
      orderDate: DateTime(2024, 12, 10),
      status: OrderStatus.shipped,
      total: 890.00,
      itemCount: 2,
      trackingNumber: '1Z999AA10123456785',
      imageUrl:
          'https://images.unsplash.com/photo-1603561596112-0a132b757442?w=100&q=80',
      subtotal: 750.00,
      shippingCost: 40.00,
      tax: 100.00,
      carrier: 'FedEx',
      estimatedDelivery: DateTime(2024, 12, 17),
      items: [
        const OrderItem(
          productId: 'gm_004',
          title: 'Round Brilliant Diamond Stud Earrings',
          imageUrl:
              'https://images.unsplash.com/photo-1603561596112-0a132b757442?w=200&q=80',
          price: 450.00,
          quantity: 1,
          variantLabel: '1.0ct TW, 14k White Gold',
        ),
        const OrderItem(
          productId: 'gm_005',
          title: 'Diamond Tennis Bracelet',
          imageUrl:
              'https://images.unsplash.com/photo-1603561596112-0a132b757442?w=200&q=80',
          price: 300.00,
          quantity: 1,
          variantLabel: '7.5 inches',
        ),
      ],
      shippingAddress: ShippingInfo(
        fullName: 'Alexander Sterling',
        street: '742 Evergreen Terrace',
        city: 'New York',
        state: 'NY',
        zipCode: '10001',
        country: 'United States',
        phone: '+1 (555) 789-0123',
        carrier: 'FedEx',
        trackingNumber: '1Z999AA10123456785',
        estimatedDelivery: DateTime(2024, 12, 17),
      ),
      paymentInfo: const PaymentInfo(
        methodLabel: 'Mastercard ending in 8888',
        cardBrand: 'Mastercard',
        lastFourDigits: '8888',
        billingAddress: '742 Evergreen Terrace, New York, NY 10001',
      ),
      timeline: [
        TimelineEvent(
          date: DateTime(2024, 12, 15, 6, 0),
          status: 'Shipped',
          description: 'Package departed FedEx sorting facility',
          isCompleted: true,
        ),
        TimelineEvent(
          date: DateTime(2024, 12, 13, 10, 0),
          status: 'Processing',
          description: 'Order confirmed and is being prepared',
          isCompleted: true,
        ),
        TimelineEvent(
          date: DateTime(2024, 12, 12, 15, 30),
          status: 'Confirmed',
          description: 'Payment verified and order confirmed',
          isCompleted: true,
        ),
      ],
    ),
    Order(
      id: 'ORD-2024-003',
      orderDate: DateTime(2024, 12, 5),
      status: OrderStatus.processing,
      total: 3200.00,
      itemCount: 1,
      imageUrl:
          'https://images.unsplash.com/photo-1515562141589-87f0171981f1?w=100&q=80',
      subtotal: 2800.00,
      shippingCost: 100.00,
      tax: 300.00,
      carrier: 'UPS',
      items: [
        const OrderItem(
          productId: 'gm_006',
          title: 'Pear Shaped Rose Gold Pendant',
          imageUrl:
              'https://images.unsplash.com/photo-1515562141589-87f0171981f1?w=200&q=80',
          price: 2800.00,
          quantity: 1,
          variantLabel: '18k Rose Gold, 2.5ct Diamond',
        ),
      ],
      shippingAddress: const ShippingInfo(
        fullName: 'Alexander Sterling',
        street: '742 Evergreen Terrace',
        city: 'New York',
        state: 'NY',
        zipCode: '10001',
        country: 'United States',
        phone: '+1 (555) 789-0123',
        carrier: 'UPS',
      ),
      paymentInfo: const PaymentInfo(
        methodLabel: 'Visa ending in 4242',
        cardBrand: 'Visa',
        lastFourDigits: '4242',
        billingAddress: '742 Evergreen Terrace, New York, NY 10001',
      ),
      timeline: [
        TimelineEvent(
          date: DateTime(2024, 12, 6),
          status: 'Processing',
          description: 'Order confirmed and is being prepared',
          isCompleted: true,
        ),
        TimelineEvent(
          date: DateTime(2024, 12, 5),
          status: 'Confirmed',
          description: 'Payment verified and order confirmed',
          isCompleted: true,
        ),
      ],
    ),
    Order(
      id: 'ORD-2024-004',
      orderDate: DateTime(2024, 11, 28),
      status: OrderStatus.confirmed,
      total: 675.50,
      itemCount: 3,
      imageUrl:
          'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=100&q=80',
      subtotal: 550.00,
      shippingCost: 35.00,
      tax: 90.50,
      items: [
        const OrderItem(
          productId: 'gm_007',
          title: 'Lab-Grown Emerald Stud Earrings',
          imageUrl:
              'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=200&q=80',
          price: 250.00,
          quantity: 1,
          variantLabel: '1.5ct TW, 14k Yellow Gold',
        ),
        const OrderItem(
          productId: 'gm_008',
          title: 'Gold Chain Necklace',
          imageUrl:
              'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=200&q=80',
          price: 180.00,
          quantity: 1,
          variantLabel: '20 inches, 14k Gold',
        ),
        const OrderItem(
          productId: 'gm_009',
          title: 'Gemstone Birthstone Ring',
          imageUrl:
              'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=200&q=80',
          price: 120.00,
          quantity: 1,
          variantLabel: 'Size 7, Amethyst',
        ),
      ],
      shippingAddress: const ShippingInfo(
        fullName: 'Alexander Sterling',
        street: '742 Evergreen Terrace',
        city: 'New York',
        state: 'NY',
        zipCode: '10001',
        country: 'United States',
        phone: '+1 (555) 789-0123',
      ),
      paymentInfo: const PaymentInfo(
        methodLabel: 'PayPal',
        billingAddress: 'alexander@sterlinggems.com',
      ),
      timeline: [
        TimelineEvent(
          date: DateTime(2024, 11, 28),
          status: 'Confirmed',
          description: 'Payment verified and order confirmed',
          isCompleted: true,
        ),
      ],
    ),
  ];

  final List<SavedAddress> _addresses = [
    const SavedAddress(
      id: 'addr_001',
      label: 'Home',
      street: '742 Evergreen Terrace',
      city: 'New York',
      state: 'NY',
      zipCode: '10001',
      country: 'United States',
      isDefault: true,
    ),
    const SavedAddress(
      id: 'addr_002',
      label: 'Office',
      street: '350 Fifth Avenue',
      city: 'New York',
      state: 'NY',
      zipCode: '10118',
      country: 'United States',
    ),
  ];

  final List<PaymentMethod> _paymentMethods = [
    const PaymentMethod(
      id: 'pm_001',
      brand: CardBrand.visa,
      lastFourDigits: '4242',
      expiryDate: '12/27',
      isDefault: true,
    ),
    const PaymentMethod(
      id: 'pm_002',
      brand: CardBrand.mastercard,
      lastFourDigits: '8888',
      expiryDate: '08/26',
    ),
  ];

  final List<WishlistItem> _wishlist = [
    WishlistItem(
      id: 'wish_001',
      productId: 'gm_001',
      title: '4.02 Carat Cushion Cut Diamond',
      imageUrl:
          'https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=200&q=80',
      price: 24500.00,
      addedAt: DateTime(2024, 12, 1),
    ),
    WishlistItem(
      id: 'wish_002',
      productId: 'gm_002',
      title: '2.5 Carat Emerald Cut Sapphire Ring',
      imageUrl:
          'https://images.unsplash.com/photo-1603561596112-0a132b757442?w=200&q=80',
      price: 18900.00,
      addedAt: DateTime(2024, 11, 20),
    ),
    WishlistItem(
      id: 'wish_003',
      productId: 'gm_003',
      title: 'Pear Shaped Rose Gold Pendant',
      imageUrl:
          'https://images.unsplash.com/photo-1515562141589-87f0171981f1?w=200&q=80',
      price: 3200.00,
      addedAt: DateTime(2024, 11, 15),
    ),
  ];

  final List<Message> _messages = [
    Message(
      id: 'msg_001',
      senderName: 'Lumina Concierge',
      senderAvatar: '',
      preview: 'Your 4.02ct cushion cut diamond certificate is ready for review. Please confirm the details at your earliest convenience.',
      timestamp: DateTime(2024, 12, 16, 10, 30),
      isRead: false,
      imageUrl: 'https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=100&q=80',
    ),
    Message(
      id: 'msg_002',
      senderName: 'Alexander Sterling',
      senderAvatar: '',
      preview: 'Order ORD-2024-001 has been marked as delivered. We hope you love your new diamond!',
      timestamp: DateTime(2024, 12, 15, 15, 0),
      isRead: true,
    ),
    Message(
      id: 'msg_003',
      senderName: 'FedEx Delivery Updates',
      senderAvatar: '',
      preview: 'Your package ORD-2024-002 is out for delivery and will arrive today.',
      timestamp: DateTime(2024, 12, 15, 8, 15),
      isRead: true,
    ),
    Message(
      id: 'msg_004',
      senderName: 'Lumina Concierge',
      senderAvatar: '',
      preview: 'Thank you for your purchase! A member of our team will reach out to confirm the details of your custom pendant order.',
      timestamp: DateTime(2024, 12, 6, 14, 0),
      isRead: true,
    ),
    Message(
      id: 'msg_005',
      senderName: 'Lumina Gems',
      senderAvatar: '',
      preview: 'Exclusive preview: New lab-grown diamond collection arriving next week. Be the first to see our latest arrivals.',
      timestamp: DateTime(2024, 11, 25, 11, 0),
      isRead: true,
    ),
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
  Future<Order> getOrderById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _orders.firstWhere((o) => o.id == id);
  }

  @override
  Future<List<SavedAddress>> getAddresses() async =>
      List.unmodifiable(_addresses);

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
  Future<List<PaymentMethod>> getPaymentMethods() async =>
      List.unmodifiable(_paymentMethods);

  @override
  Future<void> deletePaymentMethod(String id) async {
    _paymentMethods.removeWhere((p) => p.id == id);
  }

  @override
  Future<List<WishlistItem>> getWishlist() async =>
      List.unmodifiable(_wishlist);

  @override
  Future<void> addToWishlist(WishlistItem item) async {
    _wishlist.add(item);
  }

  @override
  Future<void> removeFromWishlist(String id) async {
    _wishlist.removeWhere((w) => w.id == id);
  }

  @override
  Future<List<Message>> getMessages() async =>
      List.unmodifiable(_messages);

  @override
  Future<PaymentMethod> addPaymentMethod(PaymentMethod method) async {
    final newMethod = PaymentMethod(
      id: 'pm_${DateTime.now().millisecondsSinceEpoch}',
      brand: method.brand,
      lastFourDigits: method.lastFourDigits,
      expiryDate: method.expiryDate,
      isDefault: _paymentMethods.isEmpty,
    );
    _paymentMethods.add(newMethod);
    return newMethod;
  }

  @override
  Future<PaymentMethod> setDefaultPaymentMethod(String id) async {
    for (final method in _paymentMethods) {
      final updated = PaymentMethod(
        id: method.id,
        brand: method.brand,
        lastFourDigits: method.lastFourDigits,
        expiryDate: method.expiryDate,
        isDefault: method.id == id,
      );
      final idx = _paymentMethods.indexOf(method);
      _paymentMethods[idx] = updated;
    }
    return _paymentMethods.firstWhere((p) => p.id == id);
  }

  @override
  Future<void> logout() async {}
}
