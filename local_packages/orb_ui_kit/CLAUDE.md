# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Package Overview

`orb_ui_kit` is the theming package for `orb_test_app`. It provides a Material 3 theming system: `OrbColorScheme` and `OrbTextTheme` (both `ThemeExtension`s), plus `OrbTheme` which assembles full `ThemeData` for light/dark modes. Primary brand color is dark green (`#1B5E20`).

## Quick Reference Commands

```bash
# Run tests
flutter test

# Analyze (inherits strict rules from ../../analysis_options.yaml)
flutter analyze

# Format (120 char line width)
dart format -l 120 lib/ test/
```

## Architecture

Single layer under `lib/src/theme/`:

- `color_theme.dart` — `OrbColorScheme` as `ThemeExtension` (primary/secondary/error/success/warning/surface tokens).
- `orb_text_theme.dart` — `OrbTextTheme` as `ThemeExtension` (Material 3 text scale).
- `orb_theme.dart` — `OrbTheme.light` / `OrbTheme.dark` assemble full `ThemeData`. Also defines `OrbThemeX` extension on `BuildContext` for ergonomic access.

The top-level `lib/orb_ui_kit.dart` re-exports all three.

## Theme Access Pattern

Widgets access theme via `BuildContext` extensions from `orb_theme.dart`:

```dart
context.orbColorScheme  // OrbColorScheme (custom)
context.orbTextTheme    // OrbTextTheme (custom)
context.colorScheme     // Material ColorScheme
context.textTheme       // Material TextTheme
```

## Code Style

Inherits all rules from the parent `analysis_options.yaml` (strict inference, trailing commas, const constructors, 120-char lines).
