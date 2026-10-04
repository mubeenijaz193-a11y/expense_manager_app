import 'package:flutter/material.dart';

class FuelCalculatorScreen extends StatefulWidget {
  const FuelCalculatorScreen({super.key});

  @override
  State<FuelCalculatorScreen> createState() => _FuelCalculatorScreenState();
}

class _FuelCalculatorScreenState extends State<FuelCalculatorScreen> {
  int selectedTool = 0;

  final fuelPriceController = TextEditingController();
  final litresController = TextEditingController();
  final distanceController = TextEditingController();
  final mileageController = TextEditingController();
  final costController = TextEditingController();

  String result = '';

  final tools = const [
    ('Fuel Cost', Icons.local_gas_station_rounded),
    ('Litres Needed', Icons.water_drop_rounded),
    ('Mileage', Icons.speed_rounded),
    ('Cost / KM', Icons.route_rounded),
  ];

  @override
  void dispose() {
    fuelPriceController.dispose();
    litresController.dispose();
    distanceController.dispose();
    mileageController.dispose();
    costController.dispose();
    super.dispose();
  }

  double _value(TextEditingController controller) {
    return double.tryParse(controller.text.trim()) ?? 0;
  }

  void _calculate() {
    final price = _value(fuelPriceController);
    final litres = _value(litresController);
    final distance = _value(distanceController);
    final mileage = _value(mileageController);
    final cost = _value(costController);

    double answer = 0;
    String title = '';

    switch (selectedTool) {
      case 0:
        if (price <= 0 || litres <= 0) {
          setState(() {
            result = 'Please enter fuel price and litres.';
          });
          return;
        }

        answer = price * litres;
        title = 'Total Fuel Cost';
        break;

      case 1:
        if (price <= 0 || distance <= 0 || mileage <= 0) {
          setState(() {
            result = 'Please enter fuel price, distance and mileage.';
          });
          return;
        }

        final requiredLitres = distance / mileage;
        answer = requiredLitres;
        title = 'Fuel Required';
        break;

      case 2:
        if (litres <= 0 || distance <= 0) {
          setState(() {
            result = 'Please enter litres and distance.';
          });
          return;
        }

        answer = distance / litres;
        title = 'Mileage';
        break;

      case 3:
        if (cost <= 0 || distance <= 0) {
          setState(() {
            result = 'Please enter fuel cost and distance.';
          });
          return;
        }

        answer = cost / distance;
        title = 'Fuel Cost per KM';
        break;
    }

    setState(() {
      if (selectedTool == 1) {
        result = '$title\n${answer.toStringAsFixed(2)} litres';
      } else if (selectedTool == 2) {
        result = '$title\n${answer.toStringAsFixed(2)} km/litre';
      } else {
        result = '$title\nRs. ${answer.toStringAsFixed(2)}';
      }
    });
  }

  void _clear() {
    fuelPriceController.clear();
    litresController.clear();
    distanceController.clear();
    mileageController.clear();
    costController.clear();

    setState(() {
      result = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fuel Calculator',
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
                  'Fuel & Vehicle Tools',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  'Track fuel cost, mileage and travel expenses.',
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
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          width: 115,
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

                        if (selectedTool == 0) ...[
                          _field(
                            fuelPriceController,
                            'Fuel Price per Litre',
                            Icons.price_change_rounded,
                          ),
                          const SizedBox(height: 14),
                          _field(
                            litresController,
                            'Litres',
                            Icons.water_drop_rounded,
                          ),
                        ],

                        if (selectedTool == 1) ...[
                          _field(
                            fuelPriceController,
                            'Fuel Price per Litre',
                            Icons.price_change_rounded,
                          ),
                          const SizedBox(height: 14),
                          _field(
                            distanceController,
                            'Distance (KM)',
                            Icons.route_rounded,
                          ),
                          const SizedBox(height: 14),
                          _field(
                            mileageController,
                            'Vehicle Mileage (KM/L)',
                            Icons.speed_rounded,
                          ),
                        ],

                        if (selectedTool == 2) ...[
                          _field(
                            litresController,
                            'Fuel Used (Litres)',
                            Icons.water_drop_rounded,
                          ),
                          const SizedBox(height: 14),
                          _field(
                            distanceController,
                            'Distance Travelled (KM)',
                            Icons.route_rounded,
                          ),
                        ],

                        if (selectedTool == 3) ...[
                          _field(
                            costController,
                            'Total Fuel Cost',
                            Icons.payments_rounded,
                          ),
                          const SizedBox(height: 14),
                          _field(
                            distanceController,
                            'Distance Travelled (KM)',
                            Icons.route_rounded,
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
                  'Fuel tracking',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  'For example, if your vehicle gives 12 km/litre, enter 12 as the mileage. This calculator can later be connected to the full Fuel & Vehicles section.',
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

  Widget _field(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
    );
  }
}
