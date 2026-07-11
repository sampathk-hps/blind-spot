import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:blindspot/core/constants/app_colors.dart';
import 'package:blindspot/core/constants/app_sizes.dart';
import 'package:blindspot/core/constants/app_strings.dart';
import 'package:blindspot/shared/extensions/build_context_ext.dart';

// ---------------------------------------------------------------------------
// MainShell
// ---------------------------------------------------------------------------

/// Root scaffold shell that hosts [BSBottomNav] and delegates routing to [child].
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BSBottomNav(
        currentIndex: _getCurrentIndex(context),
        onTap: (index) => _navigate(context, index),
      ),
    );
  }

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/invoices')) return 1;
    if (location.startsWith('/insurances')) return 2;
    if (location.startsWith('/subscriptions')) return 3;
    if (location.startsWith('/settings')) return 4;
    return 0; // dashboard
  }

  void _navigate(BuildContext context, int index) {
    const routes = [
      '/dashboard',
      '/invoices',
      '/insurances',
      '/subscriptions',
      '/settings',
    ];
    context.go(routes[index]);
  }
}

// ---------------------------------------------------------------------------
// BSBottomNav
// ---------------------------------------------------------------------------

/// Custom bottom navigation bar widget.
///
/// Renders five [_TabItem] entries for Dashboard, Invoices, Insurance,
/// Subscriptions, and Settings.
class BSBottomNav extends StatelessWidget {
  const BSBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardColor,
        border: Border(
          top: BorderSide(color: context.borderColor, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: AppSizes.bottomNavHeight,
          child: Row(
            children: [
              _TabItem(
                selectedIcon: Icons.grid_view_rounded,
                unselectedIcon: Icons.grid_view_outlined,
                label: AppStrings.navDashboard,
                selected: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _TabItem(
                selectedIcon: Icons.receipt_long_rounded,
                unselectedIcon: Icons.receipt_long_outlined,
                label: AppStrings.navInvoices,
                selected: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              _TabItem(
                selectedIcon: Icons.shield_rounded,
                unselectedIcon: Icons.shield_outlined,
                label: AppStrings.navInsurance,
                selected: currentIndex == 2,
                onTap: () => onTap(2),
              ),
              _TabItem(
                selectedIcon: Icons.autorenew_rounded,
                unselectedIcon: Icons.sync_outlined,
                label: AppStrings.navSubscriptions,
                selected: currentIndex == 3,
                onTap: () => onTap(3),
              ),
              _TabItem(
                selectedIcon: Icons.settings_rounded,
                unselectedIcon: Icons.settings_outlined,
                label: AppStrings.navSettings,
                selected: currentIndex == 4,
                onTap: () => onTap(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _TabItem  (private)
// ---------------------------------------------------------------------------

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.selectedIcon,
    required this.unselectedIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData selectedIcon;
  final IconData unselectedIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color =
        selected ? AppColors.brandAccent : context.secondaryTextColor;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with animated switcher
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: animation,
                child: child,
              ),
              child: Icon(
                selected ? selectedIcon : unselectedIcon,
                key: ValueKey<bool>(selected),
                size: AppSizes.iconMd,
                color: color,
              ),
            ),
            SizedBox(height: AppSizes.xs),
            // Label
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: GoogleFonts.inter(
                fontSize: AppSizes.fontXs,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: color,
              ),
              child: Text(label),
            ),
            SizedBox(height: AppSizes.xs),
            // Active dot indicator
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: selected
                  ? Container(
                      key: const ValueKey('dot'),
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: AppColors.brandAccent,
                        shape: BoxShape.circle,
                      ),
                    ).animate().scale(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOut,
                      )
                  : const SizedBox(key: ValueKey('no-dot'), width: 4, height: 4),
            ),
          ],
        ),
      ),
    );
  }
}
