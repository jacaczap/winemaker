import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winemaker/app/router.dart';
import 'package:winemaker/app/theme.dart';

Future<void> main() async => runApp(const ProviderScope(child: MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppTheme.appTitle,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
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
