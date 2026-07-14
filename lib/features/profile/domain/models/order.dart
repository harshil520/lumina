import 'order_item.dart';
import 'payment_info.dart';
import 'shipping_info.dart';
import 'timeline_event.dart';

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
    this.subtotal,
    this.shippingCost,
    this.tax,
    this.items,
    this.shippingAddress,
    this.paymentInfo,
    this.timeline,
    this.carrier,
    this.estimatedDelivery,
  });

  final String id;
  final DateTime orderDate;
  final OrderStatus status;
  final double total;
  final int itemCount;
  final String? trackingNumber;
  final String? imageUrl;
  final double? subtotal;
  final double? shippingCost;
  final double? tax;
  final List<OrderItem>? items;
  final ShippingInfo? shippingAddress;
  final PaymentInfo? paymentInfo;
  final List<TimelineEvent>? timeline;
  final String? carrier;
  final DateTime? estimatedDelivery;
}
