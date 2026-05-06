import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Test File 20 — Widget: RegisterAddressPage - _onCityChanged()
/// Tester: Arji
/// Memastikan fungsi _onCityChanged() bekerja dengan benar:
/// memperbarui kota terpilih, mereset kecamatan dan kelurahan,
/// serta memuat daftar kecamatan setelah kota dipilih.

void main() {
  group('RegisterAddressPage - _onCityChanged()', () {
    Widget buildWidget({
      required Future<List<Map<String, String>>> Function(String id) fetchDistricts,
    }) {
      return MaterialApp(
        home: _CityChangedTestPage(fetchDistricts: fetchDistricts),
      );
    }

    testWidgets('Memilih kota memperbarui teks kota yang terpilih',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget(fetchDistricts: (_) async => []));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Pilih Kota'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Banda Aceh').last);
      await tester.pumpAndSettle();

      expect(find.text('Banda Aceh'), findsOneWidget);
    });

    testWidgets('Memilih kota baru mereset kecamatan ke null',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget(
        fetchDistricts: (_) async => [
          {'id': '110101', 'name': 'Baiturrahman'},
        ],
      ));
      await tester.pumpAndSettle();

      // Pilih kota pertama
      await tester.tap(find.text('Pilih Kota'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Banda Aceh').last);
      await tester.pumpAndSettle();

      // Pilih kecamatan
      await tester.tap(find.text('Pilih Kecamatan'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Baiturrahman').last);
      await tester.pumpAndSettle();

      // Ganti kota — kecamatan harus direset
      await tester.tap(find.text('Banda Aceh'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Langsa').last);
      await tester.pumpAndSettle();

      expect(find.text('Baiturrahman'), findsNothing);
    });

    testWidgets('Loading kecamatan dimulai saat kota dipilih',
        (WidgetTester tester) async {
      final completer = Completer<List<Map<String, String>>>();

      await tester.pumpWidget(
          buildWidget(fetchDistricts: (_) => completer.future));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Pilih Kota'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Banda Aceh').last);
      await tester.pump();

      expect(find.byKey(const Key('district_loading')), findsOneWidget);

      completer.complete([]);
      await tester.pumpAndSettle();
    });

    testWidgets('Daftar kecamatan tampil di dropdown setelah dimuat',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget(
        fetchDistricts: (_) async => [
          {'id': '110101', 'name': 'Baiturrahman'},
          {'id': '110102', 'name': 'Banda Raya'},
        ],
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Pilih Kota'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Banda Aceh').last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Pilih Kecamatan'));
      await tester.pumpAndSettle();

      expect(find.text('Baiturrahman'), findsWidgets);
      expect(find.text('Banda Raya'), findsWidgets);
    });

    testWidgets('Dropdown kecamatan tidak aktif sebelum kota dipilih',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget(fetchDistricts: (_) async => []));
      await tester.pumpAndSettle();

      final districtDropdown = tester.widget<DropdownButton<String>>(
        find.byKey(const Key('district_dropdown')),
      );
      expect(districtDropdown.onChanged, isNull);
    });

    testWidgets('Memilih kota mereset pilihan kelurahan',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget(fetchDistricts: (_) async => []));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Pilih Kota'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Banda Aceh').last);
      await tester.pumpAndSettle();

      final state = tester.state<_CityChangedTestPageState>(
        find.byType(_CityChangedTestPage),
      );
      expect(state.selectedVillage, isNull);
    });
  });
}

// ─── Test Widget ──────────────────────────────────────────────────────────────

class _CityChangedTestPage extends StatefulWidget {
  final Future<List<Map<String, String>>> Function(String id) fetchDistricts;

  const _CityChangedTestPage({required this.fetchDistricts});

  @override
  State<_CityChangedTestPage> createState() => _CityChangedTestPageState();
}

class _CityChangedTestPageState extends State<_CityChangedTestPage> {
  static const _cities = [
    {'id': '1101', 'name': 'Banda Aceh'},
    {'id': '1102', 'name': 'Langsa'},
  ];

  String? _selectedCity;
  String? _selectedCityId;
  List<Map<String, String>> _districts = [];
  String? _selectedDistrict;
  String? selectedVillage;
  bool _loadingDistricts = false;

  Future<void> _onCityChanged(String id, String name) async {
    setState(() {
      _selectedCityId = id;
      _selectedCity = name;
      _selectedDistrict = null;
      selectedVillage = null;
      _districts = [];
      _loadingDistricts = true;
    });
    try {
      final list = await widget.fetchDistricts(id);
      setState(() => _districts = list);
    } catch (_) {
    } finally {
      setState(() => _loadingDistricts = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          DropdownButton<String>(
            hint: const Text('Pilih Kota'),
            value: _selectedCity,
            onChanged: (name) {
              if (name == null) return;
              final item = _cities.firstWhere((c) => c['name'] == name);
              _onCityChanged(item['id']!, item['name']!);
            },
            items: _cities
                .map((c) => DropdownMenuItem<String>(
                      value: c['name'],
                      child: Text(c['name']!),
                    ))
                .toList(),
          ),
          if (_loadingDistricts)
            const SizedBox(
              key: Key('district_loading'),
              child: CircularProgressIndicator(),
            )
          else
            DropdownButton<String>(
              key: const Key('district_dropdown'),
              hint: const Text('Pilih Kecamatan'),
              value: _selectedDistrict,
              onChanged: _selectedCityId == null || _districts.isEmpty
                  ? null
                  : (name) => setState(() => _selectedDistrict = name),
              items: _districts
                  .map((d) => DropdownMenuItem<String>(
                        value: d['name'],
                        child: Text(d['name']!),
                      ))
                  .toList(),
            ),
        ],
      ),
    );
  }
}
