import 'package:blindspot/core/utils/date_formatter.dart';

extension DateTimeExt on DateTime {
  String toDisplayString() => DateFormatter.toDisplay(this);
  String toShortString() => DateFormatter.toShort(this);
  String toIsoString() => DateFormatter.toIso(this);
  String toRelativeLabel() => DateFormatter.toRelativeLabel(this);

  int get daysUntil => DateFormatter.daysUntil(this);
  bool get isOverdue => DateFormatter.isOverdue(this);
  bool isExpiringSoon({int days = 30}) => DateFormatter.isExpiringSoon(this, daysThreshold: days);

  DateTime get startOfDay => DateTime(year, month, day);
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }
}
