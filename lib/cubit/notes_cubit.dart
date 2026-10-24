import 'package:flutter_bloc/flutter_bloc.dart';

// Состояние — неизменяемый список заметок
class NotesCubit extends Cubit<List<String>> {
  NotesCubit() : super(const []);

  // Добавление новой заметки
  void addNote(String text) {
    final note = text.trim();
    if (note.isEmpty) return;
    emit([...state, note]);
  }

  // Редактирование заметки по индексу
  void editNote(int index, String text) {
    final note = text.trim();
    if (note.isEmpty) return;
    final notes = [...state];
    notes[index] = note;
    emit(notes);
  }

  // Удаление заметки по индексу
  void deleteNote(int index) {
    final notes = [...state]..removeAt(index);
    emit(notes);
  }
}
