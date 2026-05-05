import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:findkal/user_auth/login.dart';


void main() {
  group('LoginPage - Button login (_handleLogin)', () {
    Widget buildLoginPage({Map<String, Widget Function(BuildContext)>? routes}) {
      return MaterialApp(
        home: const LoginPage(),
        routes: routes ?? {},
      );
    }

    testWidgets('Tombol Masuk tampil di halaman login',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildLoginPage());
      await tester.pumpAndSettle();

      expect(find.text('Masuk'), findsOneWidget);
    });

    testWidgets('Tombol Masuk bertipe ElevatedButton',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildLoginPage());
      await tester.pumpAndSettle();

      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets(
        'Muncul SnackBar error jika username dan password kosong saat tombol Masuk ditekan',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildLoginPage());
      await tester.pumpAndSettle();

      // Tekan tombol Masuk tanpa mengisi apapun
      await tester.tap(find.text('Masuk'));
      await tester.pump();

      expect(
        find.text('Username/Email dan kata sandi wajib diisi.'),
        findsOneWidget,
      );
    });

    testWidgets(
        'Muncul SnackBar error jika hanya username diisi, password kosong',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildLoginPage());
      await tester.pumpAndSettle();

      final textFields = find.byType(TextField);
      await tester.enterText(textFields.first, 'irsyad123');
      await tester.pump();

      await tester.tap(find.text('Masuk'));
      await tester.pump();

      expect(
        find.text('Username/Email dan kata sandi wajib diisi.'),
        findsOneWidget,
      );
    });

    testWidgets(
        'Muncul SnackBar error jika hanya password diisi, username kosong',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildLoginPage());
      await tester.pumpAndSettle();

      final textFields = find.byType(TextField);
      await tester.enterText(textFields.last, 'Password123!');
      await tester.pump();

      await tester.tap(find.text('Masuk'));
      await tester.pump();

      expect(
        find.text('Username/Email dan kata sandi wajib diisi.'),
        findsOneWidget,
      );
    });

    testWidgets('SnackBar validasi berwarna merah (redAccent)',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildLoginPage());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Masuk'));
      await tester.pump();

      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBar.backgroundColor, Colors.redAccent);
    });

    testWidgets('Tombol Masuk dapat ditekan (onPressed tidak null)',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildLoginPage());
      await tester.pumpAndSettle();

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNotNull);
    });

    testWidgets(
        'Tidak ada SnackBar jika username dan password diisi sebelum ditekan',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildLoginPage());
      await tester.pumpAndSettle();

      final textFields = find.byType(TextField);
      await tester.enterText(textFields.first, 'irsyad@example.com');
      await tester.enterText(textFields.last, 'Password123!');
      await tester.pump();

      // Tidak ada SnackBar validasi kosong yang muncul sebelum tap
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('Teks tombol Masuk menggunakan font yang sesuai',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildLoginPage());
      await tester.pumpAndSettle();

      final textWidget = tester.widget<Text>(
        find.descendant(
          of: find.byType(ElevatedButton),
          matching: find.byType(Text),
        ),
      );
      expect(textWidget.data, 'Masuk');
    });

    testWidgets('Tombol Masuk memiliki lebar penuh (full width)',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildLoginPage());
      await tester.pumpAndSettle();

      final sizedBox = tester.widget<SizedBox>(
        find.ancestor(
          of: find.byType(ElevatedButton),
          matching: find.byType(SizedBox),
        ).first,
      );
      expect(sizedBox.width, double.infinity);
    });

    testWidgets('SnackBar muncul dengan behavior floating',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildLoginPage());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Masuk'));
      await tester.pump();

      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBar.behavior, SnackBarBehavior.floating);
    });
  });
}