import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Widget Test: Tombol cari lokasi GPS ter-render dan bisa di-tap', (WidgetTester tester) async {
    bool isTapped = false;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: IconButton(
          key: const Key('btn_lokasi_gps'), 
          icon: const Icon(Icons.my_location), 
          onPressed: () => isTapped = true,
        )
      ),
    ));
    
    final gpsBtn = find.byKey(const Key('btn_lokasi_gps'));
    expect(gpsBtn, findsOneWidget);
    
    await tester.tap(gpsBtn);
    await tester.pump();
    
    expect(isTapped, true);
  });
}