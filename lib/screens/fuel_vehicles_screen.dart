import 'package:flutter/material.dart';

import '../models/app_currencies.dart';
import 'fuel_calculator_screen.dart';

class FuelVehiclesScreen extends StatefulWidget {
  const FuelVehiclesScreen({super.key});

  @override
  State<FuelVehiclesScreen> createState() => _FuelVehiclesScreenState();
}

class _FuelVehiclesScreenState extends State<FuelVehiclesScreen> {
  static const green = Color(0xFF0B9B67);

  final List<_Vehicle> _vehicles = [];
  final List<_FuelRecord> _records = [];

  @override
  Widget build(BuildContext context) {
    final currency = AppCurrencies.defaultCurrency;

    final totalFuelCost = _records.fold<double>(
      0,
      (sum, record) => sum + record.totalCost,
    );

    final totalLitres = _records.fold<double>(
      0,
      (sum, record) => sum + record.litres,
    );

    final averagePrice = totalLitres > 0 ? totalFuelCost / totalLitres : 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F7),
      appBar: AppBar(
        title: const Text(
          'Fuel & Vehicles',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFF5F8F7),
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 900;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: wide ? 32 : 18,
              vertical: 20,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildIntro(),
                    const SizedBox(height: 22),

                    _buildCalculatorCard(),

                    const SizedBox(height: 24),

                    _buildOverview(
                      currency,
                      totalFuelCost,
                      totalLitres,
                      averagePrice,
                    ),

                    const SizedBox(height: 28),

                    _buildSectionHeader(
                      title: 'My Vehicles',
                      subtitle: 'Manage your vehicles and fuel records',
                      actionLabel: 'Add Vehicle',
                      onAction: _showAddVehicleDialog,
                    ),

                    const SizedBox(height: 14),

                    _vehicles.isEmpty
                        ? _buildEmptyVehicles()
                        : _buildVehicleList(),

                    const SizedBox(height: 30),

                    _buildSectionHeader(
                      title: 'Recent Fuel History',
                      subtitle: 'Your latest fuel records',
                    ),

                    const SizedBox(height: 14),

                    _records.isEmpty
                        ? _buildEmptyHistory()
                        : _buildHistory(currency),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _vehicles.isEmpty
            ? _showAddVehicleDialog
            : _showAddFuelDialog,
        backgroundColor: green,
        foregroundColor: Colors.white,
        icon: Icon(
          _vehicles.isEmpty
              ? Icons.add_rounded
              : Icons.local_gas_station_rounded,
        ),
        label: Text(
          _vehicles.isEmpty ? 'Add Vehicle' : 'Add Fuel',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildIntro() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fuel management made simple',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF202924),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Calculate fuel costs, track vehicles and monitor mileage.',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildCalculatorCard() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: const BorderSide(color: Color(0xFFE3EAE6)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: _openFuelCalculator,
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: green.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: const Icon(
                  Icons.calculate_rounded,
                  color: green,
                  size: 29,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fuel Calculator',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Fuel cost • Litres • Mileage • Cost / KM',
                      style: TextStyle(color: Color(0xFF718078), fontSize: 13),
                    ),
                  ],
                ),
              ),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: green.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: green,
                  size: 17,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverview(
    AppCurrency currency,
    double totalFuelCost,
    double totalLitres,
    double averagePrice,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 800 ? 4 : 2;

        return GridView.count(
          crossAxisCount: columns,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: columns == 4 ? 2.2 : 1.65,
          children: [
            _statCard(
              icon: Icons.payments_rounded,
              title: 'Fuel Cost',
              value: '${currency.symbol} ${totalFuelCost.toStringAsFixed(0)}',
            ),
            _statCard(
              icon: Icons.local_gas_station_rounded,
              title: 'Litres',
              value: totalLitres.toStringAsFixed(1),
            ),
            _statCard(
              icon: Icons.price_check_rounded,
              title: 'Avg. Price',
              value: '${currency.symbol} ${averagePrice.toStringAsFixed(2)}',
            ),
            _statCard(
              icon: Icons.directions_car_rounded,
              title: 'Vehicles',
              value: '${_vehicles.length}',
            ),
          ],
        );
      },
    );
  }

  Widget _statCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE3EAE6)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: green.withValues(alpha: 0.09),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: green, size: 21),
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
                    color: Color(0xFF718078),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: Color(0xFF718078), fontSize: 12),
              ),
            ],
          ),
        ),
        if (actionLabel != null && onAction != null)
          OutlinedButton.icon(
            onPressed: onAction,
            icon: const Icon(Icons.add_rounded, size: 18),
            label: Text(actionLabel),
            style: OutlinedButton.styleFrom(
              foregroundColor: green,
              side: BorderSide(color: green.withValues(alpha: 0.35)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyVehicles() {
    return _emptyCard(
      icon: Icons.directions_car_outlined,
      title: 'No vehicles added yet',
      subtitle:
          'Add your car, bike, van or other vehicle to start tracking fuel.',
      buttonText: 'Add Vehicle',
      onPressed: _showAddVehicleDialog,
    );
  }

  Widget _buildEmptyHistory() {
    return _emptyCard(
      icon: Icons.local_gas_station_outlined,
      title: 'No fuel records yet',
      subtitle: 'Add a fuel record after refueling to track your spending.',
      buttonText: 'Add Fuel Record',
      onPressed: _vehicles.isEmpty ? _showAddVehicleDialog : _showAddFuelDialog,
    );
  }

  Widget _emptyCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE3EAE6)),
      ),
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: green.withValues(alpha: 0.09),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: green, size: 28),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 7),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF718078), fontSize: 13),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: onPressed,
            icon: const Icon(Icons.add_rounded),
            label: Text(buttonText),
            style: FilledButton.styleFrom(
              backgroundColor: green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleList() {
    return Column(
      children: _vehicles.map((vehicle) {
        final vehicleRecords = _records
            .where((record) => record.vehicleId == vehicle.id)
            .toList();

        final fuelCost = vehicleRecords.fold<double>(
          0,
          (sum, record) => sum + record.totalCost,
        );

        final litres = vehicleRecords.fold<double>(
          0,
          (sum, record) => sum + record.litres,
        );

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE3EAE6)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(17),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: green.withValues(alpha: 0.09),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.directions_car_rounded,
                        color: green,
                        size: 27,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vehicle.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${vehicle.model} • ${vehicle.fuelType}',
                            style: const TextStyle(
                              color: Color(0xFF718078),
                              fontSize: 12,
                            ),
                          ),
                          if (vehicle.registration.isNotEmpty) ...[
                            const SizedBox(height: 3),
                            Text(
                              vehicle.registration,
                              style: const TextStyle(
                                color: Color(0xFF718078),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          _showEditVehicleDialog(vehicle);
                        } else if (value == 'delete') {
                          _deleteVehicle(vehicle);
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: 'edit',
                          child: Text('Edit Vehicle'),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete Vehicle'),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                Container(
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7FAF8),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _vehicleMiniStat(
                          'Odometer',
                          '${vehicle.odometer.toStringAsFixed(0)} km',
                        ),
                      ),
                      Expanded(
                        child: _vehicleMiniStat(
                          'Fuel',
                          '${litres.toStringAsFixed(1)} L',
                        ),
                      ),
                      Expanded(
                        child: _vehicleMiniStat(
                          'Spent',
                          fuelCost.toStringAsFixed(0),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showAddFuelDialog(vehicle: vehicle);
                    },
                    icon: const Icon(Icons.local_gas_station_rounded, size: 19),
                    label: const Text('Add Fuel Record'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: green,
                      side: BorderSide(color: green.withValues(alpha: 0.35)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _vehicleMiniStat(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(color: Color(0xFF718078), fontSize: 11),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildHistory(AppCurrency currency) {
    final records = [..._records]..sort((a, b) => b.date.compareTo(a.date));

    return Column(
      children: records.take(10).map((record) {
        final vehicle = _vehicles.cast<_Vehicle?>().firstWhere(
          (item) => item?.id == record.vehicleId,
          orElse: () => null,
        );

        return Dismissible(
          key: ValueKey(record.id),
          direction: DismissDirection.endToStart,
          background: Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(17),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: Icon(
              Icons.delete_outline_rounded,
              color: Colors.red.shade600,
            ),
          ),
          onDismissed: (_) {
            setState(() {
              _records.removeWhere((item) => item.id == record.id);
            });
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(17),
              border: Border.all(color: const Color(0xFFE3EAE6)),
            ),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: green.withValues(alpha: 0.09),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.local_gas_station_rounded,
                    color: green,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vehicle?.name ?? 'Vehicle',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${record.litres.toStringAsFixed(1)} L • '
                        '${record.pricePerLitre.toStringAsFixed(2)}/L',
                        style: const TextStyle(
                          color: Color(0xFF718078),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _formatDate(record.date),
                        style: const TextStyle(
                          color: Color(0xFF8A948F),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${currency.symbol} '
                      '${record.totalCost.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: green,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${record.odometer.toStringAsFixed(0)} km',
                      style: const TextStyle(
                        color: Color(0xFF8A948F),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Future<void> _openFuelCalculator() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FuelCalculatorScreen()),
    );
  }

  Future<void> _showAddVehicleDialog() async {
    final nameController = TextEditingController();
    final modelController = TextEditingController();
    final registrationController = TextEditingController();
    final odometerController = TextEditingController();

    String fuelType = 'Petrol';

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text(
                'Add Vehicle',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _dialogField(
                      controller: nameController,
                      label: 'Vehicle Name',
                      hint: 'e.g. Family Car',
                      icon: Icons.directions_car_outlined,
                    ),
                    const SizedBox(height: 13),
                    _dialogField(
                      controller: modelController,
                      label: 'Make / Model',
                      hint: 'e.g. Toyota Corolla 2020',
                      icon: Icons.car_repair_rounded,
                    ),
                    const SizedBox(height: 13),
                    _dialogField(
                      controller: registrationController,
                      label: 'Registration',
                      hint: 'Optional',
                      icon: Icons.badge_outlined,
                    ),
                    const SizedBox(height: 13),
                    _dialogField(
                      controller: odometerController,
                      label: 'Current Odometer (km)',
                      hint: 'e.g. 45000',
                      icon: Icons.speed_rounded,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 13),
                    DropdownButtonFormField<String>(
                      initialValue: fuelType,
                      decoration: _dialogDecoration(
                        'Fuel Type',
                        Icons.local_gas_station_outlined,
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Petrol',
                          child: Text('Petrol'),
                        ),
                        DropdownMenuItem(
                          value: 'Diesel',
                          child: Text('Diesel'),
                        ),
                        DropdownMenuItem(
                          value: 'Hybrid',
                          child: Text('Hybrid'),
                        ),
                        DropdownMenuItem(
                          value: 'Electric',
                          child: Text('Electric'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            fuelType = value;
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
                  onPressed: () {
                    final name = nameController.text.trim();

                    if (name.isEmpty) {
                      return;
                    }

                    final vehicle = _Vehicle(
                      id: DateTime.now().microsecondsSinceEpoch.toString(),
                      name: name,
                      model: modelController.text.trim(),
                      registration: registrationController.text.trim(),
                      fuelType: fuelType,
                      odometer:
                          double.tryParse(odometerController.text.trim()) ?? 0,
                    );

                    setState(() {
                      _vehicles.add(vehicle);
                    });

                    Navigator.pop(dialogContext);
                  },
                  style: FilledButton.styleFrom(backgroundColor: green),
                  child: const Text('Add Vehicle'),
                ),
              ],
            );
          },
        );
      },
    );

    nameController.dispose();
    modelController.dispose();
    registrationController.dispose();
    odometerController.dispose();
  }

  Future<void> _showEditVehicleDialog(_Vehicle vehicle) async {
    final nameController = TextEditingController(text: vehicle.name);
    final modelController = TextEditingController(text: vehicle.model);
    final registrationController = TextEditingController(
      text: vehicle.registration,
    );
    final odometerController = TextEditingController(
      text: vehicle.odometer.toStringAsFixed(0),
    );

    String fuelType = vehicle.fuelType;

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text(
                'Edit Vehicle',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _dialogField(
                      controller: nameController,
                      label: 'Vehicle Name',
                      icon: Icons.directions_car_outlined,
                    ),
                    const SizedBox(height: 13),
                    _dialogField(
                      controller: modelController,
                      label: 'Make / Model',
                      icon: Icons.car_repair_rounded,
                    ),
                    const SizedBox(height: 13),
                    _dialogField(
                      controller: registrationController,
                      label: 'Registration',
                      icon: Icons.badge_outlined,
                    ),
                    const SizedBox(height: 13),
                    _dialogField(
                      controller: odometerController,
                      label: 'Current Odometer (km)',
                      icon: Icons.speed_rounded,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 13),
                    DropdownButtonFormField<String>(
                      initialValue: fuelType,
                      decoration: _dialogDecoration(
                        'Fuel Type',
                        Icons.local_gas_station_outlined,
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Petrol',
                          child: Text('Petrol'),
                        ),
                        DropdownMenuItem(
                          value: 'Diesel',
                          child: Text('Diesel'),
                        ),
                        DropdownMenuItem(
                          value: 'Hybrid',
                          child: Text('Hybrid'),
                        ),
                        DropdownMenuItem(
                          value: 'Electric',
                          child: Text('Electric'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            fuelType = value;
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
                  onPressed: () {
                    setState(() {
                      vehicle.name = nameController.text.trim();
                      vehicle.model = modelController.text.trim();
                      vehicle.registration = registrationController.text.trim();
                      vehicle.fuelType = fuelType;
                      vehicle.odometer =
                          double.tryParse(odometerController.text.trim()) ??
                          vehicle.odometer;
                    });

                    Navigator.pop(dialogContext);
                  },
                  style: FilledButton.styleFrom(backgroundColor: green),
                  child: const Text('Save Changes'),
                ),
              ],
            );
          },
        );
      },
    );

    nameController.dispose();
    modelController.dispose();
    registrationController.dispose();
    odometerController.dispose();
  }

  Future<void> _showAddFuelDialog({_Vehicle? vehicle}) async {
    if (_vehicles.isEmpty) {
      await _showAddVehicleDialog();
      return;
    }

    _Vehicle selectedVehicle = vehicle ?? _vehicles.first;

    final litresController = TextEditingController();
    final priceController = TextEditingController();
    final odometerController = TextEditingController(
      text: selectedVehicle.odometer.toStringAsFixed(0),
    );
    final stationController = TextEditingController();
    final noteController = TextEditingController();

    DateTime selectedDate = DateTime.now();
    bool fullTank = true;

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final litres = double.tryParse(litresController.text) ?? 0;
            final price = double.tryParse(priceController.text) ?? 0;
            final total = litres * price;

            return AlertDialog(
              title: const Text(
                'Add Fuel Record',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<_Vehicle>(
                      initialValue: selectedVehicle,
                      decoration: _dialogDecoration(
                        'Vehicle',
                        Icons.directions_car_outlined,
                      ),
                      items: _vehicles.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            selectedVehicle = value;
                            odometerController.text = value.odometer
                                .toStringAsFixed(0);
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 13),

                    Row(
                      children: [
                        Expanded(
                          child: _dialogField(
                            controller: litresController,
                            label: 'Litres',
                            icon: Icons.local_gas_station_outlined,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            onChanged: (_) {
                              setDialogState(() {});
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _dialogField(
                            controller: priceController,
                            label: 'Price / Litre',
                            icon: Icons.payments_outlined,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            onChanged: (_) {
                              setDialogState(() {});
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 13),

                    _dialogField(
                      controller: odometerController,
                      label: 'Odometer (km)',
                      icon: Icons.speed_rounded,
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 13),

                    _dialogField(
                      controller: stationController,
                      label: 'Fuel Station',
                      hint: 'Optional',
                      icon: Icons.store_outlined,
                    ),

                    const SizedBox(height: 13),

                    _dialogField(
                      controller: noteController,
                      label: 'Note',
                      hint: 'Optional',
                      icon: Icons.notes_rounded,
                      maxLines: 2,
                    ),

                    const SizedBox(height: 13),

                    InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );

                        if (picked != null) {
                          setDialogState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: _dialogDecoration(
                          'Date',
                          Icons.calendar_today_outlined,
                        ),
                        child: Text(_formatDate(selectedDate)),
                      ),
                    ),

                    const SizedBox(height: 5),

                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: fullTank,
                      activeColor: green,
                      title: const Text(
                        'Full tank',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onChanged: (value) {
                        setDialogState(() {
                          fullTank = value ?? true;
                        });
                      },
                    ),

                    if (total > 0)
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 5),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: green.withValues(alpha: 0.07),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Total Fuel Cost',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(
                              '${AppCurrencies.defaultCurrency.symbol} '
                              '${total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: green,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
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
                  onPressed: () {
                    final litres = double.tryParse(litresController.text) ?? 0;
                    final price = double.tryParse(priceController.text) ?? 0;
                    final odometer =
                        double.tryParse(odometerController.text) ??
                        selectedVehicle.odometer;

                    if (litres <= 0 || price <= 0) {
                      return;
                    }

                    final record = _FuelRecord(
                      id: DateTime.now().microsecondsSinceEpoch.toString(),
                      vehicleId: selectedVehicle.id,
                      date: selectedDate,
                      litres: litres,
                      pricePerLitre: price,
                      odometer: odometer,
                      station: stationController.text.trim(),
                      note: noteController.text.trim(),
                      fullTank: fullTank,
                    );

                    setState(() {
                      _records.add(record);

                      if (odometer > selectedVehicle.odometer) {
                        selectedVehicle.odometer = odometer;
                      }
                    });

                    Navigator.pop(dialogContext);
                  },
                  style: FilledButton.styleFrom(backgroundColor: green),
                  child: const Text('Save Fuel Record'),
                ),
              ],
            );
          },
        );
      },
    );

    litresController.dispose();
    priceController.dispose();
    odometerController.dispose();
    stationController.dispose();
    noteController.dispose();
  }

  void _deleteVehicle(_Vehicle vehicle) {
    final hasRecords = _records.any((record) => record.vehicleId == vehicle.id);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Delete Vehicle?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            hasRecords
                ? 'This vehicle has fuel records. Deleting it will also remove its fuel history.'
                : 'Are you sure you want to delete this vehicle?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                setState(() {
                  _vehicles.removeWhere((item) => item.id == vehicle.id);

                  _records.removeWhere(
                    (record) => record.vehicleId == vehicle.id,
                  );
                });

                Navigator.pop(dialogContext);
              },
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red.shade600,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Widget _dialogField({
    required TextEditingController controller,
    required String label,
    String? hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    ValueChanged<String>? onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      onChanged: onChanged,
      decoration: _dialogDecoration(label, icon, hint: hint),
    );
  }

  InputDecoration _dialogDecoration(
    String label,
    IconData icon, {
    String? hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: const Color(0xFFF8FAF9),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: Color(0xFFE0E8E4)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: Color(0xFFE0E8E4)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: green, width: 1.4),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}

class _Vehicle {
  final String id;
  String name;
  String model;
  String registration;
  String fuelType;
  double odometer;

  _Vehicle({
    required this.id,
    required this.name,
    required this.model,
    required this.registration,
    required this.fuelType,
    required this.odometer,
  });
}

class _FuelRecord {
  final String id;
  final String vehicleId;
  final DateTime date;
  final double litres;
  final double pricePerLitre;
  final double odometer;
  final String station;
  final String note;
  final bool fullTank;

  _FuelRecord({
    required this.id,
    required this.vehicleId,
    required this.date,
    required this.litres,
    required this.pricePerLitre,
    required this.odometer,
    required this.station,
    required this.note,
    required this.fullTank,
  });

  double get totalCost => litres * pricePerLitre;
}
