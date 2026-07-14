import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../application/profile_providers.dart';
import '../../domain/models/user_profile.dart';

/// Main profile screen showing user card and navigation to sub-sections.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
        appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        title: Text(
          'My Profile',
          style: AppTypography.headlineLg.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.primary),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SafeArea(
        child: profileAsync.when(
          data: (profile) => SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.sm),
                _ProfileCard(profile: profile),
                const SizedBox(height: AppSpacing.md),
                _MenuSection(
                  items: const [
                    _MenuItem(icon: Icons.shopping_bag_outlined, title: 'Recent Orders', subtitle: 'Track and manage your orders', route: '/profile/orders'),
                    _MenuItem(icon: Icons.location_on_outlined, title: 'Saved Addresses', subtitle: 'Manage delivery locations', route: '/profile/addresses'),
                    _MenuItem(icon: Icons.payment_outlined, title: 'Payment Methods', subtitle: 'Manage cards and billing', route: '/profile/payment-methods'),
                    _MenuItem(icon: Icons.mail_outline, title: 'Messages', subtitle: 'Inbox and support conversations', route: '/profile/messages'),
                    _MenuItem(icon: Icons.favorite_border, title: 'Wishlist', subtitle: 'View your saved items', route: '/profile/wishlist'),
                    _MenuItem(icon: Icons.help_outline, title: 'Help & Support', subtitle: 'Get assistance and contact us', route: '/profile/help'),
                    _MenuItem(icon: Icons.settings_outlined, title: 'Settings', subtitle: 'App preferences and account', route: '/settings'),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                _LogoutButton(),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text('Could not load profile: $err', style: AppTypography.bodyMd.copyWith(color: AppColors.error)),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/profile/edit'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppSpacing.borderRadiusCard,
          border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
          boxShadow: AppSpacing.elevationSm,
        ),
        child: Row(
          children: [
            ClipOval(
              child: Image.network(
                profile.avatarUrl ?? '',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, color: AppColors.onSurfaceVariant, size: 30),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.name,
                    style: AppTypography.titleLg.copyWith(color: AppColors.primary, fontSize: 18),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    profile.email,
                    style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.edit_outlined, color: AppColors.outline, size: 18),
          ],
        ),
      ),
    );
  }
}

class _MenuItem {
  const _MenuItem({required this.icon, required this.title, required this.subtitle, required this.route});
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;
}

class _MenuSection extends StatelessWidget {
  const _MenuSection({required this.items});
  final List<_MenuItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((item) => _buildItem(context, item)).toList(),
    );
  }

  Widget _buildItem(BuildContext context, _MenuItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusCard,
        child: InkWell(
          borderRadius: AppSpacing.borderRadiusCard,
          onTap: () => context.push(item.route),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: AppSpacing.borderRadiusCard,
              border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.15)),
            ),
            child: Row(
              children: [
                Icon(item.icon, color: AppColors.primary, size: 22),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: AppTypography.bodyMd.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                      Text(
                        item.subtitle,
                        style: AppTypography.bodySm.copyWith(color: AppColors.outline),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, color: AppColors.outline, size: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Logout'),
              content: const Text('Are you sure you want to logout?'),
              actions: [
                TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    context.go('/');
                  },
                  child: const Text('Logout', style: TextStyle(color: AppColors.error)),
                ),
              ],
            ),
          );
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.error,
          side: const BorderSide(color: AppColors.error),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusDefault),
        ),
        child: const Text('LOGOUT', style: TextStyle(letterSpacing: 1)),
      ),
    );
  }
}
