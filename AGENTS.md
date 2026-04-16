# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

The default stack for this project is **Flutter + BLoC + Helm routing + a custom `ApiClient` middleware chain**. Heavier dependencies (`sqflite`, `hive_ce`, `flutter_secure_storage`, localization, native plugins) are **not** included by default — add them to `pubspec.yaml` only when a concrete feature needs them.

## Quick Reference Commands

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Run all tests
flutter test

# Run a single test file
flutter test test/path/to/test_file.dart

# Run a specific test by name
flutter test --name "test name"

# Format code (100 char line width)
dart format -l 100 lib/ test/

# Analyze (strict lint — fix everything before finalizing)
flutter analyze

# Auto-fix lint issues
dart fix --apply lib
```

## Architecture

**Stack:**
- BLoC state management (`flutter_bloc`, `bloc_concurrency`, `equatable`)
- Helm for declarative routing (`helm`)
- Custom `ApiClient` middleware chain (logger → auth + token refresh → retry)
- `rxdart` for stateful streams in repositories (`BehaviorSubject`)
- `fast_immutable_collections` for `IList`/`ISet`/`IMap`

**Data flow:** `Widget -> BLoC -> Repository (abstract interface + *Impl) -> DataSource (remote API / local)`

**DI & bootstrap:** An `AppDependencies` class under `lib/src/core/init/` lazily wires data sources, repositories, and infrastructure (ApiClient, logger). A `RootScope` widget in `lib/src/app/` creates app-level BLoCs in `initState()` and disposes them in `dispose()`. Feature BLoCs are created on-demand via `BlocProvider` inside the screen that owns them.

**API client:** When the first networked feature is added, build the `ApiClient` under `lib/src/core/api_client/` as a pipeline of composable middlewares (logger, auth + token refresh, retry). Do not reach for `package:http` directly or a bare `Dio` instance from feature code — the middleware chain is the contract and every request goes through it.

**Routing:** Use Helm (`helm: ^0.0.1`) declarative routing. Define routes under `lib/src/core/routing/` and keep screen navigation parameters on typed route classes.

**Not included by default:** no local database, no secure storage, no background sync, no localization, no native plugins, no config JSON. Add any of these when (and only when) a feature requires it.

## Workflow

- Always run `flutter analyze` and fix all lint errors before finishing work on any task.

## Code Style & Formatting

- Always use `package:orb_test_app/...` imports, never relative imports for `lib/`.
- Import grouping: Dart/Flutter SDK first, then third-party, then package imports.
- Line width: 120 characters.
- Single quotes for strings, trailing commas required, `final` for all non-reassigned variables.
- `const` constructors where possible.
- Explicitly declare return types (`always_declare_return_types`).
- Omit local variable types when inferred (`omit_local_variable_types`).
- Naming: files `snake_case.dart`, classes `PascalCase`, methods/variables `camelCase`, constants `lowerCamelCase`.
- Strict analysis: `strict-inference`, `strict-raw-types`, all warnings as errors. See `analysis_options.yaml`.
- Always run `flutter analyze` and fix all issues before finalizing any change.

## Architecture Rules

### Layering

- `Widget -> BLoC -> Repository -> DataSource` — never skip layers.
- No business logic in widgets; no HTTP/DB concerns in BLoCs.
- Repositories: `abstract interface class FooRepository` + `final class FooRepositoryImpl implements FooRepository`.
- Use DTOs when crossing layer boundaries.
- Keep row/transport mapping in `fromJson` factory constructors on DTO/model types, not inline in repositories.
- If model and DTO are structurally identical, unify into a single type.

### Widgets

- One widget per file; no `_buildItem()` helpers — extract standalone widgets instead.
- Colors/styles via `Theme.of(context)`. If strings need i18n later, introduce `flutter_localizations` + ARB files and access via `context.l10n`; plain `String` literals are fine until then.
- Feature-specific widgets live in their feature folder.

### BLoC

Only `Bloc<Event, State>` — **never `Cubit`**. The explicit event model is required for consistency and testability.

**File layout:**

```
features/<feature>/bloc/
  foo_bloc.dart      # contains FooBloc + part directives
  foo_event.dart     # `part of 'foo_bloc.dart';` — sealed FooEvent + subclasses
  foo_state.dart     # `part of 'foo_bloc.dart';` — sealed FooState or single-class FooState
```

**Events** — sealed base + `final class` subclasses, always `const`, always `Equatable`:

```dart
part of 'foo_bloc.dart';

sealed class FooEvent extends Equatable {
  const FooEvent();

  @override
  List<Object?> get props => const <Object?>[];
}

final class FooStarted extends FooEvent {
  const FooStarted();
}

final class FooItemSelected extends FooEvent {
  const FooItemSelected({required this.id});

  final String id;

  @override
  List<Object?> get props => <Object?>[id];
}
```

**States** — pick one of two patterns:

1. **Sealed union** for complex state machines (multi-step flows, auth, editors). Each variant is a `final class extends FooState`; shared getters use `switch` expressions.

   ```dart
   part of 'foo_bloc.dart';

   sealed class FooState extends Equatable {
     const FooState();

     bool get isBusy => switch (this) {
       FooLoading() => true,
       FooIdle() || FooReady() || FooFailure() => false,
     };

     @override
     List<Object?> get props => const <Object?>[];
   }

   final class FooIdle extends FooState {
     const FooIdle();
   }

   final class FooLoading extends FooState {
     const FooLoading();
   }

   final class FooReady extends FooState {
     const FooReady({required this.items});

     final List<FooItem> items;

     @override
     List<Object?> get props => <Object?>[items];
   }

   final class FooFailure extends FooState {
     const FooFailure({required this.error});

     final Object error;

     @override
     List<Object?> get props => <Object?>[error];
   }
   ```

2. **Single class with `copyWith`** for simple features (one list + loading/error flags):

   ```dart
   part of 'foo_bloc.dart';

   final class FooState extends Equatable {
     const FooState({
       this.items = const <FooItem>[],
       this.isLoading = false,
       this.error,
     });

     final List<FooItem> items;
     final bool isLoading;
     final Object? error;

     FooState copyWith({List<FooItem>? items, bool? isLoading, Object? error}) => FooState(
       items: items ?? this.items,
       isLoading: isLoading ?? this.isLoading,
       error: error ?? this.error,
     );

     @override
     List<Object?> get props => <Object?>[items, isLoading, error];
   }
   ```

Both patterns extend `Equatable` and override `props`. No Freezed — states are hand-written.

**Bloc class body** — constructor DI, single `on<FooEvent>` handler with `switch` dispatch, private `_onFoo` methods, `sequential()` transformer when event order matters:

```dart
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orb_test_app/src/features/foo/data/foo_repository.dart';

part 'foo_event.dart';
part 'foo_state.dart';

final class FooBloc extends Bloc<FooEvent, FooState> {
  FooBloc({required FooRepository fooRepository})
    : _fooRepository = fooRepository,
      super(const FooIdle()) {
    on<FooEvent>(
      (event, emit) => switch (event) {
        FooStarted() => _onStarted(event, emit),
        FooItemSelected() => _onItemSelected(event, emit),
      },
      transformer: sequential(),
    );
  }

  final FooRepository _fooRepository;

  Future<void> _onStarted(FooStarted event, Emitter<FooState> emit) async {
    emit(const FooLoading());
    try {
      final items = await _fooRepository.loadItems();
      emit(FooReady(items: items));
    } on Object catch (error) {
      emit(FooFailure(error: error));
    }
  }
}
```

Handler rules:
- Handlers are `Future<void>`; always `await` repository calls.
- Wrap in `try { ... } on Object catch (error) { emit(FooFailure(...)); }` — **never `throw` from a handler**.
- Always `emit` a new state instance; never mutate state.
- Repositories and other collaborators are injected via the constructor and stored as `final` fields.
- Cancel stream subscriptions in `close()` (and close any `BehaviorSubject` you own).

**Consumption in widgets:**
- `BlocConsumer<FooBloc, FooState>` when you need both a builder and listener (toasts, navigation).
- Use `listenWhen` to filter side effects (e.g. only fire when route is current, only on specific states).
- `context.read<FooBloc>()` for one-shot `add(...)` from button callbacks (no rebuild subscription).
- `context.watch` only when the widget genuinely needs to rebuild on every state change and a `BlocBuilder` won't fit.
- `BlocProvider.value` to pass a pre-created Bloc (e.g. from `RootScope`) down into a subtree.

### Repositories / Data Layer

- `abstract interface class FooRepository { ... }` defines the contract; `final class FooRepositoryImpl implements FooRepository` holds the logic.
- Throw typed sealed errors from repositories — do not return `Result`/`Either`:

  ```dart
  sealed class FooError implements Exception {
    const FooError();
  }
  final class FooNotFoundError extends FooError { const FooNotFoundError(); }
  final class FooNetworkError extends FooError { const FooNetworkError({required this.cause}); final Object cause; }
  ```
- BLoC handlers catch `on Object` and emit a failure state; they do not `rethrow`.
- Use `BehaviorSubject` from `rxdart` when a repository needs to expose a seeded stream of state; close it in `dispose()`.

### Models & Types

- Domain models must be immutable (`@immutable`), override `toString()`, provide custom equality/`hashCode` (usually via `Equatable`).
- Prefer enhanced enums (Dart ≥ 2.17) when associating data/behavior with enum values.
- Prefer domain enums over raw strings.
- Prefer `Duration` for time quantities instead of raw `int` milliseconds/minutes.
- Use extension types for semantic primitives to avoid raw `int`/`String` leakage.
- Prefer immutable collections (`IList`/`ISet`/`IMap` from `fast_immutable_collections`) over mutable ones.
- Place model-related methods on the model itself; use extensions if the model is from another package.

### Feature Structure

```
lib/src/
├── app/                 # Root widget, RootScope (app-level BLoC provision)
├── core/                # Infrastructure only — no feature logic
│   ├── api_client/      # ApiClient + middleware (logger, auth, retry)
│   ├── init/            # AppDependencies
│   ├── logging/         # AppLogger, Loggable mixin, AppBlocObserver
│   └── routing/         # Helm routes
├── common/              # App-wide shared widgets/utils (not feature-specific)
└── features/
    └── feature_name/
        ├── bloc/        # foo_bloc.dart + foo_event.dart + foo_state.dart (part files)
        ├── data/        # FooRepository + FooRepositoryImpl + data sources
        ├── widget/      # Screens + feature-local widgets (one widget per file)
        └── common/      # Feature-local models, errors, utils
```

## Logging

Centralized logging lives in `lib/src/core/logging/`. All logging goes through `AppLogger` — **never use `dart:developer` directly**.

- **`AppLogger`** — static facade with leveled methods: `debug`, `info`, `warning`, `error`, `fatal`. Delegates to pluggable `LogOutput` implementations.
- **`Loggable` mixin** — add `with Loggable` to repositories/coordinators, override `String get logTag`, then use `log.info(...)`, `log.error(...)`, etc.
- **`AppBlocObserver`** — global `BlocObserver` set in `main.dart`. Logs BLoC errors (always) and transitions (debug mode only).
- **Tag conventions:** `'orb.<domain>'` for features (e.g. `'orb.counter'`), `'http'`/`'http_cache'` for infrastructure, `'bloc'` for BlocObserver.
- **Widgets** should not use the `Loggable` mixin — use `AppLogger` directly for the rare widget-level log.
- **Adding crash reporting:** implement `LogOutput`, call `AppLogger.addOutput(...)` in `main.dart` — zero call-site changes.

## Testing

- Tests mirror `lib/` structure under `test/`.
- Uses `mocktail` for mocking, `bloc_test` for BLoC tests.
- **Never use `pumpAndSettle()`** with animating widgets — use bounded `tester.pump(Duration(...))` instead.
- **Never `await bloc.close()`** while the widget tree listens — use `addTearDown(bloc.close)` instead.
- Register fallback values (for `any()` on custom types) in `test/helpers/register_fallback_values.dart` and call `setUpAll(registerTestFallbackValues)` in each test file that needs them.

Canonical BLoC test shape:

```dart
void main() {
  late MockFooRepository fooRepository;

  setUpAll(registerTestFallbackValues);

  setUp(() {
    fooRepository = MockFooRepository();
    when(() => fooRepository.loadItems()).thenAnswer((_) async => const <FooItem>[]);
  });

  group('FooBloc', () {
    blocTest<FooBloc, FooState>(
      'emits loading then ready on FooStarted',
      build: () => FooBloc(fooRepository: fooRepository),
      act: (bloc) => bloc.add(const FooStarted()),
      expect: () => [
        isA<FooLoading>(),
        isA<FooReady>(),
      ],
      verify: (_) => verify(() => fooRepository.loadItems()).called(1),
    );
  });
}
```

## Git & Generated Files

- Never commit secrets (API keys, tokens, `.env`).
- Generated files (`.dart_tool/`, `build/`, any future `lib/src/core/localization/gen/`) must not be committed.

## Key Dependencies

Required (add to `pubspec.yaml` as features come online — `pubspec.yaml` is intentionally bare today):

- `flutter_bloc` — BLoC state management
- `bloc_concurrency` — event transformers (`sequential()`, `droppable()`, etc.)
- `equatable` — equality for events/states (no Freezed)
- `helm` — declarative routing
- `rxdart` — `BehaviorSubject` for stateful repository streams
- `fast_immutable_collections` — immutable `IList`/`ISet`/`IMap`
- `bloc_test` (dev) — `blocTest()` macro
- `mocktail` (dev) — mocking
