import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo_app/firebase_options.dart';
import 'package:todo_app/screens/todo_screen.dart';
import 'package:todo_app/services/firebase_service.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late FirebaseService firebaseService;

  setUpAll(() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebaseService = FirebaseService();
  });

  Widget createTestApp() {
    return MaterialApp(
      home: TodoScreen(service: firebaseService),
    );
  }

  group('Real Firebase DB Tests', () {
    testWidgets('can add and delete a todo from real DB', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Add a test todo
      final testTitle = 'Test todo ${DateTime.now().millisecondsSinceEpoch}';
      await tester.enterText(find.byType(TextField).first, testTitle);
      await tester.pump();

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify it appears
      expect(find.text(testTitle), findsOneWidget);

      // Clean up - delete the test todo
      await tester.drag(find.text(testTitle), const Offset(-500, 0));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify it's gone
      expect(find.text(testTitle), findsNothing);
    });

    testWidgets('can toggle todo completion in real DB', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Add a test todo
      final testTitle = 'Toggle test ${DateTime.now().millisecondsSinceEpoch}';
      await tester.enterText(find.byType(TextField).first, testTitle);
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Find and tap the checkbox
      final checkbox = find.descendant(
        of: find.widgetWithText(ListTile, testTitle),
        matching: find.byType(Checkbox),
      );
      await tester.tap(checkbox);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify checkbox is checked
      final checkboxWidget = tester.widget<Checkbox>(checkbox);
      expect(checkboxWidget.value, isTrue);

      // Clean up - delete the test todo
      await tester.drag(find.text(testTitle), const Offset(-500, 0));
      await tester.pumpAndSettle(const Duration(seconds: 2));
    });
  });
}
