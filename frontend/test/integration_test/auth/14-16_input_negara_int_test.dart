import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Integration Test: Memilih negara/provinsi dari list', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: DropdownButton<String>(
          key: const Key('dropdown_negara'),
          value: 'ID',
          items: const [
            DropdownMenuItem(value: 'ID', child: Text('Indonesia')),
            DropdownMenuItem(value: 'SG', child: Text('Singapore')),
          ],
          onChanged: (_) {},
        ),
      ),
    ));
    await tester.pumpAndSettle();

    // Buka dropdown
    await tester.tap(find.byKey(const Key('dropdown_negara')));
    await tester.pumpAndSettle();

    // Pilih item
    await tester.tap(find.text('Singapore').last);
    await tester.pumpAndSettle();
  });
}