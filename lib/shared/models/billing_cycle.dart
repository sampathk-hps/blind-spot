enum BillingCycle {
  weekly(label: 'Weekly', shortLabel: 'wk', multiplierToMonthly: 4.33),
  monthly(label: 'Monthly', shortLabel: 'mo', multiplierToMonthly: 1.0),
  quarterly(label: 'Quarterly', shortLabel: 'qtr', multiplierToMonthly: 0.333),
  semiAnnual(label: 'Semi-Annual', shortLabel: '6mo', multiplierToMonthly: 0.1667),
  annual(label: 'Annual', shortLabel: 'yr', multiplierToMonthly: 0.0833);

  const BillingCycle({
    required this.label,
    required this.shortLabel,
    required this.multiplierToMonthly,
  });

  final String label;
  final String shortLabel;
  final double multiplierToMonthly;

  double toMonthlyAmount(double amount) => amount * multiplierToMonthly;
  
  String toJson() => name;
  
  static BillingCycle fromJson(String? value) =>
      value == null ? BillingCycle.monthly : BillingCycle.values.firstWhere(
        (c) => c.name == value, orElse: () => BillingCycle.monthly);

  DateTime nextDate(DateTime current) {
    switch (this) {
      case BillingCycle.weekly: return current.add(const Duration(days: 7));
      case BillingCycle.monthly: return DateTime(current.year, current.month + 1, current.day);
      case BillingCycle.quarterly: return DateTime(current.year, current.month + 3, current.day);
      case BillingCycle.semiAnnual: return DateTime(current.year, current.month + 6, current.day);
      case BillingCycle.annual: return DateTime(current.year + 1, current.month, current.day);
    }
  }
}
