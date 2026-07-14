import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../cart/application/cart_provider.dart';
import '../../../gemstone_detail/domain/models/gemstone_detail.dart';
import '../../application/profile_providers.dart';
import '../../domain/models/order.dart';
import '../../domain/models/order_item.dart';
import '../../domain/models/payment_info.dart';
import '../../domain/models/shipping_info.dart';
import '../../domain/models/timeline_event.dart';

/// Screen showing the full details and summary of a single order.
class OrderDetailScreen extends ConsumerWidget {
  const OrderDetailScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(orderDetailProvider(orderId));

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Order Details',
          style: AppTypography.titleLg.copyWith(color: AppColors.primary),
        ),
      ),
      body: SafeArea(
        child: orderAsync.when(
          data: (order) => _OrderDetailContent(order: order, ref: ref),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Could not load order details.',
                    style: AppTypography.bodyMd.copyWith(color: AppColors.error),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OrderDetailContent extends StatelessWidget {
  const _OrderDetailContent({required this.order, required this.ref});
  final Order order;
  final WidgetRef ref;

  void _onRequestInvoice(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _InvoiceSheet(order: order),
    );
  }

  void _onContactSupport(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _ContactSupportSheet(),
    );
  }

  Future<void> _onReorder(BuildContext context) async {
    if (order.items == null || order.items!.isEmpty) return;

    final cartNotifier = ref.read(cartProvider.notifier);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = context;

    String? errorItem;
    int addedCount = 0;

    for (final item in order.items!) {
      final gemstone = _orderItemToGemstoneDetail(item);
      if (gemstone == null) {
        errorItem = item.title;
        continue;
      }
      try {
        await cartNotifier.addItem(gemstone);
        addedCount++;
      } catch (_) {
        errorItem = item.title;
      }
    }

    if (!navigator.mounted) return;

    if (addedCount > 0) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('$addedCount item${addedCount > 1 ? 's' : ''} added to cart'),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'View Cart',
            onPressed: () => context.pushNamed('cart'),
          ),
        ),
      );
    }
    if (errorItem != null) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('Could not reorder: $errorItem'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  GemstoneDetail? _orderItemToGemstoneDetail(OrderItem item) {
    final nameParts = item.title.split(' — ');
    final name = nameParts.isNotEmpty ? nameParts[0] : item.title;
    final caratMatch = RegExp(r'(\d+\.?\d*)\s*ct', caseSensitive: false).firstMatch(item.title);
    final caratStr = caratMatch != null ? '${caratMatch.group(1)}ct' : 'N/A';

    return GemstoneDetail(
      id: item.productId,
      name: name,
      collectionLabel: 'Gemstone Collection',
      price: item.price,
      imageUrls: [item.imageUrl],
      certificationBadge: 'GIA',
      caratWeight: caratStr,
      colorGrade: 'F',
      clarityGrade: 'VS1',
      cutGrade: 'Excellent',
      polish: 'Excellent',
      symmetry: 'Excellent',
      fluorescence: 'None',
      giaReportNumber: 'GIA${item.productId.hashCode.abs().toString().padLeft(10, '0')}',
      description: item.title,
      seller: const SellerInfo(
        name: 'Lumina Gems',
        avatarUrl: '',
        rating: 4.8,
        reviewCount: 1247,
        tagline: 'Premium Gemstones & Fine Jewelry',
      ),
      similarStoneIds: [],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPaddingH,
        AppSpacing.sm,
        AppSpacing.screenPaddingH,
        AppSpacing.xl,
      ),
      children: [
        _OrderHeader(order: order),
        const SizedBox(height: AppSpacing.md),
        if (order.timeline != null && order.timeline!.isNotEmpty) ...[
          _StatusTimeline(events: order.timeline!),
          const SizedBox(height: AppSpacing.md),
        ],
        if (order.items != null && order.items!.isNotEmpty) ...[
          _SectionHeader(title: 'Items Ordered'),
          const SizedBox(height: AppSpacing.sm),
          ...order.items!.map((item) => _OrderItemCard(item: item)),
          const SizedBox(height: AppSpacing.md),
        ],
        if (order.shippingAddress != null) ...[
          _SectionHeader(title: 'Shipping Address'),
          const SizedBox(height: AppSpacing.sm),
          _ShippingCard(shipping: order.shippingAddress!),
          const SizedBox(height: AppSpacing.md),
        ],
        if (order.paymentInfo != null) ...[
          _SectionHeader(title: 'Payment'),
          const SizedBox(height: AppSpacing.sm),
          _PaymentCard(payment: order.paymentInfo!),
          const SizedBox(height: AppSpacing.md),
        ],
        _SectionHeader(title: 'Price Summary'),
        const SizedBox(height: AppSpacing.sm),
        _PriceBreakdownCard(order: order),
        const SizedBox(height: AppSpacing.lg),
        _ActionButtons(
          order: order,
          onRequestInvoice: () => _onRequestInvoice(context),
          onContactSupport: () => _onContactSupport(context),
          onReorder: () => _onReorder(context),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Request Invoice Sheet
// ─────────────────────────────────────────────────────────────────────────────

class _InvoiceSheet extends StatelessWidget {
  const _InvoiceSheet({required this.order});
  final Order order;

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Future<void> _sendViaEmail(BuildContext context) async {
    final subject = Uri.encodeComponent('Invoice for ${order.id}');
    final body = Uri.encodeComponent(
      'Order: ${order.id}\n'
      'Date: ${_formatDate(order.orderDate)}\n'
      'Total: \$${order.total.toStringAsFixed(2)}\n\n'
      'Thank you for your business.\n'
      '— Lumina Gems',
    );
    final uri = Uri.parse('mailto:support@luminagems.com?subject=$subject&body=$body');

    try {
      await launchUrl(uri);
    } catch (_) {
      await Clipboard.setData(ClipboardData(
        text: 'support@luminagems.com',
      ));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email address copied to clipboard'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _simulateDownload(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Invoice PDF will be available for download shortly'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.md + bottomInset),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLg)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHighest,
                  borderRadius: AppSpacing.borderRadiusPill,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Invoice', style: AppTypography.headlineMd.copyWith(color: AppColors.primary)),
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: AppSpacing.cardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _invoiceLine('Lumina Gems', AppTypography.bodyMd.copyWith(fontWeight: FontWeight.w600)),
                  _invoiceLine('support@luminagems.com', AppTypography.bodySm),
                  const SizedBox(height: AppSpacing.sm),
                  const Divider(height: 1),
                  const SizedBox(height: AppSpacing.sm),
                  _invoiceLine('Invoice #', AppTypography.bodySm.copyWith(color: AppColors.outline)),
                  _invoiceLine(order.id, AppTypography.bodyMd.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: AppSpacing.xs),
                  _invoiceLine('Date', AppTypography.bodySm.copyWith(color: AppColors.outline)),
                  _invoiceLine(_formatDate(order.orderDate), AppTypography.bodyMd),
                  const SizedBox(height: AppSpacing.xs),
                  _invoiceLine('Status', AppTypography.bodySm.copyWith(color: AppColors.outline)),
                  _invoiceLine(order.status.label, AppTypography.bodyMd),
                  if (order.carrier != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    _invoiceLine('Carrier', AppTypography.bodySm.copyWith(color: AppColors.outline)),
                    _invoiceLine(order.carrier!, AppTypography.bodyMd),
                  ],
                  if (order.trackingNumber != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    _invoiceLine('Tracking', AppTypography.bodySm.copyWith(color: AppColors.outline)),
                    _invoiceLine(order.trackingNumber!, AppTypography.bodyMd),
                  ],
                ],
              ),
            ),
            if (order.items != null && order.items!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: AppSpacing.cardDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Items', style: AppTypography.eyebrow.copyWith(color: AppColors.onSurfaceVariant)),
                    const SizedBox(height: AppSpacing.sm),
                    ...order.items!.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(item.title, style: AppTypography.bodySm, maxLines: 2, overflow: TextOverflow.ellipsis),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text('x${item.quantity}', style: AppTypography.bodySm.copyWith(color: AppColors.outline)),
                          const SizedBox(width: AppSpacing.sm),
                          SizedBox(
                            width: 72,
                            child: Text('\$${item.total.toStringAsFixed(2)}', style: AppTypography.priceSm, textAlign: TextAlign.right),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
            _PriceBreakdownCard(order: order),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _simulateDownload(context),
                    icon: const Icon(Icons.download_outlined, size: 18),
                    label: const Text('Download PDF'),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => _sendViaEmail(context),
                    icon: const Icon(Icons.email_outlined, size: 18),
                    label: const Text('Send to Email'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _invoiceLine(String text, TextStyle style) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Text(text, style: style),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Contact Support Sheet
// ─────────────────────────────────────────────────────────────────────────────

class _ContactSupportSheet extends StatelessWidget {
  const _ContactSupportSheet();

  Future<void> _launchUrl(String url, BuildContext context) async {
    try {
      await launchUrl(Uri.parse(url));
    } catch (_) {
      final label = url.startsWith('mailto:')
          ? url.substring(7)
          : url.startsWith('tel:')
              ? url.substring(4)
              : url;
      await Clipboard.setData(ClipboardData(text: label));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$label copied to clipboard'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.md + MediaQuery.of(context).viewInsets.bottom),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLg)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHighest,
                borderRadius: AppSpacing.borderRadiusPill,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Contact Support', style: AppTypography.headlineMd.copyWith(color: AppColors.primary)),
          const SizedBox(height: AppSpacing.sm),
          _SupportTile(
            icon: Icons.email_outlined,
            title: 'Email Us',
            subtitle: 'support@luminagems.com',
            onTap: () => _launchUrl('mailto:support@luminagems.com', context),
          ),
          _SupportTile(
            icon: Icons.phone_outlined,
            title: 'Call Us',
            subtitle: '+1 (800) 555-LUNA',
            onTap: () => _launchUrl('tel:+18005555862', context),
          ),
          _SupportTile(
            icon: Icons.chat_outlined,
            title: 'Live Chat',
            subtitle: 'Chat with a gemstone specialist',
            onTap: () {
              Navigator.pop(context);
              context.pushNamed('concierge');
            },
          ),
          _SupportTile(
            icon: Icons.help_outline,
            title: 'Help Center',
            subtitle: 'FAQs, shipping, returns & more',
            onTap: () {
              Navigator.pop(context);
              context.pushNamed('help');
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Available Mon–Fri, 9 AM – 8 PM EST',
            style: AppTypography.bodySm.copyWith(color: AppColors.outline),
          ),
        ],
      ),
    );
  }
}

class _SupportTile extends StatelessWidget {
  const _SupportTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        leading: Container(
          width: 44, height: 44,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: AppSpacing.borderRadiusMd,
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        title: Text(title, style: AppTypography.bodyMd.copyWith(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
        trailing: const Icon(Icons.chevron_right, color: AppColors.outline, size: 20),
        shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusMd),
        onTap: onTap,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Action Buttons
// ─────────────────────────────────────────────────────────────────────────────

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.order,
    required this.onRequestInvoice,
    required this.onContactSupport,
    required this.onReorder,
  });
  final Order order;
  final VoidCallback onRequestInvoice;
  final VoidCallback onContactSupport;
  final VoidCallback onReorder;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onRequestInvoice,
            icon: const Icon(Icons.receipt_long_outlined, size: 18),
            label: const Text('Request Invoice'),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            onPressed: onContactSupport,
            icon: const Icon(Icons.headset_mic_outlined, size: 18),
            label: const Text('Contact Support'),
          ),
        ),
        if (order.status == OrderStatus.delivered) ...[
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onReorder,
              icon: const Icon(Icons.replay_outlined, size: 18),
              label: const Text('Reorder'),
            ),
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header, Timeline, Items, Shipping, Payment, Price Breakdown
// ─────────────────────────────────────────────────────────────────────────────

class _OrderHeader extends StatelessWidget {
  const _OrderHeader({required this.order});
  final Order order;

  Color _statusColor(OrderStatus status) {
    return switch (status) {
      OrderStatus.delivered => AppColors.success,
      OrderStatus.shipped => AppColors.info,
      OrderStatus.processing => AppColors.accentAmber,
      OrderStatus.confirmed => AppColors.primary,
      OrderStatus.cancelled => AppColors.error,
      OrderStatus.returned => AppColors.warning,
      OrderStatus.pending => AppColors.outline,
    };
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(order.status);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: AppSpacing.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  order.id,
                  style: AppTypography.headlineMd.copyWith(color: AppColors.primary),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: AppSpacing.borderRadiusPill,
                ),
                child: Text(
                  order.status.label,
                  style: AppTypography.labelSm.copyWith(color: statusColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Placed on ${_formatDate(order.orderDate)}',
            style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
          ),
          if (order.carrier != null && order.trackingNumber != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              '${order.carrier} · ${order.trackingNumber}',
              style: AppTypography.bodySm.copyWith(color: AppColors.outline),
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTypography.eyebrow.copyWith(color: AppColors.onSurfaceVariant),
    );
  }
}

class _StatusTimeline extends StatelessWidget {
  const _StatusTimeline({required this.events});
  final List<TimelineEvent> events;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: AppSpacing.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Timeline',
            style: AppTypography.eyebrow.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.sm),
          ...List.generate(events.length, (index) {
            final event = events[index];
            final isFirst = index == 0;
            final isLast = index == events.length - 1;
            return _TimelineRow(event: event, isFirst: isFirst, isLast: isLast);
          }),
        ],
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.event, required this.isFirst, required this.isLast});
  final TimelineEvent event;
  final bool isFirst;
  final bool isLast;

  String _formatTime(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final amPm = date.hour >= 12 ? 'PM' : 'AM';
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute $amPm';
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 12, height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: event.isCompleted ? AppColors.secondary : AppColors.surfaceContainerHighest,
                  border: Border.all(
                    color: event.isCompleted ? AppColors.secondary : AppColors.outlineVariant,
                    width: 2,
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: event.isCompleted
                        ? AppColors.secondary.withValues(alpha: 0.4)
                        : AppColors.surfaceContainerHighest,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.status,
                    style: AppTypography.bodyMd.copyWith(
                      fontWeight: FontWeight.w600,
                      color: event.isCompleted ? AppColors.onSurface : AppColors.outline,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    event.description,
                    style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${_formatDate(event.date)} at ${_formatTime(event.date)}',
                    style: AppTypography.badge.copyWith(color: AppColors.outline),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderItemCard extends StatelessWidget {
  const _OrderItemCard({required this.item});
  final OrderItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: AppSpacing.cardDecoration,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: AppSpacing.borderRadiusMd,
            child: Image.network(
              item.imageUrl,
              width: 64, height: 64,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                width: 64, height: 64,
                color: AppColors.surfaceContainerHigh,
                child: const Icon(Icons.image, color: AppColors.outline),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppTypography.bodyMd.copyWith(fontWeight: FontWeight.w600, color: AppColors.onSurface),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.variantLabel != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    item.variantLabel!,
                    style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Qty: ${item.quantity}', style: AppTypography.bodySm.copyWith(color: AppColors.outline)),
                    Text('\$${item.total.toStringAsFixed(2)}', style: AppTypography.priceSm.copyWith(color: AppColors.primary)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShippingCard extends StatelessWidget {
  const _ShippingCard({required this.shipping});
  final ShippingInfo shipping;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: AppSpacing.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.local_shipping_outlined, size: 18, color: AppColors.primary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  shipping.fullName,
                  style: AppTypography.bodyMd.copyWith(fontWeight: FontWeight.w600, color: AppColors.onSurface),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(shipping.street, style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
          Text('${shipping.city}, ${shipping.state} ${shipping.zipCode}', style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
          Text(shipping.country, style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
          if (shipping.phone != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(shipping.phone!, style: AppTypography.bodySm.copyWith(color: AppColors.outline)),
          ],
          if (shipping.carrier != null && shipping.trackingNumber != null) ...[
            const Divider(height: AppSpacing.md),
            _InfoRow(label: 'Carrier', value: shipping.carrier!),
            _InfoRow(label: 'Tracking', value: shipping.trackingNumber!),
          ],
          if (shipping.estimatedDelivery != null) ...[
            const SizedBox(height: AppSpacing.xs),
            _InfoRow(label: 'Est. Delivery', value: _formatDate(shipping.estimatedDelivery!)),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: AppTypography.bodySm.copyWith(color: AppColors.outline)),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.bodySm.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  const _PaymentCard({required this.payment});
  final PaymentInfo payment;

  IconData _cardIcon(String? brand) {
    return switch (brand?.toLowerCase()) {
      'visa' || 'mastercard' => Icons.credit_card,
      'paypal' => Icons.account_balance_wallet,
      _ => Icons.payment,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: AppSpacing.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_cardIcon(payment.cardBrand), size: 20, color: AppColors.primary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  payment.methodLabel,
                  style: AppTypography.bodyMd.copyWith(fontWeight: FontWeight.w600, color: AppColors.onSurface),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (payment.billingAddress != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              payment.billingAddress!,
              style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

class _PriceBreakdownCard extends StatelessWidget {
  const _PriceBreakdownCard({required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: AppSpacing.cardDecoration,
      child: Column(
        children: [
          if (order.subtotal != null) _PriceRow(label: 'Subtotal', value: order.subtotal!),
          if (order.shippingCost != null) _PriceRow(label: 'Shipping', value: order.shippingCost!),
          if (order.tax != null) _PriceRow(label: 'Tax', value: order.tax!),
          const Divider(height: AppSpacing.md),
          _PriceRow(label: 'Total', value: order.total, isBold: true),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({required this.label, required this.value, this.isBold = false});
  final String label;
  final double value;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: (isBold ? AppTypography.bodyMd : AppTypography.bodySm).copyWith(
              color: isBold ? AppColors.onSurface : AppColors.onSurfaceVariant,
              fontWeight: isBold ? FontWeight.w600 : null,
            ),
          ),
          Text(
            '\$${value.toStringAsFixed(2)}',
            style: (isBold ? AppTypography.priceMd : AppTypography.priceSm).copyWith(
              color: isBold ? AppColors.primary : AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
