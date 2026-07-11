import 'package:flutter/material.dart';

enum AppCategory {
  utilities(label: 'Utilities', icon: Icons.bolt_rounded),
  software(label: 'Software', icon: Icons.computer_rounded),
  healthcare(label: 'Healthcare', icon: Icons.health_and_safety_rounded),
  finance(label: 'Finance', icon: Icons.account_balance_rounded),
  education(label: 'Education', icon: Icons.school_rounded),
  entertainment(label: 'Entertainment', icon: Icons.movie_rounded),
  food(label: 'Food & Dining', icon: Icons.restaurant_rounded),
  travel(label: 'Travel', icon: Icons.flight_rounded),
  marketing(label: 'Marketing', icon: Icons.campaign_rounded),
  infrastructure(label: 'Infrastructure', icon: Icons.dns_rounded),
  rent(label: 'Rent & Lease', icon: Icons.home_rounded),
  insurance(label: 'Insurance', icon: Icons.shield_rounded),
  other(label: 'Other', icon: Icons.category_rounded);

  const AppCategory({required this.label, required this.icon});

  final String label;
  final IconData icon;

  String toJson() => name;

  static AppCategory fromJson(String? value) =>
      AppCategory.values.firstWhere((c) => c.name == value, orElse: () => AppCategory.other);

  static List<String> get allLabels => AppCategory.values.map((c) => c.label).toList();
}

enum InsuranceType {
  health(label: 'Health', icon: Icons.health_and_safety_rounded),
  auto(label: 'Auto', icon: Icons.directions_car_rounded),
  life(label: 'Life', icon: Icons.favorite_rounded),
  home(label: 'Home', icon: Icons.home_rounded),
  travel(label: 'Travel', icon: Icons.flight_rounded),
  business(label: 'Business', icon: Icons.business_rounded),
  other(label: 'Other', icon: Icons.shield_rounded);

  const InsuranceType({required this.label, required this.icon});

  final String label;
  final IconData icon;

  String toJson() => name;

  static InsuranceType fromJson(String? value) =>
      InsuranceType.values.firstWhere((t) => t.name == value, orElse: () => InsuranceType.other);
}
