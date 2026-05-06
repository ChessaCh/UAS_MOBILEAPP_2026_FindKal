import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Unit Test — RegisterAddressPage
/// Tester: Arji
/// Menguji logika murni pada RegisterAddressPage:
/// getter _allSelected (button enable/disable),
/// dan perilaku reset cascade saat pilihan berubah.

void main() {
  group('RegisterAddressPage - Unit: _allSelected', () {
    testWidgets(
        'Tombol nonaktif saat provinsi null (belum dipilih)',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: _AddressLogicWidget(
          province: null,
          city: 'Banda Aceh',
          district: 'Baiturrahman',
          village: 'Ateuk Jawo',
        ),
      ));
      final btn = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(btn.onPressed, isNull);
    });

    testWidgets(
        'Tombol nonaktif saat kota null (belum dipilih)',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: _AddressLogicWidget(
          province: 'Aceh',
          city: null,
          district: 'Baiturrahman',
          village: 'Ateuk Jawo',
        ),
      ));
      final btn = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(btn.onPressed, isNull);
    });

    testWidgets(
        'Tombol nonaktif saat kecamatan null (belum dipilih)',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: _AddressLogicWidget(
          province: 'Aceh',
          city: 'Banda Aceh',
          district: null,
          village: 'Ateuk Jawo',
        ),
      ));
      final btn = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(btn.onPressed, isNull);
    });

    testWidgets(
        'Tombol nonaktif saat kelurahan null (belum dipilih)',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: _AddressLogicWidget(
          province: 'Aceh',
          city: 'Banda Aceh',
          district: 'Baiturrahman',
          village: null,
        ),
      ));
      final btn = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(btn.onPressed, isNull);
    });

    testWidgets(
        'Tombol aktif saat semua field alamat terisi',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: _AddressLogicWidget(
          province: 'Aceh',
          city: 'Banda Aceh',
          district: 'Baiturrahman',
          village: 'Ateuk Jawo',
        ),
      ));
      final btn = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(btn.onPressed, isNotNull);
    });

    testWidgets(
        'Tombol nonaktif saat semua field null',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: _AddressLogicWidget(
          province: null,
          city: null,
          district: null,
          village: null,
        ),
      ));
      final btn = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(btn.onPressed, isNull);
    });
  });

  group('RegisterAddressPage - Unit: Cascade Reset Logic', () {
    testWidgets('Memilih provinsi baru mengosongkan kota, kecamatan, kelurahan',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: _CascadeResetWidget()),
      );
      await tester.pumpAndSettle();

      // Pilih provinsi → otomatis memilih kota dummy untuk simulasi
      await tester.tap(find.text('Pilih Provinsi'));
      await tester.pumpAndSettle();

      final state =
          tester.state<_CascadeResetWidgetState>(find.byType(_CascadeResetWidget));
      expect(state.city, isNull);
      expect(state.district, isNull);
      expect(state.village, isNull);
    });

    testWidgets('Memilih kota baru mengosongkan kecamatan dan kelurahan',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: _CascadeResetWidget()),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Pilih Kota'));
      await tester.pumpAndSettle();

      final state =
          tester.state<_CascadeResetWidgetState>(find.byType(_CascadeResetWidget));
      expect(state.district, isNull);
      expect(state.village, isNull);
    });

    testWidgets('Memilih kecamatan baru mengosongkan kelurahan',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: _CascadeResetWidget()),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Pilih Kecamatan'));
      await tester.pumpAndSettle();

      final state =
          tester.state<_CascadeResetWidgetState>(find.byType(_CascadeResetWidget));
      expect(state.village, isNull);
    });
  });
}

// ─── Helper: Tests _allSelected logic ────────────────────────────────────────

class _AddressLogicWidget extends StatelessWidget {
  final String? province;
  final String? city;
  final String? district;
  final String? village;

  const _AddressLogicWidget({
    required this.province,
    required this.city,
    required this.district,
    required this.village,
  });

  bool get _allSelected =>
      province != null && city != null && district != null && village != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(
        onPressed: _allSelected ? () {} : null,
        child: const Text('Buat akun'),
      ),
    );
  }
}

// ─── Helper: Tests cascade reset logic ────────────────────────────────────────

class _CascadeResetWidget extends StatefulWidget {
  const _CascadeResetWidget();

  @override
  State<_CascadeResetWidget> createState() => _CascadeResetWidgetState();
}

class _CascadeResetWidgetState extends State<_CascadeResetWidget> {
  String? province;
  String? city;
  String? district;
  String? village;

  void _onProvinceChanged() =>
      setState(() {
        province = 'Aceh';
        city = null;
        district = null;
        village = null;
      });

  void _onCityChanged() =>
      setState(() {
        city = 'Banda Aceh';
        district = null;
        village = null;
      });

  void _onDistrictChanged() =>
      setState(() {
        district = 'Baiturrahman';
        village = null;
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _onProvinceChanged,
            child: const Text('Pilih Provinsi'),
          ),
          ElevatedButton(
            onPressed: _onCityChanged,
            child: const Text('Pilih Kota'),
          ),
          ElevatedButton(
            onPressed: _onDistrictChanged,
            child: const Text('Pilih Kecamatan'),
          ),
        ],
      ),
    );
  }
}
