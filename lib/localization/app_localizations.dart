import 'package:flutter/material.dart';

class AppLanguage {
  final String code;
  final String name;
  final String nativeName;
  final String flag;
  final bool rtl;

  const AppLanguage({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
    this.rtl = false,
  });
}

class AppLanguages {
  static const List<AppLanguage> all = [
    AppLanguage(
      code: 'en',
      name: 'English',
      nativeName: 'English',
      flag: '🇬🇧',
    ),
    AppLanguage(
      code: 'ur',
      name: 'Urdu',
      nativeName: 'اردو',
      flag: '🇵🇰',
      rtl: true,
    ),
    AppLanguage(
      code: 'ar',
      name: 'Arabic',
      nativeName: 'العربية',
      flag: '🇸🇦',
      rtl: true,
    ),
    AppLanguage(code: 'hi', name: 'Hindi', nativeName: 'हिन्दी', flag: '🇮🇳'),
    AppLanguage(code: 'bn', name: 'Bengali', nativeName: 'বাংলা', flag: '🇧🇩'),
    AppLanguage(
      code: 'es',
      name: 'Spanish',
      nativeName: 'Español',
      flag: '🇪🇸',
    ),
    AppLanguage(
      code: 'fr',
      name: 'French',
      nativeName: 'Français',
      flag: '🇫🇷',
    ),
    AppLanguage(
      code: 'de',
      name: 'German',
      nativeName: 'Deutsch',
      flag: '🇩🇪',
    ),
    AppLanguage(
      code: 'it',
      name: 'Italian',
      nativeName: 'Italiano',
      flag: '🇮🇹',
    ),
    AppLanguage(
      code: 'pt',
      name: 'Portuguese',
      nativeName: 'Português',
      flag: '🇵🇹',
    ),
    AppLanguage(
      code: 'tr',
      name: 'Turkish',
      nativeName: 'Türkçe',
      flag: '🇹🇷',
    ),
    AppLanguage(
      code: 'ru',
      name: 'Russian',
      nativeName: 'Русский',
      flag: '🇷🇺',
    ),
    AppLanguage(code: 'zh', name: 'Chinese', nativeName: '中文', flag: '🇨🇳'),
    AppLanguage(code: 'ja', name: 'Japanese', nativeName: '日本語', flag: '🇯🇵'),
    AppLanguage(code: 'ko', name: 'Korean', nativeName: '한국어', flag: '🇰🇷'),
    AppLanguage(
      code: 'id',
      name: 'Indonesian',
      nativeName: 'Bahasa Indonesia',
      flag: '🇮🇩',
    ),
    AppLanguage(
      code: 'ms',
      name: 'Malay',
      nativeName: 'Bahasa Melayu',
      flag: '🇲🇾',
    ),
    AppLanguage(
      code: 'nl',
      name: 'Dutch',
      nativeName: 'Nederlands',
      flag: '🇳🇱',
    ),
    AppLanguage(code: 'pl', name: 'Polish', nativeName: 'Polski', flag: '🇵🇱'),
    AppLanguage(code: 'th', name: 'Thai', nativeName: 'ไทย', flag: '🇹🇭'),
    AppLanguage(
      code: 'vi',
      name: 'Vietnamese',
      nativeName: 'Tiếng Việt',
      flag: '🇻🇳',
    ),
    AppLanguage(
      code: 'fa',
      name: 'Persian',
      nativeName: 'فارسی',
      flag: '🇮🇷',
      rtl: true,
    ),
    AppLanguage(
      code: 'he',
      name: 'Hebrew',
      nativeName: 'עברית',
      flag: '🇮🇱',
      rtl: true,
    ),
    AppLanguage(
      code: 'sv',
      name: 'Swedish',
      nativeName: 'Svenska',
      flag: '🇸🇪',
    ),
    AppLanguage(
      code: 'no',
      name: 'Norwegian',
      nativeName: 'Norsk',
      flag: '🇳🇴',
    ),
    AppLanguage(code: 'da', name: 'Danish', nativeName: 'Dansk', flag: '🇩🇰'),
    AppLanguage(code: 'fi', name: 'Finnish', nativeName: 'Suomi', flag: '🇫🇮'),
  ];

  static AppLanguage find(String code) {
    return all.firstWhere(
      (language) => language.code == code,
      orElse: () => all.first,
    );
  }
}

class AppLocalizations {
  final Locale locale;

  const AppLocalizations(this.locale);

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('ur'),
    Locale('ar'),
    Locale('hi'),
    Locale('bn'),
    Locale('es'),
    Locale('fr'),
    Locale('de'),
    Locale('it'),
    Locale('pt'),
    Locale('tr'),
    Locale('ru'),
    Locale('zh'),
    Locale('ja'),
    Locale('ko'),
    Locale('id'),
    Locale('ms'),
    Locale('nl'),
    Locale('pl'),
    Locale('th'),
    Locale('vi'),
    Locale('fa'),
    Locale('he'),
    Locale('sv'),
    Locale('no'),
    Locale('da'),
    Locale('fi'),
  ];

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        const AppLocalizations(Locale('en'));
  }

  static const Map<String, Map<String, String>> _translations = {
    'en': {
      'appName': 'Expense Manager',
      'settings': 'Settings',
      'profile': 'Profile',
      'home': 'Home',
      'transactions': 'Transactions',
      'reports': 'Reports',
      'goals': 'Goals',
      'preferences': 'Preferences',
      'defaultCurrency': 'Default Currency',
      'language': 'Language',
      'darkMode': 'Dark Mode',
      'notifications': 'Notifications',
      'dataSecurity': 'Data & Security',
      'backupRestore': 'Backup & Restore',
      'exportData': 'Export Data',
      'security': 'Security',
      'support': 'Support',
      'feedbackSupport': 'Feedback & Support',
      'helpFaq': 'Help & FAQ',
      'about': 'About',
      'save': 'Save',
      'cancel': 'Cancel',
      'done': 'Done',
      'close': 'Close',
      'selectLanguage': 'Select Language',
      'selectCurrency': 'Select Currency',
      'comingSoon': 'Coming soon',
      'totalBalance': 'Total Balance',
      'income': 'Income',
      'expenses': 'Expenses',
      'savings': 'Savings',
      'addIncome': 'Add Income',
      'addExpense': 'Add Expense',
      'quickTools': 'Quick Tools',
      'calculator': 'Calculator',
      'fuel': 'Fuel',
      'bills': 'Bills',
      'budget': 'Budget',
      'recentTransactions': 'Recent Transactions',
    },
    'ur': {
      'appName': 'اخراجات مینیجر',
      'settings': 'ترتیبات',
      'profile': 'پروفائل',
      'home': 'ہوم',
      'transactions': 'لین دین',
      'reports': 'رپورٹس',
      'goals': 'اہداف',
      'preferences': 'ترجیحات',
      'defaultCurrency': 'ڈیفالٹ کرنسی',
      'language': 'زبان',
      'darkMode': 'ڈارک موڈ',
      'notifications': 'اطلاعات',
      'dataSecurity': 'ڈیٹا اور سیکیورٹی',
      'backupRestore': 'بیک اپ اور بحالی',
      'exportData': 'ڈیٹا ایکسپورٹ',
      'security': 'سیکیورٹی',
      'support': 'مدد',
      'feedbackSupport': 'رائے اور مدد',
      'helpFaq': 'مدد اور سوالات',
      'about': 'ہمارے بارے میں',
      'save': 'محفوظ کریں',
      'cancel': 'منسوخ',
      'done': 'مکمل',
      'close': 'بند کریں',
      'selectLanguage': 'زبان منتخب کریں',
      'selectCurrency': 'کرنسی منتخب کریں',
      'comingSoon': 'جلد دستیاب ہوگا',
      'totalBalance': 'کل بیلنس',
      'income': 'آمدنی',
      'expenses': 'اخراجات',
      'savings': 'بچت',
      'addIncome': 'آمدنی شامل کریں',
      'addExpense': 'خرچ شامل کریں',
      'quickTools': 'فوری ٹولز',
      'calculator': 'کیلکولیٹر',
      'fuel': 'ایندھن',
      'bills': 'بلز',
      'budget': 'بجٹ',
      'recentTransactions': 'حالیہ لین دین',
    },
    'ar': {
      'appName': 'مدير المصروفات',
      'settings': 'الإعدادات',
      'profile': 'الملف الشخصي',
      'home': 'الرئيسية',
      'transactions': 'المعاملات',
      'reports': 'التقارير',
      'goals': 'الأهداف',
      'preferences': 'التفضيلات',
      'defaultCurrency': 'العملة الافتراضية',
      'language': 'اللغة',
      'darkMode': 'الوضع الداكن',
      'notifications': 'الإشعارات',
      'dataSecurity': 'البيانات والأمان',
      'backupRestore': 'النسخ الاحتياطي والاستعادة',
      'exportData': 'تصدير البيانات',
      'security': 'الأمان',
      'support': 'الدعم',
      'feedbackSupport': 'التعليقات والدعم',
      'helpFaq': 'المساعدة والأسئلة الشائعة',
      'about': 'حول التطبيق',
      'save': 'حفظ',
      'cancel': 'إلغاء',
      'done': 'تم',
      'close': 'إغلاق',
      'selectLanguage': 'اختر اللغة',
      'selectCurrency': 'اختر العملة',
      'comingSoon': 'قريباً',
      'totalBalance': 'الرصيد الإجمالي',
      'income': 'الدخل',
      'expenses': 'المصروفات',
      'savings': 'المدخرات',
      'addIncome': 'إضافة دخل',
      'addExpense': 'إضافة مصروف',
      'quickTools': 'أدوات سريعة',
      'calculator': 'حاسبة',
      'fuel': 'الوقود',
      'bills': 'الفواتير',
      'budget': 'الميزانية',
      'recentTransactions': 'المعاملات الأخيرة',
    },
    'hi': {
      'appName': 'खर्च प्रबंधक',
      'settings': 'सेटिंग्स',
      'profile': 'प्रोफ़ाइल',
      'home': 'होम',
      'transactions': 'लेन-देन',
      'reports': 'रिपोर्ट',
      'goals': 'लक्ष्य',
      'preferences': 'प्राथमिकताएँ',
      'defaultCurrency': 'डिफ़ॉल्ट मुद्रा',
      'language': 'भाषा',
      'darkMode': 'डार्क मोड',
      'notifications': 'सूचनाएँ',
      'dataSecurity': 'डेटा और सुरक्षा',
      'backupRestore': 'बैकअप और पुनर्स्थापना',
      'exportData': 'डेटा निर्यात',
      'security': 'सुरक्षा',
      'support': 'सहायता',
      'feedbackSupport': 'प्रतिक्रिया और सहायता',
      'helpFaq': 'मदद और सामान्य प्रश्न',
      'about': 'ऐप के बारे में',
      'save': 'सहेजें',
      'cancel': 'रद्द करें',
      'done': 'पूर्ण',
      'close': 'बंद करें',
      'selectLanguage': 'भाषा चुनें',
      'selectCurrency': 'मुद्रा चुनें',
      'comingSoon': 'जल्द आ रहा है',
      'totalBalance': 'कुल शेष',
      'income': 'आय',
      'expenses': 'खर्च',
      'savings': 'बचत',
      'addIncome': 'आय जोड़ें',
      'addExpense': 'खर्च जोड़ें',
      'quickTools': 'त्वरित टूल',
      'calculator': 'कैलकुलेटर',
      'fuel': 'ईंधन',
      'bills': 'बिल',
      'budget': 'बजट',
      'recentTransactions': 'हाल के लेन-देन',
    },
  };

  String text(String key) {
    final language = locale.languageCode;

    return _translations[language]?[key] ?? _translations['en']?[key] ?? key;
  }

  String get appName => text('appName');
  String get settings => text('settings');
  String get profile => text('profile');
  String get home => text('home');
  String get transactions => text('transactions');
  String get reports => text('reports');
  String get goals => text('goals');
  String get preferences => text('preferences');
  String get defaultCurrency => text('defaultCurrency');
  String get language => text('language');
  String get darkMode => text('darkMode');
  String get notifications => text('notifications');
  String get dataSecurity => text('dataSecurity');
  String get backupRestore => text('backupRestore');
  String get exportData => text('exportData');
  String get security => text('security');
  String get support => text('support');
  String get feedbackSupport => text('feedbackSupport');
  String get helpFaq => text('helpFaq');
  String get about => text('about');
  String get save => text('save');
  String get cancel => text('cancel');
  String get done => text('done');
  String get close => text('close');
  String get selectLanguage => text('selectLanguage');
  String get selectCurrency => text('selectCurrency');
  String get comingSoon => text('comingSoon');
  String get totalBalance => text('totalBalance');
  String get income => text('income');
  String get expenses => text('expenses');
  String get savings => text('savings');
  String get addIncome => text('addIncome');
  String get addExpense => text('addExpense');
  String get quickTools => text('quickTools');
  String get calculator => text('calculator');
  String get fuel => text('fuel');
  String get bills => text('bills');
  String get budget => text('budget');
  String get recentTransactions => text('recentTransactions');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales.any(
      (supported) => supported.languageCode == locale.languageCode,
    );
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}
