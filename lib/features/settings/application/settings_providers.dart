import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/settings_repository_fake.dart';
import '../domain/models/app_settings.dart';
import '../domain/repositories/settings_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepositoryFake();
});

final settingsProvider = FutureProvider<AppSettings>((ref) async {
  return ref.read(settingsRepositoryProvider).getSettings();
});

final settingsNotifierProvider =
    AsyncNotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);

class SettingsNotifier extends AsyncNotifier<AppSettings> {
  @override
  Future<AppSettings> build() async {
    return ref.read(settingsRepositoryProvider).getSettings();
  }

  Future<void> _applyUpdate(AppSettings Function(AppSettings) updater) async {
    final current = state.valueOrNull ?? const AppSettings();
    final updated = updater(current);
    state = const AsyncLoading();
    state = AsyncData(updated);
    await ref.read(settingsRepositoryProvider).updateSettings(updated);
  }

  Future<void> toggleDarkMode() async {
    await _applyUpdate((s) => s.copyWith(darkMode: !s.darkMode));
  }

  Future<void> toggleNotifications() async {
    await _applyUpdate((s) => s.copyWith(notificationsEnabled: !s.notificationsEnabled));
  }

  Future<void> toggleEmailNotifications() async {
    await _applyUpdate((s) => s.copyWith(emailNotifications: !s.emailNotifications));
  }

  Future<void> toggleSmsNotifications() async {
    await _applyUpdate((s) => s.copyWith(smsNotifications: !s.smsNotifications));
  }

  Future<void> toggleOrderUpdates() async {
    await _applyUpdate((s) => s.copyWith(orderUpdates: !s.orderUpdates));
  }

  Future<void> togglePromotions() async {
    await _applyUpdate((s) => s.copyWith(promotions: !s.promotions));
  }

  Future<void> toggleNewArrivals() async {
    await _applyUpdate((s) => s.copyWith(newArrivals: !s.newArrivals));
  }

  Future<void> togglePriceDrops() async {
    await _applyUpdate((s) => s.copyWith(priceDrops: !s.priceDrops));
  }

  Future<void> toggleNewsletter() async {
    await _applyUpdate((s) => s.copyWith(newsletter: !s.newsletter));
  }

  Future<void> toggleBiometricAuth() async {
    await _applyUpdate((s) => s.copyWith(biometricAuth: !s.biometricAuth));
  }

  Future<void> toggleSaveCards() async {
    await _applyUpdate((s) => s.copyWith(saveCards: !s.saveCards));
  }
}
