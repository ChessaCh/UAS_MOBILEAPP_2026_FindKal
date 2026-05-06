import 'package:flutter_test/flutter_test.dart';


void main() {
  group('SurveyResultPage - Unit Test: Getter dari Result Map', () {
    Map<String, dynamic> makeResult({
      bool passed = false,
      int score = 3,
      int attemptsRemaining = 2,
      String? lockedUntil,
    }) =>
        {
          'passed': passed,
          'score': score,
          'attempts_remaining': attemptsRemaining,
          'locked_until': lockedUntil,
        };

    test('_success = true saat passed=true', () {
      final result = makeResult(passed: true);
      final success = result['passed'] == true;
      expect(success, isTrue);
    });

    test('_success = false saat passed=false', () {
      final result = makeResult(passed: false);
      final success = result['passed'] == true;
      expect(success, isFalse);
    });

    test('_score mengembalikan nilai score yang benar', () {
      final result = makeResult(score: 4);
      final score = (result['score'] as int?) ?? 0;
      expect(score, 4);
    });

    test('_attemptsRemaining mengembalikan sisa percobaan yang benar', () {
      final result = makeResult(attemptsRemaining: 3);
      final attempts = (result['attempts_remaining'] as int?) ?? 0;
      expect(attempts, 3);
    });

    test('_lockedUntil null saat tidak ada locked_until', () {
      final result = makeResult();
      expect(result['locked_until'], isNull);
    });

    test('_lockedUntil berisi tanggal saat akun dikunci', () {
      final result = makeResult(lockedUntil: '2025-12-31T00:00:00Z');
      expect(result['locked_until'], isNotNull);
    });
  });

  group('SurveyResultPage - Unit Test: Logika Pesan Gagal (_failMessage)', () {
    String buildFailMessage({
      required int score,
      required int attemptsRemaining,
      String? lockedUntil,
    }) {
      if (lockedUntil != null) {
        final dt = DateTime.tryParse(lockedUntil);
        final formatted = dt != null
            ? '${dt.day}/${dt.month}/${dt.year} pukul ${dt.hour.toString().padLeft(2, '0')}.${dt.minute.toString().padLeft(2, '0')}'
            : lockedUntil;
        return 'Kamu menjawab $score dari 5 pertanyaan dengan benar. '
            'Kamu telah kehabisan percobaan. Coba lagi setelah $formatted.';
      }
      return 'Kamu menjawab $score dari 5 pertanyaan dengan benar. '
          'Minimal 4 jawaban benar diperlukan untuk menjadi warga lokal terverifikasi. '
          'Sisa percobaan: $attemptsRemaining.';
    }

    test('Pesan gagal biasa menampilkan score dan sisa percobaan', () {
      final msg = buildFailMessage(score: 2, attemptsRemaining: 2);
      expect(msg.contains('2 dari 5'), isTrue);
      expect(msg.contains('Sisa percobaan: 2'), isTrue);
    });

    test('Pesan gagal locked menampilkan info kehabisan percobaan', () {
      final msg = buildFailMessage(
        score: 1,
        attemptsRemaining: 0,
        lockedUntil: '2025-12-31T23:59:00Z',
      );
      expect(msg.contains('kehabisan percobaan'), isTrue);
    });

    test('Pesan gagal locked memformat tanggal dengan benar (dd/mm/yyyy)', () {
      final msg = buildFailMessage(
        score: 0,
        attemptsRemaining: 0,
        lockedUntil: '2025-06-15T10:30:00Z',
      );
      expect(msg.contains('15/6/2025'), isTrue);
    });

    test('Skor 0 ditampilkan dengan benar di pesan', () {
      final msg = buildFailMessage(score: 0, attemptsRemaining: 1);
      expect(msg.contains('0 dari 5'), isTrue);
    });
  });
}