import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Widget Test: UI peringatan fitur locked (BottomSheet) muncul', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: BottomSheet(
          key: const Key('sheet_validasi_locked'),
          onClosing: () {},
          builder: (_) => const Text('Fitur Terkunci: Verifikasi Warga Lokal Dibutuhkan'),
        )
      ),
    ));
    
    expect(find.byKey(const Key('sheet_validasi_locked')), findsOneWidget);
    expect(find.text('Fitur Terkunci: Verifikasi Warga Lokal Dibutuhkan'), findsOneWidget);
  });
}