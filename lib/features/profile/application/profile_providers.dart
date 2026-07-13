import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/profile_repository_fake.dart';
import '../domain/models/order.dart';
import '../domain/models/payment_method.dart';
import '../domain/models/saved_address.dart';
import '../domain/models/user_profile.dart';
import '../domain/models/wishlist_item.dart';
import '../domain/repositories/profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryFake();
});

final profileProvider = FutureProvider<UserProfile>((ref) async {
  return ref.read(profileRepositoryProvider).getProfile();
});

final ordersProvider = FutureProvider<List<Order>>((ref) async {
  return ref.read(profileRepositoryProvider).getOrders();
});

final addressesProvider = FutureProvider<List<SavedAddress>>((ref) async {
  return ref.read(profileRepositoryProvider).getAddresses();
});

final paymentMethodsProvider = FutureProvider<List<PaymentMethod>>((ref) async {
  return ref.read(profileRepositoryProvider).getPaymentMethods();
});

final wishlistProvider = FutureProvider<List<WishlistItem>>((ref) async {
  return ref.read(profileRepositoryProvider).getWishlist();
});
