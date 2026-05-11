import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:todo_app/screens/todo_screen.dart';
import 'mock_todo_service.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockTodoService mockService;

  setUp(() {
    mockService = MockTodoService();
  });

  tearDown(() {
    mockService.dispose();
  });

  Widget createTestApp() {
    return MaterialApp(
      home: TodoScreen(service: mockService),
    );
  }

  group('Todo App Integration Tests', () {
    testWidgets('shows empty state when no todos exist', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();
      await tester.pump();

      expect(find.text('No todos yet!\nAdd one above.'), findsOneWidget);
    });

    testWidgets('can add a new todo', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      await tester.enterText(find.byType(TextField).first, 'Buy groceries');
      await tester.pump();

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(find.text('Buy groceries'), findsOneWidget);

      final textField = tester.widget<TextField>(find.byType(TextField).first);
      expect(textField.controller?.text, isEmpty);
    });

    testWidgets('can add todo by pressing Enter', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      await tester.enterText(find.byType(TextField).first, 'Call mom');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(find.text('Call mom'), findsOneWidget);
    });

    testWidgets('can toggle todo completion', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      await tester.enterText(find.byType(TextField).first, 'Exercise');
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      final checkbox = find.byType(Checkbox);
      expect(checkbox, findsOneWidget);

      await tester.tap(checkbox);
      await tester.pump();

      final checkboxWidget = tester.widget<Checkbox>(checkbox);
      expect(checkboxWidget.value, isTrue);
    });

    testWidgets('completed todo shows strikethrough', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      await tester.enterText(find.byType(TextField).first, 'Read book');
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      final textWidget = tester.widget<Text>(find.text('Read book'));
      expect(textWidget.style?.decoration, TextDecoration.lineThrough);
    });

    testWidgets('can delete todo by swiping', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      await tester.enterText(find.byType(TextField).first, 'Delete me');
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(find.text('Delete me'), findsOneWidget);

      await tester.drag(find.text('Delete me'), const Offset(-500, 0));
      await tester.pumpAndSettle();

      expect(find.text('Delete me'), findsNothing);
    });

    testWidgets('can edit todo via dialog', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      await tester.enterText(find.byType(TextField).first, 'Original title');
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      await tester.tap(find.text('Original title'));
      await tester.pumpAndSettle();

      expect(find.text('Edit Todo'), findsOneWidget);

      await tester.enterText(find.byType(TextField).last, 'Updated title');
      await tester.pump();

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('Updated title'), findsOneWidget);
      expect(find.text('Original title'), findsNothing);
    });

    testWidgets('can cancel edit dialog', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      await tester.enterText(find.byType(TextField).first, 'Keep me');
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      await tester.tap(find.text('Keep me'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).last, 'Changed');
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Keep me'), findsOneWidget);
    });

    testWidgets('can add multiple todos', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      final todos = ['First todo', 'Second todo', 'Third todo'];
      for (final title in todos) {
        await tester.enterText(find.byType(TextField).first, title);
        await tester.tap(find.byIcon(Icons.add));
        await tester.pump();
      }

      for (final title in todos) {
        expect(find.text(title), findsOneWidget);
      }
    });

    testWidgets('empty input does not add todo', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();
      await tester.pump();

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(find.text('No todos yet!\nAdd one above.'), findsOneWidget);
    });

    testWidgets('whitespace-only input does not add todo', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();
      await tester.pump();

      await tester.enterText(find.byType(TextField).first, '   ');
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(find.text('No todos yet!\nAdd one above.'), findsOneWidget);
    });
  });
}
