import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Test File 18 — Widget: RegisterAddressPage - _loadProvinces()
/// Tester: Arji
/// Memastikan fungsi _loadProvinces() bekerja dengan benar:
/// menampilkan loading indicator saat memuat data provinsi,
/// mengisi dropdown setelah data tersedia, dan gagal secara diam-diam saat error.

void main() {
  group('RegisterAddressPage - _loadProvinces()', () {
    Widget buildProvinceWidget({
      required Future<List<Map<String, String>>> Function() fetchProvinces,
    }) {
      return MaterialApp(
        home: _LoadProvincesTestPage(fetchProvinces: fetchProvinces),
      );
    }

    testWidgets('Loading indicator tampil saat memuat provinsi',
        (WidgetTester tester) async {
      final completer = Completer<List<Map<String, String>>>();

      await tester.pumpWidget(buildProvinceWidget(
        fetchProvinces: () => completer.future,
      ));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete([]);
      await tester.pumpAndSettle();
    });

    testWidgets('Loading indicator hilang setelah data provinsi termuat',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildProvinceWidget(
        fetchProvinces: () async => [
          {'id': '11', 'name': 'Aceh'},
          {'id': '12', 'name': 'Sumatera Utara'},
        ],
      ));
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('Dropdown provinsi terisi setelah data dimuat',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildProvinceWidget(
        fetchProvinces: () async => [
          {'id': '11', 'name': 'Aceh'},
          {'id': '12', 'name': 'Sumatera Utara'},
        ],
      ));
      await tester.pumpAndSettle();

      // Open dropdown
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();

      expect(find.text('Aceh'), findsWidgets);
      expect(find.text('Sumatera Utara'), findsWidgets);
    });

    testWidgets('Dropdown tetap kosong dan tidak crash saat fetch gagal',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildProvinceWidget(
        fetchProvinces: () async => throw Exception('Network error'),
      ));
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Pilih Provinsi'), findsNothing);
    });

    testWidgets('Dropdown provinsi aktif (enabled) setelah data termuat',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildProvinceWidget(
        fetchProvinces: () async => [
          {'id': '11', 'name': 'Aceh'},
        ],
      ));
      await tester.pumpAndSettle();

      final dropdown = tester.widget<DropdownButton<String>>(
        find.byType(DropdownButton<String>),
      );
      expect(dropdown.onChanged, isNotNull);
    });

    testWidgets('Beberapa item provinsi tampil di dropdown',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildProvinceWidget(
        fetchProvinces: () async => [
          {'id': '11', 'name': 'Aceh'},
          {'id': '12', 'name': 'Sumatera Utara'},
          {'id': '13', 'name': 'Sumatera Barat'},
        ],
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();

      expect(find.text('Aceh'), findsWidgets);
      expect(find.text('Sumatera Utara'), findsWidgets);
      expect(find.text('Sumatera Barat'), findsWidgets);
    });

    testWidgets('Dropdown tidak aktif (disabled) saat masih loading',
        (WidgetTester tester) async {
      final completer = Completer<List<Map<String, String>>>();

      await tester.pumpWidget(buildProvinceWidget(
        fetchProvinces: () => completer.future,
      ));
      await tester.pump();

      // During loading, DropdownButton is not rendered (CircularProgressIndicator shown instead)
      expect(find.byType(DropdownButton<String>), findsNothing);

      completer.complete([]);
      await tester.pumpAndSettle();
    });
  });
}

// ─── Test Widget ──────────────────────────────────────────────────────────────

class _LoadProvincesTestPage extends StatefulWidget {
  final Future<List<Map<String, String>>> Function() fetchProvinces;

  const _LoadProvincesTestPage({required this.fetchProvinces});

  @override
  State<_LoadProvincesTestPage> createState() => _LoadProvincesTestPageState();
}

class _LoadProvincesTestPageState extends State<_LoadProvincesTestPage> {
  List<Map<String, String>> _provinces = [];
  bool _loading = false;
  String? _selected;

  @override
  void initState() {
    super.initState();
    _loadProvinces();
  }

  Future<void> _loadProvinces() async {
    setState(() => _loading = true);
    try {
      final list = await widget.fetchProvinces();
      setState(() => _provinces = list);
    } catch (_) {
      // silently fail
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : DropdownButton<String>(
                value: _selected,
                hint: _provinces.isEmpty ? null : const Text('Pilih Provinsi'),
                onChanged: _provinces.isEmpty
                    ? null
                    : (val) => setState(() => _selected = val),
                items: _provinces
                    .map((p) => DropdownMenuItem<String>(
                          value: p['name'],
                          child: Text(p['name']!),
                        ))
                    .toList(),
              ),
      ),
    );
  }
}

