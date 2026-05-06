import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'package:findkal/settingpage/change_email_page.dart';
import 'package:findkal/services/api_service.dart';
import 'package:findkal/services/auth_state.dart';


@GenerateMocks([ApiService])
void main() {
  group('ChangeEmailPage - Widget Test', () {
    setUp(() {
      // Set mock current user agar userId tidak null
      AuthState.currentUser = {'id': 1, 'name': 'Test User', 'email': 'old@mail.com'};
    });

    tearDown(() {
      AuthState.currentUser = null;
    });

    Widget buildWidget() {
      return const MaterialApp(
        home: ChangeEmailPage(),
      );
    }

    testWidgets('Menampilkan judul "Masukkan email baru"', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('Masukkan email baru'), findsOneWidget);
    });

    testWidgets('Menampilkan TextField untuk input email', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('Tombol Lanjutkan awalnya disabled ketika email kosong',
        (tester) async {
      await tester.pumpWidget(buildWidget());

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('Tombol Lanjutkan aktif setelah email diisi', (tester) async {
      await tester.pumpWidget(buildWidget());

      await tester.enterText(find.byType(TextField), 'test@email.com');
      await tester.pump();

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNotNull);
    });

    testWidgets('Menampilkan SnackBar error jika format email tidak valid',
        (tester) async {
      await tester.pumpWidget(buildWidget());

      await tester.enterText(find.byType(TextField), 'email-tidak-valid');
      await tester.pump();
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.text('Format email tidak valid.'), findsOneWidget);
    });

    testWidgets('Menampilkan icon back (arrow_back_ios_new_rounded)',
        (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
    });
  });
}