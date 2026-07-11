import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:blindspot/core/constants/app_sizes.dart';
import 'package:blindspot/shared/extensions/build_context_ext.dart';

/// A pre-styled [AppBar] that implements [PreferredSizeWidget].
///
/// - Transparent background by default.
/// - Zero elevation and scroll-under tint.
/// - Space Grotesk title typography.
/// - Optional back button that calls [onBackPressed] or [GoRouter.pop].
/// - Subtle 1 px bottom divider.
class BSAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BSAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton = true,
    this.leading,
    this.centerTitle = false,
    this.backgroundColor,
    this.onBackPressed,
  });

  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final VoidCallback? onBackPressed;

  @override
  Size get preferredSize =>
      const Size.fromHeight(AppSizes.appBarHeight + 1);

  @override
  Widget build(BuildContext context) {
    final Widget leadingWidget;

    if (showBackButton) {
      leadingWidget = IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: AppSizes.iconMd,
          color: context.primaryTextColor,
        ),
        onPressed: onBackPressed ?? () => context.pop(),
      );
    } else {
      leadingWidget = leading ?? const SizedBox.shrink();
    }

    return AppBar(
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: AppSizes.elevationNone,
      scrolledUnderElevation: AppSizes.elevationNone,
      surfaceTintColor: Colors.transparent,
      centerTitle: centerTitle,
      leading: leadingWidget,
      automaticallyImplyLeading: false,
      actions: actions,
      title: Text(
        title,
        style: GoogleFonts.spaceGrotesk(
          fontSize: AppSizes.fontXl,
          fontWeight: FontWeight.w600,
          color: context.primaryTextColor,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(
          height: 1,
          thickness: 1,
          color: context.borderColor,
        ),
      ),
    );
  }
}
