import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/ambient_gradient_background.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      (
        'Price Alert: Eternal Radiant',
        'The price of Eternal Radiant (GIA VVS1, 2.45 ct) has dropped by 5% to \$18,450.',
        '2 hours ago',
        Icons.local_offer_outlined,
        AppColors.tertiary,
      ),
      (
        'Vault Deposit Confirmed',
        'Physical deposit of GIA Solitaire #92831 has been safely received in custody.',
        '1 day ago',
        Icons.shield_outlined,
        AppColors.secondary,
      ),
      (
        'Offer Received',
        'A buyer has placed an escrow offer of \$4,800 on Nova Brilliant Cut.',
        '2 days ago',
        Icons.gavel_outlined,
        AppColors.primary,
      ),
      (
        'Certificate Verified',
        'GIA Report #21983021 for Sunrise Pear Diamond has been fully audited and registered on-ledger.',
        '3 days ago',
        Icons.verified_outlined,
        AppColors.secondary,
      ),
      (
        'Portfolio Update',
        'The estimated value of your diamond assets has increased by 1.24% this week.',
        '1 week ago',
        Icons.trending_up_rounded,
        AppColors.primary,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AmbientGradientBackground.home(
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPaddingH,
                  AppSpacing.sm,
                  AppSpacing.screenPaddingH,
                  AppSpacing.md,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: AppSpacing.borderRadiusMd,
                          border: Border.all(
                            color: AppColors.outlineVariant.withValues(alpha: 0.2),
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'NOTIFICATIONS',
                      style: AppTypography.titleLg.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              // Notification List
              Expanded(
                child: notifications.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.notifications_none_rounded,
                              size: 64,
                              color: AppColors.outline.withValues(alpha: 0.3),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              'All caught up!',
                              style: AppTypography.titleLg.copyWith(
                                color: AppColors.onSurface,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              'We\'ll notify you when active listings or offers change.',
                              style: AppTypography.bodyMd.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.screenPaddingH,
                          vertical: AppSpacing.xs,
                        ),
                        itemCount: notifications.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = notifications[index];
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: AppSpacing.borderRadiusCard,
                              border: Border.all(
                                color: AppColors.outlineVariant.withValues(
                                  alpha: 0.25,
                                ),
                              ),
                              boxShadow: AppSpacing.elevationSm,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Icon with shaded background
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: item.$5.withValues(alpha: 0.1),
                                    borderRadius: AppSpacing.borderRadiusMd,
                                  ),
                                  child: Icon(
                                    item.$4,
                                    color: item.$5,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                // Title, description and time stamp
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              item.$1,
                                              style:
                                                  AppTypography.bodyMd.copyWith(
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            item.$3,
                                            style:
                                                AppTypography.overline.copyWith(
                                              color: AppColors.outline,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        item.$2,
                                        style: AppTypography.bodySm.copyWith(
                                          color: AppColors.onSurfaceVariant,
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
