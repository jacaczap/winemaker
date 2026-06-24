import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:winemaker/core/database/database.dart';
import 'package:winemaker/core/notifications/notification_service.dart';
import 'package:winemaker/main.dart';

import 'helpers/test_database.dart';

void main() {
  testWidgets('home shows the empty state when there are no realizations',
      (tester) async {
    final db = createTestDatabase();
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          notificationServiceProvider.overrideWithValue(FakeNotificationService()),
        ],
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.widgetWithText(AppBar, 'Winemaker'), findsOneWidget);
    expect(find.text('No realizations yet'), findsOneWidget);
    expect(find.text('New realization'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  });
}
