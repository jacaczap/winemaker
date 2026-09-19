import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:winemaker/app/notification_navigation.dart';
import 'package:winemaker/app/router.dart';
import 'package:winemaker/app/theme.dart';
import 'package:winemaker/core/notifications/notification_service.dart';
import 'package:winemaker/l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  final container = ProviderContainer();
  final launchTarget = await _setUpNotifications(container);
  runApp(
    UncontrolledProviderScope(container: container, child: const MyApp()),
  );
  if (launchTarget != null) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => openTaskFromNotification(container, launchTarget),
    );
  }
}

/// Wires up reminders and reports the one that launched the app, if any.
///
/// Reminders are a convenience, not a prerequisite: if the plugin fails the
/// app still has to start, so the failure is logged and swallowed rather than
/// left to take down `main`.
Future<ReminderTarget?> _setUpNotifications(ProviderContainer container) async {
  final notifications = container.read(notificationServiceProvider);
  try {
    await notifications.init();
    notifications.onTaskTap =
        (target) => openTaskFromNotification(container, target);
    return await notifications.launchTask();
  } catch (error, stackTrace) {
    developer.log(
      'Notifications unavailable, continuing without reminders',
      name: 'winemaker.notifications',
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
    return null;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppTheme.appTitle,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: appRouter,
      builder: (context, child) => _A11yScope(child: child ?? const SizedBox.shrink()),
    );
  }
}

/// Cross-cutting a11y baseline.
///
/// Keeps system text scaling enabled (do not clamp upward) while
/// preventing text from shrinking below 100% which can hurt legibility.
class _A11yScope extends StatelessWidget {
  const _A11yScope({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final scaler = media.textScaler.clamp(minScaleFactor: 1.0);
    return MediaQuery(
      data: media.copyWith(textScaler: scaler),
      child: child,
    );
  }
}
