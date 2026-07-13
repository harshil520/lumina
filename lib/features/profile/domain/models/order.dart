/// Order status enum matching common marketplace states.
enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled,
  returned;

  String get label {
    return switch (this) {
      OrderStatus.pending => 'Pending',
      OrderStatus.confirmed => 'Confirmed',
      OrderStatus.processing => 'Processing',
      OrderStatus.shipped => 'Shipped',
      OrderStatus.delivered => 'Delivered',
      OrderStatus.cancelled => 'Cancelled',
      OrderStatus.returned => 'Returned',
    };
  }
}

/// Clean domain representation of a user order.
class Order {
  const Order({
    required this.id,
    required this.orderDate,
    required this.status,
    required this.total,
    required this.itemCount,
    this.trackingNumber,
    this.imageUrl,
  });

  final String id;
  final DateTime orderDate;
  final OrderStatus status;
  final double total;
  final int itemCount;
  final String? trackingNumber;
  final String? imageUrl;
}
