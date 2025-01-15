import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:percobaan_ukk_kasir/login.dart';

import 'package:percobaan_ukk_kasir/main.dart';

void main() {
  testWidgets('Login screen smoke test', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const LoginPage());

    // Verify that the login screen is displayed with specific elements.
    expect(find.text('Email or username'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);

    // Interact with the email and password fields.
    await tester.enterText(find.byType(TextField).first, 'aurel');
    await tester.enterText(find.byType(TextField).last, 'aurellia');

    // Tap the login button and trigger a frame.
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    // Verify navigation to the home page.
    expect(find.text('Selamat Datang di Halaman Kasir!'), findsOneWidget);
  });
}
