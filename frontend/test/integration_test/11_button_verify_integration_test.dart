import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Integration Test: Tap Button verify memicu aksi', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: ElevatedButton(key: const Key('btn_verify'), onPressed: (){}, child: const Text('Verify')))));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('btn_verify')));
    await tester.pumpAndSettle();
  });
}