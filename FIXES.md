# Clean Architecture Review — Fixes

Review of the layering and a round of fixes applied on branch
`refactor/clean-arch-fixes`. `main` is left untouched.

## Verdict

Layering is textbook-correct (feature-first, dependency rule respected):
domain depends on nothing, data implements domain interfaces, presentation
talks only to use cases. Functional errors via `Either<Failure, T>`,
use-case abstraction, `get_it` DI split per feature.

Gaps were around correctness and production-readiness, not structure:
a live bloc bug, no real tests, leaky nullable domain entity, thin error
model, a static (un-mockable) Dio, and dependency bloat.

## Fixes

| # | Problem | Fix | File |
|---|---------|-----|------|
| 1 | `on<TodoEvent>` catch-all double-fired alongside `on<TodoGetPressed>` (loading state was a side-effect of the generic handler) | Removed the base handler; emit `TodoLoadInProgress()` inside `_onGetTodos`; `void` → `Future<void>` | `lib/features/todo/presentation/bloc/todo_bloc.dart` |
| 2 | `Failure` was a thin, non-`Equatable` class → broken state equality, no way to distinguish error kinds | Sealed `Failure` + `Equatable`; added `ServerFailure` (carries status code) and `NetworkFailure` | `lib/core/error/failures.dart` |
| 3 | Repo caught only `ServerException`; other throws escaped uncaught | Map to typed failures + fallback `catch` so nothing escapes the boundary | `lib/features/todo/data/repositories/todo_repository_impl.dart` |
| 4 | Domain entity had all-nullable fields → API shape leaked into domain, forced `todo.title!` in UI | Non-nullable `required` fields | `lib/features/todo/domain/entities/todo.dart` |
| 5 | Model redeclared `Equatable`/`props` already inherited; no null-handling | Null-handling in `fromJson` (defaults); dropped redundant `EquatableMixin`/`props` | `lib/features/todo/data/models/todo_model.dart` |
| 6 | `DioClient` was a static singleton with hardcoded `baseUrl` (un-mockable); pretty logger dumped headers (auth-token leak) | Injectable `DioClient.create()`; header logging gated behind `kDebugMode` | `lib/core/network/dio_client.dart` |
| 7 | — | Register `Dio` via factory in the service locator | `lib/init_dependencies.main.dart` |
| 8 | Force-unwrap `todo.title!` (crash risk) | Removed (field now non-null) | `lib/features/todo/presentation/pages/todo_page.dart` |
| 9 | Unused deps bloated the build | Dropped `hive`, `isar_flutter_libs`, `uuid`, `dotted_border`, `path_provider`; added `bloc_test` | `pubspec.yaml` |
| 10 | Only test was the default counter template referencing a non-existent `MyApp` counter (would not compile) | Replaced with dependency-free use-case + bloc tests | `test/features/todo/...` |

## Not yet verified

No Flutter/Dart toolchain was available in the env these fixes were made in,
so they are **static-verified only**. Before merge:

```sh
flutter pub get
flutter analyze
flutter test
```

## Suggested next steps (not done here)

- `auth` / `main` features are stubs — flesh out or remove to keep the
  architecture story clean.
- Remove placeholder files: `widgets/dummy_widget.dart`,
  `todo/presentation/widgets/test.dart`.
- Add a second feature with `Params` to exercise the non-`NoParams`
  use-case path.
- Consider `freezed` for entities/states to cut boilerplate.
