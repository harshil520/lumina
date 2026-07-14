/// A single product line item within an order.
class OrderItem {
  const OrderItem({
    required this.productId,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    this.variantLabel,
  });

  final String productId;
  final String title;
  final String imageUrl;
  final double price;
  final int quantity;
  final String? variantLabel;

  double get total => price * quantity;
}
