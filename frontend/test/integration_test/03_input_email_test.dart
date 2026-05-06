import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Integration Test: Interaksi Input Email Reset', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: TextFormField(key: const Key('input_reset_email')))));
    await tester.pumpAndSettle();

    final inputEmail = find.byKey(const Key('input_reset_email'));
    await tester.tap(inputEmail);
    await tester.enterText(inputEmail, 'irsyad@findkal.com');
    await tester.pumpAndSettle();

    expect(find.text('irsyad@findkal.com'), findsOneWidget);
  });
}