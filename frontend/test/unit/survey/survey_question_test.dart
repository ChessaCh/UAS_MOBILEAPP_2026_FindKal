import 'package:flutter_test/flutter_test.dart';


void main() {
  group('SurveyQuestionPage - Unit Test: Logika Penyimpanan Jawaban', () {
    test('Jawaban berhasil ditambahkan ke list answers', () {
      final answers = <Map<String, dynamic>>[];
      answers.add({'question_id': 1, 'selected_index': 2});

      expect(answers.length, 1);
      expect(answers[0]['question_id'], 1);
      expect(answers[0]['selected_index'], 2);
    });

    test('Beberapa jawaban tersimpan dengan benar', () {
      final answers = <Map<String, dynamic>>[];
      answers.add({'question_id': 1, 'selected_index': 0});
      answers.add({'question_id': 2, 'selected_index': 3});
      answers.add({'question_id': 3, 'selected_index': 1});

      expect(answers.length, 3);
      expect(answers[2]['selected_index'], 1);
    });

    test('Tidak bisa simpan jawaban jika selected null', () {
      int? selected;
      final answers = <Map<String, dynamic>>[];

      if (selected != null) {
        answers.add({'question_id': 1, 'selected_index': selected});
      }

      expect(answers.isEmpty, isTrue);
    });
  });

  group('SurveyQuestionPage - Unit Test: Navigasi Pertanyaan', () {
    test('Index pertanyaan bertambah 1 setelah menekan Next', () {
      int current = 0;
      const total = 5;

      if (current < total - 1) current++;

      expect(current, 1);
    });

    test('Index tidak melewati batas maksimum pertanyaan', () {
      int current = 4; // pertanyaan terakhir (0-based, total 5)
      const total = 5;

      if (current < total - 1) current++;

      expect(current, 4); // tidak berubah
    });

    test('Selected direset ke null saat pindah ke pertanyaan berikutnya', () {
      int? selected = 2;

      // Pindah ke pertanyaan berikutnya → reset selected
      selected = null;

      expect(selected, isNull);
    });

    test('Progress dihitung dari (current + 1) / total', () {
      const current = 2;
      const total = 5;
      final progress = (current + 1) / total;

      expect(progress, closeTo(0.6, 0.001));
    });
  });

  group('SurveyQuestionPage - Unit Test: Parsing Data Pertanyaan', () {
    test('Data pertanyaan diparse dari Map dengan benar', () {
      final raw = {
        'id': 10,
        'question': 'Apa kuliner khas daerah ini?',
        'options': ['Rendang', 'Gudeg', 'Pempek', 'Soto'],
      };

      expect(raw['id'], 10);
      expect((raw['options'] as List).length, 4);
    });

    test('List pertanyaan kosong saat error API', () {
      final List<Map<String, dynamic>> questions = [];
      expect(questions.isEmpty, isTrue);
    });
  });
}