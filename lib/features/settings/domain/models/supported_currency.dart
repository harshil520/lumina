/// A currency option available in the app's preference settings.
class SupportedCurrency {
  const SupportedCurrency({required this.code, required this.name, required this.symbol});

  final String code;
  final String name;
  final String symbol;

  static const List<SupportedCurrency> supportedCurrencies = [
    SupportedCurrency(code: 'USD', name: 'US Dollar', symbol: r'$'),
    SupportedCurrency(code: 'EUR', name: 'Euro', symbol: r'€'),
    SupportedCurrency(code: 'GBP', name: 'British Pound', symbol: r'£'),
    SupportedCurrency(code: 'JPY', name: 'Japanese Yen', symbol: r'¥'),
    SupportedCurrency(code: 'CNY', name: 'Chinese Yuan', symbol: r'¥'),
    SupportedCurrency(code: 'INR', name: 'Indian Rupee', symbol: r'₹'),
    SupportedCurrency(code: 'AUD', name: 'Australian Dollar', symbol: r'A$'),
    SupportedCurrency(code: 'CAD', name: 'Canadian Dollar', symbol: r'C$'),
    SupportedCurrency(code: 'CHF', name: 'Swiss Franc', symbol: r'CHF'),
    SupportedCurrency(code: 'SGD', name: 'Singapore Dollar', symbol: r'S$'),
    SupportedCurrency(code: 'AED', name: 'UAE Dirham', symbol: r'د.إ'),
    SupportedCurrency(code: 'SAR', name: 'Saudi Riyal', symbol: r'﷼'),
    SupportedCurrency(code: 'KRW', name: 'South Korean Won', symbol: r'₩'),
    SupportedCurrency(code: 'BRL', name: 'Brazilian Real', symbol: r'R$'),
  ];
}
