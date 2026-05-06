import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Unit Test: Mock mendapatkan kordinat lokasi saat ini', () async {
    final location = await mockGetCurrentPosition();
    expect(location, 'Lat: -6.2, Lng: 106.8');
  });
}

// Mock service Geolocator
Future<String> mockGetCurrentPosition() async {
  await Future.delayed(const Duration(milliseconds: 100));
  return 'Lat: -6.2, Lng: 106.8';
}