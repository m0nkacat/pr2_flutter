import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/notes_cubit.dart';
import 'cubit/theme_cubit.dart';
import 'cubit/theme_state.dart';

void main() {
  // Оба Cubit создаются один раз и доступны всему приложению
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => NotesCubit()),
      ],
      child: const NotesApp(),
    ),
  );
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Приложение перестраивается при каждом новом состоянии темы
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Заметки',
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: const Color(0xFF5362FF),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: const Color(0xFF5362FF),
            brightness: Brightness.dark,
          ),
          themeMode: themeState.isDark ? ThemeMode.dark : ThemeMode.light,
          // Масштаб шрифта для всего приложения
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(themeState.fontScale)),
            child: child!,
          ),
          home: const NotesScreen(),
        );
      },
    );
  }
}

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final TextEditingController _controller = TextEditingController();

  // Добавление новой заметки
  void _saveNote() {
    context.read<NotesCubit>().addNote(_controller.text);
    _controller.clear();
  }

  // Удаление заметки по индексу
  void _deleteNote(int index) {
    context.read<NotesCubit>().deleteNote(index);
  }

  // Редактирование заметки в диалоговом окне
  Future<void> _editNote(int index) async {
    final cubit = context.read<NotesCubit>();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => EditNoteDialog(initialText: cubit.state[index]),
    );
    if (result != null) {
      cubit.editNote(index, result);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Заметки'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.text_decrease),
            tooltip: 'Уменьшить шрифт',
            onPressed: () => context.read<ThemeCubit>().decreaseFont(),
          ),
          IconButton(
            icon: const Icon(Icons.text_increase),
            tooltip: 'Увеличить шрифт',
            onPressed: () => context.read<ThemeCubit>().increaseFont(),
          ),
          IconButton(
            icon: Icon(
              context.watch<ThemeCubit>().state.isDark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            tooltip: 'Сменить тему',
            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Поле ввода
            TextField(
              controller: _controller,
              maxLines: null,
              decoration: const InputDecoration(
                labelText: 'Текст заметки',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Кнопка сохранения
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveNote,
                child: const Text('Сохранить'),
              ),
            ),
            const SizedBox(height: 16),

            // Список заметок перестраивается при каждом новом состоянии NotesCubit
            Expanded(
              child: BlocBuilder<NotesCubit, List<String>>(
                builder: (context, notes) => notes.isEmpty
                    ? const Center(child: Text('Заметок пока нет'))
                    : ListView.builder(
                        itemCount: notes.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              title: Text(notes[index]),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    tooltip: 'Редактировать',
                                    onPressed: () => _editNote(index),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    tooltip: 'Удалить',
                                    onPressed: () => _deleteNote(index),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Диалоговое окно редактирования заметки
class EditNoteDialog extends StatefulWidget {
  const EditNoteDialog({super.key, required this.initialText});

  final String initialText;

  @override
  State<EditNoteDialog> createState() => _EditNoteDialogState();
}

class _EditNoteDialogState extends State<EditNoteDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialText,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Редактировать заметку'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        maxLines: null,
        decoration: const InputDecoration(border: OutlineInputBorder()),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _controller.text.trim()),
          child: const Text('Сохранить'),
        ),
      ],
    );
  }
}
