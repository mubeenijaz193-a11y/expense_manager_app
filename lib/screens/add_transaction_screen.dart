import 'package:flutter/material.dart';

import '../models/app_categories.dart';
import '../models/app_currencies.dart';

class AddTransactionScreen extends StatefulWidget {
  final void Function(
    String type,
    double amount,
    String category,
    DateTime date,
    String note,
    String currency,
  )?
  onSaved;

  final String initialType;
  final double? initialAmount;
  final String? initialCategory;
  final DateTime? initialDate;
  final String? initialNote;
  final String? initialCurrency;
  final bool isEditing;

  const AddTransactionScreen({
    super.key,
    this.onSaved,
    this.initialType = 'Expense',
    this.initialAmount,
    this.initialCategory,
    this.initialDate,
    this.initialNote,
    this.initialCurrency,
    this.isEditing = false,
  });

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  static const Color green = Color(0xFF0B9B67);

  late TextEditingController amountController;
  late TextEditingController noteController;

  late String selectedType;
  late String selectedCategory;
  late String selectedCurrency;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();

    selectedType = widget.initialType;
    selectedCurrency = widget.initialCurrency ?? 'PKR';
    selectedDate = widget.initialDate ?? DateTime.now();

    amountController = TextEditingController(
      text: widget.initialAmount == null
          ? ''
          : widget.initialAmount!.toStringAsFixed(0),
    );

    noteController = TextEditingController(text: widget.initialNote ?? '');

    final availableCategories = selectedType == 'Income'
        ? AppCategories.income
        : AppCategories.expense;

    final requestedCategory = widget.initialCategory;

    if (requestedCategory != null &&
        availableCategories.any(
          (category) => category.name == requestedCategory,
        )) {
      selectedCategory = requestedCategory;
    } else {
      selectedCategory = availableCategories.first.name;
    }
  }

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  List<AppCategory> get categories {
    return selectedType == 'Income'
        ? AppCategories.income
        : AppCategories.expense;
  }

  AppCurrency get currency {
    return AppCurrencies.find(selectedCurrency);
  }

  void changeType(String type) {
    setState(() {
      selectedType = type;
      selectedCategory = type == 'Income'
          ? AppCategories.income.first.name
          : AppCategories.expense.first.name;
    });
  }

  Future<void> selectCurrency() async {
    final selected = await showModalBottomSheet<AppCurrency>(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            children: [
              const Text(
                'Select Currency',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              ...AppCurrencies.all.map((item) {
                final isSelected = item.code == selectedCurrency;

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Text(
                    item.flag,
                    style: const TextStyle(fontSize: 25),
                  ),
                  title: Text(
                    item.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text('${item.code} • ${item.symbol}'),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle_rounded, color: green)
                      : null,
                  onTap: () {
                    Navigator.pop(context, item);
                  },
                );
              }),
            ],
          ),
        );
      },
    );

    if (selected != null) {
      setState(() {
        selectedCurrency = selected.code;
      });
    }
  }

  Future<void> selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void saveTransaction() {
    final amount = double.tryParse(amountController.text.trim());

    if (amount == null || amount <= 0) {
      _showMessage('Please enter a valid amount.');
      return;
    }

    widget.onSaved?.call(
      selectedType,
      amount,
      selectedCategory,
      selectedDate,
      noteController.text.trim(),
      selectedCurrency,
    );

    Navigator.pop(context);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isIncome = selectedType == 'Income';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F7),
      appBar: AppBar(
        title: Text(
          widget.isEditing ? 'Edit Transaction' : 'Add Transaction',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 35),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 650),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _typeSelector(isIncome),

                  const SizedBox(height: 25),

                  const Text(
                    'Currency',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 8),

                  _currencySelector(),

                  const SizedBox(height: 22),

                  const Text(
                    'Amount',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller: amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      hintText: '0.00',
                      prefixText: '${currency.symbol} ',
                      prefixStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: green,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: _border(),
                      enabledBorder: _border(),
                      focusedBorder: _focusedBorder(),
                    ),
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    'Category',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 12),

                  _categoryGrid(),

                  const SizedBox(height: 24),

                  const Text(
                    'Date',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 8),

                  InkWell(
                    onTap: selectDate,
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(17),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: const Color(0xFFE0E8E4)),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_month_rounded,
                            color: green,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            formatDate(selectedDate),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const Spacer(),
                          const Icon(Icons.chevron_right_rounded),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    'Note',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller: noteController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Add a note (optional)',
                      filled: true,
                      fillColor: Colors.white,
                      border: _border(),
                      enabledBorder: _border(),
                      focusedBorder: _focusedBorder(),
                    ),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: saveTransaction,
                      icon: Icon(
                        widget.isEditing
                            ? Icons.save_rounded
                            : Icons.check_rounded,
                      ),
                      label: Text(
                        widget.isEditing
                            ? 'Update Transaction'
                            : 'Save Transaction',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: green,
                        padding: const EdgeInsets.symmetric(vertical: 17),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _currencySelector() {
    return InkWell(
      onTap: selectCurrency,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFFE0E8E4)),
        ),
        child: Row(
          children: [
            Text(currency.flag, style: const TextStyle(fontSize: 25)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currency.code,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    currency.name,
                    style: const TextStyle(
                      color: Color(0xFF718078),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded),
          ],
        ),
      ),
    );
  }

  Widget _typeSelector(bool isIncome) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E8E4)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _typeButton(title: 'Income', selected: isIncome),
          ),
          Expanded(
            child: _typeButton(title: 'Expense', selected: !isIncome),
          ),
        ],
      ),
    );
  }

  Widget _typeButton({required String title, required bool selected}) {
    return GestureDetector(
      onTap: () => changeType(title),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? green : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: selected ? Colors.white : const Color(0xFF52615A),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _categoryGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.05,
      ),
      itemBuilder: (context, index) {
        final category = categories[index];
        final selected = category.name == selectedCategory;

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedCategory = category.name;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: selected ? green : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected ? green : const Color(0xFFE2EAE6),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  category.icon,
                  size: 25,
                  color: selected ? Colors.white : green,
                ),
                const SizedBox(height: 7),
                Text(
                  category.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: selected ? Colors.white : const Color(0xFF35413B),
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  OutlineInputBorder _border() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: Color(0xFFE0E8E4)),
    );
  }

  OutlineInputBorder _focusedBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: green, width: 1.5),
    );
  }
}
