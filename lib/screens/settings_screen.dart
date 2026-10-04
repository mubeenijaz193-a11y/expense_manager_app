import 'package:flutter/material.dart';

import '../localization/app_localizations.dart';
import '../main.dart';
import '../models/app_currencies.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const Color primaryGreen = Color(0xFF0B9B67);

  String selectedCurrency = 'PKR';

  bool darkMode = false;
  bool notifications = true;

  AppCurrency get currentCurrency {
    return AppCurrencies.find(selectedCurrency);
  }

  AppLanguage get currentLanguage {
    return AppLanguages.find(appLocale.value.languageCode);
  }

  @override
  void initState() {
    super.initState();

    darkMode = appThemeMode.value == ThemeMode.dark;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF101513)
          : const Color(0xFFF5F8F7),
      appBar: AppBar(
        title: Text(
          l10n.settings,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              children: [
                _buildHeader(),
                const SizedBox(height: 24),

                _buildSectionTitle(l10n.preferences),
                _buildSettingsCard(
                  isDark: isDark,
                  children: [
                    _buildSettingTile(
                      isDark: isDark,
                      icon: Icons.currency_exchange_rounded,
                      title: l10n.defaultCurrency,
                      subtitle:
                          '${currentCurrency.flag} ${currentCurrency.code} • ${currentCurrency.name}',
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: _showCurrencySelector,
                    ),
                    _divider(isDark),
                    _buildSettingTile(
                      isDark: isDark,
                      icon: Icons.language_rounded,
                      title: l10n.language,
                      subtitle:
                          '${currentLanguage.flag} ${currentLanguage.nativeName}',
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: _showLanguageSelector,
                    ),
                    _divider(isDark),
                    _buildSwitchTile(
                      isDark: isDark,
                      icon: Icons.dark_mode_rounded,
                      title: l10n.darkMode,
                      subtitle: 'Use a darker appearance throughout the app',
                      value: darkMode,
                      onChanged: (value) {
                        setState(() {
                          darkMode = value;
                        });

                        appThemeMode.value = value
                            ? ThemeMode.dark
                            : ThemeMode.light;

                        _showMessage(
                          value ? 'Dark mode enabled' : 'Dark mode disabled',
                        );
                      },
                    ),
                    _divider(isDark),
                    _buildSwitchTile(
                      isDark: isDark,
                      icon: Icons.notifications_active_rounded,
                      title: l10n.notifications,
                      subtitle: 'Receive reminders and finance updates',
                      value: notifications,
                      onChanged: (value) {
                        setState(() {
                          notifications = value;
                        });

                        _showMessage(
                          value
                              ? 'Notifications enabled'
                              : 'Notifications disabled',
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                _buildSectionTitle(l10n.dataSecurity),
                _buildSettingsCard(
                  isDark: isDark,
                  children: [
                    _buildSettingTile(
                      isDark: isDark,
                      icon: Icons.backup_rounded,
                      title: l10n.backupRestore,
                      subtitle: 'Protect and restore your financial data',
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: _showBackupDialog,
                    ),
                    _divider(isDark),
                    _buildSettingTile(
                      isDark: isDark,
                      icon: Icons.file_download_rounded,
                      title: l10n.exportData,
                      subtitle: 'Export your transactions and reports',
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: _showExportDialog,
                    ),
                    _divider(isDark),
                    _buildSettingTile(
                      isDark: isDark,
                      icon: Icons.lock_outline_rounded,
                      title: l10n.security,
                      subtitle: 'PIN, app lock and privacy options',
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: _showSecurityDialog,
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                _buildSectionTitle(l10n.support),
                _buildSettingsCard(
                  isDark: isDark,
                  children: [
                    _buildSettingTile(
                      isDark: isDark,
                      icon: Icons.feedback_outlined,
                      title: l10n.feedbackSupport,
                      subtitle: 'Send feedback or contact support',
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: _showFeedbackDialog,
                    ),
                    _divider(isDark),
                    _buildSettingTile(
                      isDark: isDark,
                      icon: Icons.help_outline_rounded,
                      title: l10n.helpFaq,
                      subtitle: 'Find answers to common questions',
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: _showHelpDialog,
                    ),
                    _divider(isDark),
                    _buildSettingTile(
                      isDark: isDark,
                      icon: Icons.info_outline_rounded,
                      title: l10n.about,
                      subtitle: 'Expense Manager • Version 1.0.0',
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: _showAboutDialog,
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.account_balance_wallet_rounded,
                        color: primaryGreen.withValues(alpha: 0.75),
                        size: 34,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Expense Manager',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF26332F),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Manage your money with confidence',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white60 : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryGreen, primaryGreen.withValues(alpha: 0.78)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primaryGreen.withValues(alpha: 0.20),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.settings_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.settings,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Personalize your money management experience',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
      ),
    );
  }

  Widget _buildSettingsCard({
    required bool isDark,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF18211E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.05),
            blurRadius: 18,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingTile({
    required bool isDark,
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      leading: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: primaryGreen.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: primaryGreen, size: 23),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white60 : Colors.grey.shade600,
          ),
        ),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required bool isDark,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      leading: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: primaryGreen.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: primaryGreen, size: 23),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white60 : Colors.grey.shade600,
          ),
        ),
      ),
      trailing: Switch(
        value: value,
        activeThumbColor: Colors.white,
        activeTrackColor: primaryGreen,
        onChanged: onChanged,
      ),
    );
  }

  Widget _divider(bool isDark) {
    return Divider(
      height: 1,
      indent: 80,
      endIndent: 18,
      color: isDark ? Colors.white12 : Colors.grey.shade200,
    );
  }

  void _showCurrencySelector() {
    final l10n = AppLocalizations.of(context);

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.72,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      l10n.selectCurrency,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    itemCount: AppCurrencies.all.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 4),
                    itemBuilder: (context, index) {
                      final currency = AppCurrencies.all[index];

                      final selected = currency.code == selectedCurrency;

                      return ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        tileColor: selected
                            ? primaryGreen.withValues(alpha: 0.10)
                            : null,
                        leading: Text(
                          currency.flag,
                          style: const TextStyle(fontSize: 25),
                        ),
                        title: Text(
                          currency.name,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        subtitle: Text('${currency.code} • ${currency.symbol}'),
                        trailing: selected
                            ? const Icon(
                                Icons.check_circle_rounded,
                                color: primaryGreen,
                              )
                            : null,
                        onTap: () {
                          setState(() {
                            selectedCurrency = currency.code;
                          });

                          Navigator.pop(context);

                          _showMessage(
                            'Default currency changed to ${currency.code}',
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLanguageSelector() {
    final l10n = AppLocalizations.of(context);

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.78,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      l10n.selectLanguage,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    itemCount: AppLanguages.all.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 4),
                    itemBuilder: (context, index) {
                      final language = AppLanguages.all[index];

                      final selected =
                          language.code == appLocale.value.languageCode;

                      return ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        tileColor: selected
                            ? primaryGreen.withValues(alpha: 0.10)
                            : null,
                        leading: Text(
                          language.flag,
                          style: const TextStyle(fontSize: 25),
                        ),
                        title: Text(
                          language.name,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        subtitle: Text(
                          language.nativeName,
                          textDirection: language.rtl
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                        ),
                        trailing: selected
                            ? const Icon(
                                Icons.check_circle_rounded,
                                color: primaryGreen,
                              )
                            : null,
                        onTap: () {
                          appLocale.value = Locale(language.code);

                          Navigator.pop(sheetContext);

                          _showMessage('${language.name} selected');
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showBackupDialog() {
    _showInfoDialog(
      title: 'Backup & Restore',
      icon: Icons.backup_rounded,
      message: 'Backup and restore will protect your transactions, categories, goals and other financial information.\n\nThe complete local data-storage and backup system will be connected in the data-management phase.',
    );
  }

  void _showExportDialog() {
    _showInfoDialog(
      title: 'Export Data',
      icon: Icons.file_download_rounded,
      message: 'You will be able to export your financial information for personal records, reporting and business use.\n\nCSV, Excel and PDF export options will be connected in the reporting and data-export phase.',
    );
  }

  void _showSecurityDialog() {
    _showInfoDialog(
      title: 'Security',
      icon: Icons.lock_outline_rounded,
      message: 'Security settings will include app lock, PIN protection and privacy controls.\n\nThese features will be connected when the app security system is added.',
    );
  }

  void _showFeedbackDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();

        return AlertDialog(
          title: const Text('Feedback & Support'),
          content: TextField(
            controller: controller,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Tell us what you think...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: primaryGreen),
              onPressed: () {
                Navigator.pop(context);
                _showMessage('Thank you for your feedback!');
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }

  void _showHelpDialog() {
    _showInfoDialog(
      title: 'Help & FAQ',
      icon: Icons.help_outline_rounded,
      message: 'Help and frequently asked questions will cover transactions, categories, budgets, savings goals, reports, currencies, fuel tracking, business tools and more.',
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'Expense Manager',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(
        Icons.account_balance_wallet_rounded,
        color: primaryGreen,
        size: 42,
      ),
      children: const [
        SizedBox(height: 12),
        Text(
          'A professional money management app designed for personal, family, student, freelancer, driver, shop, business and professional use.',
        ),
      ],
    );
  }

  void _showInfoDialog({
    required String title,
    required IconData icon,
    required String message,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: Icon(icon, color: primaryGreen, size: 34),
          title: Text(title, textAlign: TextAlign.center),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(height: 1.5),
          ),
          actions: [
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: primaryGreen),
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
  }
}
