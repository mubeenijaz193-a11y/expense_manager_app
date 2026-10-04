import 'package:flutter/material.dart';

import '../models/app_currencies.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _SavingsGoal {
  String name;
  double target;
  double saved;
  DateTime? targetDate;

  _SavingsGoal({
    required this.name,
    required this.target,
    required this.saved,
    this.targetDate,
  });
}

class _GoalsScreenState extends State<GoalsScreen> {
  static const Color green = Color(0xFF0B9B67);

  final List<_SavingsGoal> goals = [
    _SavingsGoal(
      name: 'Emergency Fund',
      target: 200000,
      saved: 75000,
      targetDate: DateTime(2027, 3, 1),
    ),
    _SavingsGoal(
      name: 'New Laptop',
      target: 250000,
      saved: 85000,
      targetDate: DateTime(2027, 6, 1),
    ),
  ];

  AppCurrency get currency => AppCurrencies.defaultCurrency;

  String money(double value) {
    return '${currency.symbol} ${value.toStringAsFixed(0)}';
  }

  double get totalTarget {
    return goals.fold(0, (sum, goal) => sum + goal.target);
  }

  double get totalSaved {
    return goals.fold(0, (sum, goal) => sum + goal.saved);
  }

  double get totalRemaining {
    return totalTarget - totalSaved;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Savings Goals',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            tooltip: 'Add Goal',
            onPressed: showAddGoalDialog,
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: showAddGoalDialog,
        backgroundColor: green,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Goal'),
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
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildOverview(),
                    const SizedBox(height: 24),
                    if (goals.isEmpty)
                      buildEmptyState()
                    else
                      ...goals.asMap().entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: buildGoalCard(entry.value, entry.key),
                        );
                      }),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildOverview() {
    final progress = totalTarget == 0
        ? 0.0
        : (totalSaved / totalTarget).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0B9B67), Color(0xFF087A53)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: green.withValues(alpha: 0.22),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.savings_rounded, color: Colors.white),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Your Savings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            money(totalSaved),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'saved toward ${money(totalTarget)}',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.82)),
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.white.withValues(alpha: 0.18),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${(progress * 100).toStringAsFixed(0)}% completed',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '${goals.length} ${goals.length == 1 ? 'goal' : 'goals'}',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.flag_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    '${money(totalRemaining)} remaining to reach all goals.',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGoalCard(_SavingsGoal goal, int index) {
    final progress = goal.target <= 0
        ? 0.0
        : (goal.saved / goal.target).clamp(0.0, 1.0);

    final remaining = (goal.target - goal.saved).clamp(0.0, double.infinity);

    final completed = goal.saved >= goal.target;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 6),
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
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: green.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  completed ? Icons.check_circle_rounded : Icons.flag_rounded,
                  color: green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      completed
                          ? 'Goal completed'
                          : '${money(remaining)} remaining',
                      style: TextStyle(
                        fontSize: 12,
                        color: completed
                            ? green
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: completed
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'add') {
                    showAddSavingsDialog(goal);
                  } else if (value == 'edit') {
                    showEditGoalDialog(goal);
                  } else if (value == 'delete') {
                    deleteGoal(index);
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'add',
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.add_rounded),
                      title: Text('Add Savings'),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'edit',
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.edit_rounded),
                      title: Text('Edit Goal'),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.delete_outline_rounded),
                      title: Text('Delete Goal'),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                money(goal.saved),
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                money(goal.target),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
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
              backgroundColor: green.withValues(alpha: 0.10),
              valueColor: const AlwaysStoppedAnimation<Color>(green),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${(progress * 100).toStringAsFixed(0)}% complete',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (goal.targetDate != null)
                Text(
                  'Target: ${formatDate(goal.targetDate!)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: completed ? null : () => showAddSavingsDialog(goal),
              icon: const Icon(Icons.add_circle_outline_rounded),
              label: Text(completed ? 'Completed' : 'Add Savings'),
              style: OutlinedButton.styleFrom(
                foregroundColor: green,
                side: BorderSide(color: green.withValues(alpha: 0.35)),
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(35),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: green.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.savings_rounded, size: 34, color: green),
          ),
          const SizedBox(height: 18),
          const Text(
            'No savings goals yet',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            'Create a goal for an emergency fund, car, phone, travel, education or anything else you want to save for.',
            textAlign: TextAlign.center,
            style: TextStyle(
              height: 1.45,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 22),
          FilledButton.icon(
            onPressed: showAddGoalDialog,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Create First Goal'),
            style: FilledButton.styleFrom(
              backgroundColor: green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showAddGoalDialog() async {
    final nameController = TextEditingController();
    final targetController = TextEditingController();
    final savedController = TextEditingController();

    DateTime? targetDate;

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text(
                'Create Savings Goal',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Goal Name',
                        hintText: 'e.g. New Car',
                        prefixIcon: Icon(Icons.flag_rounded),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: targetController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Target Amount',
                        prefixIcon: const Icon(
                          Icons.account_balance_wallet_rounded,
                        ),
                        prefixText: '${currency.symbol} ',
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: savedController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Already Saved',
                        prefixIcon: const Icon(Icons.savings_rounded),
                        prefixText: '${currency.symbol} ',
                      ),
                    ),
                    const SizedBox(height: 14),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: green.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.calendar_month_rounded,
                          color: green,
                        ),
                      ),
                      title: Text(
                        targetDate == null
                            ? 'Target Date'
                            : formatDate(targetDate!),
                      ),
                      subtitle: const Text('Optional'),
                      trailing: TextButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                            initialDate: DateTime.now().add(
                              const Duration(days: 90),
                            ),
                          );

                          if (picked != null) {
                            setDialogState(() {
                              targetDate = picked;
                            });
                          }
                        },
                        child: const Text('Select'),
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
                    final name = nameController.text.trim();

                    final target =
                        double.tryParse(targetController.text.trim()) ?? 0;

                    final saved =
                        double.tryParse(savedController.text.trim()) ?? 0;

                    if (name.isEmpty || target <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Enter a goal name and valid target amount.',
                          ),
                        ),
                      );
                      return;
                    }

                    setState(() {
                      goals.add(
                        _SavingsGoal(
                          name: name,
                          target: target,
                          saved: saved.clamp(0, target),
                          targetDate: targetDate,
                        ),
                      );
                    });

                    Navigator.pop(dialogContext);
                  },
                  style: FilledButton.styleFrom(backgroundColor: green),
                  child: const Text('Create'),
                ),
              ],
            );
          },
        );
      },
    );

    nameController.dispose();
    targetController.dispose();
    savedController.dispose();
  }

  Future<void> showEditGoalDialog(_SavingsGoal goal) async {
    final nameController = TextEditingController(text: goal.name);

    final targetController = TextEditingController(
      text: goal.target.toStringAsFixed(0),
    );

    DateTime? targetDate = goal.targetDate;

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text(
                'Edit Goal',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Goal Name',
                      prefixIcon: Icon(Icons.flag_rounded),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: targetController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Target Amount',
                      prefixText: '${currency.symbol} ',
                      prefixIcon: const Icon(
                        Icons.account_balance_wallet_rounded,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.calendar_month_rounded,
                      color: green,
                    ),
                    title: Text(
                      targetDate == null
                          ? 'No target date'
                          : formatDate(targetDate!),
                    ),
                    trailing: TextButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                          initialDate:
                              targetDate ??
                              DateTime.now().add(const Duration(days: 90)),
                        );

                        if (picked != null) {
                          setDialogState(() {
                            targetDate = picked;
                          });
                        }
                      },
                      child: const Text('Change'),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    final target =
                        double.tryParse(targetController.text.trim()) ?? 0;

                    if (nameController.text.trim().isEmpty || target <= 0) {
                      return;
                    }

                    setState(() {
                      goal.name = nameController.text.trim();
                      goal.target = target;

                      if (goal.saved > target) {
                        goal.saved = target;
                      }

                      goal.targetDate = targetDate;
                    });

                    Navigator.pop(dialogContext);
                  },
                  style: FilledButton.styleFrom(backgroundColor: green),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    nameController.dispose();
    targetController.dispose();
  }

  Future<void> showAddSavingsDialog(_SavingsGoal goal) async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            'Add Savings',
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Amount',
              prefixText: '${currency.symbol} ',
              prefixIcon: const Icon(Icons.savings_rounded),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final value = double.tryParse(controller.text.trim()) ?? 0;

                if (value <= 0) {
                  return;
                }

                setState(() {
                  goal.saved = (goal.saved + value).clamp(0, goal.target);
                });

                Navigator.pop(dialogContext);
              },
              style: FilledButton.styleFrom(backgroundColor: green),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    controller.dispose();
  }

  Future<void> deleteGoal(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Delete Goal?',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          content: Text(
            'Delete "${goals[index].name}"? This cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      setState(() {
        goals.removeAt(index);
      });
    }
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}
