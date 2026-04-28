import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'survey_question_page.dart';

const String _regionApiBase = 'https://api-regional-indonesia.vercel.app/api';

class SurveyRegionPage extends StatefulWidget {
  const SurveyRegionPage({super.key});

  @override
  State<SurveyRegionPage> createState() => _SurveyRegionPageState();
}

class _SurveyRegionPageState extends State<SurveyRegionPage> {
  String? _selectedProvinceId;
  String? _selectedProvince;
  String? _selectedCity;

  List<Map<String, String>> _provinces = [];
  List<Map<String, String>> _cities = [];

  bool _loadingProvinces = false;
  bool _loadingCities = false;

  @override
  void initState() {
    super.initState();
    _loadProvinces();
  }

  Future<List<Map<String, String>>> _fetch(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) throw Exception('Gagal memuat data');
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final data = body['data'] as List<dynamic>;
    return data
        .map((e) => {'id': e['id'].toString(), 'name': e['name'].toString()})
        .toList();
  }

  Future<void> _loadProvinces() async {
    setState(() => _loadingProvinces = true);
    try {
      final list = await _fetch('$_regionApiBase/provinces');
      setState(() => _provinces = list);
    } catch (_) {
    } finally {
      setState(() => _loadingProvinces = false);
    }
  }

  Future<void> _onProvinceChanged(String id, String name) async {
    setState(() {
      _selectedProvinceId = id;
      _selectedProvince = name;
      _selectedCity = null;
      _cities = [];
      _loadingCities = true;
    });
    try {
      final list = await _fetch('$_regionApiBase/cities/$id');
      setState(() => _cities = list);
    } catch (_) {
    } finally {
      setState(() => _loadingCities = false);
    }
  }

  String get _regionLabel {
    if (_selectedCity != null) return _selectedCity!;
    if (_selectedProvince != null) return _selectedProvince!;
    return '';
  }

  bool get _canProceed => _selectedProvince != null;

  void _proceed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SurveyQuestionPage(region: _regionLabel),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ── TOP CURVED BACKGROUND ──────────────────────────────────
          ClipPath(
            clipper: _TopCurveClipper(),
            child: Container(
              height: 220,
              width: double.infinity,
              color: const Color(0xFF4AA5A6),
            ),
          ),
          Positioned(
            top: -20,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: _TopCurveClipper(),
              child: Container(
                height: 240,
                color: const Color(0xFF9ACAD0).withValues(alpha: 0.4),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white, size: 20),
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon
                        Center(
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: const Color(0xFF4AA5A6),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF4AA5A6).withValues(alpha: 0.3),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.location_on_rounded,
                                color: Colors.white, size: 30),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Title
                        const Center(
                          child: Text(
                            'Pilih Daerahmu',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Pilih provinsi dan kota daerahmu. Pertanyaan akan disesuaikan untuk menguji pengetahuan lokalmu.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                color: Colors.grey,
                                height: 1.6,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Province dropdown
                        _buildDropdown(
                          label: 'Provinsi',
                          items: _provinces,
                          value: _selectedProvince,
                          loading: _loadingProvinces,
                          onChanged: (id, name) => _onProvinceChanged(id, name),
                        ),
                        const SizedBox(height: 16),

                        // City dropdown
                        _buildDropdown(
                          label: 'Kota / Kabupaten (Opsional)',
                          items: _cities,
                          value: _selectedCity,
                          loading: _loadingCities,
                          onChanged: _selectedProvinceId != null
                              ? (id, name) => setState(() => _selectedCity = name)
                              : null,
                        ),

                        // Selected region preview
                        if (_regionLabel.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4AA5A6).withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: const Color(0xFF4AA5A6), width: 1.5),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle_rounded,
                                    color: Color(0xFF4AA5A6), size: 18),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Kamu mendaftar sebagai Warga Lokal $_regionLabel',
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 13,
                                      color: Color(0xFF4AA5A6),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 48),
                      ],
                    ),
                  ),
                ),

                // Proceed button
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 48),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _canProceed ? _proceed : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9ACAD0),
                        disabledBackgroundColor: Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Mulai Verifikasi',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required List<Map<String, String>> items,
    required String? value,
    required void Function(String id, String name)? onChanged,
    bool loading = false,
  }) {
    final bool enabled = !loading && items.isNotEmpty && onChanged != null;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF4AA5A6)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.grey),
          ),
          if (loading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF4AA5A6)),
              ),
            )
          else
            SizedBox(
              height: 28,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: value,
                  hint: Text(
                    enabled ? 'Pilih $label' : '',
                    style: const TextStyle(fontFamily: 'Inter', fontSize: 14, color: Colors.black54),
                  ),
                  icon: const Icon(Icons.unfold_more, size: 20, color: Colors.black54),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  onChanged: enabled
                      ? (selectedName) {
                          if (selectedName == null) return;
                          final item = items.firstWhere((e) => e['name'] == selectedName);
                          onChanged(item['id']!, item['name']!);
                        }
                      : null,
                  items: items
                      .map((e) => DropdownMenuItem<String>(
                            value: e['name'],
                            child: Text(e['name']!, overflow: TextOverflow.ellipsis),
                          ))
                      .toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(size.width * 0.25, size.height, size.width * 0.5, size.height - 40);
    path.quadraticBezierTo(size.width * 0.75, size.height - 80, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
