import 'package:flutter/material.dart';

import '../models/app_currencies.dart';

class BillItem {
  final String id;
  String name;
  String category;
  double amount;
  DateTime dueDate;
  String frequency;
  String currency;
  bool paid;

  BillItem({
    required this.id,
    required this.name,
    required this.category,
    required this.amount,
    required this.dueDate,
    required this.frequency,
    required this.currency,
    this.paid = false,
  });
}

class BillsScreen extends StatefulWidget {
  const BillsScreen({super.key});

  @override
  State<BillsScreen> createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
  static const Color primaryGreen = Color(0xFF0B9B67);

  String selectedCurrency = 'PKR';

  final List<BillItem> bills = [
    BillItem(
      id: '1',
      name: 'Electricity Bill',
      category: 'Utilities',
      amount: 12500,
      dueDate: DateTime(2026, 10, 8),
      frequency: 'Monthly',
      currency: 'PKR',
    ),
    BillItem(
      id: '2',
      name: 'Internet',
      category: 'Internet',
      amount: 3500,
      dueDate: DateTime(2026, 10, 12),
      frequency: 'Monthly',
      currency: 'PKR',
    ),
    BillItem(
      id: '3',
      name: 'Rent',
      category: 'Rent',
      amount: 35000,
      dueDate: DateTime(2026, 10, 5),
      frequency: 'Monthly',
      currency: 'PKR',
    ),
    BillItem(
      id: '4',
      name: 'Netflix',
      category: 'Subscription',
      amount: 1100,
      dueDate: DateTime(2026, 10, 18),
      frequency: 'Monthly',
      currency: 'PKR',
      paid: true,
    ),
  ];

  AppCurrency get currency {
    return AppCurrencies.find(selectedCurrency);
  }

  List<BillItem> get visibleBills {
    return bills.where((bill) => bill.currency == selectedCurrency).toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  List<BillItem> get upcomingBills {
    return visibleBills.where((bill) => !bill.paid).toList();
  }

  List<BillItem> get paidBills {
    return visibleBills.where((bill) => bill.paid).toList();
  }

  double get upcomingTotal {
    return upcomingBills.fold(0, (sum, bill) => sum + bill.amount);
  }

  double get paidTotal {
    return paidBills.fold(0, (sum, bill) => sum + bill.amount);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF101513)
          : const Color(0xFFF5F8F7),
      appBar: AppBar(
        title: const Text(
          'Bills & Recurring',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Add Bill',
            onPressed: () => _showBillDialog(),
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        onPressed: () => _showBillDialog(),
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Add Bill',
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
                _buildSummaryCard(isDark),
                const SizedBox(height: 26),
                if (upcomingBills.isNotEmpty) ...[
                  const Text(
                    'Upcoming Bills',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  ...upcomingBills.map(
                    (bill) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _buildBillCard(bill, isDark),
                    ),
                  ),
                ],
                if (paidBills.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  const Text(
                    'Paid Bills',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  ...paidBills.map(
                    (bill) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _buildBillCard(bill, isDark),
                    ),
                  ),
                ],
                if (visibleBills.isEmpty) _buildEmptyState(isDark),
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
              Icons.receipt_long_rounded,
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
                  'Never Miss a Payment',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Track bills, subscriptions and recurring expenses.',
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

  Widget _buildSummaryCard(bool isDark) {
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
      child: Row(
        children: [
          Expanded(
            child: _summaryValue(
              'Upcoming',
              upcomingBills.length.toString(),
              _money(upcomingTotal),
              Icons.schedule_rounded,
              Colors.orange,
              isDark,
            ),
          ),
          Container(
            width: 1,
            height: 65,
            color: isDark ? Colors.white12 : Colors.grey.shade200,
          ),
          Expanded(
            child: _summaryValue(
              'Paid',
              paidBills.length.toString(),
              _money(paidTotal),
              Icons.check_circle_rounded,
              primaryGreen,
              isDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryValue(
    String title,
    String count,
    String amount,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 7),
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? Colors.white60 : Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          count,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 2),
        FittedBox(
          child: Text(
            amount,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBillCard(BillItem bill, bool isDark) {
    final days = bill.dueDate
        .difference(
          DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
          ),
        )
        .inDays;

    final isOverdue = !bill.paid && days < 0;
    final isSoon = !bill.paid && days >= 0 && days <= 3;

    final statusColor = bill.paid
        ? primaryGreen
        : isOverdue
        ? Colors.red
        : isSoon
        ? Colors.orange
        : primaryGreen;

    return Container(
      padding: const EdgeInsets.all(17),
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
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  _billIcon(bill.category),
                  color: statusColor,
                  size: 25,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bill.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${bill.category} • ${bill.frequency}',
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
                    _showBillDialog(bill: bill);
                  } else if (value == 'delete') {
                    _deleteBill(bill);
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
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.04)
                  : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Row(
              children: [
                Icon(
                  bill.paid
                      ? Icons.check_circle_rounded
                      : Icons.calendar_today_rounded,
                  size: 17,
                  color: statusColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    bill.paid
                        ? 'Paid'
                        : isOverdue
                        ? 'Overdue by ${days.abs()} day${days.abs() == 1 ? '' : 's'}'
                        : days == 0
                        ? 'Due today'
                        : 'Due in $days day${days == 1 ? '' : 's'}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: statusColor,
                    ),
                  ),
                ),
                Text(
                  _dateText(bill.dueDate),
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white60 : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  _money(bill.amount),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (!bill.paid)
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: primaryGreen,
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                  ),
                  onPressed: () {
                    setState(() {
                      bill.paid = true;
                    });

                    _showMessage('${bill.name} marked as paid.');
                  },
                  icon: const Icon(Icons.check_rounded, size: 17),
                  label: const Text('Mark Paid'),
                )
              else
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryGreen,
                  ),
                  onPressed: () {
                    setState(() {
                      bill.paid = false;
                    });

                    _showMessage('${bill.name} marked as unpaid.');
                  },
                  icon: const Icon(Icons.undo_rounded, size: 17),
                  label: const Text('Undo'),
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
            Icons.receipt_long_outlined,
            size: 52,
            color: primaryGreen.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 14),
          const Text(
            'No bills yet',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
          ),
          const SizedBox(height: 7),
          Text(
            'Add your electricity, rent, internet, subscriptions and other recurring payments.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.white60 : Colors.grey.shade600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: primaryGreen),
            onPressed: () => _showBillDialog(),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add Bill'),
          ),
        ],
      ),
    );
  }

  IconData _billIcon(String category) {
    switch (category) {
      case 'Utilities':
        return Icons.bolt_rounded;
      case 'Internet':
        return Icons.wifi_rounded;
      case 'Phone':
        return Icons.phone_android_rounded;
      case 'Rent':
        return Icons.home_work_rounded;
      case 'Subscription':
        return Icons.subscriptions_rounded;
      case 'Insurance':
        return Icons.verified_user_rounded;
      case 'Salary':
        return Icons.people_alt_rounded;
      case 'Loan / Installment':
        return Icons.payments_rounded;
      case 'Education':
        return Icons.school_rounded;
      default:
        return Icons.receipt_long_rounded;
    }
  }

  String _money(double value) {
    final formatted = value
        .toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',');

    return '${currency.symbol} $formatted';
  }

  String _dateText(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _showBillDialog({BillItem? bill}) {
    final isEditing = bill != null;

    final nameController = TextEditingController(text: bill?.name ?? '');

    final amountController = TextEditingController(
      text: bill != null ? bill.amount.toStringAsFixed(0) : '',
    );

    String category = bill?.category ?? 'Utilities';
    String frequency = bill?.frequency ?? 'Monthly';
    String dialogCurrency = bill?.currency ?? selectedCurrency;
    DateTime selectedDate = bill?.dueDate ?? DateTime.now();

    const categories = [
      'Utilities',
      'Internet',
      'Phone',
      'Rent',
      'Subscription',
      'Insurance',
      'Salary',
      'Loan / Installment',
      'Education',
      'Other',
    ];

    const frequencies = [
      'One Time',
      'Weekly',
      'Monthly',
      'Quarterly',
      'Yearly',
    ];

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                isEditing ? 'Edit Bill' : 'Add Bill',
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
                        labelText: 'Bill name',
                        hintText: 'e.g. Electricity Bill',
                        prefixIcon: const Icon(Icons.receipt_long_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: amountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Amount',
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
                    DropdownButtonFormField<String>(
                      initialValue: frequency,
                      decoration: InputDecoration(
                        labelText: 'Frequency',
                        prefixIcon: const Icon(Icons.repeat_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      items: frequencies
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
                            frequency = value;
                          });
                        }
                      },
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
                    const SizedBox(height: 14),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      leading: const Icon(
                        Icons.calendar_month_rounded,
                        color: primaryGreen,
                      ),
                      title: const Text(
                        'Due Date',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text(_dateText(selectedDate)),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );

                        if (picked != null) {
                          setDialogState(() {
                            selectedDate = picked;
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
                        'Please enter a valid bill name and amount.',
                      );
                      return;
                    }

                    setState(() {
                      if (isEditing) {
                        bill
                          ..name = nameController.text.trim()
                          ..category = category
                          ..amount = amount
                          ..dueDate = selectedDate
                          ..frequency = frequency
                          ..currency = dialogCurrency;
                      } else {
                        bills.add(
                          BillItem(
                            id: DateTime.now().millisecondsSinceEpoch
                                .toString(),
                            name: nameController.text.trim(),
                            category: category,
                            amount: amount,
                            dueDate: selectedDate,
                            frequency: frequency,
                            currency: dialogCurrency,
                          ),
                        );
                      }
                    });

                    Navigator.pop(dialogContext);

                    _showMessage(
                      isEditing
                          ? 'Bill updated successfully.'
                          : 'Bill added successfully.',
                    );
                  },
                  child: Text(isEditing ? 'Save Changes' : 'Add Bill'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteBill(BillItem bill) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Delete Bill',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          content: Text('Are you sure you want to delete "${bill.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                setState(() {
                  bills.removeWhere((item) => item.id == bill.id);
                });

                Navigator.pop(dialogContext);
                _showMessage('Bill deleted.');
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
