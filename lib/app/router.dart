import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:blindspot/core/constants/app_strings.dart';
import 'package:blindspot/core/di/providers.dart';
import 'package:blindspot/shared/widgets/bs_bottom_nav.dart';
import 'package:blindspot/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:blindspot/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:blindspot/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:blindspot/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:blindspot/features/invoices/presentation/screens/invoice_list_screen.dart';
import 'package:blindspot/features/invoices/presentation/screens/invoice_detail_screen.dart';
import 'package:blindspot/features/invoices/presentation/screens/add_edit_invoice_screen.dart';
import 'package:blindspot/features/insurances/presentation/screens/insurance_list_screen.dart';
import 'package:blindspot/features/insurances/presentation/screens/insurance_detail_screen.dart';
import 'package:blindspot/features/insurances/presentation/screens/add_edit_insurance_screen.dart';
import 'package:blindspot/features/subscriptions/presentation/screens/subscription_list_screen.dart';
import 'package:blindspot/features/subscriptions/presentation/screens/subscription_detail_screen.dart';
import 'package:blindspot/features/subscriptions/presentation/screens/add_edit_subscription_screen.dart';
import 'package:blindspot/features/settings/presentation/screens/settings_screen.dart';
import 'package:blindspot/features/premium/presentation/screens/premium_paywall_screen.dart';

/// Global router provider.
///
/// Reads [sharedPreferencesProvider] synchronously to determine the initial
/// route redirect. Does **not** watch it — the router itself is recreated only
/// when the provider is invalidated, which is intentional.
final routerProvider = Provider<GoRouter>((ref) {
  final prefs = ref.read(sharedPreferencesProvider);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    routes: [
      // ── Root redirect ──────────────────────────────────────────────────────
      GoRoute(
        path: '/',
        redirect: (BuildContext context, GoRouterState state) {
          final onboardingDone =
              prefs.getBool(AppStrings.prefOnboardingComplete) ?? false;
          return onboardingDone ? '/dashboard' : '/onboarding';
        },
      ),

      // ── Auth & Onboarding ──────────────────────────────────────────────────
      GoRoute(
        path: '/onboarding',
        builder: (BuildContext context, GoRouterState state) =>
            const OnboardingScreen(),
      ),
      GoRoute(
        path: '/auth/sign-in',
        builder: (BuildContext context, GoRouterState state) =>
            const SignInScreen(),
      ),
      GoRoute(
        path: '/auth/sign-up',
        builder: (BuildContext context, GoRouterState state) =>
            const SignUpScreen(),
      ),

      // ── Main shell with bottom navigation ─────────────────────────────────
      ShellRoute(
        builder: (BuildContext context, GoRouterState state, Widget child) =>
            MainShell(child: child),
        routes: [
          // Dashboard
          GoRoute(
            path: '/dashboard',
            builder: (BuildContext context, GoRouterState state) =>
                const DashboardScreen(),
          ),

          // Invoices
          GoRoute(
            path: '/invoices',
            builder: (BuildContext context, GoRouterState state) =>
                const InvoiceListScreen(),
            routes: [
              GoRoute(
                path: 'add',
                builder: (BuildContext context, GoRouterState state) =>
                    const AddEditInvoiceScreen(),
              ),
              GoRoute(
                path: ':id',
                builder: (BuildContext context, GoRouterState state) =>
                    InvoiceDetailScreen(
                  invoiceId: state.pathParameters['id']!,
                ),
                routes: [
                  GoRoute(
                    path: 'edit',
                    builder: (BuildContext context, GoRouterState state) =>
                        AddEditInvoiceScreen(
                      invoiceId: state.pathParameters['id'],
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Insurances
          GoRoute(
            path: '/insurances',
            builder: (BuildContext context, GoRouterState state) =>
                const InsuranceListScreen(),
            routes: [
              GoRoute(
                path: 'add',
                builder: (BuildContext context, GoRouterState state) =>
                    const AddEditInsuranceScreen(),
              ),
              GoRoute(
                path: ':id',
                builder: (BuildContext context, GoRouterState state) =>
                    InsuranceDetailScreen(
                  insuranceId: state.pathParameters['id']!,
                ),
                routes: [
                  GoRoute(
                    path: 'edit',
                    builder: (BuildContext context, GoRouterState state) =>
                        AddEditInsuranceScreen(
                      insuranceId: state.pathParameters['id'],
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Subscriptions
          GoRoute(
            path: '/subscriptions',
            builder: (BuildContext context, GoRouterState state) =>
                const SubscriptionListScreen(),
            routes: [
              GoRoute(
                path: 'add',
                builder: (BuildContext context, GoRouterState state) =>
                    const AddEditSubscriptionScreen(),
              ),
              GoRoute(
                path: ':id',
                builder: (BuildContext context, GoRouterState state) =>
                    SubscriptionDetailScreen(
                  subscriptionId: state.pathParameters['id']!,
                ),
                routes: [
                  GoRoute(
                    path: 'edit',
                    builder: (BuildContext context, GoRouterState state) =>
                        AddEditSubscriptionScreen(
                      subscriptionId: state.pathParameters['id'],
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Settings
          GoRoute(
            path: '/settings',
            builder: (BuildContext context, GoRouterState state) =>
                const SettingsScreen(),
          ),
        ],
      ),

      // ── Standalone (no bottom nav) ─────────────────────────────────────────
      GoRoute(
        path: '/premium',
        builder: (BuildContext context, GoRouterState state) =>
            const PremiumScreen(),
      ),
    ],
  );
});
