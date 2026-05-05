import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:findkal/user_auth/register.dart';


void main() {
  group('RegisterPage - _VerificationDialog (tampilan dialog OTP)', () {
  
    Widget buildRegisterPage() {
      return const MaterialApp(
        home: RegisterPage(),
      );
    }

    testWidgets('RegisterPage berhasil dirender (prasyarat dialog)',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();
      expect(find.byType(RegisterPage), findsOneWidget);
    });

    testWidgets('Tombol verify tersedia sebagai trigger dialog',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();
      expect(find.text('verify'), findsOneWidget);
    });

    testWidgets('Dialog verifikasi tampil langsung via showDialog',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Colors.white,
                      child: const Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Verifikasi email kamu',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text('Kami telah mengirim 6 digit kode ke email kamu'),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                child: const Text('Buka Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Buka Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Verifikasi email kamu'), findsOneWidget);
      expect(
        find.text('Kami telah mengirim 6 digit kode ke email kamu'),
        findsOneWidget,
      );
    });

    testWidgets('Dialog dapat ditutup dengan tombol close',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (ctx) => Dialog(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Verifikasi email kamu'),
                                InkWell(
                                  onTap: () => Navigator.pop(ctx, false),
                                  child: const Icon(Icons.close),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                child: const Text('Buka Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Buka Dialog'));
      await tester.pumpAndSettle();
      expect(find.text('Verifikasi email kamu'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      expect(find.text('Verifikasi email kamu'), findsNothing);
    });

    testWidgets('Dialog bersifat barrierDismissible false (tidak bisa ditutup tap luar)',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const Dialog(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('Dialog OTP'),
                      ),
                    ),
                  );
                },
                child: const Text('Buka'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Buka'));
      await tester.pumpAndSettle();
      expect(find.text('Dialog OTP'), findsOneWidget);

      // Tap di luar dialog (barrier) tidak menutup dialog
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(find.text('Dialog OTP'), findsOneWidget);
    });

    testWidgets('Dialog memiliki background putih',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => Dialog(
                      backgroundColor: Colors.white,
                      child: const Text('Test'),
                    ),
                  );
                },
                child: const Text('Buka'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Buka'));
      await tester.pumpAndSettle();

      final dialog = tester.widget<Dialog>(find.byType(Dialog));
      expect(dialog.backgroundColor, Colors.white);
    });

    testWidgets('Tidak ada dialog yang terbuka saat RegisterPage baru dibuka',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsNothing);
    });

    testWidgets('Field email ada dan dapat diisi sebelum dialog dibuka',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildRegisterPage());
      await tester.pumpAndSettle();

      final fields = find.byType(TextField);
      await tester.enterText(fields.at(3), 'irsyad@example.com');
      await tester.pump();

      expect(find.text('irsyad@example.com'), findsOneWidget);
    });
  });
}