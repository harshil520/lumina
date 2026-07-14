import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../application/profile_providers.dart';
import '../../domain/models/order.dart';

/// Screen showing the user's recent orders.
class OrderListScreen extends ConsumerWidget {
  const OrderListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
        title: Text('Recent Orders', style: AppTypography.titleLg.copyWith(color: AppColors.primary)),
      ),
      body: SafeArea(
        child: ordersAsync.when(
          data: (orders) {
            if (orders.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.shopping_bag_outlined, size: 64, color: AppColors.outline),
                    SizedBox(height: AppSpacing.md),
                    Text('No orders yet', style: TextStyle(color: AppColors.outline, fontSize: 16)),
                  ],
                ),
              );
            }
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
              itemCount: orders.length,
              itemBuilder: (context, index) => _OrderCard(order: orders[index]),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text('Could not load orders: $err', style: AppTypography.bodyMd.copyWith(color: AppColors.error)),
            ),
          ),
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(
        RouteNames.orderDetail,
        pathParameters: {'id': order.id},
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppSpacing.borderRadiusCard,
          border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.15)),
          boxShadow: AppSpacing.elevationSm,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: AppSpacing.borderRadiusMd,
              child: Image.network(
                order.imageUrl ?? '',
                width: 56,
                height: 56,
                fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                width: 56,
                height: 56,
                color: AppColors.surfaceContainerHigh,
                child: const Icon(Icons.image, color: AppColors.outline),
              ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(order.id, style: AppTypography.bodyMd.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
                  const SizedBox(height: 2),
                  Text('${order.itemCount} item${order.itemCount > 1 ? 's' : ''} · \$${order.total.toStringAsFixed(2)}',
                      style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _statusColor(order.status).withValues(alpha: 0.1),
                      borderRadius: AppSpacing.borderRadiusPill,
                    ),
                    child: Text(
                      order.status.label,
                      style: AppTypography.badge.copyWith(color: _statusColor(order.status)),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: AppColors.outline, size: 12),
          ],
        ),
      ),
    );
  }
}
