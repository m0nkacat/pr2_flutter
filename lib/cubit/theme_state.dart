class ThemeState {
  final bool isDark;
  final double fontScale;

  const ThemeState({this.isDark = false, this.fontScale = 1.0});

  ThemeState copyWith({bool? isDark, double? fontScale}) {
    return ThemeState(
      isDark: isDark ?? this.isDark,
      fontScale: fontScale ?? this.fontScale,
    );
  }
}
