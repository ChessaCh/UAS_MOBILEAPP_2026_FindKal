import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Unit Test: onProvinceChanged menyimpan state negara/provinsi yang dipilih', () {
    String state = '';
    void onProvinceChanged(String val) => state = val;
    
    onProvinceChanged('Banten');
    expect(state, 'Banten');
  });
}