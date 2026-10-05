import 'package:flutter/material.dart';

import '../models/app_currencies.dart';

class FuelVehiclesScreen extends StatefulWidget {
  const FuelVehiclesScreen({super.key});

  @override
  State<FuelVehiclesScreen> createState() => _FuelVehiclesScreenState();
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
    this.odometer = 0,
  });
}

class _FuelRecord {
  final String id;
  final String vehicleId;
  DateTime date;
  double litres;
  double pricePerLitre;
  double odometer;
  String station;
  String note;
  bool fullTank;

  _FuelRecord({
    required this.id,
    required this.vehicleId,
    required this.date,
    required this.litres,
    required this.pricePerLitre,
    required this.odometer,
    this.station = '',
    this.note = '',
    this.fullTank = false,
  });

  double get totalCost => litres * pricePerLitre;
}

class _FuelVehiclesScreenState extends State<FuelVehiclesScreen> {
  final List<_Vehicle> _vehicles = [
    _Vehicle(
      id: 'v1',
      name: 'My Car',
      model: 'Toyota Corolla',
      registration: 'ABC-123',
      fuelType: 'Petrol',
      odometer: 25000,
    ),
  ];

  final List<_FuelRecord> _records = [];

  AppCurrency get _currency => AppCurrencies.defaultCurrency;

  double get _totalCost {
    return _records.fold(0, (sum, record) => sum + record.totalCost);
  }

  double get _totalLitres {
    return _records.fold(0, (sum, record) => sum + record.litres);
  }

  double get _averagePrice {
    if (_totalLitres == 0) return 0;
    return _totalCost / _totalLitres;
  }

  double get _totalDistance {
    if (_records.length < 2) return 0;

    final sorted = [..._records]
      ..sort((a, b) => a.odometer.compareTo(b.odometer));

    if (sorted.last.odometer <= sorted.first.odometer) {
      return 0;
    }

    return sorted.last.odometer - sorted.first.odometer;
  }

  double get _mileage {
    if (_totalLitres == 0 || _totalDistance <= 0) {
      return 0;
    }

    return _totalDistance / _totalLitres;
  }

  double get _costPerKm {
    if (_totalDistance <= 0) return 0;
    return _totalCost / _totalDistance;
  }

  String _money(double value) {
    return '${_currency.symbol} ${value.toStringAsFixed(2)}';
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  _Vehicle? _vehicleFor(String id) {
    for (final vehicle in _vehicles) {
      if (vehicle.id == id) {
        return vehicle;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= 900;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fuel & Vehicles',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _vehicles.isEmpty
            ? _showAddVehicleDialog
            : _showAddFuelDialog,
        icon: Icon(
          _vehicles.isEmpty
              ? Icons.directions_car_rounded
              : Icons.local_gas_station_rounded,
        ),
        label: Text(_vehicles.isEmpty ? 'Add Vehicle' : 'Add Fuel'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            isWide ? 32 : 16,
            16,
            isWide ? 32 : 16,
            100,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 20),
                  _buildOverviewGrid(context, isWide),
                  const SizedBox(height: 24),
                  _buildQuickActions(context, isWide),
                  const SizedBox(height: 28),
                  _buildVehiclesSection(context),
                  const SizedBox(height: 28),
                  _buildFuelHistorySection(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
              Icons.local_gas_station_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Fuel Manager',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Track vehicles, fuel costs and mileage',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.88),
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

  Widget _buildOverviewGrid(BuildContext context, bool isWide) {
    final cards = [
      _OverviewData(
        title: 'Fuel Cost',
        value: _money(_totalCost),
        icon: Icons.payments_rounded,
      ),
      _OverviewData(
        title: 'Litres',
        value: _totalLitres.toStringAsFixed(2),
        icon: Icons.water_drop_rounded,
      ),
      _OverviewData(
        title: 'Avg. Price',
        value: _money(_averagePrice),
        icon: Icons.price_change_rounded,
      ),
      _OverviewData(
        title: 'Mileage',
        value: _mileage > 0 ? '${_mileage.toStringAsFixed(2)} km/L' : '--',
        icon: Icons.speed_rounded,
      ),
      _OverviewData(
        title: 'Distance',
        value: _totalDistance > 0
            ? '${_totalDistance.toStringAsFixed(0)} km'
            : '--',
        icon: Icons.route_rounded,
      ),
      _OverviewData(
        title: 'Cost / KM',
        value: _costPerKm > 0 ? _money(_costPerKm) : '--',
        icon: Icons.monetization_on_rounded,
      ),
    ];

    if (isWide) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: cards.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 2.25,
        ),
        itemBuilder: (context, index) {
          return _buildOverviewCard(context, cards[index]);
        },
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cards.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.65,
      ),
      itemBuilder: (context, index) {
        return _buildOverviewCard(context, cards[index]);
      },
    );
  }

  Widget _buildOverviewCard(BuildContext context, _OverviewData data) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(data.icon, color: theme.colorScheme.primary, size: 24),
          const Spacer(),
          Text(
            data.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.62),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            data.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, bool isWide) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            context,
            icon: Icons.local_gas_station_rounded,
            title: 'Add Fuel Record',
            subtitle: 'Record a refill',
            onTap: _vehicles.isEmpty
                ? _showAddVehicleDialog
                : _showAddFuelDialog,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            context,
            icon: Icons.directions_car_filled_rounded,
            title: 'Add Vehicle',
            subtitle: 'Manage your vehicles',
            onTap: _showAddVehicleDialog,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: theme.dividerColor.withValues(alpha: 0.12),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: theme.colorScheme.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.58,
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

  Widget _buildVehiclesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'My Vehicles',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
            ),
            TextButton.icon(
              onPressed: _showAddVehicleDialog,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (_vehicles.isEmpty)
          _buildEmptyState(
            context,
            icon: Icons.directions_car_rounded,
            title: 'No vehicles yet',
            subtitle: 'Add your first vehicle to start tracking fuel.',
            buttonText: 'Add Vehicle',
            onPressed: _showAddVehicleDialog,
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _vehicles.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              return _buildVehicleCard(context, _vehicles[index]);
            },
          ),
      ],
    );
  }

  Widget _buildVehicleCard(BuildContext context, _Vehicle vehicle) {
    final theme = Theme.of(context);

    final vehicleRecords = _records
        .where((record) => record.vehicleId == vehicle.id)
        .toList();

    final vehicleCost = vehicleRecords.fold<double>(
      0,
      (sum, record) => sum + record.totalCost,
    );

    final vehicleLitres = vehicleRecords.fold<double>(
      0,
      (sum, record) => sum + record.litres,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.12)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.directions_car_filled_rounded,
                  color: theme.colorScheme.primary,
                  size: 28,
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
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${vehicle.model} • ${vehicle.fuelType}',
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.62,
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      vehicle.registration.isEmpty
                          ? 'No registration'
                          : vehicle.registration,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.52,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    _showEditVehicleDialog(vehicle);
                  } else if (value == 'delete') {
                    _confirmDeleteVehicle(vehicle);
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_rounded),
                        SizedBox(width: 10),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline_rounded),
                        SizedBox(width: 10),
                        Text('Delete'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: theme.dividerColor.withValues(alpha: 0.10)),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _vehicleStat(context, 'Fuel Cost', _money(vehicleCost)),
              ),
              Expanded(
                child: _vehicleStat(
                  context,
                  'Litres',
                  vehicleLitres.toStringAsFixed(2),
                ),
              ),
              Expanded(
                child: _vehicleStat(
                  context,
                  'Odometer',
                  '${vehicle.odometer.toStringAsFixed(0)} km',
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showAddFuelDialog(selectedVehicle: vehicle),
              icon: const Icon(Icons.local_gas_station_rounded),
              label: const Text('Add Fuel for This Vehicle'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _vehicleStat(BuildContext context, String title, String value) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  Widget _buildFuelHistorySection(BuildContext context) {
    final sortedRecords = [..._records]
      ..sort((a, b) => b.date.compareTo(a.date));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fuel History',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        if (sortedRecords.isEmpty)
          _buildEmptyState(
            context,
            icon: Icons.receipt_long_rounded,
            title: 'No fuel records',
            subtitle: 'Your fuel purchases will appear here.',
            buttonText: 'Add Fuel Record',
            onPressed: _vehicles.isEmpty
                ? _showAddVehicleDialog
                : _showAddFuelDialog,
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sortedRecords.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final record = sortedRecords[index];
              return _buildFuelRecordCard(context, record);
            },
          ),
      ],
    );
  }

  Widget _buildFuelRecordCard(BuildContext context, _FuelRecord record) {
    final theme = Theme.of(context);
    final vehicle = _vehicleFor(record.vehicleId);

    return Dismissible(
      key: ValueKey(record.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.red),
      ),
      confirmDismiss: (_) => _confirmDeleteFuelRecord(record),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: theme.dividerColor.withValues(alpha: 0.12)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.local_gas_station_rounded,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          vehicle?.name ?? 'Unknown Vehicle',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Text(
                        _money(record.totalCost),
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${record.litres.toStringAsFixed(2)} L × '
                    '${_money(record.pricePerLitre)}/L',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: 0.62,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 12,
                    runSpacing: 4,
                    children: [
                      Text(
                        _formatDate(record.date),
                        style: TextStyle(
                          fontSize: 11,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.52,
                          ),
                        ),
                      ),
                      Text(
                        '${record.odometer.toStringAsFixed(0)} km',
                        style: TextStyle(
                          fontSize: 11,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.52,
                          ),
                        ),
                      ),
                      if (record.fullTank)
                        Text(
                          'Full tank',
                          style: TextStyle(
                            fontSize: 11,
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                  if (record.station.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      record.station,
                      style: TextStyle(
                        fontSize: 11,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.52,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.12)),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 44,
            color: theme.colorScheme.primary.withValues(alpha: 0.75),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.58),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onPressed,
            icon: const Icon(Icons.add_rounded),
            label: Text(buttonText),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddVehicleDialog() async {
    final nameController = TextEditingController();
    final modelController = TextEditingController();
    final registrationController = TextEditingController();
    final odometerController = TextEditingController();

    String fuelType = 'Petrol';

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add Vehicle'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Vehicle Name',
                        hintText: 'e.g. My Car',
                        prefixIcon: Icon(Icons.label_outline_rounded),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: modelController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Make / Model',
                        hintText: 'e.g. Toyota Corolla',
                        prefixIcon: Icon(Icons.directions_car_rounded),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: registrationController,
                      textCapitalization: TextCapitalization.characters,
                      decoration: const InputDecoration(
                        labelText: 'Registration',
                        hintText: 'e.g. ABC-123',
                        prefixIcon: Icon(Icons.confirmation_number_rounded),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: odometerController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Current Odometer (km)',
                        prefixIcon: Icon(Icons.speed_rounded),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: fuelType,
                      decoration: const InputDecoration(
                        labelText: 'Fuel Type',
                        prefixIcon: Icon(Icons.local_gas_station_rounded),
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
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    if (nameController.text.trim().isEmpty) {
                      return;
                    }

                    setState(() {
                      _vehicles.add(
                        _Vehicle(
                          id: DateTime.now().microsecondsSinceEpoch.toString(),
                          name: nameController.text.trim(),
                          model: modelController.text.trim(),
                          registration: registrationController.text.trim(),
                          fuelType: fuelType,
                          odometer:
                              double.tryParse(odometerController.text) ?? 0,
                        ),
                      );
                    });

                    Navigator.pop(context, true);
                  },
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

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vehicle added successfully')),
      );
    }
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

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Edit Vehicle'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Vehicle Name',
                        prefixIcon: Icon(Icons.label_outline_rounded),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: modelController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Make / Model',
                        prefixIcon: Icon(Icons.directions_car_rounded),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: registrationController,
                      textCapitalization: TextCapitalization.characters,
                      decoration: const InputDecoration(
                        labelText: 'Registration',
                        prefixIcon: Icon(Icons.confirmation_number_rounded),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: odometerController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Current Odometer (km)',
                        prefixIcon: Icon(Icons.speed_rounded),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: fuelType,
                      decoration: const InputDecoration(
                        labelText: 'Fuel Type',
                        prefixIcon: Icon(Icons.local_gas_station_rounded),
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
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    if (nameController.text.trim().isEmpty) {
                      return;
                    }

                    setState(() {
                      vehicle.name = nameController.text.trim();
                      vehicle.model = modelController.text.trim();
                      vehicle.registration = registrationController.text.trim();
                      vehicle.fuelType = fuelType;
                      vehicle.odometer =
                          double.tryParse(odometerController.text) ??
                          vehicle.odometer;
                    });

                    Navigator.pop(context, true);
                  },
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

    if (result == true && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Vehicle updated')));
    }
  }

  Future<void> _showAddFuelDialog({_Vehicle? selectedVehicle}) async {
    if (_vehicles.isEmpty) {
      await _showAddVehicleDialog();
      return;
    }

    _Vehicle currentVehicle = selectedVehicle ?? _vehicles.first;

    final litresController = TextEditingController();
    final priceController = TextEditingController();
    final odometerController = TextEditingController(
      text: currentVehicle.odometer > 0
          ? currentVehicle.odometer.toStringAsFixed(0)
          : '',
    );
    final stationController = TextEditingController();
    final noteController = TextEditingController();

    DateTime selectedDate = DateTime.now();
    bool fullTank = false;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final litres = double.tryParse(litresController.text) ?? 0;
            final price = double.tryParse(priceController.text) ?? 0;
            final total = litres * price;

            return AlertDialog(
              title: const Text('Add Fuel Record'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<_Vehicle>(
                      initialValue: currentVehicle,
                      decoration: const InputDecoration(
                        labelText: 'Vehicle',
                        prefixIcon: Icon(Icons.directions_car_rounded),
                      ),
                      items: _vehicles.map((vehicle) {
                        return DropdownMenuItem(
                          value: vehicle,
                          child: Text(
                            vehicle.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            currentVehicle = value;
                            if (currentVehicle.odometer > 0) {
                              odometerController.text = currentVehicle.odometer
                                  .toStringAsFixed(0);
                            }
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: litresController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onChanged: (_) => setDialogState(() {}),
                      decoration: const InputDecoration(
                        labelText: 'Litres',
                        hintText: 'e.g. 35.5',
                        prefixIcon: Icon(Icons.water_drop_rounded),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: priceController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onChanged: (_) => setDialogState(() {}),
                      decoration: InputDecoration(
                        labelText: 'Fuel Price per Litre',
                        hintText: 'e.g. 280',
                        prefixIcon: const Icon(Icons.payments_rounded),
                        prefixText: '${_currency.symbol} ',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: odometerController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Odometer (km)',
                        prefixIcon: Icon(Icons.speed_rounded),
                      ),
                    ),
                    const SizedBox(height: 12),
                    InkWell(
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
                      borderRadius: BorderRadius.circular(12),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Date',
                          prefixIcon: Icon(Icons.calendar_month_rounded),
                        ),
                        child: Text(_formatDate(selectedDate)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: stationController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Fuel Station',
                        hintText: 'Optional',
                        prefixIcon: Icon(Icons.location_on_outlined),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: noteController,
                      maxLines: 2,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: 'Note',
                        hintText: 'Optional',
                        prefixIcon: Icon(Icons.notes_rounded),
                      ),
                    ),
                    const SizedBox(height: 6),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: fullTank,
                      onChanged: (value) {
                        setDialogState(() {
                          fullTank = value ?? false;
                        });
                      },
                      title: const Text(
                        'Full tank',
                        style: TextStyle(fontSize: 14),
                      ),
                      subtitle: const Text(
                        'Useful for accurate mileage tracking',
                        style: TextStyle(fontSize: 11),
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary
                            .withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calculate_rounded, size: 21),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              'Total Fuel Cost',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Text(
                            _money(total),
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Theme.of(context).colorScheme.primary,
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
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    if (litres <= 0 || price <= 0) {
                      return;
                    }

                    final odometer =
                        double.tryParse(odometerController.text) ?? 0;

                    setState(() {
                      _records.add(
                        _FuelRecord(
                          id: DateTime.now().microsecondsSinceEpoch.toString(),
                          vehicleId: currentVehicle.id,
                          date: selectedDate,
                          litres: litres,
                          pricePerLitre: price,
                          odometer: odometer,
                          station: stationController.text.trim(),
                          note: noteController.text.trim(),
                          fullTank: fullTank,
                        ),
                      );

                      if (odometer > currentVehicle.odometer) {
                        currentVehicle.odometer = odometer;
                      }
                    });

                    Navigator.pop(context, true);
                  },
                  child: const Text('Save Fuel'),
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

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fuel record added successfully')),
      );
    }
  }

  Future<void> _confirmDeleteVehicle(_Vehicle vehicle) async {
    final hasRecords = _records.any((record) => record.vehicleId == vehicle.id);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Vehicle?'),
          content: Text(
            hasRecords
                ? 'This vehicle has fuel records. Deleting it will also remove those fuel records.'
                : 'Are you sure you want to delete ${vehicle.name}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    setState(() {
      _vehicles.removeWhere((item) => item.id == vehicle.id);

      _records.removeWhere((record) => record.vehicleId == vehicle.id);
    });

    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Vehicle deleted')));
    }
  }

  Future<bool> _confirmDeleteFuelRecord(_FuelRecord record) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Fuel Record?'),
          content: const Text(
            'This fuel record will be permanently removed from this session.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      setState(() {
        _records.removeWhere((item) => item.id == record.id);
      });
      return true;
    }

    return false;
  }
}

class _OverviewData {
  final String title;
  final String value;
  final IconData icon;

  const _OverviewData({
    required this.title,
    required this.value,
    required this.icon,
  });
}
