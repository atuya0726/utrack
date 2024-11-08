import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff001373),
      surfaceTint: Color(0xff4655b6),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff29399a),
      onPrimaryContainer: Color(0xffd6d9ff),
      secondary: Color(0xff575c83),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffd4d7ff),
      onSecondaryContainer: Color(0xff3b4065),
      tertiary: Color(0xff400051),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff69257a),
      onTertiaryContainer: Color(0xfffbccff),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      surface: Color(0xfffbf8ff),
      onSurface: Color(0xff1b1b21),
      onSurfaceVariant: Color(0xff454652),
      outline: Color(0xff767683),
      outlineVariant: Color(0xffc6c5d4),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff303037),
      inversePrimary: Color(0xffbbc3ff),
      primaryFixed: Color(0xffdfe0ff),
      onPrimaryFixed: Color(0xff000e5f),
      primaryFixedDim: Color(0xffbbc3ff),
      onPrimaryFixedVariant: Color(0xff2d3c9d),
      secondaryFixed: Color(0xffdfe0ff),
      onSecondaryFixed: Color(0xff13183b),
      secondaryFixedDim: Color(0xffbfc4f0),
      onSecondaryFixedVariant: Color(0xff3f446a),
      tertiaryFixed: Color(0xfffdd6ff),
      onTertiaryFixed: Color(0xff340042),
      tertiaryFixedDim: Color(0xfff4aeff),
      onTertiaryFixedVariant: Color(0xff6c287e),
      surfaceDim: Color(0xffdbd9e2),
      surfaceBright: Color(0xfffbf8ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff5f2fb),
      surfaceContainer: Color(0xffefedf6),
      surfaceContainerHigh: Color(0xffe9e7f0),
      surfaceContainerHighest: Color(0xffe3e1ea),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
      );
}
