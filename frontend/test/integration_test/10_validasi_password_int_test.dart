import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Integration Test: Peringatan validasi password saat E2E', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: TextFormField(
      key: const Key('input_pass_reg'),
      autovalidateMode: AutovalidateMode.always,
      validator: (val) => val == 'lemah' ? 'Sandi lemah' : null,
    ))));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('input_pass_reg')), 'lemah');
    await tester.pumpAndSettle();

    expect(find.text('Sandi lemah'), findsOneWidget);
  });
}