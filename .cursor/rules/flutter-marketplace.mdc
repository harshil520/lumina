# Flutter Marketplace App — Production Module Builder

## What this skill is for

The user is building a production-grade Flutter marketplace app **one feature/module at a time**, not all at once. Each time, they'll hand you a feature name and description. Your job is to generate code for *that one feature* that slots into the existing app without touching unrelated code, follows the exact same architecture as every other module, and would survive a code review at a company that actually ships to millions of users.

The reason this skill exists: when every module is generated ad hoc, apps rot — inconsistent state management, API calls sprinkled inside widgets, one crashed request taking down an entire screen, giant `build()` methods, hardcoded colors everywhere. This skill is the single contract that prevents that, so module #40 looks and behaves exactly like module #1.

**Read the reference file for a topic before writing code that touches it** — they contain the actual patterns and code shapes, not just principles:

| Reference file | Read it when you're... |
|---|---|
| `references/folder-structure.md` | Placing any new file — where it goes and how it's named |
| `references/state-management.md` | Writing any Riverpod provider/notifier |
| `references/api-layer.md` | Writing anything that touches the network (Dio, repositories, DTOs) |
| `references/error-handling.md` | Writing anything that can fail — which is almost everything |
| `references/ui-components.md` | Writing any widget — overflow safety, reuse, theming |
| `references/performance.md` | Writing any list, image, or anything rendering many items |
| `references/code-templates.md` | Scaffolding a brand-new feature from scratch |
| `references/definition-of-done.md` | Before telling the user the feature is ready to test |

Don't try to hold all of these in your head at once — go read the relevant one when you hit that part of the work. They're short and specific on purpose.

## The tech stack contract (do not deviate per-module)

| Concern | Choice | Why it's fixed |
|---|---|---|
| State management | **Riverpod** (`flutter_riverpod` + `riverpod_annotation`/codegen) | One mental model everywhere; `.select()` and provider scoping are what make independent, non-cascading UI updates possible |
| Networking | **Dio** | Interceptors give one place for auth headers, retry, logging, and timeout policy instead of repeating it per call |
| Architecture | **Feature-first, layered inside each feature** (hybrid) | Every feature is a self-contained folder with its own data/domain/presentation, so it can be added, removed, or handed to another dev without touching other features. Shared code lives in `core/` |
| Routing | **go_router** | Declarative, deep-link friendly, works cleanly with Riverpod for auth-gated redirects |
| Local persistence/cache | **Hive** (or `shared_preferences` for flags) | Fast, no native build step, good for offline-first list caching |
| Secure storage | **flutter_secure_storage** | Tokens and anything sensitive never touch plain SharedPreferences |
| Images | **cached_network_image** | Marketplace apps are image-heavy; this is non-negotiable for performance and data usage |
| Testing | **flutter_test + mocktail** | Mocktail avoids codegen friction for mocks; keeps unit tests fast to write per module |

If the user's project already uses different choices for any of these, ask before assuming — don't silently mix e.g. Provider and Riverpod in the same app.

## Non-negotiable principles (the "why" behind every rule below)

1. **UI never talks to Dio directly.** Widgets depend only on a `Repository` interface returning domain models. This is what lets a backend outage, a slow endpoint, or an API contract change stay contained to one file instead of rippling into every screen that shows that data.
2. **Nothing throws past the repository boundary.** Every repository method returns a `Result<T, Failure>` (see `error-handling.md`). Providers turn that into `AsyncValue`, and the UI renders loading/data/empty/error states from a single reusable pattern. A failed API call becomes a friendly retry card, never a red screen or a silent crash.
3. **Providers are scoped as narrowly as possible.** A price updating shouldn't rebuild the whole product card, and a product card updating shouldn't rebuild the whole list. Use `.select()`, split notifiers per concern, and keep `ConsumerWidget`s small. This is both the "modules update independently" requirement and a major performance lever — they're the same problem.
4. **Every feature folder is deletable.** If you can't remove a feature folder without hunting for stray imports scattered across `core/` or other features, the boundary is wrong. Shared stuff belongs in `core/`; feature-specific stuff never leaks out of its folder.
5. **No screen trusts fixed sizes.** Real marketplace data (seller names, product titles, prices in different currencies, review counts) varies wildly in length. Every layout must survive that variance — see the overflow rules in `ui-components.md`.
6. **Large lists are always virtualized and paginated.** Never `Column` + `.map()` over a list that could grow large (products, orders, chat messages, reviews). Always `ListView.builder`/`SliverList` with pagination — see `performance.md`.
7. **Nothing sensitive leaves the layer that owns it.** Auth tokens, raw API error bodies/stack traces, and internal IDs meant only for the backend never get logged, never get shown in a user-facing message, and never get exposed as public fields outside the module that owns them (prefix with `_` and expose narrow getters instead).
8. **One design-token source of truth.** Colors, spacing, radii, and text styles are never hardcoded in a widget — they come from `AppTheme`/`AppColors`/`AppTypography` in `core/theme/`. This is what keeps 40 independently-built modules looking like one app.

## Workflow for building one feature/module

Follow this every time, regardless of what the feature is:

1. **Clarify scope in one pass, not many rounds.** If the user's feature description is missing something structurally important (which API endpoints exist and their shapes, whether it needs offline support, whether it's paginated), ask once, up front. Don't guess at API contracts — ask for the endpoint/response shape or ask the user to paste API docs/Postman/OpenAPI if you don't have it.
2. **Scaffold the feature folder** per `folder-structure.md` — don't touch other features' folders.
3. **Build bottom-up**: domain model → DTO + mapper → repository interface + implementation → Riverpod providers/notifiers → UI. This order means every layer below the UI is done and typed before you write a widget against it.
4. **Wire in error handling and loading/empty states from the start** — not as an afterthought bolted on at the end. Use the `AsyncValue`/`Result` patterns from `error-handling.md` from the first line of the notifier, not after the happy path works.
5. **Use existing shared widgets before creating new ones.** Check `core/widgets/` (buttons, cards, loading shimmer, error/empty state views, price/rating chips) first. Only add a new shared widget if the pattern will clearly recur; otherwise keep it local to the feature.
6. **Register the route** in the central `go_router` config, in its own small file the router imports — don't hand-edit a giant switch statement.
7. **Self-check against `definition-of-done.md`** before handing the feature back. Call out explicitly which boxes are checked and which need the user's backend/API to actually verify (e.g., real network failure testing).

## The universal per-feature prompt

This is the template the user fills in and sends for every new module. When you receive a message shaped like this, treat every field as a real constraint, not a suggestion — and apply everything above automatically without being re-asked.

```
FEATURE: <name, e.g. "Product Listing Screen">

DESCRIPTION:
<what it does, from the user's perspective>

API DETAILS:
<endpoint(s), method, request/response shape, pagination params, auth requirements —
 or "not available yet, mock it behind the repository interface">

UI REQUIREMENTS:
<layout specifics, states it needs to handle, any design reference>

DEPENDS ON:
<other features/shared widgets/providers it needs to read, if any>

OUT OF SCOPE:
<explicitly what NOT to touch this round>
```

If the user sends a bare feature name with no detail, don't stall — apply the Workflow step 1 above: ask the one or two structurally-important questions (API shape, pagination, offline needs) and proceed with everything else defaulted to this skill's standards.

## Output expectations

- Generate real files in the project structure (not one giant pasted blob) — respect `folder-structure.md`.
- Every new public class gets a one-line doc comment explaining its responsibility — future modules (and the user) need to know what's safe to depend on.
- Call out in your response, briefly: what you built, where it lives, what's mocked vs. real, and what the user should manually verify before marking the module done.
- Don't refactor or "improve" unrelated existing code while building a feature — flag it to the user instead and let them decide if it's in scope.


---

# Appendix: Reference Material

Everything below was split into separate files in the multi-file skill version. It's inlined here since single-file rule formats can't reference external files.


---

## Appendix — Folder Structure

# Folder Structure — Feature-First + Layered (Hybrid)

Every feature is a self-contained folder. Inside that folder, code is layered (data/domain/presentation) the same way every time. Shared code that multiple features genuinely need lives in `core/`. Nothing in `core/` should ever import from a feature folder — dependencies only flow feature → core, never the reverse.

```
lib/
├── main.dart
├── app.dart                      # MaterialApp.router + top-level ProviderScope wiring
│
├── core/
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_typography.dart
│   │   ├── app_spacing.dart      # spacing/radius/elevation constants
│   │   └── app_theme.dart        # ThemeData assembled from the above
│   ├── router/
│   │   ├── app_router.dart       # go_router root config, imports each feature's routes
│   │   └── route_names.dart
│   ├── network/
│   │   ├── dio_client.dart       # Dio instance + interceptors (auth, retry, logging)
│   │   ├── api_endpoints.dart    # base URL + path constants
│   │   └── network_exceptions.dart
│   ├── error/
│   │   ├── failure.dart          # sealed Failure hierarchy
│   │   └── result.dart           # Result<T, Failure> type
│   ├── widgets/                  # shared, reused across 2+ features
│   │   ├── app_button.dart
│   │   ├── app_text_field.dart
│   │   ├── loading_shimmer.dart
│   │   ├── error_state_view.dart
│   │   ├── empty_state_view.dart
│   │   └── paginated_list_view.dart
│   ├── utils/
│   │   ├── formatters.dart       # currency, date, etc.
│   │   └── validators.dart
│   └── storage/
│       ├── secure_storage_service.dart
│       └── local_cache_service.dart   # Hive boxes wrapper
│
└── features/
    └── product_listing/                       # <- one folder per feature
        ├── data/
        │   ├── models/
        │   │   └── product_dto.dart            # raw API shape + fromJson/toJson
        │   ├── mappers/
        │   │   └── product_mapper.dart          # DTO <-> domain model
        │   └── repositories/
        │       └── product_repository_impl.dart # implements the domain interface, uses Dio
        ├── domain/
        │   ├── models/
        │   │   └── product.dart                 # clean domain model UI actually uses
        │   └── repositories/
        │       └── product_repository.dart       # abstract interface — UI/providers depend on THIS
        ├── application/
        │   └── product_list_provider.dart        # Riverpod notifiers/providers for this feature
        └── presentation/
            ├── screens/
            │   └── product_list_screen.dart
            └── widgets/
                ├── product_card.dart              # local to this feature (not reused elsewhere yet)
                └── product_list_filters.dart
```

## Naming conventions

- Files: `snake_case.dart`. Classes: `PascalCase`. Providers/notifiers: `camelCaseProvider` / `CamelCaseNotifier`.
- One class of real substance per file. Small private helper widgets can live alongside the widget that uses them in the same file if they're never reused.
- DTOs are suffixed `Dto` and only exist in `data/`. Domain models have no suffix and are what everything above `data/` uses. **Never let a `Dto` class leak into `presentation/` or `application/`** — that's the whole point of the mapper step, and it's what keeps a backend field rename from touching UI code.
- Screens go in `presentation/screens/`, reusable-within-feature widgets in `presentation/widgets/`. Widgets reused across 2+ features get promoted to `core/widgets/` — don't put them there pre-emptively "just in case."

## Adding a new feature checklist

1. Create the folder under `features/<feature_name>/` with the four subfolders above (skip `data/` only if the feature has no network calls of its own).
2. Add its routes in its own small file, e.g. `features/product_listing/product_listing_routes.dart`, and import that into `core/router/app_router.dart` — never hand-edit one giant route list.
3. If it needs a shared widget that doesn't exist yet and is clearly reusable, add it to `core/widgets/`. If unsure, keep it local — promoting later is cheap, demoting a wrongly-shared widget is not.
4. Nothing outside `features/<feature_name>/` should import from inside it except its route file and, if genuinely needed, a public provider another feature explicitly depends on (see `DEPENDS ON` in the per-feature prompt).


---

## Appendix — State Management

# State Management — Riverpod Patterns

The goal of every pattern here is the same: **a change in one piece of data should rebuild the smallest possible number of widgets.** That's what makes modules "update independently without refreshing the major UI," and it's also most of what makes the app fast — those are the same problem solved the same way.

## Provider shapes, by use case

- **A single async fetch (screen data, a detail page):** `FutureProvider`/`AsyncNotifierProvider` returning `AsyncValue<T>`.
- **Paginated/infinite list:** a dedicated `AsyncNotifier<List<T>>` (or a small custom notifier) that exposes `loadNextPage()`, tracks `hasMore`, and appends rather than replaces — see `performance.md` for the widget side.
- **Form/local UI state (filters, quantity selector, toggle):** `NotifierProvider` holding a small immutable state class, scoped to the widget subtree that needs it, not global.
- **Derived/computed values (e.g. cart total from cart items):** a plain `Provider` that watches the source provider — never recompute derived values inside `build()`.
- **Cross-feature shared state (auth session, cart):** lives in `core/` or a clearly-owned feature, exposed via a `Provider`/`NotifierProvider` other features are allowed to `ref.watch` — this is the one legitimate way features are allowed to depend on each other.

## Scoping rules that prevent cascading rebuilds

1. **Watch the narrowest thing possible.** Prefer `ref.watch(productProvider.select((p) => p.price))` over watching the whole `Product` object in a widget that only renders the price.
2. **Split one big screen notifier into several small ones** rather than one `HomeScreenState` object with 15 fields where changing one field rebuilds everything watching the notifier. If two pieces of state change independently, they belong in independent providers.
3. **Push `Consumer`/`ConsumerWidget` down to the smallest widget that actually needs the data**, not at the top of the screen. A screen's outer `Scaffold`/`AppBar` almost never needs to rebuild when list data changes — wrap only the part that does in a `Consumer`.
4. **Use `family` for per-item state** (e.g. "is this specific product favorited") instead of one provider holding a map/list for every item on screen — that way toggling item #47 doesn't touch the widget for item #1.
5. **Keep providers close to where they're used.** Feature-scoped providers live in that feature's `application/` folder. Only promote to `core/` when a second feature genuinely needs it (see `folder-structure.md`).

## Standard async UI pattern

Every screen backed by a `FutureProvider`/`AsyncNotifierProvider` renders its `AsyncValue` the same way, via a shared helper so the loading/error/empty look and feel is consistent everywhere (put this in `core/widgets/` — see `ui-components.md` for the widget itself):

```dart
final productsAsync = ref.watch(productListProvider);

return productsAsync.when(
  data: (products) => products.isEmpty
      ? const EmptyStateView(message: 'No products yet')
      : ProductGrid(products: products),
  loading: () => const LoadingShimmer(),
  error: (error, stackTrace) => ErrorStateView(
    // map the raw error to a Failure/user-facing message — see error-handling.md
    onRetry: () => ref.invalidate(productListProvider),
  ),
);
```

Note what this buys you: a failed request never leaves the screen half-built or throws past the widget tree — it renders `ErrorStateView` with a retry action, every single time, for every feature, because it's the same pattern everywhere.

## What NOT to do

- Don't call `ref.read` inside `build()` to "get the current value" — that skips rebuilds when it changes. Use `ref.watch` in `build()`; reserve `ref.read` for inside callbacks (button `onPressed`, etc.).
- Don't put `Dio`/repository calls directly inside a `Notifier`'s constructor logic without going through the repository interface — the notifier depends on the domain `Repository` interface, never on `data/` classes directly.
- Don't create a provider inside `build()` (e.g. `Provider((ref) => ...)` defined locally) — providers are always top-level `final` declarations so Riverpod can track and dispose them correctly.
- Don't use `ChangeNotifier`/`setState` for anything that represents shared or async state — reserve local `setState` for truly ephemeral, single-widget UI state (e.g. a `PageView` index) that no other widget needs.


---

## Appendix — Api Layer

# API Integration Layer — Fully Decoupled from UI

The rule that makes everything else in this skill work: **UI and providers never see Dio, HTTP status codes, or raw JSON.** They see domain models and a `Result<T, Failure>`. This means an API contract change, a backend outage, or a slow endpoint is fixed in exactly one file — the repository implementation — and can't ripple into screens.

## The chain, in order

```
Dio (network) → *Dto (raw JSON shape) → mapper → domain model → Repository interface → Provider/Notifier → UI
```

### 1. Central Dio client (`core/network/dio_client.dart`)

One `Dio` instance, configured once, with interceptors — not per-call setup:

- **Auth interceptor**: attaches the token from `SecureStorageService`, and on a 401 tries a token refresh once before failing.
- **Timeout policy**: sane connect/receive timeouts so a hung request can't hang a whole screen forever.
- **Retry interceptor**: automatic retry with backoff for idempotent GET requests on network-level failures (timeout, connection error) — not for POST/PUT unless the endpoint is explicitly idempotent.
- **Logging interceptor**: verbose in debug builds only, and it must never log auth tokens or full request/response bodies containing user PII in release builds.

### 2. DTOs (`data/models/`)

Mirror the API response exactly, including `fromJson`/`toJson`. DTOs are allowed to be ugly (nullable everywhere the backend might omit a field, exact backend field names) — that ugliness is contained here and never spreads further.

### 3. Mapper (`data/mappers/`)

Pure functions converting `Dto -> domain model` (and back, if needed for requests). This is where you decide sane defaults for nulls, normalize enums, format things once. If the backend renames a field, only the DTO and mapper change.

### 4. Domain model (`domain/models/`)

The clean, non-nullable-where-reasonable model the rest of the app actually works with. No `Dto` suffix, no backend-specific naming.

### 5. Repository interface + implementation

```dart
// domain/repositories/product_repository.dart — this is what providers depend on
abstract class ProductRepository {
  Future<Result<List<Product>, Failure>> getProducts({required int page, int pageSize = 20});
  Future<Result<Product, Failure>> getProductById(String id);
}
```

```dart
// data/repositories/product_repository_impl.dart — the ONLY file that imports Dio for this feature
class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl(this._dio);
  final Dio _dio;

  @override
  Future<Result<List<Product>, Failure>> getProducts({required int page, int pageSize = 20}) async {
    try {
      final response = await _dio.get(ApiEndpoints.products, queryParameters: {
        'page': page,
        'page_size': pageSize,
      });
      final dtos = (response.data['results'] as List).map((j) => ProductDto.fromJson(j));
      return Result.success(dtos.map(ProductMapper.toDomain).toList());
    } on DioException catch (e) {
      return Result.failure(NetworkFailure.fromDioException(e));
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }
  // ...
}
```

Every repository method is `try/catch`-wrapped exactly like this — no repository method is ever allowed to throw past its own boundary. See `error-handling.md` for how `DioException` maps to `Failure`.

### 6. Provider wiring

The repository interface is provided via a Riverpod `Provider`, with the concrete implementation swapped in at the composition point — this is also what makes the repository trivially mockable in tests:

```dart
final dioProvider = Provider<Dio>((ref) => DioClient.create());

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl(ref.watch(dioProvider));
});
```

## Handling "the API doesn't exist yet"

Don't block on backend availability. Write the domain interface and a fake/in-memory implementation (`ProductRepositoryFake`) returning realistic sample data with the same `Result` shape, wire the UI against the interface, and swap in `ProductRepositoryImpl` later by changing one `Provider` override. The UI code never needs to change when the fake is replaced with the real thing.

## Resilience under load / spikes

- **Debounce, don't spam**: search-as-you-type and filter changes should debounce (e.g. 300–400ms) before firing a request, not fire on every keystroke.
- **Cancel stale requests**: use Dio `CancelToken`s tied to the provider's lifecycle so navigating away from a screen or a fast filter change cancels the in-flight request instead of racing it.
- **Cache reads, don't refetch reflexively**: use `keepAlive`/appropriate provider caching so switching tabs back and forth doesn't refire identical requests; pair with pull-to-refresh for explicit re-fetch.
- **Pagination is mandatory** for any endpoint that can return an unbounded list — see `performance.md`.


---

## Appendix — Error Handling

# Error & Exception Handling — Nothing Reaches the UI Unhandled

Three layers of defense, in order. A well-built feature should almost never need layer 3 — but layer 3 exists so that if something genuinely unexpected happens, the user sees a friendly message instead of a crash, in every build, not just debug.

## Layer 1 — `Result<T, Failure>` at the repository boundary

```dart
// core/error/result.dart
sealed class Result<T, F> {
  const Result();
  factory Result.success(T value) = Success<T, F>;
  factory Result.failure(F failure) = ResultFailure<T, F>;
}
class Success<T, F> extends Result<T, F> { final T value; const Success(this.value); }
class ResultFailure<T, F> extends Result<T, F> { final F failure; const ResultFailure(this.failure); }
```

```dart
// core/error/failure.dart
sealed class Failure {
  const Failure(this.message);
  final String message; // user-facing, already safe to display
}
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
  factory NetworkFailure.fromDioException(DioException e) => switch (e.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.receiveTimeout => const NetworkFailure('This is taking longer than expected. Please try again.'),
    DioExceptionType.connectionError => const NetworkFailure('You appear to be offline. Check your connection and try again.'),
    _ => NetworkFailure(_messageForStatus(e.response?.statusCode)),
  };
}
class ValidationFailure extends Failure { const ValidationFailure(super.message); }
class AuthFailure extends Failure { const AuthFailure(super.message); }
class UnknownFailure extends Failure {
  const UnknownFailure(this.debugDetail) : super('Something went wrong. Please try again.');
  final String debugDetail; // logged internally, NEVER shown to the user or sent to analytics with PII attached
}
```

Every `Failure` message is written **as if a designer wrote the copy** — never a raw exception string, never a stack trace, never a raw HTTP status code shown to the user. Map status codes to sane copy once, centrally (`_messageForStatus`), not per-feature.

Repositories never throw. Every repository method signature returns `Result<T, Failure>`, and every implementation wraps its body in `try/catch` mapping to a `Failure` (see `api-layer.md`).

## Layer 2 — Providers turn `Result` into `AsyncValue`, UI renders it uniformly

```dart
class ProductListNotifier extends AsyncNotifier<List<Product>> {
  @override
  Future<List<Product>> build() => _fetch();

  Future<List<Product>> _fetch() async {
    final result = await ref.read(productRepositoryProvider).getProducts(page: 1);
    return switch (result) {
      Success(:final value) => value,
      ResultFailure(:final failure) => throw failure, // AsyncNotifier converts this into AsyncError for us
    };
  }
}
```

Riverpod's `AsyncValue` already carries loading/data/error — the UI's `.when(...)` (shown in `state-management.md`) is the *only* place error-vs-data branching happens for that data. No `try/catch` scattered through widgets, no nullable "errorMessage" fields threaded through UI state.

Every screen that can be empty (zero results, not an error) must render an explicit empty state, distinct from the error state — a marketplace with "no products in this category" should never look like a crash.

## Layer 3 — App-wide safety net (catches the truly unexpected)

Two things wired once, in `main.dart`, so a genuinely unhandled exception anywhere in the widget tree degrades gracefully instead of showing Flutter's red/grey error screen in production:

```dart
void main() {
  runZonedGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();
    ErrorWidget.builder = (details) => const FriendlyErrorFallback(); // replaces the red screen
    FlutterError.onError = (details) {
      // log to crash reporting here (Sentry/Crashlytics) — never rethrow to the user
    };
    runApp(const ProviderScope(child: MyApp()));
  }, (error, stack) {
    // catches errors outside the Flutter framework's own error handling (async gaps, isolates)
    // log to crash reporting here too
  });
}
```

This is a safety net, not a substitute for layers 1 and 2 — if you find yourself relying on it to catch expected failure modes (network errors, empty results, validation errors), that's a sign a repository or provider is throwing instead of returning a `Result`/`Failure` properly.

## Retry & recovery UX

Every error state the user can hit from normal use (not layer-3 territory) gets a way forward, not a dead end:

- Network/list errors → `ErrorStateView` with a **Retry** button that calls `ref.invalidate(...)` on the relevant provider.
- Form submission errors (validation, conflict) → inline field errors or a snackbar with the `Failure.message`, form stays filled in, nothing is lost.
- Auth failures (expired session) → route to login, don't just show an error and strand the user.

## What never happens, anywhere in the codebase

- A `catch (e) { print(e); }` that swallows an error silently with no user-visible consequence and no logging.
- A raw `Exception`/`DioException`/stack trace string shown to the user in a `Text` widget or `SnackBar`.
- A widget's `build()` method that can throw on legitimate data (e.g. `list.first` on a list that can be empty, `!` on a value that can genuinely be null from the API) — handle it explicitly instead of assuming.


---

## Appendix — Ui Components

# UI Components — Reusable, Overflow-Safe, Consistently Themed

## Design tokens — the single source of truth

Nothing in a feature widget hardcodes a color, font size, spacing value, or radius. Everything comes from `core/theme/`:

```dart
// core/theme/app_colors.dart
class AppColors {
  const AppColors._();
  static const primary = Color(0xFF1A73E8);
  static const surface = Color(0xFFFFFFFF);
  static const error = Color(0xFFD32F2F);
  static const textPrimary = Color(0xFF1A1A1A);
  static const textSecondary = Color(0xFF6B6B6B);
  // ...
}

// core/theme/app_spacing.dart
class AppSpacing {
  const AppSpacing._();
  static const xs = 4.0, sm = 8.0, md = 16.0, lg = 24.0, xl = 32.0;
  static const radiusSm = 8.0, radiusMd = 12.0, radiusLg = 16.0;
}
```

`app_theme.dart` assembles a single `ThemeData` (colors, `textTheme`, `elevatedButtonTheme`, `inputDecorationTheme`, etc.) from these tokens, and `MaterialApp.router` uses only that. A widget reaching for `Colors.blue` or `fontSize: 14` directly instead of `Theme.of(context)`/`AppColors`/`AppTypography` is a bug, not a style preference — it's what makes 40 independently-built modules look like one designed app instead of a patchwork.

If the user has an existing design system (Figma tokens, an existing `AppTheme`), use that instead of inventing a new one — ask if unsure rather than creating a second, competing token set.

## Reusable widget library (`core/widgets/`)

Before writing a new widget, check whether one of these already covers it. Typical marketplace-app set to build once and reuse everywhere:

- `AppButton` (primary/secondary/text variants, loading state built in — so every async button shows a spinner the same way instead of each screen inventing its own)
- `AppTextField` (consistent error/label/helper text styling)
- `LoadingShimmer` — skeleton loading, not a bare `CircularProgressIndicator`, for anything list/card-shaped
- `ErrorStateView` — icon + message + retry button, used by every `.when(error: ...)` branch
- `EmptyStateView` — icon + message, used for legitimate zero-results states
- `PaginatedListView<T>` — wraps the infinite-scroll pattern from `performance.md` so no feature reimplements pagination scrolling logic
- `PriceTag`, `RatingChip`, `AppBadge` — small marketplace-specific atoms reused across product cards, order rows, seller cards, etc.
- `CachedNetworkImageWithPlaceholder` — thin wrapper around `cached_network_image` with the app's standard placeholder/error asset baked in

A widget only gets promoted here once it's actually needed by a second feature — see `folder-structure.md`. Guessing ahead of time leads to a bloated shared library nobody trusts.

## Overflow safety — non-negotiable rules

Marketplace data is unpredictable in length (long product titles, seller names, prices with different currency formats). Every layout must assume the worst-case string length, not the string in your test data.

1. **Every `Text` in a `Row`/constrained width gets wrapped**: `Expanded`/`Flexible` around the `Text`, plus `overflow: TextOverflow.ellipsis` and usually `maxLines`. A bare `Text(longString)` directly inside a `Row` is the #1 cause of yellow-and-black overflow bars — never ship one.
2. **Never give a `Row`/`Column` children whose combined intrinsic size can exceed the available space without a `Flexible`/`Expanded` somewhere** — if in doubt, wrap it.
3. **Use `Wrap` instead of `Row`** for things like tag/chip lists whose count varies (categories, filters) — a `Row` of an unbounded number of chips will overflow; `Wrap` degrades gracefully.
4. **Avoid fixed pixel heights on anything containing text** (e.g. a card with `height: 80` and a title inside) — let content determine height, or use `ConstrainedBox`/`minHeight` instead of a hard `height` when a minimum is needed.
5. **Grids of cards**: use `GridView.builder` with `childAspectRatio` tuned generously, or better, a `SliverGrid` with a fixed cross-axis extent and let card height be intrinsic via `mainAxisExtent` — a too-tight `childAspectRatio` is the second most common overflow source in product grids.
6. **Test against real worst cases mentally**: the longest realistic product title, a seller name in a language with different average character width, a price with more digits than your sample data (₹1,23,456 vs $9.99), a small phone width (~320dp) — a layout that only survives your one sample string isn't done.
7. **`SafeArea`** wraps every top-level screen so content never sits under a notch/status bar/gesture nav.

## Performance-conscious widget habits (also see `performance.md`)

- Mark widgets `const` wherever every field is a compile-time constant — this is the single cheapest performance habit and costs nothing to apply consistently.
- Give list items stable `Key`s (e.g. `ValueKey(product.id)`) so Flutter can diff efficiently instead of rebuilding every item on any list change.
- Avoid rebuilding an entire screen for a small state change — this is a `state-management.md` concern as much as a widget one; split widgets so `Consumer`s wrap only the part that actually changes.
- Wrap independently-animating or independently-repainting subtrees (e.g. a shimmer loader next to static content) in `RepaintBoundary` so their repaints don't force siblings to repaint too.


---

## Appendix — Performance

# Performance — Fast Rendering Under Real Marketplace Data Volumes

The frontend doesn't need to "handle high traffic" the way a backend does — it needs to handle **large and frequently-changing datasets without janking**, and never hold the whole dataset's worth of widgets in memory or rebuild more than necessary. Every rule here serves that.

## Lists — always virtualized, always paginated

**Never** render a list with `Column(children: items.map(...).toList())` or inside a `SingleChildScrollView` once the list can grow past a screenful (products, orders, reviews, chat messages, notifications). That builds every single item's widget tree immediately, even off-screen ones — it's the single biggest performance mistake in a marketplace app.

**Always** use one of:
- `ListView.builder` — builds items lazily as they scroll into view.
- `SliverList.builder`/`SliverGrid` inside a `CustomScrollView` — when you need the list to coexist with other scrolling content (a header, filter bar, banner) in one smooth scroll.
- `GridView.builder` — for product grids.

### Pagination pattern (infinite scroll)

Wrap this once as `core/widgets/paginated_list_view.dart` and reuse it for every paginated feature instead of reimplementing scroll-position listening per screen:

```dart
class PaginatedListView<T> extends ConsumerStatefulWidget {
  const PaginatedListView({
    required this.items,
    required this.itemBuilder,
    required this.onLoadMore,
    required this.hasMore,
    required this.isLoadingMore,
    super.key,
  });
  final List<T> items;
  final Widget Function(BuildContext, T) itemBuilder;
  final VoidCallback onLoadMore;
  final bool hasMore;
  final bool isLoadingMore;

  @override
  ConsumerState<PaginatedListView<T>> createState() => _PaginatedListViewState<T>();
}

class _PaginatedListViewState<T> extends ConsumerState<PaginatedListView<T>> {
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final nearBottom = _controller.position.pixels >
          _controller.position.maxScrollExtent - 300;
      if (nearBottom && widget.hasMore && !widget.isLoadingMore) {
        widget.onLoadMore();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _controller,
      itemCount: widget.items.length + (widget.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= widget.items.length) return const LoadingShimmer(compact: true);
        return widget.itemBuilder(context, widget.items[index]);
      },
    );
  }
}
```

The `hasMore`/`isLoadingMore` flags and `onLoadMore()` callback come from the feature's `AsyncNotifier` (see `state-management.md`), which appends the next page to its held list rather than replacing it — and guards against firing a second request while one is already in flight.

### List item performance checklist

- `const` constructors on item widgets wherever possible.
- Stable `Key` per item (`ValueKey(item.id)`) so Flutter's diffing doesn't rebuild-and-discard everything on a list update.
- `itemExtent`/`prototypeItem` on `ListView.builder` when items are a fixed height — lets Flutter skip measuring every item and jump-scroll accurately.
- Images inside list items always go through `cached_network_image` (see below) — never `Image.network` directly in a list.

## Images

- Always `cached_network_image`, never bare `Image.network`, in anything that scrolls — it caches to disk, avoids re-downloading on every rebuild/scroll-back, and gives a built-in placeholder/error widget slot (use the shared `CachedNetworkImageWithPlaceholder` from `ui-components.md`).
- Request appropriately-sized images from the backend/CDN where possible (thumbnail vs full-size) rather than downloading full-resolution images for a small product-card thumbnail.
- Set explicit `width`/`height`/`memCacheWidth` so Flutter doesn't decode a huge image at full resolution just to display it small.

## Avoiding unnecessary work

- **Search/filter inputs**: debounce (300–400ms) before triggering a provider refresh or API call — see `api-layer.md`.
- **Heavy computation** (client-side sorting/filtering of a large already-fetched list, JSON parsing of a large payload): move off the main isolate with `compute()` if it's large enough to cause a visible frame drop; profile before assuming it's needed.
- **Avoid `Opacity`** for simple show/hide of static content — prefer conditionally not building the widget, or `Visibility`, since `Opacity` forces a full repaint of its subtree every frame it's used in an animation.
- **Don't recompute derived data in `build()`** (e.g. sorting/filtering a list inline in a widget's `build()` method) — do it in a `Provider` that only recomputes when its inputs actually change, so an unrelated rebuild doesn't re-run an O(n log n) sort every frame.

## How to sanity-check a feature performs well

Before marking a feature done (see `definition-of-done.md`): run it with a realistically large dataset (100+ items, not the 3 items in a happy-path mock), scroll fast, and confirm no visible jank. In debug mode, Flutter's performance overlay (or DevTools' "Rebuild counts") should show list items building lazily as they scroll into view, not all at once.


---

## Appendix — Code Templates

# Code Templates — Scaffolding a New Feature End-to-End

This walks through one complete, minimal feature ("Product Listing") touching every layer, so you can see how the pieces in the other reference docs fit together. Use it as the shape for any new feature — swap the domain, keep the layering.

## 1. Domain model — `features/product_listing/domain/models/product.dart`

```dart
/// Clean domain representation of a product. UI and providers depend only on this,
/// never on ProductDto.
class Product {
  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.sellerName,
    this.rating,
  });

  final String id;
  final String title;
  final double price;
  final String imageUrl;
  final String sellerName;
  final double? rating;
}
```

## 2. DTO — `features/product_listing/data/models/product_dto.dart`

```dart
/// Raw API shape for a product. Never used outside data/ — see product_mapper.dart.
class ProductDto {
  const ProductDto({
    required this.id,
    required this.title,
    required this.priceCents,
    required this.imageUrl,
    this.seller,
    this.avgRating,
  });

  final String id;
  final String title;
  final int priceCents; // backend sends cents, not dollars — mapper handles conversion
  final String imageUrl;
  final Map<String, dynamic>? seller;
  final double? avgRating;

  factory ProductDto.fromJson(Map<String, dynamic> json) => ProductDto(
        id: json['id'] as String,
        title: json['title'] as String? ?? '',
        priceCents: json['price_cents'] as int? ?? 0,
        imageUrl: json['image_url'] as String? ?? '',
        seller: json['seller'] as Map<String, dynamic>?,
        avgRating: (json['avg_rating'] as num?)?.toDouble(),
      );
}
```

## 3. Mapper — `features/product_listing/data/mappers/product_mapper.dart`

```dart
class ProductMapper {
  const ProductMapper._();
  static Product toDomain(ProductDto dto) => Product(
        id: dto.id,
        title: dto.title,
        price: dto.priceCents / 100,
        imageUrl: dto.imageUrl,
        sellerName: dto.seller?['name'] as String? ?? 'Unknown seller',
        rating: dto.avgRating,
      );
}
```

## 4. Repository interface — `features/product_listing/domain/repositories/product_repository.dart`

```dart
abstract class ProductRepository {
  Future<Result<List<Product>, Failure>> getProducts({required int page, int pageSize = 20});
}
```

## 5. Repository implementation — `features/product_listing/data/repositories/product_repository_impl.dart`

See the full pattern in `api-layer.md` — same shape, `try/catch` mapping `DioException` to `Failure`, never throwing past this file.

## 6. Providers — `features/product_listing/application/product_list_provider.dart`

```dart
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl(ref.watch(dioProvider));
});

class ProductListState {
  const ProductListState({
    this.products = const [],
    this.hasMore = true,
    this.isLoadingMore = false,
  });
  final List<Product> products;
  final bool hasMore;
  final bool isLoadingMore;

  ProductListState copyWith({List<Product>? products, bool? hasMore, bool? isLoadingMore}) =>
      ProductListState(
        products: products ?? this.products,
        hasMore: hasMore ?? this.hasMore,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      );
}

class ProductListNotifier extends AsyncNotifier<ProductListState> {
  int _page = 1;

  @override
  Future<ProductListState> build() => _fetchPage(1, const ProductListState());

  Future<ProductListState> _fetchPage(int page, ProductListState current) async {
    final result = await ref.read(productRepositoryProvider).getProducts(page: page);
    return switch (result) {
      Success(:final value) => current.copyWith(
          products: page == 1 ? value : [...current.products, ...value],
          hasMore: value.length == 20,
          isLoadingMore: false,
        ),
      ResultFailure(:final failure) => throw failure,
    };
  }

  Future<void> loadNextPage() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore || current.isLoadingMore) return;
    state = AsyncData(current.copyWith(isLoadingMore: true));
    _page++;
    state = await AsyncValue.guard(() => _fetchPage(_page, current));
  }
}

final productListProvider = AsyncNotifierProvider<ProductListNotifier, ProductListState>(
  ProductListNotifier.new,
);
```

## 7. Screen — `features/product_listing/presentation/screens/product_list_screen.dart`

```dart
class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(productListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: SafeArea(
        child: stateAsync.when(
          data: (state) => state.products.isEmpty
              ? const EmptyStateView(message: 'No products yet')
              : PaginatedListView<Product>(
                  items: state.products,
                  hasMore: state.hasMore,
                  isLoadingMore: state.isLoadingMore,
                  onLoadMore: () => ref.read(productListProvider.notifier).loadNextPage(),
                  itemBuilder: (context, product) => ProductCard(product: product),
                ),
          loading: () => const LoadingShimmer(),
          error: (error, _) => ErrorStateView(
            message: error is Failure ? error.message : 'Something went wrong.',
            onRetry: () => ref.invalidate(productListProvider),
          ),
        ),
      ),
    );
  }
}
```

## 8. Feature-local widget — `features/product_listing/presentation/widgets/product_card.dart`

```dart
class ProductCard extends StatelessWidget {
  const ProductCard({required this.product, super.key});
  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      key: ValueKey(product.id),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Row(
          children: [
            CachedNetworkImageWithPlaceholder(url: product.imageUrl, width: 64, height: 64),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleSmall),
                  const SizedBox(height: AppSpacing.xs),
                  PriceTag(price: product.price),
                  Text(product.sellerName, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

## 9. Route registration — `features/product_listing/product_listing_routes.dart`

```dart
List<RouteBase> productListingRoutes = [
  GoRoute(
    path: '/products',
    name: RouteNames.productList,
    builder: (context, state) => const ProductListScreen(),
  ),
];
```

Then in `core/router/app_router.dart`, add `...productListingRoutes` to the root routes list — nothing else about the router changes.

---

Every future feature follows this same nine-step shape: domain model → DTO → mapper → repository interface/impl → providers → screen → local widgets → route. The names and fields change; the architecture doesn't.


---

## Appendix — Definition Of Done

# Definition of Done — Checklist Before Moving to the Next Module

The user builds one feature at a time and only moves on once the current one "passes all the test cases." Use this checklist at the end of every feature and report it back explicitly — call out anything that genuinely needs the user's real backend to verify (mark it, don't silently skip it).

## Architecture conformance
- [ ] No widget/provider imports `Dio`, `dio`, or a `*Dto` class directly — only the domain repository interface and domain models.
- [ ] Every repository method returns `Result<T, Failure>`; none can throw past its own `try/catch`.
- [ ] The feature lives entirely under `features/<name>/`, with routes registered in their own route file, not hand-edited into a shared list.
- [ ] Any newly-shared widget actually earned its place in `core/widgets/` (used by 2+ features) — nothing promoted "just in case."

## Error handling
- [ ] Loading, data, empty, and error states are all handled and visually distinct — an empty result never looks like an error, and an error never looks like a crash.
- [ ] Every error state has a way forward (retry button, navigate to login, inline field error) — no dead ends.
- [ ] No raw exception text, stack trace, or HTTP status code is ever shown to the user.
- [ ] Tested (or at least reasoned through) what happens on: slow network (loading state shows), request failure (error state + retry works), empty result (empty state, not error).

## Independence & performance
- [ ] Changing one piece of data (e.g. one item's price/favorite state) doesn't visibly rebuild unrelated parts of the screen — verify with Flutter DevTools' rebuild highlighting if unsure.
- [ ] Any list that can exceed a screenful uses `ListView.builder`/`Sliver*`/`GridView.builder` with pagination, not an eagerly-built `Column`.
- [ ] Tested with a realistic data volume (100+ items for lists), not just the 2–3 items in a happy-path mock.
- [ ] `const` used wherever possible; list items have stable `Key`s.

## Layout safety
- [ ] No overflow warnings at the default screen size, a small phone width (~320dp), and with unusually long text in every text field that shows user/backend-provided content (long titles, long names).
- [ ] All `Text` widgets that can overflow have `overflow`/`maxLines` set and are wrapped in `Flexible`/`Expanded` where needed.

## Consistency
- [ ] No hardcoded colors, font sizes, or spacing values — everything traces back to `core/theme/`.
- [ ] Matches the visual language of already-built features (same card styles, same button styles, same spacing rhythm).

## Data safety
- [ ] No token, password, or full API response containing PII is logged, even in debug builds' verbose logging — check the Dio logging interceptor's scope.
- [ ] Sensitive fields (tokens, internal-only IDs) are not exposed as public fields outside the module that owns them.
- [ ] Nothing sensitive is cached in plain `SharedPreferences`/unencrypted storage — tokens go through `SecureStorageService`.

## Handoff notes to give the user
When reporting a finished feature, always state explicitly:
1. What's real vs. mocked (e.g. "repository is wired to a fake in-memory implementation since the `/products` endpoint isn't live yet — swap `ProductRepositoryFake` for `ProductRepositoryImpl` in the provider override once it is").
2. What the user should manually verify with the real backend that can't be verified without it (actual error responses matching the mapped `Failure` messages, actual pagination behavior, actual auth token flow).
3. Any assumption made about the API shape that should be confirmed against real API docs.