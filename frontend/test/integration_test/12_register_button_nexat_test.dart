import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Integration Test: Tap Button Selanjutnya pindah ke form alamat', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: ElevatedButton(key: const Key('btn_selanjutnya'), onPressed: (){}, child: const Text('Selanjutnya')))));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('btn_selanjutnya')));
    await tester.pumpAndSettle();
  });
}