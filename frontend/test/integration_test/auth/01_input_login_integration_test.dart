import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Integration Test: Interaksi Input Login', (WidgetTester tester) async {
    // Render aplikasi (Ganti dengan app.main() milikmu jika di-run beneran)
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              TextFormField(key: const Key('input_email')),
              TextFormField(key: const Key('input_password')),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final inputEmail = find.byKey(const Key('input_email'));
    final inputPassword = find.byKey(const Key('input_password'));

    // User tap dan ketik di emulator
    await tester.tap(inputEmail);
    await tester.enterText(inputEmail, 'irsyad@findkal.com');
    
    await tester.tap(inputPassword);
    await tester.enterText(inputPassword, 'super_secret');
    await tester.pumpAndSettle();

    // Verifikasi final di layar emulator
    expect(find.text('irsyad@findkal.com'), findsOneWidget);
    expect(find.text('super_secret'), findsOneWidget);
  });
}