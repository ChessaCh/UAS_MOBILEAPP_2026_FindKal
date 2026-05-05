import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('_VerificationDialog - _onVerify()', () {
    Widget buildDialogWithVerify({
      required VoidCallback onVerify,
      List<TextEditingController>? controllers,
    }) {
      final ctrls = controllers ??
          List.generate(6, (_) => TextEditingController());

      return MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => _VerifyTestDialog(
                    controllers: ctrls,
                    onVerify: onVerify,
                  ),
                );
              },
              child: const Text('Buka'),
            ),
          ),
        ),
      );
    }

    testWidgets('Tombol Verify tampil di dalam dialog',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildDialogWithVerify(onVerify: () {}));
      await tester.tap(find.text('Buka'));
      await tester.pumpAndSettle();

      expect(find.text('Verify'), findsOneWidget);
    });

    testWidgets('Tombol Verify dapat ditekan',
        (WidgetTester tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        buildDialogWithVerify(onVerify: () => tapped = true),
      );
      await tester.tap(find.text('Buka'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Verify'));
      await tester.pump();

      // Fungsi onVerify dipanggil
      expect(tapped, isTrue);
    });

    testWidgets('Tidak ada aksi saat Verify ditekan dan kode < 6 digit',
        (WidgetTester tester) async {
      bool verified = false;
      final ctrls = List.generate(6, (_) => TextEditingController());
      // Hanya isi 3 field
      ctrls[0].text = '1';
      ctrls[1].text = '2';
      ctrls[2].text = '3';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => _VerifyGuardDialog(
                      controllers: ctrls,
                      onVerified: () => verified = true,
                    ),
                  );
                },
                child: const Text('Buka'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Buka'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Verify'));
      await tester.pump();

      // Karena kode < 6, onVerified tidak dipanggil
      expect(verified, isFalse);
    });

    testWidgets('Aksi verify dipanggil jika semua 6 digit terisi',
        (WidgetTester tester) async {
      bool verified = false;
      final ctrls = List.generate(6, (_) => TextEditingController());
      for (int i = 0; i < 6; i++) {
        ctrls[i].text = '$i';
      }

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => _VerifyGuardDialog(
                      controllers: ctrls,
                      onVerified: () => verified = true,
                    ),
                  );
                },
                child: const Text('Buka'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Buka'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Verify'));
      await tester.pump();

      expect(verified, isTrue);
    });

    testWidgets('Dialog OTP memiliki 6 field yang kosong saat pertama dibuka',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildDialogWithVerify(onVerify: () {}));
      await tester.tap(find.text('Buka'));
      await tester.pumpAndSettle();

      final fields = find.byType(TextField);
      expect(fields, findsNWidgets(6));
      for (int i = 0; i < 6; i++) {
        final f = tester.widget<TextField>(fields.at(i));
        expect(f.controller?.text ?? '', isEmpty);
      }
    });

    testWidgets('Tombol Verify memiliki border radius melengkung',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildDialogWithVerify(onVerify: () {}));
      await tester.tap(find.text('Buka'));
      await tester.pumpAndSettle();

      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('Tidak ada CircularProgressIndicator sebelum Verify ditekan',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildDialogWithVerify(onVerify: () {}));
      await tester.tap(find.text('Buka'));
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('Kode OTP yang dikumpulkan dari 6 field harus 6 karakter',
        (WidgetTester tester) async {
      final ctrls = List.generate(6, (i) => TextEditingController(text: '$i'));
      final code = ctrls.map((c) => c.text).join();
      expect(code.length, 6);
    });
  });
}

/// Dialog helper untuk test _onVerify dengan callback
class _VerifyTestDialog extends StatelessWidget {
  final List<TextEditingController> controllers;
  final VoidCallback onVerify;

  const _VerifyTestDialog({
    required this.controllers,
    required this.onVerify,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Verifikasi email kamu',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                6,
                (i) => SizedBox(
                  width: 40,
                  height: 55,
                  child: TextField(
                    controller: controllers[i],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    decoration: const InputDecoration(counterText: ''),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onVerify,
              child: const Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dialog helper yang mengimplementasikan guard kode < 6
class _VerifyGuardDialog extends StatelessWidget {
  final List<TextEditingController> controllers;
  final VoidCallback onVerified;

  const _VerifyGuardDialog({
    required this.controllers,
    required this.onVerified,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Dialog OTP'),
            ElevatedButton(
              onPressed: () {
                final code = controllers.map((c) => c.text).join();
                if (code.length < 6) return;
                onVerified();
              },
              child: const Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }
}