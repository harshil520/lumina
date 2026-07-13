import '../../domain/models/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';

/// Fake in-memory implementation of [SettingsRepository] for development.
class SettingsRepositoryFake implements SettingsRepository {
  AppSettings _settings = const AppSettings();

  @override
  Future<AppSettings> getSettings() async => _settings;

  @override
  Future<void> updateSettings(AppSettings settings) async {
    _settings = settings;
  }
}
