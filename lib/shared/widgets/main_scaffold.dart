import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:blindspot/core/constants/app_colors.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;
  const MainScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    int currentIndex = 0;
    if (location.startsWith('/dashboard')) currentIndex = 0;
    if (location.startsWith('/invoices')) currentIndex = 1;
    if (location.startsWith('/insurances')) currentIndex = 2;
    if (location.startsWith('/subscriptions')) currentIndex = 3;
    if (location.startsWith('/settings')) currentIndex = 4;

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          switch (index) {
            case 0: context.go('/dashboard'); break;
            case 1: context.go('/invoices'); break;
            case 2: context.go('/insurances'); break;
            case 3: context.go('/subscriptions'); break;
            case 4: context.go('/settings'); break;
          }
        },
        backgroundColor: isDark ? AppColors.cardDark : AppColors.cardSurface,
        indicatorColor: AppColors.brandAccentLight,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard_rounded, color: AppColors.brandAccent), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long_rounded, color: AppColors.brandAccent), label: 'Invoices'),
          NavigationDestination(icon: Icon(Icons.shield_outlined), selectedIcon: Icon(Icons.shield_rounded, color: AppColors.brandAccent), label: 'Insurances'),
          NavigationDestination(icon: Icon(Icons.autorenew_outlined), selectedIcon: Icon(Icons.autorenew_rounded, color: AppColors.brandAccent), label: 'Subs'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings_rounded, color: AppColors.brandAccent), label: 'Settings'),
        ],
      ),
    );
  }
}
