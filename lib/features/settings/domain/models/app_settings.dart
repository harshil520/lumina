/// App-wide settings including preferences and notification toggles.
class AppSettings {
  const AppSettings({
    this.darkMode = false,
    this.notificationsEnabled = true,
    this.emailNotifications = true,
    this.smsNotifications = false,
    this.orderUpdates = true,
    this.promotions = false,
    this.newArrivals = true,
    this.priceDrops = true,
    this.newsletter = false,
    this.language = 'English',
    this.currency = 'USD',
    this.biometricAuth = false,
    this.saveCards = true,
  });

  final bool darkMode;
  final bool notificationsEnabled;
  final bool emailNotifications;
  final bool smsNotifications;
  final bool orderUpdates;
  final bool promotions;
  final bool newArrivals;
  final bool priceDrops;
  final bool newsletter;
  final String language;
  final String currency;
  final bool biometricAuth;
  final bool saveCards;

  AppSettings copyWith({
    bool? darkMode,
    bool? notificationsEnabled,
    bool? emailNotifications,
    bool? smsNotifications,
    bool? orderUpdates,
    bool? promotions,
    bool? newArrivals,
    bool? priceDrops,
    bool? newsletter,
    String? language,
    String? currency,
    bool? biometricAuth,
    bool? saveCards,
  }) {
    return AppSettings(
      darkMode: darkMode ?? this.darkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      smsNotifications: smsNotifications ?? this.smsNotifications,
      orderUpdates: orderUpdates ?? this.orderUpdates,
      promotions: promotions ?? this.promotions,
      newArrivals: newArrivals ?? this.newArrivals,
      priceDrops: priceDrops ?? this.priceDrops,
      newsletter: newsletter ?? this.newsletter,
      language: language ?? this.language,
      currency: currency ?? this.currency,
      biometricAuth: biometricAuth ?? this.biometricAuth,
      saveCards: saveCards ?? this.saveCards,
    );
  }
}
