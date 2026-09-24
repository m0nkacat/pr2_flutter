import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pr2/main.dart';

void main() {
  testWidgets('Добавление, редактирование и удаление заметки', (tester) async {
    await tester.pumpWidget(const NotesApp());
    expect(find.text('Заметок пока нет'), findsOneWidget);

    // Добавление
    await tester.enterText(find.byType(TextField), 'Купить хлеб');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Сохранить'));
    await tester.pump();
    expect(find.text('Купить хлеб'), findsOneWidget);

    // Редактирование
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, 'Купить молоко');
    await tester.tap(find.widgetWithText(FilledButton, 'Сохранить'));
    await tester.pumpAndSettle();
    expect(find.text('Купить молоко'), findsOneWidget);
    expect(find.text('Купить хлеб'), findsNothing);

    // Удаление
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pump();
    expect(find.text('Купить молоко'), findsNothing);
    expect(find.text('Заметок пока нет'), findsOneWidget);
  });
}
