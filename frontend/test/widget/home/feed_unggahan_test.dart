import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Widget Test: List feed unggahan ter-render di layar', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ListView(
          key: const Key('list_feed_unggahan'), 
          children: const [
            ListTile(title: Text('Unggahan 1')),
            ListTile(title: Text('Unggahan 2')),
          ]
        )
      ),
    ));
    
    expect(find.byKey(const Key('list_feed_unggahan')), findsOneWidget);
    expect(find.text('Unggahan 1'), findsOneWidget);
    expect(find.text('Unggahan 2'), findsOneWidget);
  });
}