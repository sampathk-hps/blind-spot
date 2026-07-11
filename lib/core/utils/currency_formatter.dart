import 'package:intl/intl.dart';

abstract final class CurrencyFormatter {
  static const List<String> supportedCurrencies = [
    'USD', 'EUR', 'GBP', 'INR', 'JPY', 'CAD', 'AUD', 'CHF', 'SGD', 'AED'
  ];

  static String _symbol(String code) {
    switch (code.toUpperCase()) {
      case 'USD': return '\$';
      case 'EUR': return '€';
      case 'GBP': return '£';
      case 'INR': return '₹';
      case 'JPY': return '¥';
      case 'CAD': return '\$';
      case 'AUD': return '\$';
      case 'CHF': return 'CHF';
      case 'SGD': return '\$';
      case 'AED': return 'د.إ';
      default: return '\$';
    }
  }

  static String format(double amount, String currencyCode) {
    final symbol = _symbol(currencyCode);
    final formatter = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  static String formatCompact(double amount, String currencyCode) {
    final symbol = _symbol(currencyCode);
    final formatter = NumberFormat.compactCurrency(
      symbol: symbol,
      decimalDigits: 1,
    );
    return formatter.format(amount);
  }

  static String formatNumeric(double amount) {
    final formatter = NumberFormat('#,##0.00');
    return formatter.format(amount);
  }
}
