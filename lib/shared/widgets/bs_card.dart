import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:blindspot/core/constants/app_sizes.dart';
import 'package:blindspot/shared/extensions/build_context_ext.dart';

/// A reusable card widget that wraps its [child] in a styled [Container].
///
/// Supports optional tap callbacks with a subtle press-scale animation,
/// gradient backgrounds, borders, and configurable box shadows.
class BSCard extends StatefulWidget {
  const BSCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.borderRadius,
    this.backgroundColor,
    this.hasBorder = true,
    this.gradient,
    this.width,
    this.height,
    this.boxShadow,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final double? borderRadius;
  final Color? backgroundColor;
  final bool hasBorder;
  final Gradient? gradient;
  final double? width;
  final double? height;
  final List<BoxShadow>? boxShadow;

  @override
  State<BSCard> createState() => _BSCardState();
}

class _BSCardState extends State<BSCard> {
  bool _pressed = false;

  void _handleTapDown(TapDownDetails _) {
    if (widget.onTap != null) setState(() => _pressed = true);
  }

  void _handleTapUp(TapUpDetails _) {
    if (widget.onTap != null) setState(() => _pressed = false);
  }

  void _handleTapCancel() {
    if (widget.onTap != null) setState(() => _pressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? AppSizes.radiusLg;

    final defaultShadow = BoxShadow(
      color: context.isDark ? Colors.black38 : Colors.black.withOpacity(0.04),
      blurRadius: 8,
      offset: const Offset(0, 2),
    );

    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      color: widget.gradient != null
          ? null
          : (widget.backgroundColor ?? context.cardColor),
      gradient: widget.gradient,
      border: widget.hasBorder
          ? Border.all(
              color: context.borderColor,
              width: AppSizes.borderThin,
            )
          : null,
      boxShadow: widget.boxShadow ?? [defaultShadow],
    );

    Widget content = Container(
      width: widget.width,
      height: widget.height,
      decoration: decoration,
      padding: widget.padding ?? EdgeInsets.all(AppSizes.cardPadding),
      child: widget.child,
    );

    if (widget.onTap != null) {
      content = Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(radius),
          onTap: widget.onTap,
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: decoration,
            padding: widget.padding ?? EdgeInsets.all(AppSizes.cardPadding),
            child: widget.child,
          ),
        ),
      );
    }

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: content,
      ),
    );
  }
}
