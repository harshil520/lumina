/// Payment method summary used in order details.
class PaymentInfo {
  const PaymentInfo({
    required this.methodLabel,
    this.cardBrand,
    this.lastFourDigits,
    this.billingAddress,
  });

  final String methodLabel;
  final String? cardBrand;
  final String? lastFourDigits;
  final String? billingAddress;
}
