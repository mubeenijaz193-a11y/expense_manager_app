import 'package:flutter/material.dart';

import '../models/app_currencies.dart';

class ReportsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> transactions;

  const ReportsScreen({super.key, required this.transactions});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  static const Color green = Color(0xFF0B9B67);

  String selectedPeriod = 'This Month';

  AppCurrency get currency => AppCurrencies.defaultCurrency;

  List<Map<String, dynamic>> get currencyTransactions {
    return widget.transactions.where((transaction) {
      return (transaction['currency'] ?? 'PKR') == currency.code;
    }).toList();
  }

  DateTime transactionDate(Map<String, dynamic> transaction) {
    final value = transaction['date'];

    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }

    return DateTime.now();
  }

  bool isIncome(Map<String, dynamic> transaction) {
    return transaction['type'] == 'Income';
  }

  double amount(Map<String, dynamic> transaction) {
    final value = transaction['amount'];

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  bool matchesPeriod(Map<String, dynamic> transaction) {
    final date = transactionDate(transaction);
    final now = DateTime.now();

    switch (selectedPeriod) {
      case 'Today':
        return date.year == now.year &&
            date.month == now.month &&
            date.day == now.day;

      case 'This Week':
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

        final start = DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day,
        );

        final end = start.add(const Duration(days: 7));

        return !date.isBefore(start) && date.isBefore(end);

      case 'This Year':
        return date.year == now.year;

      case 'This Month':
      default:
        return date.year == now.year && date.month == now.month;
    }
  }

  List<Map<String, dynamic>> get filteredTransactions {
    return currencyTransactions.where(matchesPeriod).toList();
  }

  double get income {
    return filteredTransactions
        .where(isIncome)
        .fold(0, (sum, item) => sum + amount(item));
  }

  double get expense {
    return filteredTransactions
        .where((item) => !isIncome(item))
        .fold(0, (sum, item) => sum + amount(item));
  }

  double get savings {
    return income - expense;
  }

  String money(double value) {
    return '${currency.symbol} ${value.toStringAsFixed(0)}';
  }

  Map<String, double> categoryExpenses() {
    final Map<String, double> result = {};

    for (final transaction in filteredTransactions) {
      if (isIncome(transaction)) {
        continue;
      }

      final category = transaction['category']?.toString() ?? 'Other Expense';

      result[category] = (result[category] ?? 0) + amount(transaction);
    }

    return result;
  }

  IconData categoryIcon(String category) {
    const icons = <String, IconData>{
      'Food & Dining': Icons.restaurant_rounded,
      'Groceries': Icons.shopping_cart_rounded,
      'Fuel': Icons.local_gas_station_rounded,
      'Transport': Icons.directions_car_rounded,
      'Housing': Icons.home_rounded,
      'Bills & Utilities': Icons.receipt_long_rounded,
      'Shopping': Icons.shopping_bag_rounded,
      'Health': Icons.medical_services_rounded,
      'Education': Icons.school_rounded,
      'Family': Icons.family_restroom_rounded,
      'Travel': Icons.flight_takeoff_rounded,
      'Entertainment': Icons.movie_rounded,
      'Business': Icons.business_center_rounded,
      'Maintenance': Icons.build_rounded,
      'Phone & Internet': Icons.phone_android_rounded,
      'Taxes': Icons.account_balance_rounded,
      'Other Expense': Icons.more_horiz_rounded,
    };

    return icons[category] ?? Icons.category_rounded;
  }

  Color categoryColor(int index) {
    const colors = [
      Color(0xFF0B9B67),
      Color(0xFF2D7FF9),
      Color(0xFFFF9F43),
      Color(0xFF9B59B6),
      Color(0xFFE74C3C),
      Color(0xFF16A085),
      Color(0xFF34495E),
    ];

    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final categories = categoryExpenses();

    final sortedCategories = categories.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final maxCategoryAmount = sortedCategories.isEmpty
        ? 1.0
        : sortedCategories.first.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reports',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth > 1000
              ? 1000.0
              : constraints.maxWidth;

          return Center(
            child: SizedBox(
              width: maxWidth,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildPeriodSelector(),
                    const SizedBox(height: 20),
                    buildSummaryCards(),
                    const SizedBox(height: 24),
                    buildIncomeExpenseCard(),
                    const SizedBox(height: 24),
                    buildCategoryCard(sortedCategories, maxCategoryAmount),
                    const SizedBox(height: 24),
                    buildInsights(),
                    const SizedBox(height: 24),
                    buildReportFeatures(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildPeriodSelector() {
    final periods = ['Today', 'This Week', 'This Month', 'This Year'];

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            offset: const Offset(0, 5),
            color: Colors.black.withValues(alpha: 0.05),
          ),
        ],
      ),
      child: Row(
        children: periods.map((period) {
          final selected = selectedPeriod == period;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedPeriod = period;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                  vertical: 11,
                  horizontal: 6,
                ),
                decoration: BoxDecoration(
                  color: selected ? green : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  period.replaceFirst('This ', ''),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget buildSummaryCards() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 650) {
          return Column(
            children: [
              summaryCard(
                title: 'Income',
                value: money(income),
                icon: Icons.arrow_downward_rounded,
                color: green,
              ),
              const SizedBox(height: 12),
              summaryCard(
                title: 'Expenses',
                value: money(expense),
                icon: Icons.arrow_upward_rounded,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 12),
              summaryCard(
                title: 'Savings',
                value: money(savings),
                icon: Icons.savings_rounded,
                color: Colors.blue,
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: summaryCard(
                title: 'Income',
                value: money(income),
                icon: Icons.arrow_downward_rounded,
                color: green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: summaryCard(
                title: 'Expenses',
                value: money(expense),
                icon: Icons.arrow_upward_rounded,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: summaryCard(
                title: 'Savings',
                value: money(savings),
                icon: Icons.savings_rounded,
                color: Colors.blue,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget summaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 6),
            color: Colors.black.withValues(alpha: 0.05),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
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

  Widget buildIncomeExpenseCard() {
    final total = income + expense;

    final incomePercent = total == 0 ? 0.0 : income / total;

    final expensePercent = total == 0 ? 0.0 : expense / total;

    return sectionCard(
      title: 'Income vs Expenses',
      icon: Icons.compare_arrows_rounded,
      child: Column(
        children: [
          const SizedBox(height: 12),
          SizedBox(
            height: 18,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Row(
                children: [
                  Expanded(
                    flex: total == 0 ? 1 : (incomePercent * 1000).round(),
                    child: Container(color: green),
                  ),
                  Expanded(
                    flex: total == 0 ? 0 : (expensePercent * 1000).round(),
                    child: Container(color: Colors.redAccent),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(child: legendItem('Income', money(income), green)),
              Expanded(
                child: legendItem('Expenses', money(expense), Colors.redAccent),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: green.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(
                  savings >= 0
                      ? Icons.trending_up_rounded
                      : Icons.trending_down_rounded,
                  color: savings >= 0 ? green : Colors.redAccent,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    savings >= 0
                        ? 'You saved ${money(savings)} during this period.'
                        : 'Your expenses exceeded income by ${money(savings.abs())}.',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget legendItem(String title, String value, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 3),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildCategoryCard(
    List<MapEntry<String, double>> categories,
    double maxAmount,
  ) {
    return sectionCard(
      title: 'Spending by Category',
      icon: Icons.pie_chart_rounded,
      child: categories.isEmpty
          ? emptyState(
              Icons.bar_chart_rounded,
              'No expense data yet',
              'Add some expenses to see your spending breakdown.',
            )
          : Column(
              children: [
                const SizedBox(height: 6),
                ...categories.take(8).toList().asMap().entries.map((entry) {
                  final index = entry.key;
                  final category = entry.value;
                  final progress = category.value / maxAmount;
                  final color = categoryColor(index);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(11),
                              ),
                              child: Icon(
                                categoryIcon(category.key),
                                size: 19,
                                color: color,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                category.key,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              money(category.value),
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: LinearProgressIndicator(
                            value: progress.clamp(0.0, 1.0),
                            minHeight: 7,
                            backgroundColor: color.withValues(alpha: 0.10),
                            valueColor: AlwaysStoppedAnimation<Color>(color),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
    );
  }

  Widget buildInsights() {
    final categories = categoryExpenses();

    String message;

    if (filteredTransactions.isEmpty) {
      message = 'Start adding transactions and your financial insights will appear here.';
    } else if (expense == 0) {
      message = 'Great start! You currently have no recorded expenses for this period.';
    } else if (savings > 0) {
      final sorted = categories.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      if (sorted.isNotEmpty) {
        message =
            'You are saving money. Your largest expense category is ${sorted.first.key}.';
      } else {
        message = 'You are currently spending less than your income.';
      }
    } else {
      message = 'Your expenses are higher than your income. Consider reviewing your spending categories.';
    }

    return sectionCard(
      title: 'Financial Insight',
      icon: Icons.lightbulb_rounded,
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.amber.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.auto_awesome_rounded, color: Colors.amber),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  height: 1.45,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildReportFeatures() {
    final features = [
      (
        'Monthly Report',
        'Review your complete monthly financial activity.',
        Icons.calendar_month_rounded,
      ),
      (
        'Category Analysis',
        'Find where most of your money is being spent.',
        Icons.category_rounded,
      ),
      (
        'Savings Analysis',
        'Track how much you are keeping from your income.',
        Icons.savings_rounded,
      ),
      (
        'Fuel Analysis',
        'Track fuel expenses separately for better vehicle management.',
        Icons.local_gas_station_rounded,
      ),
    ];

    return sectionCard(
      title: 'Detailed Analysis',
      icon: Icons.analytics_rounded,
      child: Column(
        children: [
          const SizedBox(height: 6),
          ...features.map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: featureTile(
                title: feature.$1,
                description: feature.$2,
                icon: feature.$3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget featureTile({
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest
            .withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: green.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: green),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.35,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, size: 15),
        ],
      ),
    );
  }

  Widget sectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(0, 7),
            color: Colors.black.withValues(alpha: 0.05),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: green.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, color: green, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          child,
        ],
      ),
    );
  }

  Widget emptyState(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Column(
        children: [
          Icon(
            icon,
            size: 46,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
