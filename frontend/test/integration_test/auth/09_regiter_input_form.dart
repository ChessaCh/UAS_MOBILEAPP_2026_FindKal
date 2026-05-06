import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Integration Test: Interaksi Form Register', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: TextFormField(key: const Key('input_nama_lengkap')))));
    await tester.pumpAndSettle();

    final inputName = find.byKey(const Key('input_nama_lengkap'));
    await tester.tap(inputName);
    await tester.enterText(inputName, 'Irsyad Programmer');
    await tester.pumpAndSettle();

    expect(find.text('Irsyad Programmer'), findsOneWidget);
  });
}