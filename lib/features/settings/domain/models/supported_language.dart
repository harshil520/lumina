/// A language option available in the app's preference settings.
class SupportedLanguage {
  const SupportedLanguage({required this.code, required this.name});

  final String code;
  final String name;

  static const List<SupportedLanguage> supportedLanguages = [
    SupportedLanguage(code: 'en', name: 'English'),
    SupportedLanguage(code: 'es', name: 'Español'),
    SupportedLanguage(code: 'fr', name: 'Français'),
    SupportedLanguage(code: 'de', name: 'Deutsch'),
    SupportedLanguage(code: 'it', name: 'Italiano'),
    SupportedLanguage(code: 'pt', name: 'Português'),
    SupportedLanguage(code: 'ru', name: 'Русский'),
    SupportedLanguage(code: 'zh', name: '中文'),
    SupportedLanguage(code: 'ja', name: '日本語'),
    SupportedLanguage(code: 'ar', name: 'العربية'),
    SupportedLanguage(code: 'hi', name: 'हिन्दी'),
    SupportedLanguage(code: 'ko', name: '한국어'),
  ];
}
