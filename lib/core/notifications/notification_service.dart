import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:winemaker/core/l10n/system_localizations.dart';

part 'notification_service.g.dart';

const _channelId = 'wine_tasks';

/// Identifies the task occurrence a reminder belongs to.
typedef ReminderTarget = ({int realizationId, int taskIndex});

/// Schedules and cancels the local reminders backing `timeNotification` tasks.
///
/// Reminders are relative (`now + delay`) so the exact device time zone is
/// irrelevant; we schedule the absolute instant and let the OS fire it. A
/// reminder has no actions: it is a plain prompt to open the app. Tapping it
/// routes to the matching task via [onTaskTap] (app running) or [launchTask]
/// (app started from the notification). The task is never completed
/// automatically; the user still acts on the step screen.
class NotificationService {
  NotificationService();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  /// Called when a reminder is tapped while the app is already running.
  void Function(ReminderTarget target)? onTaskTap;

  Future<void> init() async {
    if (_initialized) return;
    tz.initializeTimeZones();
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onDidReceiveNotificationResponse: _handleTap,
    );
    final l10n = systemAppLocalizations();
    await _androidPlugin?.createNotificationChannel(
      AndroidNotificationChannel(
        _channelId,
        l10n.notificationChannelName,
        description: l10n.notificationChannelDescription,
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
  }) async {
    await init();
    await _androidPlugin?.requestNotificationsPermission();
    final now = tz.TZDateTime.now(tz.local);
    final when = tz.TZDateTime.from(scheduledFor, tz.local);
    final safeWhen =
        when.isAfter(now) ? when : now.add(const Duration(seconds: 1));
    final l10n = systemAppLocalizations();
    await _plugin.zonedSchedule(
      id: _notificationId(realizationId, taskIndex),
      title: title,
      body: body,
      scheduledDate: safeWhen,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          l10n.notificationChannelName,
          channelDescription: l10n.notificationChannelDescription,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: jsonEncode({
        'realizationId': realizationId,
        'taskIndex': taskIndex,
      }),
    );
  }

  Future<void> cancel(int realizationId, int taskIndex) =>
      _plugin.cancel(id: _notificationId(realizationId, taskIndex));

  /// The task whose reminder launched the app from a terminated state, if any.
  Future<ReminderTarget?> launchTask() async {
    await init();
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details == null || !details.didNotificationLaunchApp) return null;
    return _decodeTarget(details.notificationResponse?.payload);
  }

  void _handleTap(NotificationResponse response) {
    final target = _decodeTarget(response.payload);
    if (target != null) onTaskTap?.call(target);
  }

  AndroidFlutterLocalNotificationsPlugin? get _androidPlugin =>
      _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
}

ReminderTarget? _decodeTarget(String? raw) {
  if (raw == null || raw.isEmpty) return null;
  final data = jsonDecode(raw) as Map<String, dynamic>;
  final realizationId = data['realizationId'] as int?;
  final taskIndex = data['taskIndex'] as int?;
  if (realizationId == null || taskIndex == null) return null;
  return (realizationId: realizationId, taskIndex: taskIndex);
}

int _notificationId(int realizationId, int taskIndex) =>
    (realizationId * 1000 + taskIndex) & 0x7fffffff;

@Riverpod(keepAlive: true)
NotificationService notificationService(Ref ref) => NotificationService();
