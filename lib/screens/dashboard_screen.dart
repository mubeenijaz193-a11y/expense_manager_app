import 'package:flutter/material.dart';

import '../models/app_currencies.dart';
import 'add_transaction_screen.dart';
import 'finance_calculator_screen.dart';
import 'budgets_screen.dart';
import 'bills_screen.dart';
import 'fuel_calculator_screen.dart';
import 'goals_screen.dart';
import 'reports_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static const Color primaryGreen = Color(0xFF0B9B67);
  static const Color expenseRed = Colors.redAccent;
  static const Color fuelOrange = Color(0xFFE67E22);
  int currentTab = 0;
  final TextEditingController searchController = TextEditingController();
  String transactionFilter = 'All';
  final List<Map<String, dynamic>> transactions = [
    {
      'type': 'Expense',
      'amount': 2500.0,
      'category': 'Food & Dining',
      'date': DateTime(2026, 10, 4),
      'note': 'Dinner',
      'currency': 'PKR',
    },
    {
      'type': 'Income',
      'amount': 75000.0,
      'category': 'Salary',
      'date': DateTime(2026, 10, 1),
      'note': 'Monthly salary',
      'currency': 'PKR',
    },
    {
      'type': 'Expense',
      'amount': 5000.0,
      'category': 'Fuel',
      'date': DateTime(2026, 9, 30),
      'note': 'Car fuel',
      'currency': 'PKR',
    },
  ];
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _homePage(),
      _transactionsPage(),
      _reportsPage(),
      _goalsPage(),
      _profilePage(),
    ];
    return Scaffold(
      body: IndexedStack(index: currentTab, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentTab,
        onDestinationSelected: (index) {
          setState(() {
            currentTab = index;
          });
        },
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF151D1A)
            : Colors.white,
        indicatorColor: primaryGreen.withValues(alpha: 0.14),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long_rounded),
            label: 'Transactions',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart_rounded),
            label: 'Reports',
          ),
          NavigationDestination(
            icon: Icon(Icons.flag_outlined),
            selectedIcon: Icon(Icons.flag_rounded),
            label: 'Goals',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _homePage() {
    final income = _total('Income');
    final expense = _total('Expense');
    final balance = income - expense;
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
            children: [
              _homeHeader(),
              const SizedBox(height: 22),
              _balanceCard(balance, income, expense),
              const SizedBox(height: 20),
              _quickActions(),
              const SizedBox(height: 24),
              _sectionHeader('Quick Tools', 'Manage your finances faster'),
              const SizedBox(height: 12),
              _quickTools(),
              const SizedBox(height: 26),
              _sectionHeader(
                'Recent Transactions',
                'View your latest activity',
              ),
              const SizedBox(height: 12),
              if (transactions.isEmpty)
                _emptyTransactions()
              else
                ...transactions
                    .take(5)
                    .map(
                      (transaction) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _transactionCard(
                          transaction,
                          showActions: false,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _homeHeader() {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: primaryGreen.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(
            Icons.account_balance_wallet_rounded,
            color: primaryGreen,
            size: 26,
          ),
        ),
        const SizedBox(width: 13),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Expense Manager',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 3),
              Text(
                'Manage your money smarter',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              currentTab = 4;
            });
          },
          icon: const Icon(Icons.settings_outlined),
        ),
      ],
    );
  }

  Widget _balanceCard(double balance, double income, double expense) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0B9B67), Color(0xFF087D56)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primaryGreen.withValues(alpha: 0.22),
            blurRadius: 22,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Balance',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            _formatAmount(balance),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 31,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(
                child: _balanceItem(
                  'Income',
                  income,
                  Icons.arrow_downward_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _balanceItem(
                  'Expenses',
                  expense,
                  Icons.arrow_upward_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _balanceItem(String title, double amount, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 19),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
                const SizedBox(height: 3),
                Text(
                  _formatAmount(amount),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickActions() {
    return Row(
      children: [
        Expanded(
          child: _actionButton(
            title: 'Add Income',
            icon: Icons.add_circle_outline_rounded,
            color: primaryGreen,
            onTap: () => _openAddTransaction('Income'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _actionButton(
            title: 'Add Expense',
            icon: Icons.remove_circle_outline_rounded,
            color: expenseRed,
            onTap: () => _openAddTransaction('Expense'),
          ),
        ),
      ],
    );
  }

  Widget _actionButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color.withValues(alpha: 0.09),
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickTools() {
    final tools = [
      ('Calculator', Icons.calculate_rounded, const Color(0xFF4361EE)),
      ('Fuel', Icons.local_gas_station_rounded, fuelOrange),
      ('Bills', Icons.receipt_long_rounded, const Color(0xFF8E44AD)),
      ('Budget', Icons.account_balance_wallet_rounded, primaryGreen),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tools.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        childAspectRatio: 0.9,
      ),
      itemBuilder: (context, index) {
        final tool = tools[index];
        return _toolCard(title: tool.$1, icon: tool.$2, color: tool.$3);
      },
    );
  }

  Widget _toolCard({
    required String title,
    required IconData icon,
    required Color color,
  }) {
    return Material(
      color: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF18211E)
          : Colors.white,
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: () {
          if (title == 'Calculator') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const FinanceCalculatorScreen(),
              ),
            );
          } else if (title == 'Fuel') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FuelCalculatorScreen()),
            );
          } else if (title == 'Bills') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BillsScreen()),
            );
          } else if (title == 'Budget') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BudgetsScreen()),
            );
          }
        },
        borderRadius: BorderRadius.circular(17),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, color: color, size: 21),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _transactionsPage() {
    final filtered = _filteredTransactions();
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
            children: [
              const Text(
                'Transactions',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 5),
              Text(
                '${transactions.length} recorded transactions',
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search transactions...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            searchController.clear();
                            setState(() {});
                          },
                          icon: const Icon(Icons.clear_rounded),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 14),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _filterChip('All'),
                    const SizedBox(width: 8),
                    _filterChip('Income'),
                    const SizedBox(width: 8),
                    _filterChip('Expense'),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              if (filtered.isEmpty)
                _emptyTransactions()
              else
                ...filtered.map(
                  (transaction) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _transactionCard(transaction, showActions: true),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterChip(String value) {
    final selected = transactionFilter == value;
    return FilterChip(
      selected: selected,
      label: Text(value),
      onSelected: (_) {
        setState(() {
          transactionFilter = value;
        });
      },
      selectedColor: primaryGreen.withValues(alpha: 0.14),
      checkmarkColor: primaryGreen,
    );
  }

  List<Map<String, dynamic>> _filteredTransactions() {
    final search = searchController.text.trim().toLowerCase();
    return transactions.where((transaction) {
      final matchesFilter =
          transactionFilter == 'All' ||
          transaction['type'] == transactionFilter;
      final text = [
        transaction['category'],
        transaction['note'],
        transaction['type'],
        transaction['currency'],
      ].join(' ').toLowerCase();
      final matchesSearch = search.isEmpty || text.contains(search);
      return matchesFilter && matchesSearch;
    }).toList();
  }

  Widget _transactionCard(
    Map<String, dynamic> transaction, {
    required bool showActions,
  }) {
    final isIncome = transaction['type'] == 'Income';
    final amount = transaction['amount'] as double;
    final currency = transaction['currency'] as String;
    final category = transaction['category'] as String;
    final note = transaction['note'] as String;
    final date = transaction['date'] as DateTime;
    final color = isIncome ? primaryGreen : expenseRed;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF18211E)
            : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: Theme.of(context).brightness == Brightness.dark
                  ? 0.10
                  : 0.035,
            ),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              isIncome
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
              color: color,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  note.isEmpty
                      ? '${_formatDate(date)} • $currency'
                      : '$note • ${_formatDate(date)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isIncome ? '+' : '-'} '
                '${_formatAmount(amount, currency)}',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
              if (showActions)
                Row(
                  children: [
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: () => _editTransaction(transaction),
                      icon: const Icon(Icons.edit_outlined, size: 18),
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: () => _deleteTransaction(transaction),
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        size: 18,
                        color: expenseRed,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _emptyTransactions() {
    return Container(
      padding: const EdgeInsets.all(35),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF18211E)
            : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        children: [
          Icon(Icons.receipt_long_outlined, size: 50, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            'No transactions found',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
          SizedBox(height: 5),
          Text(
            'Add your first income or expense to get started.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _reportsPage() {
    return ReportsScreen(transactions: transactions);
  }

  Widget _goalsPage() {
    return const GoalsScreen();
  }

  Widget _profilePage() {
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
            children: [
              const Text(
                'Profile',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: _cardDecoration(),
                child: Row(
                  children: [
                    Container(
                      width: 62,
                      height: 62,
                      decoration: BoxDecoration(
                        color: primaryGreen.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        color: primaryGreen,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'My Profile',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Manage your preferences and app settings',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              _profileOption(
                icon: Icons.settings_rounded,
                title: 'Settings',
                subtitle: 'Currency, language, theme and preferences',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  );
                },
              ),
              _profileOption(
                icon: Icons.calculate_rounded,
                title: 'Finance Calculator',
                subtitle: 'Calculator, percentage, discount and more',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const FinanceCalculatorScreen(),
                    ),
                  );
                },
              ),
              _profileOption(
                icon: Icons.feedback_outlined,
                title: 'Feedback & Support',
                subtitle: 'Tell us how we can improve',
                onTap: () => _showComingSoon('Feedback & Support'),
              ),
              _profileOption(
                icon: Icons.help_outline_rounded,
                title: 'Help & FAQ',
                subtitle: 'Get help using Expense Manager',
                onTap: () => _showComingSoon('Help & FAQ'),
              ),
              _profileOption(
                icon: Icons.info_outline_rounded,
                title: 'About',
                subtitle: 'App information and version',
                onTap: () => _showComingSoon('About'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: _cardDecoration(),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        leading: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: primaryGreen.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, color: primaryGreen),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.grey, fontSize: 11),
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }

  Widget _sectionHeader(String title, String subtitle) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.grey, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }

  BoxDecoration _cardDecoration() {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: dark ? const Color(0xFF18211E) : Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: dark ? 0.10 : 0.035),
          blurRadius: 15,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  double _total(String type) {
    return transactions
        .where(
          (transaction) =>
              transaction['type'] == type && transaction['currency'] == 'PKR',
        )
        .fold<double>(
          0,
          (sum, transaction) => sum + (transaction['amount'] as double),
        );
  }

  String _formatAmount(double amount, [String currencyCode = 'PKR']) {
    final currency = AppCurrencies.find(currencyCode);
    return '${currency.symbol} '
        '${amount.toStringAsFixed(0)}';
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  void _openAddTransaction(String type) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddTransactionScreen(
          initialType: type,
          onSaved: (savedType, amount, category, date, note, currency) {
            setState(() {
              transactions.insert(0, {
                'type': savedType,
                'amount': amount,
                'category': category,
                'date': date,
                'note': note,
                'currency': currency,
              });
            });
          },
        ),
      ),
    );
  }

  void _editTransaction(Map<String, dynamic> transaction) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddTransactionScreen(
          isEditing: true,
          initialType: transaction['type'],
          initialAmount: transaction['amount'],
          initialCategory: transaction['category'],
          initialDate: transaction['date'],
          initialNote: transaction['note'],
          initialCurrency: transaction['currency'],
          onSaved: (savedType, amount, category, date, note, currency) {
            setState(() {
              transaction['type'] = savedType;
              transaction['amount'] = amount;
              transaction['category'] = category;
              transaction['date'] = date;
              transaction['note'] = note;
              transaction['currency'] = currency;
            });
          },
        ),
      ),
    );
  }

  void _deleteTransaction(Map<String, dynamic> transaction) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Transaction?'),
          content: const Text(
            'This transaction will be removed from the list.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: expenseRed),
              onPressed: () {
                setState(() {
                  transactions.remove(transaction);
                });
                Navigator.pop(dialogContext);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('$feature will be connected in the next phase.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}
