import 'package:flutter/material.dart';

class AppCategory {
  final String name;
  final IconData icon;

  const AppCategory({required this.name, required this.icon});
}

class AppCategories {
  static const List<AppCategory> expense = [
    AppCategory(name: 'Food & Dining', icon: Icons.restaurant_rounded),
    AppCategory(name: 'Groceries', icon: Icons.shopping_cart_rounded),
    AppCategory(name: 'Fuel', icon: Icons.local_gas_station_rounded),
    AppCategory(name: 'Transport', icon: Icons.directions_car_rounded),
    AppCategory(name: 'Housing', icon: Icons.home_rounded),
    AppCategory(name: 'Bills & Utilities', icon: Icons.receipt_long_rounded),
    AppCategory(name: 'Shopping', icon: Icons.shopping_bag_rounded),
    AppCategory(name: 'Health', icon: Icons.medical_services_rounded),
    AppCategory(name: 'Education', icon: Icons.school_rounded),
    AppCategory(name: 'Entertainment', icon: Icons.movie_rounded),
    AppCategory(name: 'Travel', icon: Icons.flight_takeoff_rounded),
    AppCategory(name: 'Family', icon: Icons.family_restroom_rounded),
    AppCategory(name: 'Business', icon: Icons.business_center_rounded),
    AppCategory(name: 'Other', icon: Icons.more_horiz_rounded),
  ];

  static const List<AppCategory> income = [
    AppCategory(name: 'Salary', icon: Icons.work_rounded),
    AppCategory(name: 'Business', icon: Icons.business_center_rounded),
    AppCategory(name: 'Freelance', icon: Icons.laptop_mac_rounded),
    AppCategory(name: 'Investment', icon: Icons.trending_up_rounded),
    AppCategory(name: 'Rental', icon: Icons.home_work_rounded),
    AppCategory(name: 'Gift', icon: Icons.card_giftcard_rounded),
    AppCategory(name: 'Other', icon: Icons.more_horiz_rounded),
  ];
}
