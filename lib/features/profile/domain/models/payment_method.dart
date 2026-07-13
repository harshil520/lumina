/// Card brand for payment methods.
enum CardBrand {
  visa,
  mastercard,
  amex,
  discover,
  other;

  String get label {
    return switch (this) {
      CardBrand.visa => 'Visa',
      CardBrand.mastercard => 'Mastercard',
      CardBrand.amex => 'American Express',
      CardBrand.discover => 'Discover',
      CardBrand.other => 'Card',
    };
  }
}

/// Clean domain representation of a saved payment method.
class PaymentMethod {
  const PaymentMethod({
    required this.id,
    required this.brand,
    required this.lastFourDigits,
    required this.expiryDate,
    this.isDefault = false,
  });

  final String id;
  final CardBrand brand;
  final String lastFourDigits;
  final String expiryDate;
  final bool isDefault;

  String get maskedNumber => '**** **** **** ${lastFourDigits}';
}
