import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Integration Test: Interaksi Ketik Password Baru', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: TextFormField(key: const Key('input_new_pass')))));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('input_new_pass')), 'superSecretNew!');
    await tester.pumpAndSettle();
    expect(find.text('superSecretNew!'), findsOneWidget);
  });
}