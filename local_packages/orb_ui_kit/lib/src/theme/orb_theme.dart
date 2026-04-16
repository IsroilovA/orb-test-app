import 'package:flutter/material.dart';
import 'package:orb_ui_kit/orb_ui_kit.dart';

OrbColorScheme get _lightColors => const OrbColorScheme(
  primary: Color(0xFF1B5E20),
  onPrimary: Colors.white,
  primaryContainer: Colors.white,
  onPrimaryContainer: Color(0xFF1B5E20),
  secondary: Color(0xFF1B5E20),
  onSecondary: Colors.white,
  secondaryContainer: Colors.white,
  onSecondaryContainer: Color(0xFF1B5E20),
  error: Color(0xFFBA1A1A),
  onError: Colors.white,
  errorContainer: Color(0xFFFFDAD6),
  onErrorContainer: Color(0xFF410002),
  success: Color(0xFF2E7D32),
  onSuccess: Colors.white,
  successContainer: Color(0xFFC8E6C9),
  onSuccessContainer: Color(0xFF0B2E0E),
  warning: Color(0xFFED8B00),
  onWarning: Colors.white,
  warningContainer: Color(0xFFFFE0B2),
  onWarningContainer: Color(0xFF4B2800),
  surfaceDim: Color(0xFFF4F6F4),
  surface: Colors.white,
  surfaceBright: Colors.white,
  surfaceContainerLowest: Colors.white,
  surfaceContainerLow: Color(0xFFFAFCFA),
  surfaceContainer: Color(0xFFF5F8F5),
  surfaceContainerHigh: Color(0xFFEFF2EF),
  surfaceContainerHighest: Color(0xFFE8EBE8),
  onSurface: Color(0xFF121714),
  onSurfaceVariant: Color(0xFF64706A),
  outline: Color(0xFFA8B2AC),
  outlineVariant: Color(0xFFD3D8D4),
);

OrbColorScheme get _darkColors => const OrbColorScheme(
  primary: Color(0xFF1B5E20),
  onPrimary: Colors.white,
  primaryContainer: Colors.black,
  onPrimaryContainer: Colors.white,
  secondary: Color(0xFF1B5E20),
  onSecondary: Colors.white,
  secondaryContainer: Colors.black,
  onSecondaryContainer: Colors.white,
  error: Color(0xFFFFB4AB),
  onError: Color(0xFF690005),
  errorContainer: Color(0xFF93000A),
  onErrorContainer: Color(0xFFFFDAD6),
  success: Color(0xFF81C784),
  onSuccess: Color(0xFF08310A),
  successContainer: Color(0xFF1B5E20),
  onSuccessContainer: Color(0xFFC8E6C9),
  warning: Color(0xFFFFB74D),
  onWarning: Color(0xFF3B1E00),
  warningContainer: Color(0xFF5D3A00),
  onWarningContainer: Color(0xFFFFE0B2),
  surfaceDim: Color(0xFF040504),
  surface: Color(0xFF070807),
  surfaceBright: Color(0xFF171A18),
  surfaceContainerLowest: Color(0xFF030403),
  surfaceContainerLow: Color(0xFF090B09),
  surfaceContainer: Color(0xFF0D100E),
  surfaceContainerHigh: Color(0xFF121512),
  surfaceContainerHighest: Color(0xFF171A18),
  onSurface: Color(0xFFF2F4F2),
  onSurfaceVariant: Color(0xFF9AA6A0),
  outline: Color(0xFF2B302D),
  outlineVariant: Color(0xFF21262A),
);

ThemeData appThemeFromBrightness(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final colorTheme = switch (brightness) {
    Brightness.light => _lightColors,
    Brightness.dark => _darkColors,
  };

  final textTheme = OrbTextTheme.fromColorTheme(colorTheme);
  final buttonShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(12));
  final inputBorder = OutlineInputBorder(borderRadius: BorderRadius.circular(4));

  return ThemeData(
    useMaterial3: true,
    disabledColor: Color.alphaBlend(
      colorTheme.onSurface.withValues(alpha: isDark ? 0.16 : 0.12),
      colorTheme.surface,
    ),
    primaryColor: colorTheme.primary,
    scaffoldBackgroundColor: colorTheme.surface,
    shadowColor: colorTheme.onSurface.withValues(alpha: isDark ? 0.7 : 0.5),
    hintColor: colorTheme.outlineVariant,
    dividerColor: colorTheme.outlineVariant,
    fontFamily: OrbTextTheme.fontFamily,
    extensions: <ThemeExtension<dynamic>>[colorTheme, textTheme],
    textTheme: textTheme.material,
    colorScheme: ColorScheme(
      brightness: brightness,
      primary: colorTheme.primary,
      onPrimary: colorTheme.onPrimary,
      primaryContainer: colorTheme.primaryContainer,
      onPrimaryContainer: colorTheme.onPrimaryContainer,
      secondary: colorTheme.secondary,
      onSecondary: colorTheme.onSecondary,
      secondaryContainer: colorTheme.secondaryContainer,
      onSecondaryContainer: colorTheme.onSecondaryContainer,
      error: colorTheme.error,
      onError: colorTheme.onError,
      errorContainer: colorTheme.errorContainer,
      onErrorContainer: colorTheme.onErrorContainer,
      surface: colorTheme.surface,
      surfaceBright: colorTheme.surfaceBright,
      surfaceContainerLowest: colorTheme.surfaceContainerLowest,
      surfaceContainerLow: colorTheme.surfaceContainerLow,
      surfaceContainer: colorTheme.surfaceContainer,
      surfaceContainerHigh: colorTheme.surfaceContainerHigh,
      surfaceContainerHighest: colorTheme.surfaceContainerHighest,
      surfaceDim: colorTheme.surfaceDim,
      onSurface: colorTheme.onSurface,
      onSurfaceVariant: colorTheme.onSurfaceVariant,
      outline: colorTheme.outline,
      outlineVariant: colorTheme.outlineVariant,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      leadingWidth: 56,
      scrolledUnderElevation: 0,
      backgroundColor: colorTheme.surface,
      centerTitle: true,
      foregroundColor: colorTheme.onSurface,
    ),
    navigationBarTheme: NavigationBarThemeData(indicatorColor: colorTheme.primary),
    cardTheme: CardThemeData(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: colorTheme.surfaceContainerLow,
      shadowColor: colorTheme.onSurface.withValues(alpha: isDark ? 0.8 : 0.7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorTheme.outline.withValues(alpha: isDark ? 0.9 : 0.6)),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      showDragHandle: true,
      backgroundColor: colorTheme.surface,
      modalElevation: 2,
      modalBackgroundColor: colorTheme.surface,
      shadowColor: colorTheme.onSurface.withValues(alpha: isDark ? 0.7 : 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        side: BorderSide(color: colorTheme.outlineVariant.withValues(alpha: 0.6)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      suffixIconColor: colorTheme.onSurfaceVariant,
      prefixIconColor: colorTheme.onSurfaceVariant,
      labelStyle: textTheme.bodyLarge.copyWith(color: colorTheme.onSurface),
      errorStyle: textTheme.bodySmall.copyWith(color: colorTheme.error),
      helperStyle: textTheme.bodySmall.copyWith(color: colorTheme.onSurfaceVariant),
      prefixStyle: textTheme.bodyLarge.copyWith(color: colorTheme.onSurfaceVariant),
      suffixStyle: textTheme.bodyLarge.copyWith(color: colorTheme.onSurfaceVariant),
      hintStyle: textTheme.bodyLarge.copyWith(color: colorTheme.outlineVariant),
      hoverColor: colorTheme.primary,
      focusColor: colorTheme.primary,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      filled: true,
      fillColor: isDark ? colorTheme.surfaceContainer : colorTheme.surfaceContainerLow,
      border: InputBorder.none,
      errorBorder: inputBorder.copyWith(borderSide: BorderSide(width: 2, color: colorTheme.error)),
      focusedErrorBorder: inputBorder.copyWith(
        borderSide: BorderSide(width: 2, color: colorTheme.error),
      ),
      focusedBorder: inputBorder.copyWith(
        borderSide: BorderSide(width: 2, color: colorTheme.primary),
      ),
      enabledBorder: inputBorder.copyWith(borderSide: BorderSide(color: colorTheme.outline)),
      disabledBorder: inputBorder.copyWith(
        borderSide: BorderSide(color: colorTheme.onSurfaceVariant.withAlpha(40)),
      ),
    ),
    chipTheme: ChipThemeData(
      padding: EdgeInsets.zero,
      backgroundColor: colorTheme.primary,
      labelStyle: textTheme.labelLarge.copyWith(color: colorTheme.onPrimary),
      shape: const StadiumBorder(),
    ),
    iconTheme: IconThemeData(color: colorTheme.onSurface),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        backgroundColor: colorTheme.primary,
        foregroundColor: colorTheme.onPrimary,
        disabledBackgroundColor: colorTheme.onSurface.withValues(alpha: isDark ? 0.16 : 0.12),
        disabledForegroundColor: colorTheme.onSurface.withValues(alpha: isDark ? 0.38 : 0.38),
        textStyle: textTheme.labelLarge,
        shape: buttonShape,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        foregroundColor: colorTheme.onSurface,
        disabledForegroundColor: colorTheme.onSurface.withValues(alpha: isDark ? 0.38 : 0.38),
        textStyle: textTheme.labelLarge,
        shape: buttonShape,
        side: BorderSide(color: colorTheme.outline),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        foregroundColor: colorTheme.onSurfaceVariant,
        disabledForegroundColor: colorTheme.onSurface.withValues(alpha: isDark ? 0.38 : 0.38),
        textStyle: textTheme.labelLarge,
        shape: buttonShape,
      ),
    ),
  );
}

abstract final class OrbTheme {
  static ThemeData get light => appThemeFromBrightness(Brightness.light);

  static ThemeData get dark => appThemeFromBrightness(Brightness.dark);
}

extension OrbThemeX on BuildContext {
  ThemeData get themeData => Theme.of(this);

  TextTheme get textTheme => TextTheme.of(this);

  OrbTextTheme get orbTextTheme => Theme.of(this).extension<OrbTextTheme>()!;

  ColorScheme get colorScheme => ColorScheme.of(this);

  OrbColorScheme get orbColorScheme => Theme.of(this).extension<OrbColorScheme>()!;
}
