import 'package:flutter/material.dart';

import '../models/app_categories.dart';
import '../models/app_currencies.dart';

class BudgetItem {
  final String id;
  String name;
  String category;
  double limit;
  double spent;
  String currency;

  BudgetItem({
    required this.id,
    required this.name,
    required this.category,
    required this.limit,
    required this.spent,
    required this.currency,
  });
}

class BudgetsScreen extends StatefulWidget {
  const BudgetsScreen({super.key});

  @override
  State<BudgetsScreen> createState() => _BudgetsScreenState();
}

class _BudgetsScreenState extends State<BudgetsScreen> {
  static const Color primaryGreen = Color(0xFF0B9B67);

  String selectedCurrency = 'PKR';

  final List<BudgetItem> budgets = [
    BudgetItem(
      id: '1',
      name: 'Monthly Budget',
      category: 'Overall',
      limit: 100000,
      spent: 63500,
      currency: 'PKR',
    ),
    BudgetItem(
      id: '2',
      name: 'Food & Dining',
      category: 'Food & Dining',
      limit: 25000,
      spent: 14800,
      currency: 'PKR',
    ),
    BudgetItem(
      id: '3',
      name: 'Transport',
      category: 'Transport',
      limit: 15000,
      spent: 9200,
      currency: 'PKR',
    ),
    BudgetItem(
      id: '4',
      name: 'Shopping',
      category: 'Shopping',
      limit: 20000,
      spent: 17500,
      currency: 'PKR',
    ),
  ];

  AppCurrency get currency => AppCurrencies.find(selectedCurrency);

  double get totalLimit {
    return budgets
        .where((budget) => budget.currency == selectedCurrency)
        .fold(0, (sum, budget) => sum + budget.limit);
  }

  double get totalSpent {
    return budgets
        .where((budget) => budget.currency == selectedCurrency)
        .fold(0, (sum, budget) => sum + budget.spent);
  }

  double get remaining {
    return totalLimit - totalSpent;
  }

  double get percentage {
    if (totalLimit <= 0) return 0;
    return (totalSpent / totalLimit).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final visibleBudgets = budgets
        .where((budget) => budget.currency == selectedCurrency)
        .toList();

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF101513)
          : const Color(0xFFF5F8F7),
      appBar: AppBar(
        title: const Text(
          'Budgets',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Add Budget',
            onPressed: () => _showBudgetDialog(),
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        onPressed: () => _showBudgetDialog(),
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Add Budget',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 820),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
              children: [
                _buildHeader(isDark),
                const SizedBox(height: 20),
                _buildOverviewCard(isDark),
                const SizedBox(height: 26),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Your Budgets',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => _showBudgetDialog(),
                      icon: const Icon(Icons.add_rounded, size: 19),
                      label: const Text('Add'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (visibleBudgets.isEmpty)
                  _buildEmptyState(isDark)
                else
                  ...visibleBudgets.map(
                    (budget) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _buildBudgetCard(budget, isDark),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
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
              Icons.account_balance_wallet_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Control Your Spending',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Set limits and keep your finances on track.',
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

  Widget _buildOverviewCard(bool isDark) {
    final percent = percentage * 100;
    final overBudget = totalSpent > totalLimit && totalLimit > 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF18211E) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.05),
            blurRadius: 18,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _overviewValue(
                  'Budget',
                  _money(totalLimit),
                  Icons.account_balance_wallet_rounded,
                  isDark,
                ),
              ),
              Expanded(
                child: _overviewValue(
                  'Spent',
                  _money(totalSpent),
                  Icons.trending_down_rounded,
                  isDark,
                ),
              ),
              Expanded(
                child: _overviewValue(
                  'Remaining',
                  _money(remaining),
                  remaining >= 0
                      ? Icons.savings_rounded
                      : Icons.warning_rounded,
                  isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Overall Usage',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                '${percent.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: overBudget ? Colors.red : primaryGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 11,
              backgroundColor: isDark ? Colors.white12 : Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(
                overBudget
                    ? Colors.red
                    : percent >= 80
                    ? Colors.orange
                    : primaryGreen,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                overBudget
                    ? Icons.warning_amber_rounded
                    : percent >= 80
                    ? Icons.info_outline_rounded
                    : Icons.check_circle_outline_rounded,
                size: 18,
                color: overBudget
                    ? Colors.red
                    : percent >= 80
                    ? Colors.orange
                    : primaryGreen,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  overBudget
                      ? 'You have exceeded your total budget.'
                      : percent >= 80
                      ? 'You are getting close to your budget limit.'
                      : 'Your spending is currently within your budget.',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white60 : Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _overviewValue(
    String title,
    String value,
    IconData icon,
    bool isDark,
  ) {
    return Column(
      children: [
        Icon(icon, color: primaryGreen, size: 23),
        const SizedBox(height: 7),
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? Colors.white60 : Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 3),
        FittedBox(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetCard(BudgetItem budget, bool isDark) {
    final progress = budget.limit <= 0
        ? 0.0
        : (budget.spent / budget.limit).clamp(0.0, 1.0);

    final percent = budget.limit <= 0
        ? 0.0
        : (budget.spent / budget.limit) * 100;

    final remaining = budget.limit - budget.spent;

    final Color statusColor = percent >= 100
        ? Colors.red
        : percent >= 80
        ? Colors.orange
        : primaryGreen;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF18211E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.13 : 0.045),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  _categoryIcon(budget.category),
                  color: statusColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      budget.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      budget.category,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white60 : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    _showBudgetDialog(budget: budget);
                  } else if (value == 'delete') {
                    _deleteBudget(budget);
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_rounded, size: 19),
                        SizedBox(width: 10),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline_rounded, size: 19),
                        SizedBox(width: 10),
                        Text('Delete'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${_money(budget.spent)} spent',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
              Text(
                'of ${_money(budget.limit)}',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white60 : Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 9,
              backgroundColor: isDark ? Colors.white12 : Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
            ),
          ),
          const SizedBox(height: 11),
          Row(
            children: [
              Expanded(
                child: Text(
                  remaining >= 0
                      ? '${_money(remaining)} remaining'
                      : '${_money(remaining.abs())} over budget',
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
              Text(
                '${percent.toStringAsFixed(0)}%',
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF18211E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 52,
            color: primaryGreen.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 14),
          const Text(
            'No budgets yet',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
          ),
          const SizedBox(height: 7),
          Text(
            'Create your first budget to start controlling your spending.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.white60 : Colors.grey.shade600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: primaryGreen),
            onPressed: () => _showBudgetDialog(),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Create Budget'),
          ),
        ],
      ),
    );
  }

  IconData _categoryIcon(String category) {
    if (category == 'Overall') {
      return Icons.account_balance_wallet_rounded;
    }

    final allCategories = [...AppCategories.expense, ...AppCategories.income];

    for (final item in allCategories) {
      if (item.name == category) {
        return item.icon;
      }
    }

    return Icons.category_rounded;
  }

  String _money(double value) {
    final formatted = value
        .toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',');

    return '${currency.symbol} $formatted';
  }

  void _showBudgetDialog({BudgetItem? budget}) {
    final isEditing = budget != null;

    final nameController = TextEditingController(text: budget?.name ?? '');

    final amountController = TextEditingController(
      text: budget != null ? budget.limit.toStringAsFixed(0) : '',
    );

    String category = budget?.category ?? 'Overall';
    String dialogCurrency = budget?.currency ?? selectedCurrency;

    final categories = [
      'Overall',
      ...AppCategories.expense.map((item) => item.name),
    ];

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                isEditing ? 'Edit Budget' : 'Create Budget',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: 'Budget name',
                        hintText: 'e.g. Monthly Food Budget',
                        prefixIcon: const Icon(Icons.edit_note_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      initialValue: category,
                      decoration: InputDecoration(
                        labelText: 'Category',
                        prefixIcon: const Icon(Icons.category_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      items: categories
                          .map(
                            (item) => DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            category = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: amountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Budget limit',
                        prefixText:
                            '${AppCurrencies.find(dialogCurrency).symbol} ',
                        prefixIcon: const Icon(Icons.payments_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      initialValue: dialogCurrency,
                      decoration: InputDecoration(
                        labelText: 'Currency',
                        prefixIcon: const Icon(Icons.currency_exchange_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      items: AppCurrencies.all
                          .map(
                            (item) => DropdownMenuItem(
                              value: item.code,
                              child: Text(
                                '${item.flag}  ${item.code} - ${item.name}',
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            dialogCurrency = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: primaryGreen),
                  onPressed: () {
                    final amount = double.tryParse(
                      amountController.text.trim(),
                    );

                    if (nameController.text.trim().isEmpty ||
                        amount == null ||
                        amount <= 0) {
                      _showMessage(
                        'Please enter a valid name and budget amount.',
                      );
                      return;
                    }

                    setState(() {
                      if (isEditing) {
                        budget
                          ..name = nameController.text.trim()
                          ..category = category
                          ..limit = amount
                          ..currency = dialogCurrency;
                      } else {
                        budgets.add(
                          BudgetItem(
                            id: DateTime.now().millisecondsSinceEpoch
                                .toString(),
                            name: nameController.text.trim(),
                            category: category,
                            limit: amount,
                            spent: 0,
                            currency: dialogCurrency,
                          ),
                        );
                      }
                    });

                    Navigator.pop(dialogContext);

                    _showMessage(
                      isEditing
                          ? 'Budget updated successfully.'
                          : 'Budget created successfully.',
                    );
                  },
                  child: Text(isEditing ? 'Save Changes' : 'Create'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteBudget(BudgetItem budget) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Delete Budget',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          content: Text('Are you sure you want to delete "${budget.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                setState(() {
                  budgets.removeWhere((item) => item.id == budget.id);
                });

                Navigator.pop(dialogContext);
                _showMessage('Budget deleted.');
              },
              child: const Text('Delete'),
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
