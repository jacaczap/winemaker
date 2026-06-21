import 'package:drift/native.dart';
import 'package:winemaker/core/database/database.dart';
import 'package:winemaker/core/notifications/notification_service.dart';

/// Creates a fresh in-memory [MyDatabase] for a single test.
MyDatabase createTestDatabase() => MyDatabase.forTesting(NativeDatabase.memory());

/// A [NotificationService] that records calls instead of touching the OS.
///
/// The real service talks to `flutter_local_notifications`, which is
/// unavailable in unit tests, so the controller is given this fake to verify
/// that pending reminders get cancelled on jump-back.
class FakeNotificationService extends NotificationService {
  final List<(int realizationId, int taskIndex)> cancelled = [];

  @override
  Future<void> init() async {}

  @override
  Future<void> cancel(int realizationId, int taskIndex) async {
    cancelled.add((realizationId, taskIndex));
  }
}
