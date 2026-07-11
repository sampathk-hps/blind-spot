import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:blindspot/core/constants/app_colors.dart';
import 'package:blindspot/core/constants/app_sizes.dart';
import 'package:blindspot/shared/extensions/build_context_ext.dart';

/// A styled [TextFormField] wrapper with label, hint, focus-state borders,
/// and an optional password-visibility toggle.
class BSTextField extends StatefulWidget {
  const BSTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.maxLines = 1,
    this.prefix,
    this.suffix,
    this.onTap,
    this.readOnly = false,
    this.onChanged,
    this.focusNode,
    this.maxLength,
    this.textInputAction,
  });

  final String label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int? maxLines;
  final Widget? prefix;
  final Widget? suffix;
  final VoidCallback? onTap;
  final bool readOnly;
  final void Function(String)? onChanged;
  final FocusNode? focusNode;
  final int? maxLength;
  final TextInputAction? textInputAction;

  @override
  State<BSTextField> createState() => _BSTextFieldState();
}

class _BSTextFieldState extends State<BSTextField> {
  late bool _obscured;
  bool _isFocused = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _obscured = widget.obscureText;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  @override
  void dispose() {
    // Only dispose the focus node if we created it internally.
    if (widget.focusNode == null) {
      _focusNode.removeListener(_onFocusChange);
      _focusNode.dispose();
    }
    super.dispose();
  }

  Widget? _buildSuffixIcon(BuildContext context) {
    if (widget.obscureText) {
      return IconButton(
        icon: Icon(
          _obscured
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: context.secondaryTextColor,
          size: AppSizes.iconMd,
        ),
        onPressed: () => setState(() => _obscured = !_obscured),
      );
    }
    return widget.suffix;
  }

  @override
  Widget build(BuildContext context) {
    final borderColor =
        _isFocused ? AppColors.brandAccent : context.borderColor;

    final fillColor =
        context.isDark ? AppColors.cardDark : AppColors.canvasBackground;

    final hintStyle = GoogleFonts.inter(
      color: context.isDark
          ? AppColors.textTertiaryDark
          : AppColors.textTertiary,
      fontSize: AppSizes.fontMd,
    );

    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      borderSide: BorderSide(color: borderColor, width: AppSizes.borderThin),
    );

    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      borderSide:
          const BorderSide(color: AppColors.brandAccent, width: AppSizes.borderThick),
    );

    final errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      borderSide: BorderSide(
          color: context.statusDangerColor, width: AppSizes.borderThin),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.inter(
            fontSize: AppSizes.fontMd,
            fontWeight: FontWeight.w500,
            color: context.primaryTextColor,
          ),
        ),
        SizedBox(height: AppSizes.sm),
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          obscureText: _obscured,
          keyboardType: widget.maxLines != null && widget.maxLines! > 1
              ? TextInputType.multiline
              : widget.keyboardType,
          validator: widget.validator,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          onTap: widget.onTap,
          readOnly: widget.readOnly,
          onChanged: widget.onChanged,
          maxLength: widget.maxLength,
          textInputAction: widget.textInputAction,
          style: GoogleFonts.inter(
            fontSize: AppSizes.fontMd,
            color: context.primaryTextColor,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: hintStyle,
            prefixIcon: widget.prefix,
            suffixIcon: _buildSuffixIcon(context),
            filled: true,
            fillColor: fillColor,
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSizes.md,
              vertical: AppSizes.md,
            ),
            border: inputBorder,
            enabledBorder: inputBorder,
            focusedBorder: focusedBorder,
            errorBorder: errorBorder,
            focusedErrorBorder: errorBorder,
            counterText: '',
          ),
        ),
      ],
    );
  }
}
