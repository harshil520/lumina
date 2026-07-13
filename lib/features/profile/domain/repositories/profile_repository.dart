import '../models/user_profile.dart';
import '../models/order.dart';
import '../models/saved_address.dart';
import '../models/payment_method.dart';
import '../models/wishlist_item.dart';

/// Abstract interface for profile data operations.
///
/// Providers depend on this interface so the implementation can be swapped
/// (fake vs real API) without touching any UI code.
abstract class ProfileRepository {
  Future<UserProfile> getProfile();
  Future<UserProfile> updateProfile(UserProfile profile);
  Future<List<Order>> getOrders();
  Future<List<SavedAddress>> getAddresses();
  Future<SavedAddress> addAddress(SavedAddress address);
  Future<SavedAddress> updateAddress(SavedAddress address);
  Future<void> deleteAddress(String id);
  Future<List<PaymentMethod>> getPaymentMethods();
  Future<void> deletePaymentMethod(String id);
  Future<List<WishlistItem>> getWishlist();
  Future<void> removeFromWishlist(String id);
  Future<void> logout();
}
