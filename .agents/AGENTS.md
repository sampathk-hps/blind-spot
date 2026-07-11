# BlindSpot — Agent Rules

These rules govern **every code change** made to this project. They encode the
architecture decisions that were established and enforced during the production
refactor. Follow them without exception.

---

## 1. Project Identity

- **App name:** `BlindSpot` — always referenced via `AppStrings.appName`, never a raw string.
- **Package:** `com.blindspot` (Android) / `com.blindspot` (iOS)
- **Version:** tracked in `pubspec.yaml` and mirrored in `AppStrings.appVersion`.
- **Dart SDK:** `>=3.3.0 <4.0.0` — use modern Dart features (records, patterns, sealed classes).

---

## 2. Architecture: Clean Architecture (per feature)

Every feature under `lib/features/<feature>/` **must** have three layers:

```
features/<feature>/
├── data/
│   ├── models/          # JSON/Map ↔ entity mapping (XxxModel)
│   ├── repositories/    # XxxRepositoryImpl (implements domain interface)
│   └── services/        # Third-party SDK wrappers (Firebase, IAP, AI, etc.)
├── domain/
│   ├── entities/        # Pure Dart classes — NO Flutter, NO Hive, NO Firebase
│   ├── repositories/    # abstract interface XxxRepository
│   └── use_cases/       # (optional) single-responsibility business logic objects
└── presentation/
    ├── providers/       # Riverpod StateNotifier + FutureProvider + Provider
    └── screens/         # ConsumerWidget / ConsumerStatefulWidget only
```

### Layer rules

| Rule | Detail |
|---|---|
| **Domain is pure Dart** | No `package:flutter`, no `package:hive`, no `package:firebase_*` imports inside `domain/`. |
| **Data wraps SDKs** | All Firebase, Hive, and third-party SDK calls live exclusively in `data/`. Never in `domain/` or `presentation/`. |
| **Presentation reads providers** | Screens observe Riverpod state. They never instantiate repositories, services, or singletons directly. |
| **No skipping layers** | A screen must not import a `RepositoryImpl` directly — only the abstract interface via its provider. |

---

## 3. Dependency Injection — Riverpod Only

**Rule: Never call `.instance` or any static factory in presentation or domain code.**

All infrastructure objects are provided through `lib/core/di/providers.dart`.

### Canonical provider list

| Provider | Type | What it provides |
|---|---|---|
| `sharedPreferencesProvider` | `Provider<SharedPreferences>` | Lightweight key-value preferences |
| `hiveServiceProvider` | `Provider<HiveService>` | Encrypted Hive box access |
| `secureStorageProvider` | `Provider<SecureStorageService>` | Keychain / Keystore secrets |
| `encryptionServiceProvider` | `Provider<EncryptionService>` | AES-256-CBC field encryption |
| `authServiceProvider` | `Provider<AuthService>` | Firebase Auth wrapper |
| `themeModeProvider` | `StateProvider<ThemeMode>` | App-wide theme |
| `biometricEnabledProvider` | `StateProvider<bool>` | Biometric gate toggle |
| `userTierProvider` | `StateProvider<UserTier>` | Free / Premium tier |
| `isPremiumProvider` | `Provider<bool>` | Derived from `userTierProvider` |
| `notificationLeadDaysProvider` | `StateProvider<int>` | Days ahead for reminders |

### Correct pattern
```dart
final invoiceRepositoryProvider = Provider<InvoiceRepository>((ref) {
  return InvoiceRepositoryImpl(hiveService: ref.read(hiveServiceProvider));
});
```

### Forbidden pattern
```dart
// Never do this inside a provider or screen:
HiveService.instance           // bypasses DI
SharedPreferences.getInstance() // bypasses DI
FirebaseAuth.instance           // bypasses DI
```

### Adding a new provider

1. Add it to `lib/core/di/providers.dart`.
2. If it requires async init, initialise it in `main.dart` and override before `runApp`.
3. Override with a mock in tests using `ProviderScope(overrides: [...])`.

---

## 4. Constants — Zero Literals Rule

> **No raw string, colour, or size literal is allowed anywhere in the widget tree or providers.**

### AppStrings — `lib/core/constants/app_strings.dart`
Covers: all UI copy, Hive box names, SharedPreferences keys, secure storage keys, IAP product IDs, default currency.

- Adding a new screen? Add its strings here first.
- Default currency must always be `AppStrings.defaultCurrency` (`'USD'`).
- Version string must always be `AppStrings.appVersion`.

### AppColors — `lib/core/constants/app_colors.dart`
Covers: all brand tokens, semantic status colours, dark-mode overrides, metric card colours.

- Never use `Colors.pink`, `Colors.teal`, `Colors.amber`, `Colors.red`, etc. inline.
- Dark-mode aware colours must use `context.cardColor`, `context.primaryTextColor`, `context.secondaryTextColor`, `context.textTertiary`, `context.borderColor`, and the `context.status*` variants — all exposed via `BuildContextExt`.
- Add a new semantic token to `AppColors` before using it in any widget.

### AppSizes — `lib/core/constants/app_sizes.dart`
Covers: padding, border radii, icon sizes, font sizes, button heights, opacity values.

- Never use a raw `double` literal for spacing (`SizedBox(height: 16)` → `SizedBox(height: AppSizes.md)`).
- Never hardcode `BorderRadius.circular(12)` — use `AppSizes.radiusLg` etc.

---

## 5. State Management — Riverpod Patterns

### Choosing the right provider

| Situation | Use |
|---|---|
| Async data loaded once | `FutureProvider` |
| Mutable list / CRUD operations | `StateNotifierProvider<XxxNotifier, AsyncValue<void>>` |
| Read-only derived value | `Provider` |
| Simple mutable flag or scalar | `StateProvider` |
| Firebase / external stream | `StreamProvider` |

### StateNotifier conventions

```dart
class InvoiceNotifier extends StateNotifier<AsyncValue<void>> {
  InvoiceNotifier(this._ref) : super(const AsyncValue.data(null));
  final Ref _ref;

  InvoiceRepository get _repo => _ref.read(invoiceRepositoryProvider);

  Future<void> addInvoice(InvoiceEntity invoice) async {
    state = const AsyncValue.loading();
    try {
      await _repo.saveInvoice(invoice);
      _ref.invalidate(invoicesProvider); // always invalidate the list
      state = const AsyncValue.data(null);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
      rethrow; // let the UI catch and show a snack bar
    }
  }
}
```

Rules:
- Always set `state = const AsyncValue.loading()` before async work.
- Always `invalidate` the relevant `FutureProvider` after a mutation.
- Always `rethrow` so the calling screen can handle error display.
- Never catch errors silently.

### Watching vs reading

- `ref.watch(...)` — inside `build()` only (reactive).
- `ref.read(...)` — inside callbacks and `StateNotifier` methods only.
- Never use `ref.watch` inside a callback or event handler.

---

## 6. Navigation — go_router

- All routes are declared in `lib/app/router.dart` via `routerProvider`.
- Never use `Navigator.push` / `Navigator.pop` — always use `context.go()`, `context.push()`, or `context.pop()`.
- The main shell (bottom nav) wraps routes inside `ShellRoute`. Dashboard, Invoices, Insurances, Subscriptions, Settings are shell children.
- Premium paywall and other full-screen flows are top-level `GoRoute` entries (no bottom nav).
- Auth redirect logic lives in the root `'/'` route's `redirect` callback — keep it there.
- Route path strings must be defined as constants if reused; single-use paths may be inline literals.

---

## 7. Feature: Auth

- `AuthService` (`features/auth/data/services/auth_service.dart`) is the **only** file allowed to import `package:firebase_auth`.
- `AuthNotifier` (`features/auth/presentation/providers/auth_provider.dart`) interacts with `AuthService` only — zero Firebase imports.
- All `FirebaseAuthException` codes are mapped to user-friendly messages inside `AuthService.mapError()`. Screens display the returned string; they do not inspect exception codes.

---

## 8. Feature: Premium / IAP

- IAP logic lives in `features/premium/data/services/iap_service.dart`.
- The premium gate UI is `shared/widgets/bs_premium_gate.dart` — wrap any premium-only widget with it.
- The tier is stored in `userTierProvider` (derived from SharedPreferences).
- Never hardcode tier checks inline — always consume `ref.watch(isPremiumProvider)`.
- `subscription_plan/` folder is deprecated and must not receive new code — use `premium/` exclusively.

---

## 9. Security Rules

- **Hive boxes** must always be opened with `HiveAesCipher` via `HiveService`. Never open a raw unencrypted box.
- **Encryption key** lives in `flutter_secure_storage` under `AppStrings.secureKeyHiveEncryption`. Never log or print keys.
- **Field-level encryption** (`EncryptionService`) must be applied to all sensitive fields before cloud (Firestore) upload. Firestore stores only ciphertext.
- **Secure storage** keys must be defined in `AppStrings` under the `// Secure Storage Keys` section. Never use a raw string key.
- **Biometric gate**: respect `biometricEnabledProvider` on app resume — do not bypass for convenience.

---

## 10. Shared Widgets — When to Use What

| Widget | Purpose |
|---|---|
| `BSCard` | Any card-shaped container — supports tap, gradient, border |
| `BSButton.primary` | Gradient-fill CTA |
| `BSButton.secondary` | Outlined brand-accent button |
| `BSButton.ghost` | Text-only button |
| `BSTextField` | All form text inputs |
| `BSBadge.safe/.warning/.danger` | Status chips |
| `BSEmptyState` | Zero-data placeholder with optional CTA |
| `BSShimmerCard` | Loading skeleton for list items |
| `BSPremiumGate` | Blur overlay for non-premium content |
| `BSAppBar` | Standard app bar with back-button logic |
| `BuildContextExt.showSnackBar` | All in-app snack bar messages |

Never create a one-off `Container+BoxDecoration` that duplicates `BSCard` behaviour.

---

## 11. Shared Models — Enums

All shared domain enums live in `lib/shared/models/`:

| File | Enums |
|---|---|
| `app_category.dart` | `AppCategory`, `InsuranceType` |
| `billing_cycle.dart` | `BillingCycle` |
| `user_tier.dart` | `UserTier` |

### Enum serialisation contract

Every enum **must** implement:
```dart
String toJson() => name;

static XxxEnum fromJson(String? value) =>
    XxxEnum.values.firstWhere((e) => e.name == value,
        orElse: () => XxxEnum.defaultValue);
```

`fromJson` **must** accept `String?` (nullable). The `orElse` fallback must always return a safe default.

---

## 12. Data Layer — Model Conventions

Every `XxxModel` in `features/<f>/data/models/` must:

1. Implement or extend `XxxEntity`.
2. Provide `fromMap(Map<String, dynamic> map)` and `toMap()` for Hive serialisation.
3. Provide `fromEntity(XxxEntity e)` for converting domain → data.
4. Never expose Hive, Firebase, or platform types in its public interface.

---

## 13. Naming Conventions

| Artefact | Convention | Example |
|---|---|---|
| Entities | `XxxEntity` (final class) | `InvoiceEntity` |
| Models | `XxxModel` | `InvoiceModel` |
| Repository interface | `XxxRepository` (abstract) | `InvoiceRepository` |
| Repository implementation | `XxxRepositoryImpl` | `InvoiceRepositoryImpl` |
| Notifiers | `XxxNotifier` | `InvoiceNotifier` |
| Providers | `xxxProvider` / `xxxNotifierProvider` | `invoicesProvider`, `invoiceNotifierProvider` |
| Screens | `XxxScreen` | `InvoiceListScreen` |
| Services (data layer) | `XxxService` | `AuthService`, `IapService` |
| Shared widgets | `BS` prefix | `BSCard`, `BSButton` |
| Files | `snake_case.dart` | `invoice_list_screen.dart` |

---

## 14. Typography

Always use `google_fonts` — never the default system font:

| Usage | Font |
|---|---|
| Display / headings (h1–h3) | `GoogleFonts.spaceGrotesk(...)` |
| UI copy / body / labels | `GoogleFonts.inter(...)` |
| Numeric values, amounts, dates, keys | `GoogleFonts.jetBrainsMono(...)` |

Font size tokens come from `AppSizes` (`fontXs`, `fontSm`, `fontMd`, `fontLg`, `fontXl`).

---

## 15. Controller Lifecycle

Every `StatefulWidget` or `ConsumerStatefulWidget` that creates a `TextEditingController`, `ScrollController`, `PageController`, `AnimationController`, or `FocusNode` **must** dispose it in `dispose()`:

```dart
@override
void dispose() {
  _controller.dispose();
  super.dispose();
}
```

Failure to do so causes memory leaks.

---

## 16. Testing

- Unit-testable code lives in `domain/` and `core/utils/` — no Flutter dependencies.
- Feature providers must be testable via `ProviderContainer` with infrastructure providers overridden.
- Test files mirror the `lib/` structure under `test/`.
- Never ship a feature without at least one unit test for its entity's computed properties and its repository's CRUD round-trip.

---

## 17. Forbidden Patterns — Quick Reference

```dart
// RAW STRINGS
Text('Invoices')                          // ❌
Text(AppStrings.invoices)                 // ✅

// RAW COLOURS
color: Colors.pink                        // ❌
color: AppColors.metricInvoiceColor       // ✅

// RAW SIZES
SizedBox(height: 16)                      // ❌
SizedBox(height: AppSizes.md)             // ✅

// DI VIOLATIONS
HiveService.instance                      // ❌
ref.read(hiveServiceProvider)             // ✅

SharedPreferences.getInstance()           // ❌
ref.read(sharedPreferencesProvider)       // ✅

FirebaseAuth.instance                     // ❌
ref.read(authServiceProvider)             // ✅

// NAVIGATION
Navigator.push(context, ...)              // ❌
context.push('/route')                    // ✅

// CURRENCY
CurrencyFormatter.format(total, 'USD')    // ❌
CurrencyFormatter.format(total, AppStrings.defaultCurrency)  // ✅

// ENUM SERIALISATION
static UserTier fromJson(String v) => ... // ❌ (non-nullable)
static UserTier fromJson(String? v) => .. // ✅

// SILENT ERRORS
} catch (e) { /* nothing */ }             // ❌
} catch (e, s) { state = AsyncValue.error(e, s); rethrow; }  // ✅

// FIREBASE IN PRESENTATION
FirebaseAuth.instance.signIn(...)         // ❌
ref.read(authServiceProvider).signInWithEmail(...)  // ✅
```
