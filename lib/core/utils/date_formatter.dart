import 'package:intl/intl.dart';

abstract final class DateFormatter {
  static String toDisplay(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  static String toShort(DateTime date) {
    return DateFormat('dd MMM').format(date);
  }

  static String toIso(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String toMonthYear(DateTime date) {
    return DateFormat('MMM yyyy').format(date);
  }

  static String toDayMonth(DateTime date) {
    return DateFormat('d MMM').format(date);
  }

  static int daysUntil(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    return target.difference(today).inDays;
  }

  static bool isOverdue(DateTime date) {
    return daysUntil(date) < 0;
  }

  static bool isExpiringSoon(DateTime date, {int daysThreshold = 30}) {
    final days = daysUntil(date);
    return days >= 0 && days <= daysThreshold;
  }

  static String toRelativeLabel(DateTime date) {
    final days = daysUntil(date);
    if (days < 0) {
      return 'Overdue by ${days.abs()} days';
    } else if (days == 0) {
      return 'Due today';
    } else if (days == 1) {
      return 'Due tomorrow';
    } else if (days <= 30) {
      return 'Due in $days days';
    } else {
      return 'Due on ${toDisplay(date)}';
    }
  }

  static DateTime fromIso(String isoString) {
    return DateTime.parse(isoString);
  }
}
