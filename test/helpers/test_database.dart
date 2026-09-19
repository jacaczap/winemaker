import 'package:drift/native.dart';
import 'package:winemaker/core/database/database.dart';
import 'package:winemaker/core/notifications/notification_service.dart';

/// Creates a fresh in-memory [MyDatabase] for a single test.
MyDatabase createTestDatabase() =>
    MyDatabase.forTesting(NativeDatabase.memory());

/// A [NotificationService] that records calls instead of touching the OS.
///
/// The real service talks to `flutter_local_notifications`, which is
/// unavailable in unit tests, so tests are given this fake to verify which
/// reminders get scheduled and cancelled.
class FakeNotificationService extends NotificationService {
  final List<(int realizationId, String taskKey)> cancelled = [];
  final List<(int realizationId, String taskKey, DateTime scheduledFor)>
      scheduled = [];

  @override
  Future<void> init() async {}

  @override
  Future<void> cancel(int realizationId, String taskKey) async {
    cancelled.add((realizationId, taskKey));
  }

  @override
  Future<void> scheduleTaskReminder({
    required int realizationId,
    required String taskKey,
    required String title,
    required String body,
    required DateTime scheduledFor,
  }) async {
    scheduled.add((realizationId, taskKey, scheduledFor));
  }
}
