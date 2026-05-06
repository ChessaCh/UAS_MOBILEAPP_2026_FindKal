import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Integration Test: Interaksi Ketik OTP', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: TextFormField(key: const Key('input_otp')))));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('input_otp')), '4321');
    await tester.pumpAndSettle();
    expect(find.text('4321'), findsOneWidget);
  });
}