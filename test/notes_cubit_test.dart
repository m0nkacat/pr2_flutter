import 'package:flutter_test/flutter_test.dart';

import 'package:pr2/cubit/notes_cubit.dart';

void main() {
  test('NotesCubit добавляет, редактирует и удаляет заметки', () {
    final cubit = NotesCubit();
    expect(cubit.state, isEmpty);

    cubit.addNote('  Купить хлеб  ');
    cubit.addNote('   ');
    expect(cubit.state, ['Купить хлеб']);

    cubit.editNote(0, 'Купить молоко');
    expect(cubit.state, ['Купить молоко']);

    cubit.deleteNote(0);
    expect(cubit.state, isEmpty);

    cubit.close();
  });
}
