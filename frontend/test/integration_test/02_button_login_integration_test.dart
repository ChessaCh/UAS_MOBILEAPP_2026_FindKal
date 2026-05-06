import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Integration Test: Tap Button Login dan memicu proses', (WidgetTester tester) async {
    // Membuat state untuk menguji perubahan UI setelah tombol ditekan
    await tester.pumpWidget(
      MaterialApp(
        home: const LoginMockPage(),
      ),
    );
    await tester.pumpAndSettle();

    final loginButton = find.byKey(const Key('btn_login'));
    
    // Pastikan teks belum ada sebelum ditekan
    expect(find.text('Login Berhasil'), findsNothing);

    // Tap tombol di emulator
    await tester.tap(loginButton);
    await tester.pumpAndSettle(); // Tunggu setstate / navigasi selesai

    // Pastikan UI menampilkan hasil proses login
    expect(find.text('Login Berhasil'), findsOneWidget);
  });
}


class LoginMockPage extends StatefulWidget {
  const LoginMockPage({Key? key}) : super(key: key);

  @override
  State<LoginMockPage> createState() => _LoginMockPageState();
}

class _LoginMockPageState extends State<LoginMockPage> {
  String status = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(status),
          ElevatedButton(
            key: const Key('btn_login'),
            onPressed: () {
              setState(() {
                status = 'Login Berhasil';
              });
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}