/// Represents a saved shipping address for checkout.
class ShippingAddress {
  const ShippingAddress({
    required this.id,
    required this.name,
    required this.street,
    required this.city,
    required this.postalCode,
  });

  /// Unique identifier for this saved location.
  final String id;

  /// Full legal name of the recipient.
  final String name;

  /// Street address (e.g. 123 Main St, Apt 4B).
  final String street;

  /// City name.
  final String city;

  /// Postal / Zip code.
  final String postalCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShippingAddress &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          street == other.street &&
          city == other.city &&
          postalCode == other.postalCode;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      street.hashCode ^
      city.hashCode ^
      postalCode.hashCode;
}
