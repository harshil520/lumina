import '../models/message.dart';
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
  Future<Order> getOrderById(String id);
  Future<List<SavedAddress>> getAddresses();
  Future<SavedAddress> addAddress(SavedAddress address);
  Future<SavedAddress> updateAddress(SavedAddress address);
  Future<void> deleteAddress(String id);
  Future<List<PaymentMethod>> getPaymentMethods();
  Future<PaymentMethod> addPaymentMethod(PaymentMethod method);
  Future<PaymentMethod> setDefaultPaymentMethod(String id);
  Future<void> deletePaymentMethod(String id);
  Future<List<WishlistItem>> getWishlist();
  Future<void> addToWishlist(WishlistItem item);
  Future<void> removeFromWishlist(String id);
  Future<List<Message>> getMessages();
  Future<void> logout();
}
