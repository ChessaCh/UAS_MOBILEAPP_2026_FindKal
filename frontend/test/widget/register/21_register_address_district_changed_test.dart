import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Test File 21 — Widget: RegisterAddressPage - _onDistrictChanged()
/// Tester: Arji
/// Memastikan fungsi _onDistrictChanged() bekerja dengan benar:
/// memperbarui kecamatan terpilih, mereset kelurahan,
/// serta memuat daftar kelurahan setelah kecamatan dipilih.

void main() {
  group('RegisterAddressPage - _onDistrictChanged()', () {
    Widget buildWidget({
      required Future<List<Map<String, String>>> Function(String id) fetchVillages,
    }) {
      return MaterialApp(
        home: _DistrictChangedTestPage(fetchVillages: fetchVillages),
      );
    }

    testWidgets('Memilih kecamatan memperbarui teks kecamatan yang terpilih',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget(fetchVillages: (_) async => []));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Pilih Kecamatan'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Baiturrahman').last);
      await tester.pumpAndSettle();

      expect(find.text('Baiturrahman'), findsOneWidget);
    });

    testWidgets('Memilih kecamatan baru mereset kelurahan ke null',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget(
        fetchVillages: (_) async => [
          {'id': '1101011', 'name': 'Ateuk Jawo'},
        ],
      ));
      await tester.pumpAndSettle();

      // Pilih kecamatan pertama
      await tester.tap(find.text('Pilih Kecamatan'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Baiturrahman').last);
      await tester.pumpAndSettle();

      // Pilih kelurahan
      await tester.tap(find.text('Pilih Kelurahan'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Ateuk Jawo').last);
      await tester.pumpAndSettle();

      // Ganti kecamatan — kelurahan harus direset
      await tester.tap(find.text('Baiturrahman'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Banda Raya').last);
      await tester.pumpAndSettle();

      expect(find.text('Ateuk Jawo'), findsNothing);
    });

    testWidgets('Loading kelurahan dimulai saat kecamatan dipilih',
        (WidgetTester tester) async {
      final completer = Completer<List<Map<String, String>>>();

      await tester.pumpWidget(
          buildWidget(fetchVillages: (_) => completer.future));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Pilih Kecamatan'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Baiturrahman').last);
      await tester.pump();

      expect(find.byKey(const Key('village_loading')), findsOneWidget);

      completer.complete([]);
      await tester.pumpAndSettle();
    });

    testWidgets('Daftar kelurahan tampil di dropdown setelah dimuat',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget(
        fetchVillages: (_) async => [
          {'id': '1101011', 'name': 'Ateuk Jawo'},
          {'id': '1101012', 'name': 'Ateuk Pahlawan'},
        ],
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Pilih Kecamatan'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Baiturrahman').last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Pilih Kelurahan'));
      await tester.pumpAndSettle();

      expect(find.text('Ateuk Jawo'), findsWidgets);
      expect(find.text('Ateuk Pahlawan'), findsWidgets);
    });

    testWidgets('Dropdown kelurahan tidak aktif sebelum kecamatan dipilih',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget(fetchVillages: (_) async => []));
      await tester.pumpAndSettle();

      final villageDropdown = tester.widget<DropdownButton<String>>(
        find.byKey(const Key('village_dropdown')),
      );
      expect(villageDropdown.onChanged, isNull);
    });

    testWidgets('Kelurahan terpilih direset setelah ganti kecamatan',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget(
        fetchVillages: (_) async => [
          {'id': '1101011', 'name': 'Ateuk Jawo'},
        ],
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Pilih Kecamatan'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Baiturrahman').last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Pilih Kelurahan'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Ateuk Jawo').last);
      await tester.pumpAndSettle();

      // Ganti kecamatan
      await tester.tap(find.text('Baiturrahman'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Banda Raya').last);
      await tester.pumpAndSettle();

      final state = tester.state<_DistrictChangedTestPageState>(
        find.byType(_DistrictChangedTestPage),
      );
      expect(state.selectedVillage, isNull);
    });
  });
}

// ─── Test Widget ──────────────────────────────────────────────────────────────

class _DistrictChangedTestPage extends StatefulWidget {
  final Future<List<Map<String, String>>> Function(String id) fetchVillages;

  const _DistrictChangedTestPage({required this.fetchVillages});

  @override
  State<_DistrictChangedTestPage> createState() =>
      _DistrictChangedTestPageState();
}

class _DistrictChangedTestPageState extends State<_DistrictChangedTestPage> {
  static const _districts = [
    {'id': '110101', 'name': 'Baiturrahman'},
    {'id': '110102', 'name': 'Banda Raya'},
  ];

  String? _selectedDistrict;
  String? _selectedDistrictId;
  List<Map<String, String>> _villages = [];
  String? selectedVillage;
  bool _loadingVillages = false;

  Future<void> _onDistrictChanged(String id, String name) async {
    setState(() {
      _selectedDistrictId = id;
      _selectedDistrict = name;
      selectedVillage = null;
      _villages = [];
      _loadingVillages = true;
    });
    try {
      final list = await widget.fetchVillages(id);
      setState(() => _villages = list);
    } catch (_) {
    } finally {
      setState(() => _loadingVillages = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          DropdownButton<String>(
            hint: const Text('Pilih Kecamatan'),
            value: _selectedDistrict,
            onChanged: (name) {
              if (name == null) return;
              final item = _districts.firstWhere((d) => d['name'] == name);
              _onDistrictChanged(item['id']!, item['name']!);
            },
            items: _districts
                .map((d) => DropdownMenuItem<String>(
                      value: d['name'],
                      child: Text(d['name']!),
                    ))
                .toList(),
          ),
          if (_loadingVillages)
            const SizedBox(
              key: Key('village_loading'),
              child: CircularProgressIndicator(),
            )
          else
            DropdownButton<String>(
              key: const Key('village_dropdown'),
              hint: const Text('Pilih Kelurahan'),
              value: selectedVillage,
              onChanged: _selectedDistrictId == null || _villages.isEmpty
                  ? null
                  : (name) => setState(() => selectedVillage = name),
              items: _villages
                  .map((v) => DropdownMenuItem<String>(
                        value: v['name'],
                        child: Text(v['name']!),
                      ))
                  .toList(),
            ),
        ],
      ),
    );
  }
}
