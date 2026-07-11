import 'package:flutter_test/flutter_test.dart';
import 'package:blindspot/core/utils/date_formatter.dart';
import 'package:blindspot/core/utils/currency_formatter.dart';
import 'package:blindspot/shared/models/billing_cycle.dart';
import 'package:blindspot/shared/models/user_tier.dart';
import 'package:blindspot/shared/models/app_category.dart';

void main() {
  group('DateFormatter', () {
    test('toDisplay formats correctly', () {
      final date = DateTime(2025, 1, 15);
      expect(DateFormatter.toDisplay(date), '15 Jan 2025');
    });

    test('toIso formats correctly', () {
      final date = DateTime(2025, 1, 15);
      expect(DateFormatter.toIso(date), '2025-01-15');
    });

    test('daysUntil returns correct days', () {
      final future = DateTime.now().add(const Duration(days: 7));
      expect(DateFormatter.daysUntil(future), 7);
    });

    test('isOverdue returns true for past dates', () {
      final past = DateTime.now().subtract(const Duration(days: 1));
      expect(DateFormatter.isOverdue(past), isTrue);
    });

    test('isOverdue returns false for future dates', () {
      final future = DateTime.now().add(const Duration(days: 1));
      expect(DateFormatter.isOverdue(future), isFalse);
    });

    test('isExpiringSoon returns true within threshold', () {
      final soon = DateTime.now().add(const Duration(days: 15));
      expect(DateFormatter.isExpiringSoon(soon, daysThreshold: 30), isTrue);
    });

    test('isExpiringSoon returns false outside threshold', () {
      final distant = DateTime.now().add(const Duration(days: 60));
      expect(DateFormatter.isExpiringSoon(distant, daysThreshold: 30), isFalse);
    });

    test('toRelativeLabel returns Overdue for past dates', () {
      final past = DateTime.now().subtract(const Duration(days: 3));
      expect(DateFormatter.toRelativeLabel(past), contains('Overdue'));
    });

    test('toRelativeLabel returns Due today for today', () {
      expect(DateFormatter.toRelativeLabel(DateTime.now()), 'Due today');
    });

    test('fromIso parses ISO string correctly', () {
      final date = DateFormatter.fromIso('2025-01-15');
      expect(date.year, 2025);
      expect(date.month, 1);
      expect(date.day, 15);
    });
  });

  group('CurrencyFormatter', () {
    test('format USD correctly', () {
      expect(CurrencyFormatter.format(1234.5, 'USD'), contains('\$'));
      expect(CurrencyFormatter.format(1234.5, 'USD'), contains('1,234.50'));
    });

    test('format EUR correctly', () {
      expect(CurrencyFormatter.format(1000.0, 'EUR'), contains('€'));
    });

    test('format GBP correctly', () {
      expect(CurrencyFormatter.format(500.0, 'GBP'), contains('£'));
    });

    test('format INR correctly', () {
      expect(CurrencyFormatter.format(50000.0, 'INR'), contains('₹'));
    });

    test('formatCompact returns K notation', () {
      expect(CurrencyFormatter.formatCompact(5000.0, 'USD'), contains('5.0K'));
    });

    test('formatCompact returns M notation', () {
      expect(CurrencyFormatter.formatCompact(1500000.0, 'USD'), contains('1.5M'));
    });

    test('supportedCurrencies includes major currencies', () {
      expect(CurrencyFormatter.supportedCurrencies, contains('USD'));
      expect(CurrencyFormatter.supportedCurrencies, contains('EUR'));
      expect(CurrencyFormatter.supportedCurrencies, contains('INR'));
    });
  });

  group('BillingCycle', () {
    test('monthly toMonthlyAmount returns same amount', () {
      expect(BillingCycle.monthly.toMonthlyAmount(100.0), closeTo(100.0, 0.01));
    });

    test('annual toMonthlyAmount divides by 12', () {
      expect(
        BillingCycle.annual.toMonthlyAmount(1200.0),
        closeTo(99.96, 0.1), // 1200 * 0.0833
      );
    });

    test('weekly toMonthlyAmount multiplies by 4.33', () {
      expect(
        BillingCycle.weekly.toMonthlyAmount(10.0),
        closeTo(43.3, 0.1),
      );
    });

    test('nextDate for monthly adds one month', () {
      final base = DateTime(2025, 1, 15);
      final next = BillingCycle.monthly.nextDate(base);
      expect(next.month, 2);
      expect(next.day, 15);
    });

    test('nextDate for annual adds one year', () {
      final base = DateTime(2025, 6, 1);
      final next = BillingCycle.annual.nextDate(base);
      expect(next.year, 2026);
      expect(next.month, 6);
    });

    test('toJson returns enum name', () {
      expect(BillingCycle.monthly.toJson(), 'monthly');
      expect(BillingCycle.annual.toJson(), 'annual');
    });

    test('fromJson parses correctly', () {
      expect(BillingCycle.fromJson('monthly'), BillingCycle.monthly);
      expect(BillingCycle.fromJson('annual'), BillingCycle.annual);
      expect(BillingCycle.fromJson(null), BillingCycle.monthly); // default
    });
  });

  group('UserTier', () {
    test('isPremium correct', () {
      expect(UserTier.premium.isPremium, isTrue);
      expect(UserTier.free.isPremium, isFalse);
    });

    test('isFree correct', () {
      expect(UserTier.free.isFree, isTrue);
      expect(UserTier.premium.isFree, isFalse);
    });

    test('displayName correct', () {
      expect(UserTier.free.displayName, 'Free');
      expect(UserTier.premium.displayName, 'BlindSpot Pro');
    });

    test('toJson/fromJson round-trips', () {
      expect(UserTier.fromJson(UserTier.premium.toJson()), UserTier.premium);
      expect(UserTier.fromJson(UserTier.free.toJson()), UserTier.free);
    });

    test('fromJson defaults to free for unknown value', () {
      expect(UserTier.fromJson('unknown'), UserTier.free);
    });
  });

  group('AppCategory', () {
    test('fromJson returns correct category', () {
      expect(AppCategory.fromJson('software'), AppCategory.software);
      expect(AppCategory.fromJson('healthcare'), AppCategory.healthcare);
    });

    test('fromJson defaults to other for unknown', () {
      expect(AppCategory.fromJson('nonexistent'), AppCategory.other);
      expect(AppCategory.fromJson(null), AppCategory.other);
    });

    test('toJson returns enum name', () {
      expect(AppCategory.software.toJson(), 'software');
    });

    test('allLabels is not empty', () {
      expect(AppCategory.allLabels, isNotEmpty);
      expect(AppCategory.allLabels.length, AppCategory.values.length);
    });
  });

  group('InsuranceType', () {
    test('fromJson returns correct type', () {
      expect(InsuranceType.fromJson('health'), InsuranceType.health);
      expect(InsuranceType.fromJson('auto'), InsuranceType.auto);
    });

    test('fromJson defaults to other for unknown', () {
      expect(InsuranceType.fromJson('xyz'), InsuranceType.other);
    });
  });
}
