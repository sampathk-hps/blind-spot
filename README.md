# BlindSpot

> **Never miss a deadline again** — Track invoices, insurances, and subscriptions with automated alerts and AES-256 encryption.

---

## Architecture

BlindSpot follows **Clean Architecture** with three clearly separated layers per feature:

```
lib/
├── app/
│   ├── app.dart                    # MaterialApp.router entry point
│   └── router.dart                 # go_router config + routerProvider
│
├── core/                           # Cross-cutting concerns (no feature logic)
│   ├── constants/
│   │   ├── app_colors.dart         # All colour tokens — zero raw Color() elsewhere
│   │   ├── app_sizes.dart          # Spacing, radii, icon sizes, font sizes
│   │   └── app_strings.dart        # All UI copy — zero inline string literals elsewhere
│   ├── di/
│   │   └── providers.dart          # Global Riverpod providers (HiveService, SharedPrefs, theme…)
│   ├── error/
│   │   └── failures.dart           # Typed failure classes (IapFailure, etc.)
│   ├── security/
│   │   └── encryption_service.dart # AES-256-CBC field encryption
│   ├── storage/
│   │   ├── hive_service.dart       # Encrypted Hive box initialisation
│   │   └── secure_storage_service.dart # flutter_secure_storage wrapper
│   ├── theme/
│   │   └── app_theme.dart          # Light + Dark ("Encrypted Obsidian") ThemeData factories
│   └── utils/
│       ├── currency_formatter.dart # Multi-currency formatting
│       └── date_formatter.dart     # Consistent date display
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   └── services/
│   │   │       └── auth_service.dart        # Firebase Auth abstraction (data layer only)
│   │   ├── domain/                          # (future: auth-specific entities/use cases)
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── auth_provider.dart       # AuthNotifier + authStateProvider (no Firebase import)
│   │       └── screens/
│   │           ├── sign_in_screen.dart
│   │           └── sign_up_screen.dart
│   ├── dashboard/
│   │   └── presentation/screens/dashboard_screen.dart
│   ├── invoices/
│   │   ├── data/
│   │   │   ├── models/invoice_model.dart
│   │   │   └── repositories/invoice_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/invoice_entity.dart
│   │   │   └── repositories/invoice_repository.dart   # abstract interface
│   │   └── presentation/
│   │       ├── providers/invoice_provider.dart
│   │       └── screens/
│   │           ├── invoice_list_screen.dart
│   │           ├── invoice_detail_screen.dart
│   │           └── add_edit_invoice_screen.dart
│   ├── insurances/                 # mirrors invoices structure
│   ├── subscriptions/              # mirrors invoices structure
│   ├── onboarding/
│   │   └── presentation/screens/onboarding_screen.dart
│   ├── premium/
│   │   ├── data/
│   │   │   └── services/
│   │   │       └── iap_service.dart            # in_app_purchase wrapper
│   │   └── presentation/screens/
│   │       └── premium_paywall_screen.dart     # exports PremiumScreen
│   ├── settings/
│   │   └── presentation/screens/settings_screen.dart
│   └── ai/
│       └── data/ai_service.dart               # Gemini API wrapper (Premium)
│
└── shared/
    ├── extensions/
    │   ├── build_context_ext.dart  # Theme helpers, showSnackBar
    │   └── date_time_ext.dart
    ├── models/
    │   ├── app_category.dart       # AppCategory + InsuranceType enums
    │   ├── billing_cycle.dart      # BillingCycle enum with date math
    │   └── user_tier.dart          # UserTier enum (free / premium)
    └── widgets/
        ├── animated_metric_card.dart
        ├── bs_app_bar.dart
        ├── bs_badge.dart
        ├── bs_bottom_nav.dart      # MainShell + BSBottomNav
        ├── bs_button.dart          # Primary / Secondary / Ghost variants
        ├── bs_card.dart
        ├── bs_empty_state.dart
        ├── bs_loading.dart
        ├── bs_premium_gate.dart    # Blur overlay for non-premium users
        └── bs_text_field.dart
```

---

## Technology Stack

| Concern | Solution |
|---|---|
| State Management | `flutter_riverpod` 2.x (`StateNotifier`, `FutureProvider`, `Provider`) |
| Navigation | `go_router` — declarative, redirect-based auth guard |
| Local Storage | `hive_flutter` + `HiveAesCipher` (AES-256 encrypted at rest) |
| Encryption Keys | `flutter_secure_storage` (iOS Keychain / Android Keystore) |
| Auth | Firebase Auth via `AuthService` abstraction (presentation layer is Firebase-free) |
| Cloud Sync (Premium) | Cloud Firestore |
| Push (Premium) | Firebase Cloud Messaging (FCM) |
| AI Features (Premium) | Gemini 1.5 Flash via `google_generative_ai` |
| IAP | `in_app_purchase` — wrapped in `IapService` (`features/premium/data/services/`) |
| Typography | Space Grotesk (headings) · Inter (UI) · JetBrains Mono (amounts & dates) |

---

## Dependency Injection

All infrastructure objects are provided through **Riverpod providers** in `lib/core/di/providers.dart`. Nothing calls `.instance` directly inside feature providers or UI code.

| Provider | Type | Purpose |
|---|---|---|
| `hiveServiceProvider` | `Provider<HiveService>` | Encrypted Hive box access |
| `sharedPreferencesProvider` | `Provider<SharedPreferences>` | Lightweight key-value prefs |
| `authServiceProvider` | `Provider<AuthService>` | Firebase Auth wrapper |
| `themeModeProvider` | `StateProvider<ThemeMode>` | Live theme switching |
| `biometricEnabledProvider` | `StateProvider<bool>` | Biometric gate toggle |
| `isPremiumProvider` | `Provider<bool>` | Tier gate for premium features |

---

## Constants Policy

> **Zero literals in the widget tree.** Every string, colour, and size comes from a constant.

| Constant class | Governs |
|---|---|
| `AppStrings` | All UI copy, Hive box names, SharedPreferences keys, secure storage keys |
| `AppColors` | All colours including semantic variants (metric card, status, dark overrides) |
| `AppSizes` | Padding, border radii, icon sizes, font sizes, button heights |

---

## Subscription Tiers

| Feature | Free | Premium |
|---|---|---|
| Local encrypted storage | ✅ | ✅ |
| Manual data entry | ✅ | ✅ |
| Local notifications | ✅ | ✅ |
| AES-256 encryption | ✅ | ✅ |
| Cloud backup (Firestore) | ❌ | ✅ |
| Multi-device sync | ❌ | ✅ |
| AI auto-categorization | ❌ | ✅ |
| AI smart tagging | ❌ | ✅ |
| FCM push notifications | ❌ | ✅ |

---

## Setup

### 1. Install dependencies
```bash
flutter pub get
```

### 2. Configure Firebase

> ⚠️ Firebase features require your own project configuration.

1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Add Android app (package: `com.blindspot`) → download `google-services.json` → place in `android/app/`
3. Add iOS app (bundle ID: `com.blindspot`) → download `GoogleService-Info.plist` → place in `ios/Runner/`
4. Run:
   ```bash
   npx -y firebase-tools@latest login
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```
   This regenerates `lib/firebase_options.dart` with your project values.

5. Enable in Firebase Console:
   - Authentication → Email/Password + Google providers
   - Firestore Database (premium cloud sync)
   - Cloud Messaging (premium push notifications)

### 3. Configure AI Features (Premium)

The Gemini API key is stored in `flutter_secure_storage` under the key defined by `AppStrings.secureKeyGemini` (`blindspot_gemini_key`).

Get your key at [aistudio.google.com](https://aistudio.google.com)

### 4. Configure IAP

Register products in:
- **App Store Connect** (iOS): product IDs `blindspot_premium_monthly` and `blindspot_premium_annual`  
  *(defined in `AppStrings.iapMonthlyId` / `AppStrings.iapAnnualId`)*
- **Google Play Console** (Android): same product IDs

### 5. Run the app
```bash
flutter run
```

---

## Design System

| Token | Light | Dark |
|---|---|---|
| Canvas | Slate-50 `#F8FAFC` | Obsidian `#090D16` |
| Card surface | White `#FFFFFF` | `#121824` |
| Brand accent | Indigo-600 `#6366F1` | Same |
| Typography | Space Grotesk (display) · Inter (UI) · JetBrains Mono (numbers) | Same |

All tokens live in `AppColors`, `AppSizes`, and `AppStrings` — the widget tree contains zero raw literals.

---

## Security Model

- All local data is encrypted with **AES-256-CBC** via Hive's `HiveAesCipher`
- The Hive encryption key is generated once with `Hive.generateSecureKey()` and stored in the platform secure enclave (iOS Keychain / Android Keystore) via `flutter_secure_storage`
- Premium cloud data: field-level AES-256 encryption occurs **before** Firestore upload — Firestore only ever stores ciphertext
- Biometric gate on app resume is fully configurable via Settings (wired to `biometricEnabledProvider`)

---

## License

Private — All rights reserved. BlindSpot © 2025.
