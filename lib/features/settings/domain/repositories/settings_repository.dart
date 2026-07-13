import '../models/app_settings.dart';

/// Abstract interface for reading and persisting app settings.
abstract class SettingsRepository {
  Future<AppSettings> getSettings();
  Future<void> updateSettings(AppSettings settings);
}
