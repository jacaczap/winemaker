import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

part 'notification_service.g.dart';

const _channelId = 'wine_tasks';
const _channelName = 'Wine tasks';
const _channelDescription = 'Reminders for timed wine-making steps';
const _postponeActionId = 'postpone';

/// Schedules and cancels the local reminders backing `timeNotification` tasks.
///
/// Reminders are relative (`now + delay`) so the exact device time zone is
/// irrelevant; we schedule the absolute instant and let the OS fire it. Each
/// reminder carries a "Postpone N days" action handled by [_handlePostpone],
/// which reschedules the same notification even while the app is closed.
class NotificationService {
  NotificationService();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    tz.initializeTimeZones();
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onDidReceiveNotificationResponse: _handlePostpone,
      onDidReceiveBackgroundNotificationResponse:
          _onBackgroundNotificationResponse,
    );
    await _androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDescription,
        importance: Importance.high,
      ),
    );
    _initialized = true;
  }

  /// Schedules the reminder for a single task occurrence, replacing any
  /// previously scheduled one for the same `(realizationId, taskIndex)`.
  Future<void> scheduleTaskReminder({
    required int realizationId,
    required int taskIndex,
    required String title,
    required String body,
    required DateTime scheduledFor,
    required int postponeDays,
  }) async {
    await init();
    await _androidPlugin?.requestNotificationsPermission();
    await _schedule(
      id: _notificationId(realizationId, taskIndex),
      title: title,
      body: body,
      scheduledFor: scheduledFor,
      postponeDays: postponeDays,
    );
  }

  Future<void> cancel(int realizationId, int taskIndex) =>
      _plugin.cancel(id: _notificationId(realizationId, taskIndex));

  Future<void> _schedule({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledFor,
    required int postponeDays,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    final when = tz.TZDateTime.from(scheduledFor, tz.local);
    final safeWhen = when.isAfter(now) ? when : now.add(const Duration(seconds: 1));
    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: safeWhen,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.high,
          priority: Priority.high,
          actions: [
            AndroidNotificationAction(
              _postponeActionId,
              'Postpone $postponeDays days',
            ),
          ],
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: jsonEncode({
        'id': id,
        'title': title,
        'body': body,
        'postponeDays': postponeDays,
      }),
    );
  }

  AndroidFlutterLocalNotificationsPlugin? get _androidPlugin =>
      _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
}

int _notificationId(int realizationId, int taskIndex) =>
    (realizationId * 1000 + taskIndex) & 0x7fffffff;

@pragma('vm:entry-point')
void _onBackgroundNotificationResponse(NotificationResponse response) {
  _handlePostpone(response);
}

/// Reschedules a reminder when its "Postpone" action is tapped.
///
/// Runs in a background isolate when the app is closed, so it re-initializes
/// the plugin before rescheduling. Only the OS notification is moved; the app
/// reconciles the stored time the next time the task screen is opened.
Future<void> _handlePostpone(NotificationResponse response) async {
  if (response.actionId != _postponeActionId) return;
  final raw = response.payload;
  if (raw == null || raw.isEmpty) return;
  final data = jsonDecode(raw) as Map<String, dynamic>;
  final postponeDays = data['postponeDays'] as int;
  final service = NotificationService();
  await service.init();
  await service._schedule(
    id: data['id'] as int,
    title: data['title'] as String,
    body: data['body'] as String,
    scheduledFor: DateTime.now().add(Duration(days: postponeDays)),
    postponeDays: postponeDays,
  );
}

@Riverpod(keepAlive: true)
NotificationService notificationService(Ref ref) => NotificationService();
