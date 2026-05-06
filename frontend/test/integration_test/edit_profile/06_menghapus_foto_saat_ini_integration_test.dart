import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:findkal/services/auth_state.dart';
import 'package:findkal/profile/profile.dart';
import 'dart:io';
import 'dart:convert';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Create a dummy file to act as the profile photo
  final dummyFile = File('dummy_photo.png');

  setUpAll(() async {
    if (!await dummyFile.exists()) {
      // 1x1 transparent PNG
      final bytes = base64Decode('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=');
      await dummyFile.writeAsBytes(bytes);
    }
  });

  tearDownAll(() async {
    if (await dummyFile.exists()) {
      await dummyFile.delete();
    }
  });

  group('06 Menghapus foto saat ini', () {
    testWidgets('Verify tap on Hapus foto profil', (WidgetTester tester) async {
      AuthState.currentUser = {
        'id': 1,
        'name': 'Test User',
        'profile_photo': dummyFile.path, // Use local file instead of network to avoid NetworkImage exceptions
      };
      
      await tester.pumpWidget(const MaterialApp(home: ProfilePage())); 
      await tester.pumpAndSettle();

      await tester.tap(find.text('Edit Profil'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(find.byType(CircleAvatar).first);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Assert Hapus option exists
      expect(find.text('Hapus foto profil'), findsOneWidget);

      await tester.tap(find.text('Hapus foto profil'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Bottom sheet should be gone
      expect(find.text('Hapus foto profil'), findsNothing);
    });
  });
}
