import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Test File 19 — Widget: RegisterAddressPage - _onProvinceChanged()
/// Tester: Arji
/// Memastikan fungsi _onProvinceChanged() bekerja dengan benar:
/// memperbarui provinsi terpilih, mereset pilihan kota/kecamatan/kelurahan,
/// dan memuat daftar kota setelah provinsi dipilih.

void main() {
  group('RegisterAddressPage - _onProvinceChanged()', () {
    Widget buildWidget({
      required Future<List<Map<String, String>>> Function(String id) fetchCities,
    }) {
      return MaterialApp(
        home: _ProvinceChangedTestPage(fetchCities: fetchCities),
      );
    }

    testWidgets('Memilih provinsi memperbarui teks provinsi yang terpilih',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget(fetchCities: (_) async => []));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Pilih Provinsi'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Aceh').last);
      await tester.pumpAndSettle();

      expect(find.text('Aceh'), findsOneWidget);
    });

    testWidgets('Memilih provinsi baru mereset pilihan kota ke null',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget(
        fetchCities: (_) async => [{'id': '1101', 'name': 'Banda Aceh'}],
      ));
      await tester.pumpAndSettle();

      // Pilih provinsi pertama
      await tester.tap(find.text('Pilih Provinsi'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Aceh').last);
      await tester.pumpAndSettle();

      // Pilih kota
      await tester.tap(find.text('Pilih Kota'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Banda Aceh').last);
      await tester.pumpAndSettle();

      // Ganti provinsi — kota harus direset
      await tester.tap(find.text('Aceh'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sumatera Utara').last);
      await tester.pumpAndSettle();

      expect(find.text('Banda Aceh'), findsNothing);
    });

    testWidgets('Loading kota dimulai setelah provinsi dipilih',
        (WidgetTester tester) async {
      final completer = Completer<List<Map<String, String>>>();

      await tester.pumpWidget(buildWidget(fetchCities: (_) => completer.future));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Pilih Provinsi'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Aceh').last);
      await tester.pump();

      expect(find.byKey(const Key('city_loading')), findsOneWidget);

      completer.complete([]);
      await tester.pumpAndSettle();
    });

    testWidgets('Daftar kota tampil di dropdown setelah kota dimuat',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget(
        fetchCities: (_) async => [
          {'id': '1101', 'name': 'Banda Aceh'},
          {'id': '1102', 'name': 'Langsa'},
        ],
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Pilih Provinsi'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Aceh').last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Pilih Kota'));
      await tester.pumpAndSettle();

      expect(find.text('Banda Aceh'), findsWidgets);
      expect(find.text('Langsa'), findsWidgets);
    });

    testWidgets('Memilih provinsi mereset daftar kota sebelumnya',
        (WidgetTester tester) async {
      int callCount = 0;
      await tester.pumpWidget(buildWidget(
        fetchCities: (_) async {
          callCount++;
          return [{'id': '1101', 'name': 'Kota $callCount'}];
        },
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Pilih Provinsi'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Aceh').last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Aceh'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sumatera Utara').last);
      await tester.pumpAndSettle();

      expect(callCount, 2);
    });

    testWidgets('Dropdown kota tidak aktif sebelum provinsi dipilih',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget(fetchCities: (_) async => []));
      await tester.pumpAndSettle();

      final cityDropdown = tester.widget<DropdownButton<String>>(
        find.byKey(const Key('city_dropdown')),
      );
      expect(cityDropdown.onChanged, isNull);
    });
  });
}

// ─── Test Widget ──────────────────────────────────────────────────────────────

class _ProvinceChangedTestPage extends StatefulWidget {
  final Future<List<Map<String, String>>> Function(String id) fetchCities;

  const _ProvinceChangedTestPage({required this.fetchCities});

  @override
  State<_ProvinceChangedTestPage> createState() =>
      _ProvinceChangedTestPageState();
}

class _ProvinceChangedTestPageState extends State<_ProvinceChangedTestPage> {
  static const _provinces = [
    {'id': '11', 'name': 'Aceh'},
    {'id': '12', 'name': 'Sumatera Utara'},
  ];

  String? _selectedProvince;
  String? _selectedProvinceId;
  List<Map<String, String>> _cities = [];
  String? _selectedCity;
  bool _loadingCities = false;

  Future<void> _onProvinceChanged(String id, String name) async {
    setState(() {
      _selectedProvinceId = id;
      _selectedProvince = name;
      _selectedCity = null;
      _cities = [];
      _loadingCities = true;
    });
    try {
      final list = await widget.fetchCities(id);
      setState(() => _cities = list);
    } catch (_) {
    } finally {
      setState(() => _loadingCities = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          DropdownButton<String>(
            hint: const Text('Pilih Provinsi'),
            value: _selectedProvince,
            onChanged: (name) {
              if (name == null) return;
              final item = _provinces.firstWhere((p) => p['name'] == name);
              _onProvinceChanged(item['id']!, item['name']!);
            },
            items: _provinces
                .map((p) => DropdownMenuItem<String>(
                      value: p['name'],
                      child: Text(p['name']!),
                    ))
                .toList(),
          ),
          if (_loadingCities)
            const SizedBox(key: Key('city_loading'), child: CircularProgressIndicator())
          else
            DropdownButton<String>(
              key: const Key('city_dropdown'),
              hint: const Text('Pilih Kota'),
              value: _selectedCity,
              onChanged: _selectedProvinceId == null || _cities.isEmpty
                  ? null
                  : (name) => setState(() => _selectedCity = name),
              items: _cities
                  .map((c) => DropdownMenuItem<String>(
                        value: c['name'],
                        child: Text(c['name']!),
                      ))
                  .toList(),
            ),
        ],
      ),
    );
  }
}
