import 'package:flutter/material.dart';

import '../models/app_currencies.dart';

class FinanceCalculatorScreen extends StatefulWidget {
  const FinanceCalculatorScreen({super.key});

  @override
  State<FinanceCalculatorScreen> createState() =>
      _FinanceCalculatorScreenState();
}

class _FinanceCalculatorScreenState extends State<FinanceCalculatorScreen> {
  int selectedTool = 0;

  final amountController = TextEditingController();
  final secondController = TextEditingController();
  final thirdController = TextEditingController();

  String result = '';
  String selectedCurrency = 'PKR';

  final tools = const [
    ('Calculator', Icons.calculate_rounded),
    ('Percentage', Icons.percent_rounded),
    ('Discount', Icons.local_offer_rounded),
    ('Tip', Icons.restaurant_rounded),
    ('Savings', Icons.savings_rounded),
    ('Loan', Icons.payments_rounded),
    ('Currency', Icons.currency_exchange_rounded),
  ];

  @override
  void dispose() {
    amountController.dispose();
    secondController.dispose();
    thirdController.dispose();
    super.dispose();
  }

  double _number(TextEditingController controller) {
    return double.tryParse(controller.text.trim()) ?? 0;
  }

  String _money(double value) {
    final currency = AppCurrencies.find(selectedCurrency);
    return '${currency.symbol} ${value.toStringAsFixed(2)}';
  }

  void _calculate() {
    final a = _number(amountController);
    final b = _number(secondController);
    final c = _number(thirdController);

    double answer = 0;
    String label = '';

    switch (selectedTool) {
      case 0:
        answer = a + b;
        label = 'Result';
        break;

      case 1:
        answer = a * b / 100;
        label = '$b% of $a';
        break;

      case 2:
        answer = a - (a * b / 100);
        label = 'Price after discount';
        break;

      case 3:
        answer = a + (a * b / 100);
        label = 'Total including tip';
        break;

      case 4:
        answer = a - b;
        label = 'Amount remaining to save';
        break;

      case 5:
        if (c <= 0) {
          setState(() {
            result = 'Please enter months greater than 0.';
          });
          return;
        }

        answer = (a + (a * b / 100)) / c;
        label = 'Estimated monthly installment';
        break;

      case 6:
        if (b <= 0) {
          setState(() {
            result = 'Please enter a valid exchange rate.';
          });
          return;
        }

        answer = a * b;
        label = 'Converted amount';
        break;
    }

    setState(() {
      result = '$label\n${_money(answer)}';
    });
  }

  void _clear() {
    amountController.clear();
    secondController.clear();
    thirdController.clear();

    setState(() {
      result = '';
    });
  }

  String _firstLabel() {
    switch (selectedTool) {
      case 0:
        return 'First Amount';
      case 1:
        return 'Amount';
      case 2:
        return 'Original Price';
      case 3:
        return 'Bill Amount';
      case 4:
        return 'Target Amount';
      case 5:
        return 'Loan Amount';
      case 6:
        return 'Amount';
      default:
        return 'Amount';
    }
  }

  String _secondLabel() {
    switch (selectedTool) {
      case 0:
        return 'Second Amount';
      case 1:
        return 'Percentage (%)';
      case 2:
        return 'Discount (%)';
      case 3:
        return 'Tip (%)';
      case 4:
        return 'Already Saved';
      case 5:
        return 'Annual Interest (%)';
      case 6:
        return 'Exchange Rate';
      default:
        return 'Value';
    }
  }

  String _thirdLabel() {
    if (selectedTool == 5) {
      return 'Number of Months';
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Finance Calculator',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 850),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Financial Tools',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  'Calculate everyday money decisions quickly.',
                  style: TextStyle(
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  height: 105,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: tools.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final selected = selectedTool == index;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTool = index;
                            result = '';
                            amountController.clear();
                            secondController.clear();
                            thirdController.clear();
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          width: 105,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: selected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: selected
                                  ? Colors.transparent
                                  : Theme.of(context).dividerColor,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                tools[index].$2,
                                color: selected
                                    ? Colors.white
                                    : Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                tools[index].$1,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: selected ? Colors.white : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tools[selectedTool].$1,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 18),

                        if (selectedTool == 6) ...[
                          DropdownButtonFormField<String>(
                            initialValue: selectedCurrency,
                            decoration: const InputDecoration(
                              labelText: 'Currency',
                              prefixIcon: Icon(Icons.currency_exchange),
                            ),
                            items: AppCurrencies.all
                                .map(
                                  (currency) => DropdownMenuItem<String>(
                                    value: currency.code,
                                    child: Text(
                                      '${currency.flag} ${currency.code} - ${currency.name}',
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  selectedCurrency = value;
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 14),
                        ],

                        TextField(
                          controller: amountController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: InputDecoration(
                            labelText: _firstLabel(),
                            prefixIcon: const Icon(Icons.attach_money),
                          ),
                        ),

                        const SizedBox(height: 14),

                        TextField(
                          controller: secondController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: InputDecoration(
                            labelText: _secondLabel(),
                            prefixIcon: const Icon(Icons.edit_rounded),
                          ),
                        ),

                        if (selectedTool == 5) ...[
                          const SizedBox(height: 14),
                          TextField(
                            controller: thirdController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: _thirdLabel(),
                              prefixIcon: const Icon(Icons.calendar_month),
                            ),
                          ),
                        ],

                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Expanded(
                              child: FilledButton.icon(
                                onPressed: _calculate,
                                icon: const Icon(Icons.calculate_rounded),
                                label: const Text('Calculate'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            OutlinedButton(
                              onPressed: _clear,
                              child: const Text('Clear'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                if (result.isNotEmpty) ...[
                  const SizedBox(height: 18),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary
                          .withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      result,
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 25),

                const Text(
                  'Tip',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  selectedTool == 6
                      ? 'Currency conversion uses the exchange rate you enter. The app does not use fake or automatically assumed exchange rates.'
                      : 'Enter the values above and tap Calculate to get your result.',
                  style: TextStyle(
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
