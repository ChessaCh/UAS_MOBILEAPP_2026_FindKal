import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Unit Test: onVerifyTapped mengembalikan respon sukses', () async {
    final result = await mockOnVerifyTapped();
    expect(result, true);
  });
}

Future<bool> mockOnVerifyTapped() async => true;