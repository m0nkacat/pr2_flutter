import 'package:flutter_test/flutter_test.dart';

import 'package:pr2/cubit/theme_cubit.dart';

void main() {
  test('ThemeCubit переключает тему и меняет шрифт', () {
    final cubit = ThemeCubit();
    expect(cubit.state.isDark, false);
    expect(cubit.state.fontScale, 1.0);

    cubit.toggleTheme();
    expect(cubit.state.isDark, true);

    for (var i = 0; i < 10; i++) {
      cubit.increaseFont();
    }
    expect(cubit.state.fontScale, 1.4);

    for (var i = 0; i < 10; i++) {
      cubit.decreaseFont();
    }
    expect(cubit.state.fontScale, 0.8);

    cubit.close();
  });
}
