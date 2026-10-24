import 'package:flutter_bloc/flutter_bloc.dart';

import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState());

  void toggleTheme() {
    emit(state.copyWith(isDark: !state.isDark));
  }

  void increaseFont() {
    if (state.fontScale < 1.4) {
      emit(state.copyWith(fontScale: _round(state.fontScale + 0.1)));
    }
  }

  void decreaseFont() {
    if (state.fontScale > 0.8) {
      emit(state.copyWith(fontScale: _round(state.fontScale - 0.1)));
    }
  }

  double _round(double value) => (value * 10).round() / 10;
}
