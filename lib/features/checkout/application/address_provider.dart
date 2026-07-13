import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/shipping_address.dart';

/// Notifier that manages the user's saved shipping addresses.
class AddressNotifier extends StateNotifier<List<ShippingAddress>> {
  AddressNotifier()
      : super([
          const ShippingAddress(
            id: 'addr-default',
            name: 'Julianne Sterling',
            street: '742 Park Avenue, Penthouse B',
            city: 'New York',
            postalCode: '10021',
          ),
        ]);

  /// Saves a new shipping address if it does not already exist.
  void saveAddress({
    required String name,
    required String street,
    required String city,
    required String postalCode,
  }) {
    // Avoid duplicates by comparing fields
    final exists = state.any((addr) =>
        addr.name.toLowerCase().trim() == name.toLowerCase().trim() &&
        addr.street.toLowerCase().trim() == street.toLowerCase().trim() &&
        addr.city.toLowerCase().trim() == city.toLowerCase().trim() &&
        addr.postalCode.toLowerCase().trim() == postalCode.toLowerCase().trim());

    if (exists) return;

    final newAddress = ShippingAddress(
      id: 'addr-${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim(),
      street: street.trim(),
      city: city.trim(),
      postalCode: postalCode.trim(),
    );

    state = [...state, newAddress];
  }
}

/// Provider for [AddressNotifier] managing saved shipping addresses.
final addressProvider = StateNotifierProvider<AddressNotifier, List<ShippingAddress>>((ref) {
  return AddressNotifier();
});
