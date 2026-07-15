import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../application/settings_providers.dart';
import '../../domain/models/supported_currency.dart';
import '../../domain/models/supported_language.dart';
import '../widgets/preference_selection_sheet.dart';

/// Main settings screen with grouped sections for all app preferences.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
        title: Text('Settings', style: AppTypography.titleLg.copyWith(color: AppColors.primary)),
      ),
      body: SafeArea(
        child: settingsAsync.when(
          data: (settings) => ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.screenPaddingH),
            children: [
              _SectionHeader(title: 'Account'),
              _SettingsTile(
                icon: Icons.person_outline,
                title: 'Personal Information',
                subtitle: 'Name, email, phone',
                onTap: () => context.push('/profile/edit'),
              ),
              _SettingsTile(
                icon: Icons.shield_outlined,
                title: 'Password & Security',
                subtitle: 'Change password, 2FA',
                onTap: () {},
              ),
              const Divider(height: AppSpacing.lg),
              _SectionHeader(title: 'Notifications'),
              _SwitchTile(
                icon: Icons.notifications_outlined,
                title: 'Push Notifications',
                value: settings.notificationsEnabled,
                onChanged: (_) => ref.read(settingsNotifierProvider.notifier).toggleNotifications(),
              ),
              _SwitchTile(
                icon: Icons.email_outlined,
                title: 'Email Notifications',
                value: settings.emailNotifications,
                onChanged: (_) => ref.read(settingsNotifierProvider.notifier).toggleEmailNotifications(),
              ),
              _SwitchTile(
                icon: Icons.sms_outlined,
                title: 'SMS Notifications',
                value: settings.smsNotifications,
                onChanged: (_) => ref.read(settingsNotifierProvider.notifier).toggleSmsNotifications(),
              ),
              const SizedBox(height: AppSpacing.sm),
              _SubHeader(title: 'Notification Types'),
              _SwitchTile(
                icon: Icons.inventory_2_outlined,
                title: 'Order Updates',
                subtitle: 'Shipping, delivery, returns',
                value: settings.orderUpdates,
                onChanged: (_) => ref.read(settingsNotifierProvider.notifier).toggleOrderUpdates(),
              ),
              _SwitchTile(
                icon: Icons.local_offer_outlined,
                title: 'Promotions & Deals',
                value: settings.promotions,
                onChanged: (_) => ref.read(settingsNotifierProvider.notifier).togglePromotions(),
              ),
              _SwitchTile(
                icon: Icons.new_releases_outlined,
                title: 'New Arrivals',
                value: settings.newArrivals,
                onChanged: (_) => ref.read(settingsNotifierProvider.notifier).toggleNewArrivals(),
              ),
              _SwitchTile(
                icon: Icons.trending_down_outlined,
                title: 'Price Drops',
                value: settings.priceDrops,
                onChanged: (_) => ref.read(settingsNotifierProvider.notifier).togglePriceDrops(),
              ),
              _SwitchTile(
                icon: Icons.article_outlined,
                title: 'Newsletter',
                value: settings.newsletter,
                onChanged: (_) => ref.read(settingsNotifierProvider.notifier).toggleNewsletter(),
              ),
              const Divider(height: AppSpacing.lg),
              _SectionHeader(title: 'Privacy & Security'),
              _SwitchTile(
                icon: Icons.fingerprint,
                title: 'Biometric Authentication',
                subtitle: 'Use fingerprint or face ID to log in',
                value: settings.biometricAuth,
                onChanged: (_) => ref.read(settingsNotifierProvider.notifier).toggleBiometricAuth(),
              ),
              _SwitchTile(
                icon: Icons.credit_card_outlined,
                title: 'Save Payment Info',
                subtitle: 'Store card details for faster checkout',
                value: settings.saveCards,
                onChanged: (_) => ref.read(settingsNotifierProvider.notifier).toggleSaveCards(),
              ),
              const Divider(height: AppSpacing.lg),
              _SectionHeader(title: 'App Preferences'),
              _SettingsTile(
                icon: Icons.language_outlined,
                title: 'Language',
                subtitle: _languageDisplayName(settings.language),
                onTap: () => _showLanguageSheet(context, ref, settings.language),
              ),
              _SettingsTile(
                icon: Icons.attach_money_outlined,
                title: 'Currency',
                subtitle: '${settings.currency} — ${_currencyDisplayName(settings.currency)}',
                onTap: () => _showCurrencySheet(context, ref, settings.currency),
              ),
              const Divider(height: AppSpacing.lg),
              _SectionHeader(title: 'About'),
              _SettingsTile(
                icon: Icons.info_outline,
                title: 'About Lumina Gems',
                subtitle: 'Version 1.0.0',
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.description_outlined,
                title: 'Terms of Service',
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                onTap: () {},
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text('Could not load settings: $err', style: AppTypography.bodyMd.copyWith(color: AppColors.error)),
            ),
          ),
        ),
      ),
    );
  }

  String _languageDisplayName(String code) {
    final match = SupportedLanguage.supportedLanguages.where((l) => l.code == code);
    return match.isNotEmpty ? match.first.name : code;
  }

  String _currencyDisplayName(String code) {
    final match = SupportedCurrency.supportedCurrencies.where((c) => c.code == code);
    return match.isNotEmpty ? match.first.name : code;
  }

  Future<void> _showLanguageSheet(BuildContext context, WidgetRef ref, String currentCode) {
    return PreferenceSelectionSheet.show<SupportedLanguage>(
      context: context,
      title: 'Select Language',
      options: SupportedLanguage.supportedLanguages,
      selectedValue: SupportedLanguage.supportedLanguages.firstWhere(
        (l) => l.code == currentCode,
        orElse: () => const SupportedLanguage(code: 'en', name: 'English'),
      ),
      labelBuilder: (lang) => lang.name,
      onSelected: (lang) => ref.read(settingsNotifierProvider.notifier).setLanguage(lang.code),
    );
  }

  Future<void> _showCurrencySheet(BuildContext context, WidgetRef ref, String currentCode) {
    return PreferenceSelectionSheet.show<SupportedCurrency>(
      context: context,
      title: 'Select Currency',
      options: SupportedCurrency.supportedCurrencies,
      selectedValue: SupportedCurrency.supportedCurrencies.firstWhere(
        (c) => c.code == currentCode,
        orElse: () => const SupportedCurrency(code: 'USD', name: 'US Dollar', symbol: r'$'),
      ),
      labelBuilder: (currency) => '${currency.symbol}  ${currency.code} — ${currency.name}',
      onSelected: (currency) => ref.read(settingsNotifierProvider.notifier).setCurrency(currency.code),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(title,
          style: AppTypography.labelMd.copyWith(
            color: AppColors.tertiary,
            letterSpacing: 1,
          )),
    );
  }
}

class _SubHeader extends StatelessWidget {
  const _SubHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.unit, AppSpacing.xs, 0, AppSpacing.sm),
      child: Text(title,
          style: AppTypography.bodySm.copyWith(
            color: AppColors.outline,
            fontWeight: FontWeight.w600,
          )),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: AppSpacing.borderRadiusMd,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
            child: Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 22),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTypography.bodyMd.copyWith(color: AppColors.primary)),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(subtitle!, style: AppTypography.bodySm.copyWith(color: AppColors.outline)),
                      ],
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

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: AppSpacing.borderRadiusMd,
          onTap: () => onChanged(!value),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            child: Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 22),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTypography.bodyMd.copyWith(color: AppColors.primary)),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(subtitle!, style: AppTypography.bodySm.copyWith(color: AppColors.outline)),
                      ],
                    ],
                  ),
                ),
                Switch(
                  value: value,
                  onChanged: onChanged,
                  activeTrackColor: AppColors.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
