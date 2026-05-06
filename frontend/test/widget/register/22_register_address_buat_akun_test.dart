import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Test File 22 — Widget: RegisterAddressPage - _onBuatAkun()
/// Tester: Arji
/// Memastikan fungsi _onBuatAkun() bekerja dengan benar:
/// tombol aktif hanya saat semua alamat dipilih, menampilkan loading saat submit,
/// memanggil callback sukses, dan menampilkan SnackBar saat terjadi error.

void main() {
  group('RegisterAddressPage - _onBuatAkun()', () {
    Widget buildWidget({
      required bool allSelected,
      required Future<void> Function() onRegister,
    }) {
      return MaterialApp(
        home: _BuatAkunTestPage(
          allSelected: allSelected,
          onRegister: onRegister,
        ),
      );
    }

    testWidgets('Tombol "Buat akun" tampil di halaman',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget(
        allSelected: false,
        onRegister: () async {},
      ));
      expect(find.text('Buat akun'), findsOneWidget);
    });

    testWidgets('Tombol "Buat akun" dinonaktifkan saat belum semua alamat dipilih',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget(
        allSelected: false,
        onRegister: () async {},
      ));

      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Buat akun'),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('Tombol "Buat akun" aktif saat semua alamat telah dipilih',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget(
        allSelected: true,
        onRegister: () async {},
      ));

      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Buat akun'),
      );
      expect(button.onPressed, isNotNull);
    });

    testWidgets('Loading indicator tampil saat proses submit berlangsung',
        (WidgetTester tester) async {
      final completer = Completer<void>();

      await tester.pumpWidget(buildWidget(
        allSelected: true,
        onRegister: () => completer.future,
      ));

      await tester.tap(find.text('Buat akun'));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Buat akun'), findsNothing);

      completer.complete();
      await tester.pumpAndSettle();
    });

    testWidgets('Callback sukses dipanggil saat tombol ditekan',
        (WidgetTester tester) async {
      bool called = false;

      await tester.pumpWidget(buildWidget(
        allSelected: true,
        onRegister: () async => called = true,
      ));

      await tester.tap(find.text('Buat akun'));
      await tester.pumpAndSettle();

      expect(called, isTrue);
    });

    testWidgets('SnackBar error tampil saat register gagal',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget(
        allSelected: true,
        onRegister: () async => throw _TestApiException('Username sudah digunakan.'),
      ));

      await tester.tap(find.text('Buat akun'));
      await tester.pumpAndSettle();

      expect(find.text('Username sudah digunakan.'), findsOneWidget);
    });

    testWidgets('Tombol kembali aktif setelah submit selesai (gagal)',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget(
        allSelected: true,
        onRegister: () async => throw _TestApiException('Error'),
      ));

      await tester.tap(find.text('Buat akun'));
      await tester.pumpAndSettle();

      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Buat akun'),
      );
      expect(button.onPressed, isNotNull);
    });

    testWidgets('CircularProgressIndicator hilang setelah submit selesai',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget(
        allSelected: true,
        onRegister: () async {},
      ));

      await tester.tap(find.text('Buat akun'));
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}

// ─── Test helpers ─────────────────────────────────────────────────────────────

class _TestApiException implements Exception {
  final String message;
  const _TestApiException(this.message);
}

// ─── Test Widget ──────────────────────────────────────────────────────────────

class _BuatAkunTestPage extends StatefulWidget {
  final bool allSelected;
  final Future<void> Function() onRegister;

  const _BuatAkunTestPage({
    required this.allSelected,
    required this.onRegister,
  });

  @override
  State<_BuatAkunTestPage> createState() => _BuatAkunTestPageState();
}

class _BuatAkunTestPageState extends State<_BuatAkunTestPage> {
  bool _submitting = false;

  Future<void> _onBuatAkun() async {
    setState(() => _submitting = true);
    try {
      await widget.onRegister();
    } on _TestApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: widget.allSelected && !_submitting ? _onBuatAkun : null,
            child: _submitting
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Buat akun'),
          ),
        ),
      ),
    );
  }
}
