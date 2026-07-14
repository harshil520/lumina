/// Shipping address and carrier details for an order.
class ShippingInfo {
  const ShippingInfo({
    required this.fullName,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    this.phone,
    this.carrier,
    this.trackingNumber,
    this.estimatedDelivery,
  });

  final String fullName;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final String? phone;
  final String? carrier;
  final String? trackingNumber;
  final DateTime? estimatedDelivery;
}
