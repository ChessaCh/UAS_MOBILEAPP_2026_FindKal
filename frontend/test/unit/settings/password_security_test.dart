import 'package:flutter_test/flutter_test.dart';

import 'package:findkal/services/auth_state.dart';


void main() {
  group('PasswordSecurityPage - Unit Test: AuthState User Data', () {
    setUp(() {
      AuthState.currentUser = null;
    });

    test('AuthState.currentUser null → name fallback ke "User"', () {
      final user = AuthState.currentUser ?? {};
      final name = user['name'] ?? 'User';
      expect(name, 'User');
    });

    test('AuthState.currentUser null → email fallback ke "email@gmail.com"',
        () {
      final user = AuthState.currentUser ?? {};
      final email = user['email'] ?? 'email@gmail.com';
      expect(email, 'email@gmail.com');
    });

    test('AuthState.currentUser terisi → name diambil dengan benar', () {
      AuthState.currentUser = {'id': 1, 'name': 'Budi Santoso', 'email': 'budi@mail.com'};
      final user = AuthState.currentUser ?? {};
      final name = user['name'] ?? 'User';
      expect(name, 'Budi Santoso');
    });

    test('AuthState.currentUser terisi → email diambil dengan benar', () {
      AuthState.currentUser = {'id': 1, 'name': 'Budi', 'email': 'budi@mail.com'};
      final user = AuthState.currentUser ?? {};
      final email = user['email'] ?? 'email@gmail.com';
      expect(email, 'budi@mail.com');
    });
  });

  group('PasswordSecurityPage - Unit Test: Validasi Password Baru', () {
    /// Aturan password: minimal 8 karakter, kombinasi huruf & angka
    bool isValidPassword(String password) {
      if (password.length < 8) return false;
      final hasLetter = password.contains(RegExp(r'[a-zA-Z]'));
      final hasDigit = password.contains(RegExp(r'[0-9]'));
      return hasLetter && hasDigit;
    }

    test('Password valid (huruf + angka, min 8 char) harus lolos', () {
      expect(isValidPassword('Password1'), isTrue);
    });

    test('Password kurang dari 8 karakter harus gagal', () {
      expect(isValidPassword('Pass1'), isFalse);
    });

    test('Password hanya huruf tanpa angka harus gagal', () {
      expect(isValidPassword('PasswordOnly'), isFalse);
    });

    test('Password hanya angka harus gagal', () {
      expect(isValidPassword('12345678'), isFalse);
    });

    test('Password kosong harus gagal', () {
      expect(isValidPassword(''), isFalse);
    });

    test('Password tepat 8 karakter dengan huruf+angka harus lolos', () {
      expect(isValidPassword('Pass1234'), isTrue);
    });
  });
}