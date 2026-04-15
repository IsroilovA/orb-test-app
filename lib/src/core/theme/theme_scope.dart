import 'package:flutter/material.dart';
import 'package:orb_test_app/src/app/root_scope.dart';
import 'package:orb_test_app/src/core/storage/key_value_storage.dart';

const _kThemeModeKey = 'theme.mode';

class ThemeModeNotifier extends ValueNotifier<ThemeMode> {
  ThemeModeNotifier(this._storage) : super(_decode(_storage.readString(_kThemeModeKey)));

  final KeyValueStorage _storage;

  Future<void> setThemeMode(ThemeMode mode) async {
    value = mode;
    await _storage.writeString(_kThemeModeKey, _encode(mode));
  }

  static ThemeMode _decode(String? raw) => switch (raw) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };

  static String _encode(ThemeMode mode) => switch (mode) {
    ThemeMode.light => 'light',
    ThemeMode.dark => 'dark',
    ThemeMode.system => 'system',
  };
}

class ThemeScope extends StatefulWidget {
  const ThemeScope({required this.child, super.key});

  final Widget child;

  static ThemeMode of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_ThemeNotifier>()?.notifier?.value ?? ThemeMode.system;

  static ThemeModeNotifier controllerOf(BuildContext context) {
    final notifier = context.getInheritedWidgetOfExactType<_ThemeNotifier>()?.notifier;
    if (notifier == null) {
      throw StateError('ThemeScope not found in context');
    }
    return notifier;
  }

  @override
  State<ThemeScope> createState() => _ThemeScopeState();
}

class _ThemeScopeState extends State<ThemeScope> {
  late final ThemeModeNotifier _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = ThemeModeNotifier(context.keyValueStorage);
  }

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _ThemeNotifier(notifier: _notifier, child: widget.child);
}

class _ThemeNotifier extends InheritedNotifier<ThemeModeNotifier> {
  const _ThemeNotifier({required super.notifier, required super.child});
}

extension ThemeScopeContextX on BuildContext {
  ThemeMode get themeModeSetting => ThemeScope.of(this);
  ThemeModeNotifier get themeModeController => ThemeScope.controllerOf(this);
}
