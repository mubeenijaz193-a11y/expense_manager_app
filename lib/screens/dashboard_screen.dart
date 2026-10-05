import 'package:flutter/material.dart';

import '../models/app_currencies.dart';
import 'add_transaction_screen.dart';
import 'finance_calculator_screen.dart';
import 'budgets_screen.dart';
import 'bills_screen.dart';
import 'fuel_vehicles_screen.dart';
import 'goals_screen.dart';
import 'reports_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _transactions = [
    {
      'title': 'Monthly Salary',
      'category': 'Salary',
      'amount': 150000.0,
      'type': 'income',
      'currency': 'PKR',
      'date': DateTime.now(),
    },
    {
      'title': 'Grocery Shopping',
      'category': 'Groceries',
      'amount': 8500.0,
      'type': 'expense',
      'currency': 'PKR',
      'date': DateTime.now(),
    },
    {
      'title': 'Fuel',
      'category': 'Fuel',
      'amount': 5000.0,
      'type': 'expense',
      'currency': 'PKR',
      'date': DateTime.now(),
    },
  ];

  AppCurrency get _currency => AppCurrencies.defaultCurrency;

  double get _income {
    return _transactions
        .where(
          (transaction) =>
              transaction['type'] == 'income' &&
              transaction['currency'] == _currency.code,
        )
        .fold<double>(
          0,
          (sum, transaction) => sum + (transaction['amount'] as double),
        );
  }

  double get _expenses {
    return _transactions
        .where(
          (transaction) =>
              transaction['type'] == 'expense' &&
              transaction['currency'] == _currency.code,
        )
        .fold<double>(
          0,
          (sum, transaction) => sum + (transaction['amount'] as double),
        );
  }

  double get _balance => _income - _expenses;

  String _money(double amount) {
    return '${_currency.symbol} ${amount.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHome(),
      _buildTransactions(),
      ReportsScreen(transactions: _transactions),
      const GoalsScreen(),
      _buildProfile(),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: pages),

      // Slightly taller than before so longer labels such as
      // "Transactions" never get clipped at the bottom.
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>((states) {
            return const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              height: 1.1,
            );
          }),
        ),
        child: NavigationBar(
          height: 78,
          selectedIndex: _selectedIndex,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
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
              icon: Icon(Icons.savings_outlined),
              selectedIcon: Icon(Icons.savings_rounded),
              label: 'Goals',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHome() {
    final theme = Theme.of(context);

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 18),
                  _buildBalanceCard(),
                  const SizedBox(height: 18),
                  _buildSummaryCards(),
                  const SizedBox(height: 26),
                  Text(
                    'Quick Add',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildQuickAdd(),
                  const SizedBox(height: 28),
                  Text(
                    'Quick Tools',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildQuickTools(),
                  const SizedBox(height: 28),
                  _buildRecentTransactions(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Expense Manager',
                style: Theme.of(context).textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                'Manage your money with confidence',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface
                      .withValues(alpha: 0.60),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Settings',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            );
          },
          icon: const Icon(Icons.settings_outlined),
        ),
      ],
    );
  }

  Widget _buildBalanceCard() {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.78),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Balance',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            _money(_balance),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              const Icon(
                Icons.account_balance_wallet_rounded,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '${_currency.flag} ${_currency.code}',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.90),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: _summaryCard(
            title: 'Income',
            amount: _income,
            icon: Icons.arrow_downward_rounded,
            positive: true,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _summaryCard(
            title: 'Expenses',
            amount: _expenses,
            icon: Icons.arrow_upward_rounded,
            positive: false,
          ),
        ),
      ],
    );
  }

  Widget _summaryCard({
    required String title,
    required double amount,
    required IconData icon,
    required bool positive,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.58),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _money(amount),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAdd() {
    return Row(
      children: [
        Expanded(
          child: _quickAddButton(
            title: 'Income',
            icon: Icons.add_rounded,
            onTap: () => _openAddTransaction(true),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _quickAddButton(
            title: 'Expense',
            icon: Icons.remove_rounded,
            onTap: () => _openAddTransaction(false),
          ),
        ),
      ],
    );
  }

  Widget _quickAddButton({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return FilledButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(title),
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  Widget _buildQuickTools() {
    final tools = [
      {
        'title': 'Calculator',
        'subtitle': 'Finance calculator',
        'icon': Icons.calculate_rounded,
      },
      {
        'title': 'Fuel',
        'subtitle': 'Fuel & vehicles',
        'icon': Icons.local_gas_station_rounded,
      },
      {
        'title': 'Bills',
        'subtitle': 'Manage bills',
        'icon': Icons.receipt_long_rounded,
      },
      {
        'title': 'Budget',
        'subtitle': 'Spending limits',
        'icon': Icons.account_balance_wallet_rounded,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tools.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 260,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.25,
      ),
      itemBuilder: (context, index) {
        final tool = tools[index];

        return _buildToolCard(
          title: tool['title']! as String,
          subtitle: tool['subtitle']! as String,
          icon: tool['icon']! as IconData,
        );
      },
    );
  }

  Widget _buildToolCard({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
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
              MaterialPageRoute(builder: (_) => const FuelVehiclesScreen()),
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
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: theme.dividerColor.withValues(alpha: 0.12),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: theme.colorScheme.primary),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.55,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentTransactions() {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Recent Transactions',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedIndex = 1;
                });
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_transactions.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: theme.dividerColor.withValues(alpha: 0.12),
              ),
            ),
            child: const Center(child: Text('No transactions yet')),
          )
        else
          ..._transactions.reversed
              .take(5)
              .map(
                (transaction) => _transactionTile(transaction, compact: true),
              ),
      ],
    );
  }

  Widget _buildTransactions() {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Transactions',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                  ),
                ),
                IconButton(
                  tooltip: 'Add Transaction',
                  onPressed: () => _openAddTransaction(false),
                  icon: const Icon(Icons.add_circle_outline_rounded),
                ),
              ],
            ),
          ),
          Expanded(
            child: _transactions.isEmpty
                ? const Center(child: Text('No transactions yet'))
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: _transactions.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: ValueKey(_transactions[index].hashCode),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 24),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.red,
                          ),
                        ),
                        onDismissed: (_) {
                          setState(() {
                            _transactions.removeAt(index);
                          });
                        },
                        child: _transactionTile(_transactions[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _transactionTile(
    Map<String, dynamic> transaction, {
    bool compact = false,
  }) {
    final theme = Theme.of(context);
    final isIncome = transaction['type'] == 'income';
    final amount = transaction['amount'] as double;
    final currencyCode = transaction['currency'] as String;

    final currency = AppCurrencies.find(currencyCode);

    return Container(
      padding: EdgeInsets.all(compact ? 13 : 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Container(
            width: compact ? 44 : 50,
            height: compact ? 44 : 50,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              isIncome
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction['title'] as String,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 3),
                Text(
                  transaction['category'] as String,
                  style: TextStyle(
                    fontSize: 11,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${isIncome ? '+' : '-'} '
            '${currency.symbol} ${amount.toStringAsFixed(0)}',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: isIncome
                  ? theme.colorScheme.primary
                  : theme.colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfile() {
    final theme = Theme.of(context);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
        children: [
          const Text(
            'Profile',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: theme.dividerColor.withValues(alpha: 0.12),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: theme.colorScheme.primary.withValues(
                    alpha: 0.10,
                  ),
                  child: Icon(
                    Icons.person_rounded,
                    size: 30,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Profile',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Manage your preferences',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _profileTile(
            icon: Icons.settings_rounded,
            title: 'Settings',
            subtitle: 'Currency, language and preferences',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
          _profileTile(
            icon: Icons.calculate_rounded,
            title: 'Finance Calculator',
            subtitle: 'Calculator and financial tools',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FinanceCalculatorScreen(),
                ),
              );
            },
          ),
          _profileTile(
            icon: Icons.feedback_outlined,
            title: 'Feedback & Support',
            subtitle: 'Send feedback or report a problem',
            onTap: _showFeedbackDialog,
          ),
          _profileTile(
            icon: Icons.help_outline_rounded,
            title: 'Help & FAQ',
            subtitle: 'Get help using Expense Manager',
            onTap: _showHelpDialog,
          ),
          _profileTile(
            icon: Icons.info_outline_rounded,
            title: 'About',
            subtitle: 'About Expense Manager',
            onTap: _showAboutDialog,
          ),
        ],
      ),
    );
  }

  Widget _profileTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }

  Future<void> _openAddTransaction(bool isIncome) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
    );
  }

  void _showFeedbackDialog() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Feedback & Support'),
          content: const Text(
            'You can use this section to send feedback, suggest features, or report a problem.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showHelpDialog() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Help & FAQ'),
          content: const Text(
            'Use Home for your financial overview, Transactions to manage records, Reports for analysis, Goals for savings targets, and Profile for settings and support.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'Expense Manager',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(
        Icons.account_balance_wallet_rounded,
        size: 42,
      ),
      children: const [
        Text('A professional personal and business money management app.'),
      ],
    );
  }
}
