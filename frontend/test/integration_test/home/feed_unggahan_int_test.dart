import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  testWidgets('Integration Test: Scroll feed unggahan', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ListView.builder(
          key: const Key('list_feed_unggahan'),
          itemCount: 20,
          itemBuilder: (_, i) => ListTile(title: Text('Unggahan $i')),
        )
      ),
    ));
    await tester.pumpAndSettle();
    
    // Simulasi scroll ke bawah
    await tester.drag(find.byKey(const Key('list_feed_unggahan')), const Offset(0, -500));
    await tester.pumpAndSettle();
    
    // Memastikan item yang di bawah sudah muncul setelah di-scroll
    expect(find.text('Unggahan 10'), findsOneWidget);
  });
}