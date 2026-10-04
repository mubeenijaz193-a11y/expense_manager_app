class AppCurrency {
  final String code;
  final String name;
  final String symbol;
  final String flag;

  const AppCurrency({
    required this.code,
    required this.name,
    required this.symbol,
    required this.flag,
  });
}

class AppCurrencies {
  static const List<AppCurrency> all = [
    AppCurrency(
      code: 'PKR',
      name: 'Pakistani Rupee',
      symbol: 'Rs.',
      flag: '🇵🇰',
    ),
    AppCurrency(code: 'USD', name: 'US Dollar', symbol: '\$', flag: '🇺🇸'),
    AppCurrency(code: 'EUR', name: 'Euro', symbol: '€', flag: '🇪🇺'),
    AppCurrency(code: 'GBP', name: 'British Pound', symbol: '£', flag: '🇬🇧'),
    AppCurrency(code: 'AED', name: 'UAE Dirham', symbol: 'د.إ', flag: '🇦🇪'),
    AppCurrency(code: 'SAR', name: 'Saudi Riyal', symbol: '﷼', flag: '🇸🇦'),
    AppCurrency(code: 'INR', name: 'Indian Rupee', symbol: '₹', flag: '🇮🇳'),
    AppCurrency(
      code: 'CAD',
      name: 'Canadian Dollar',
      symbol: 'C\$',
      flag: '🇨🇦',
    ),
    AppCurrency(
      code: 'AUD',
      name: 'Australian Dollar',
      symbol: 'A\$',
      flag: '🇦🇺',
    ),
    AppCurrency(code: 'JPY', name: 'Japanese Yen', symbol: '¥', flag: '🇯🇵'),
    AppCurrency(code: 'CNY', name: 'Chinese Yuan', symbol: '¥', flag: '🇨🇳'),
    AppCurrency(code: 'TRY', name: 'Turkish Lira', symbol: '₺', flag: '🇹🇷'),
  ];

  static AppCurrency get defaultCurrency => all.first;

  static AppCurrency find(String code) {
    return all.firstWhere(
      (currency) => currency.code == code,
      orElse: () => defaultCurrency,
    );
  }
}
