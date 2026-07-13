import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../application/profile_providers.dart';
import '../../domain/models/payment_method.dart';

/// Screen showing the user's saved payment methods.
class PaymentMethodsScreen extends ConsumerWidget {
  const PaymentMethodsScreen({super.key});

  IconData _brandIcon(CardBrand brand) {
    return switch (brand) {
      CardBrand.visa => Icons.credit_card,
      CardBrand.mastercard => Icons.credit_card,
      CardBrand.amex => Icons.credit_card,
      CardBrand.discover => Icons.credit_card,
      CardBrand.other => Icons.credit_card,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final methodsAsync = ref.watch(paymentMethodsProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
        title: Text('Payment Methods', style: AppTypography.titleLg.copyWith(color: AppColors.primary)),
      ),
      body: SafeArea(
        child: methodsAsync.when(
          data: (methods) {
            if (methods.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.credit_card_outlined, size: 64, color: AppColors.outline),
                    SizedBox(height: AppSpacing.md),
                    Text('No payment methods', style: TextStyle(color: AppColors.outline, fontSize: 16)),
                  ],
                ),
              );
            }
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(AppSpacing.screenPaddingH, 0, AppSpacing.screenPaddingH, AppSpacing.lg),
              itemCount: methods.length + 1,
              itemBuilder: (context, index) {
                if (index == methods.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.md),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add),
                        label: const Text('Add Payment Method'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusDefault),
                        ),
                      ),
                    ),
                  );
                }
                return _PaymentMethodCard(method: methods[index], brandIcon: _brandIcon(methods[index].brand));
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text('Could not load payment methods: $err', style: AppTypography.bodyMd.copyWith(color: AppColors.error)),
            ),
          ),
        ),
      ),
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  const _PaymentMethodCard({required this.method, required this.brandIcon});
  final PaymentMethod method;
  final IconData brandIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusCard,
        border: Border.all(
          color: method.isDefault ? AppColors.primary : AppColors.outlineVariant.withValues(alpha: 0.15),
        ),
        boxShadow: method.isDefault ? AppSpacing.elevationPrimary : AppSpacing.elevationSm,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: AppSpacing.borderRadiusMd,
            ),
            child: Icon(brandIcon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(method.brand.label, style: AppTypography.bodyMd.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
                    if (method.isDefault) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: AppSpacing.borderRadiusPill,
                        ),
                        child: Text('Default', style: AppTypography.badge.copyWith(color: AppColors.primary)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text('${method.maskedNumber} · Expires ${method.expiryDate}',
                    style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: AppColors.outline, size: 12),
        ],
      ),
    );
  }
}
