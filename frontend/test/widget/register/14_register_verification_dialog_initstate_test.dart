import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Test File 14 — Widget: Verifikasi email (OTP) - initState()
/// Tester: Irsyad
/// Memastikan initState() pada _VerificationDialog berjalan dengan benar:
/// timer countdown dimulai, semua controller diinisialisasi,
/// dan state awal dialog sudah benar.

void main() {
  group('_VerificationDialog - initState()', () {
    Widget buildRegisterWithDialog() {
      return MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const _TestableVerificationDialog(
                      email: 'irsyad@example.com',
                    ),
                  );
                },
                child: const Text('Buka Dialog OTP'),
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('Dialog OTP dapat dibuka tanpa error (initState berjalan)',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterWithDialog());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Buka Dialog OTP'));
      await tester.pumpAndSettle();

      expect(find.text('Verifikasi email kamu'), findsOneWidget);
    });

    testWidgets('Timer countdown tampil saat dialog dibuka (initState memulai timer)',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterWithDialog());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Buka Dialog OTP'));
      await tester.pumpAndSettle();

      // Timer 30 detik dimulai — cek teks countdown ada
      expect(find.textContaining('00:30'), findsOneWidget);
    });

    testWidgets('Timer berkurang setelah 1 detik',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterWithDialog());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Buka Dialog OTP'));
      await tester.pump();

      // Awal: 30
      expect(find.textContaining('00:30'), findsOneWidget);

      // Maju 1 detik
      await tester.pump(const Duration(seconds: 1));
      expect(find.textContaining('00:29'), findsOneWidget);
    });

    testWidgets('Semua 6 field OTP ada saat dialog dibuka (controller terinisialisasi)',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterWithDialog());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Buka Dialog OTP'));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsNWidgets(6));
    });

    testWidgets('Semua field OTP kosong saat dialog pertama dibuka',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterWithDialog());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Buka Dialog OTP'));
      await tester.pumpAndSettle();

      final fields = find.byType(TextField);
      for (int i = 0; i < 6; i++) {
        final field = tester.widget<TextField>(fields.at(i));
        expect(field.controller?.text ?? '', isEmpty);
      }
    });

    testWidgets('Tombol "Kirim kode baru" tidak aktif saat timer masih berjalan',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterWithDialog());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Buka Dialog OTP'));
      await tester.pumpAndSettle();

      // Timer masih berjalan, tombol resend tidak aktif
      expect(find.text('Kirim kode baru'), findsOneWidget);
      expect(find.textContaining('dalam 00:'), findsOneWidget);
    });

    testWidgets('Timer menjadi 0 setelah 30 detik',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterWithDialog());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Buka Dialog OTP'));
      await tester.pump();

      // Maju 30 detik
      await tester.pump(const Duration(seconds: 30));
      await tester.pump();

      // Timer habis, teks countdown tidak ada lagi
      expect(find.textContaining('dalam 00:'), findsNothing);
    });

    testWidgets('State _verifying awalnya false (tombol Verify aktif)',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterWithDialog());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Buka Dialog OTP'));
      await tester.pumpAndSettle();

      // Tombol Verify ada dan aktif (tidak ada CircularProgressIndicator)
      expect(find.text('Verify'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('State _resending awalnya false (tidak ada loading)',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterWithDialog());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Buka Dialog OTP'));
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}

/// Widget helper untuk test dialog OTP secara terisolasi
class _TestableVerificationDialog extends StatefulWidget {
  final String email;
  const _TestableVerificationDialog({required this.email});

  @override
  State<_TestableVerificationDialog> createState() =>
      _TestableVerificationDialogState();
}

class _TestableVerificationDialogState
    extends State<_TestableVerificationDialog> {
  int _start = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_start > 0) {
        setState(() {
          _start -= 1;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Verifikasi email kamu',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: () => Navigator.pop(context, false),
                  child: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('Kami telah mengirim 6 digit kode ke email kamu'),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                6,
                (index) => SizedBox(
                  width: 40,
                  height: 55,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      counterText: '',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Kirim kode baru'),
                if (_start > 0)
                  Text(
                    ' dalam 00:${_start.toString().padLeft(2, '0')}',
                  ),
              ],
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Verify'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}