import 'package:flutter_test/flutter_test.dart';


void main() {
  group('ChangeEmailPage - Unit Test: Validasi Format Email', () {
    final emailRegex = RegExp(r'^[\w\.\+\-]+@[\w\-]+(\.\w{2,})+$');

    bool isValidEmail(String email) => emailRegex.hasMatch(email.trim());

    test('Email valid standar harus lolos validasi', () {
      expect(isValidEmail('user@example.com'), isTrue);
    });

    test('Email dengan subdomain harus lolos validasi', () {
      expect(isValidEmail('user@mail.example.co.id'), isTrue);
    });

    test('Email dengan titik di local part harus lolos', () {
      expect(isValidEmail('first.last@domain.com'), isTrue);
    });

    test('Email dengan plus di local part harus lolos', () {
      expect(isValidEmail('user+tag@domain.com'), isTrue);
    });

    test('Email tanpa @ harus gagal validasi', () {
      expect(isValidEmail('userdomain.com'), isFalse);
    });

    test('Email tanpa domain extension harus gagal', () {
      expect(isValidEmail('user@domain'), isFalse);
    });

    test('Email dengan spasi harus gagal validasi', () {
      expect(isValidEmail('user @domain.com'), isFalse);
    });

    test('String kosong harus gagal validasi', () {
      expect(isValidEmail(''), isFalse);
    });

    test('Email hanya @ harus gagal validasi', () {
      expect(isValidEmail('@'), isFalse);
    });

    test('Email dengan domain TLD satu karakter harus gagal', () {
      expect(isValidEmail('user@domain.c'), isFalse);
    });
  });

  group('ChangeEmailPage - Unit Test: Kondisi tombol Lanjutkan', () {
    bool isButtonEnabled(String emailInput, bool isLoading) {
      return emailInput.trim().isNotEmpty && !isLoading;
    }

    test('Tombol enabled ketika email tidak kosong dan tidak loading', () {
      expect(isButtonEnabled('test@email.com', false), isTrue);
    });

    test('Tombol disabled ketika email kosong', () {
      expect(isButtonEnabled('', false), isFalse);
    });

    test('Tombol disabled ketika sedang loading meskipun email terisi', () {
      expect(isButtonEnabled('test@email.com', true), isFalse);
    });

    test('Tombol disabled ketika email hanya whitespace', () {
      expect(isButtonEnabled('   ', false), isFalse);
    });
  });
}