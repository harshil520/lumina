import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../application/profile_providers.dart';
import '../../domain/models/saved_address.dart';

/// Screen showing the user's saved delivery addresses.
class SavedAddressesScreen extends ConsumerWidget {
  const SavedAddressesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressesAsync = ref.watch(addressesProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
        title: Text('Saved Addresses', style: AppTypography.titleLg.copyWith(color: AppColors.primary)),
      ),
      body: SafeArea(
        child: addressesAsync.when(
          data: (addresses) {
            if (addresses.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_on_outlined, size: 64, color: AppColors.outline),
                    SizedBox(height: AppSpacing.md),
                    Text('No saved addresses', style: TextStyle(color: AppColors.outline, fontSize: 16)),
                  ],
                ),
              );
            }
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(AppSpacing.screenPaddingH, 0, AppSpacing.screenPaddingH, AppSpacing.lg),
              itemCount: addresses.length + 1,
              itemBuilder: (context, index) {
                if (index == addresses.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.md),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add),
                        label: const Text('Add New Address'),
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
                return _AddressCard(address: addresses[index]);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text('Could not load addresses: $err', style: AppTypography.bodyMd.copyWith(color: AppColors.error)),
            ),
          ),
        ),
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({required this.address});
  final SavedAddress address;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusCard,
        border: Border.all(
          color: address.isDefault ? AppColors.primary : AppColors.outlineVariant.withValues(alpha: 0.15),
        ),
        boxShadow: address.isDefault ? AppSpacing.elevationPrimary : AppSpacing.elevationSm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.location_on_outlined, color: address.isDefault ? AppColors.primary : AppColors.outline, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(address.label, style: AppTypography.bodyMd.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
                    if (address.isDefault) ...[
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
                const SizedBox(height: 4),
                Text(address.formatted, style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: AppColors.outline, size: 12),
        ],
      ),
    );
  }
}
