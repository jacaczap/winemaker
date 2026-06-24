# winemaker

Android app that guides the user step-by-step through making wine. The user
starts a *realization* of a recipe (currently the built-in Red Wine recipe) and
works through its ordered tasks: measurements and ingredient calculations,
adding ingredients, timed waiting periods with reminders, free-text descriptions,
and a final results note. A standalone calculator and a recipe browser are also
available.

The full product model lives in `.cursor/rules/project.mdc`.

## Toolchain

- Flutter stable (3.24+), Dart >=3.5 (see `environment.sdk` in `pubspec.yaml`).
- Android only. No backend, auth, or multi-user.
- Key packages: Riverpod 3 + codegen (`riverpod_annotation`,
  `riverpod_generator`), Drift 2 (`drift`, `drift_flutter`), `go_router`,
  `flex_color_scheme` (Material 3 theming), `flutter_local_notifications` +
  `timezone`, `flutter_form_builder` + `form_builder_validators`.

## Architecture

State management uses Riverpod 3 with codegen (`@riverpod`). Controllers expose
`AsyncValue`; data access goes through per-feature repositories over a single
Drift database. Routing uses `go_router` with `realizationId` as a path param.

Feature-based layout under `lib/`:

- `app/` — `app`/`main`, `router.dart` (go_router), `theme.dart` (Material 3).
- `core/` — shared models, utilities, the Drift database
  (`core/database/`), and the notification service (`core/notifications/`).
- `features/<feature>/{domain,data,presentation}`:
  - `realization/` — running a recipe: realizations list (home), recipe view,
    and per-task screens (calculations, adding ingredients, description,
    time notification, result).
  - `recipe/` — built-in recipe definitions and the recipe browser.
  - `calculator/` — standalone ingredient calculator and the calculation logic.

Realization progress and per-task data live in one unified
`realization_task_state` table `(realizationId, taskIndex, status, payload)`,
where `payload` is per-task-type JSON. This single source supports repeatable
tasks, jump-back-discard (`delete where taskIndex > N`), and read-only
inspection. Do not add per-feature singleton tables for task data.

## Android build

- `minSdk 23` (required by Drift + `flutter_local_notifications`), `compileSdk`
  and `targetSdk 34`.
- Java/Kotlin target 17 (`sourceCompatibility`/`targetCompatibility`
  `VERSION_17`, `jvmTarget = '17'`), explicit `namespace`, AGP 8.
- Launcher icons are generated via `flutter_launcher_icons`.

## Getting started

New to Flutter? Start with the
[Flutter docs](https://flutter.dev/docs) and
[first app codelab](https://flutter.dev/docs/get-started/codelab).

Install dependencies:

```shell
flutter pub get
```

## Code generation

Drift and Riverpod both rely on generated `*.g.dart` files. After changing any
annotated source (Drift tables/DAOs, `@riverpod` providers, etc.), regenerate:

```shell
dart run build_runner build --delete-conflicting-outputs
```

During active development you can watch instead:

```shell
dart run build_runner watch --delete-conflicting-outputs
```

## Running, building, testing

```shell
flutter run                # run on a connected device/emulator
flutter run --release      # run a release build
flutter build appbundle    # build an Android app bundle
flutter install            # install the built app
flutter test               # run tests
```

Run `flutter clean` first if you hit stale build issues.
