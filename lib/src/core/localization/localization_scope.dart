import 'package:flutter/widgets.dart';
import 'package:orb_test_app/src/core/init/app_dependencies_scope.dart';
import 'package:orb_test_app/src/core/storage/key_value_storage.dart';

const _kLocaleKey = 'localization.locale';

class LocaleNotifier extends ValueNotifier<Locale?> {
  LocaleNotifier(this._storage) : super(_read(_storage));

  final KeyValueStorage _storage;

  static Locale? _read(KeyValueStorage storage) {
    final tag = storage.readString(_kLocaleKey);
    return tag == null ? null : Locale(tag);
  }

  Future<void> setLocale(Locale? locale) async {
    value = locale;
    if (locale == null) {
      await _storage.remove(_kLocaleKey);
    } else {
      await _storage.writeString(_kLocaleKey, locale.toLanguageTag());
    }
  }
}

class LocalizationScope extends StatefulWidget {
  const LocalizationScope({required this.child, super.key});

  final Widget child;

  static Locale? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_LocalizationNotifier>()?.notifier?.value;

  static LocaleNotifier controllerOf(BuildContext context) {
    final notifier = context.getInheritedWidgetOfExactType<_LocalizationNotifier>()?.notifier;
    if (notifier == null) {
      throw StateError('LocalizationScope not found in context');
    }
    return notifier;
  }

  @override
  State<LocalizationScope> createState() => _LocalizationScopeState();
}

class _LocalizationScopeState extends State<LocalizationScope> {
  late final LocaleNotifier _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = LocaleNotifier(context.keyValueStorage);
  }

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      _LocalizationNotifier(notifier: _notifier, child: widget.child);
}

class _LocalizationNotifier extends InheritedNotifier<LocaleNotifier> {
  const _LocalizationNotifier({required super.notifier, required super.child});
}

extension LocalizationScopeContextX on BuildContext {
  /// User's locale override. `null` means "follow the system locale".
  /// For the effectively-applied locale, use `Localizations.localeOf(context)`.
  Locale? get localeSetting => LocalizationScope.of(this);

  LocaleNotifier get localizationController => LocalizationScope.controllerOf(this);
}
