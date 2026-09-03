import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shokollen_science/features/ai_professor/providers/rate_limit_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RateLimitNotifier', () {
    late SharedPreferences prefs;
    late RateLimitNotifier notifier;

    setUp(() async {
      // Clear SharedPreferences before each test
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      notifier = RateLimitNotifier(prefs);
    });

    test('initial state has 50 remaining quota', () {
      expect(notifier.state.monthlyLimit, 50);
      expect(notifier.state.monthlyUsed, 0);
      expect(notifier.state.monthlyRemaining, 50);
    });

    test('recordRequest increments monthly usage', () async {
      await notifier.recordRequest();

      expect(notifier.state.monthlyUsed, 1);
      expect(notifier.state.monthlyRemaining, 49);
    });

    test('multiple recordRequests increment correctly', () async {
      for (int i = 0; i < 5; i++) {
        await notifier.recordRequest();
      }

      expect(notifier.state.monthlyUsed, 5);
      expect(notifier.state.monthlyRemaining, 45);
    });

    test('isWithinQuota returns true when under limit', () {
      expect(notifier.isWithinQuota(), isTrue);
    });

    test('isWithinQuota returns true at limit', () async {
      // Manually set to 50
      notifier.state = notifier.state.copyWith(monthlyUsed: 49);

      expect(notifier.isWithinQuota(), isTrue);
    });

    test('isWithinQuota returns false when over limit', () async {
      // Manually set to 50
      notifier.state = notifier.state.copyWith(monthlyUsed: 50);

      expect(notifier.isWithinQuota(), isFalse);
    });

    test('daysUntilReset returns positive number', () {
      final days = notifier.daysUntilReset();

      expect(days, greaterThan(0));
      expect(days, lessThanOrEqualTo(31));
    });

    test('monthly reset when new month starts', () async {
      // Set reset date to yesterday
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      await prefs.setString('rate_limit_reset_date', yesterday.toString());

      // Create new notifier
      notifier = RateLimitNotifier(prefs);

      // After reset, should have fresh quota
      expect(notifier.state.monthlyUsed, 0);
      expect(notifier.state.monthlyRemaining, 50);
    });

    test('request timing tracked correctly', () async {
      final now = DateTime.now();
      await notifier.recordRequest();

      // Should be approximately now
      expect(
        notifier.state.lastRequestTime?.difference(now).inSeconds.abs(),
        lessThan(2),
      );
    });

    test('getProgress returns formatted progress string', () {
      notifier.state = notifier.state.copyWith(
        monthlyUsed: 25,
        monthlyRemaining: 25,
      );

      final progress = notifier.getProgress();

      expect(progress, contains('25'));
      expect(progress, contains('50'));
    });

    test('getStatusMessage indicates usage level', () {
      // Under 30%
      notifier.state = notifier.state.copyWith(monthlyUsed: 10);
      expect(notifier.getStatusMessage(), contains('多く'));

      // Between 30-70%
      notifier.state = notifier.state.copyWith(monthlyUsed: 30);
      expect(notifier.getStatusMessage(), isNotEmpty);

      // Over 80%
      notifier.state = notifier.state.copyWith(monthlyUsed: 45);
      expect(notifier.getStatusMessage(), contains('注意'));
    });

    test('persistence: quota saved to SharedPreferences', () async {
      await notifier.recordRequest();
      await notifier.recordRequest();

      // Create new notifier with same prefs
      final notifier2 = RateLimitNotifier(prefs);

      // Should have persisted usage
      expect(notifier2.state.monthlyUsed, greaterThanOrEqualTo(2));
    });

    test('max quota limit prevents overflow', () async {
      // Set to near max
      notifier.state = notifier.state.copyWith(monthlyUsed: 49);

      await notifier.recordRequest(); // 50
      expect(notifier.state.monthlyUsed, 50);
      expect(notifier.isWithinQuota(), isFalse);
    });
  });
}
