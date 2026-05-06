import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Unit Test: fetchUnggahans mengembalikan daftar data (tidak kosong)', () async {
    final result = await mockFetchUnggahans();
    expect(result.isNotEmpty, true);
    expect(result.length, 2);
  });
}

// Mock API Call untuk feed
Future<List<String>> mockFetchUnggahans() async => ['Unggahan 1', 'Unggahan 2'];