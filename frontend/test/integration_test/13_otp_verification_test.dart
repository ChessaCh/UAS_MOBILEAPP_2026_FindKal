import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Integration Test: Interaksi ketik di Dialog OTP', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: AlertDialog(content: TextFormField(key: const Key('input_otp_dialog')))),
    ));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('input_otp_dialog')), '123456');
    await tester.pumpAndSettle();

    expect(find.text('123456'), findsOneWidget);
  });
}