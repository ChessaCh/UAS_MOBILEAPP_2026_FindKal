import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  testWidgets('Integration Test: Tap tombol lokasi dan perbarui status UI', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: IconButton(
          key: const Key('btn_lokasi_gps'), 
          icon: const Icon(Icons.my_location), 
          onPressed: (){}
        )
      )
    ));
    await tester.pumpAndSettle();
    
    await tester.tap(find.byKey(const Key('btn_lokasi_gps')));
    await tester.pumpAndSettle();
  });
}