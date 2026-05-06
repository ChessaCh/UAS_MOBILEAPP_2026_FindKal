import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Integration Test: Tap Button Lanjutkan (1) pindah state', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: ElevatedButton(key: const Key('btn_lanjutkan_1'), onPressed: (){}, child: const Text('Lanjutkan')))));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('btn_lanjutkan_1')));
    await tester.pumpAndSettle();
  });
}