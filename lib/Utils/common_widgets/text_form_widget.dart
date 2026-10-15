

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'input_decoration_style.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final GestureTapCallback? onTap;
  final String labelText;
  final bool enabled;
  final bool readOnly;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final TextInputType? textInputType;
  final int? maxLength;
  final int maxLine;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool isRequired;
  final double? fontSize;
  final FontWeight? fontWeight;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;
  final GlobalKey<FormFieldState>? fieldKey;
  final TextInputAction? textInputAction;

  const TextFieldWidget({
    super.key,
    required this.labelText,
    this.fieldKey,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.controller,
    this.initialValue,
    this.onTap,
    this.onChanged,
    this.textInputType,
    this.maxLength,
    this.suffixIcon,
    this.prefixIcon,
    this.maxLine = 1,
    this.isRequired = false,
    this.fontSize,
    this.fontWeight,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.autofillHints,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).colorScheme.onSurface;

    final enabledFill = isDark
        ? Theme.of(context).colorScheme.surfaceContainerHighest
        : Colors.white;
    final disabledFill = isDark
        ? Theme.of(context)
        .colorScheme
        .surfaceContainerHighest
        .withOpacity(0.4)
        : Colors.grey.shade100;

    return TextFormField(
      key: fieldKey,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      controller: controller,
      autofillHints : autofillHints,
      initialValue: controller == null ? initialValue : null,
      onTap: () {
        if (readOnly) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
        onTap?.call();
      },
      enabled: enabled,
      readOnly: readOnly,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: (keyboardType ?? TextInputType.text) == TextInputType.text
          ? TextCapitalization.words
          : TextCapitalization.none,
      onChanged: (value) {
        final state = fieldKey?.currentState;
        if (state != null && state.hasError) {
          state.validate();
        }
        onChanged?.call(value);
      },
      maxLength: maxLength,
      maxLines: maxLine,
      validator: validator,
      inputFormatters: inputFormatters,
      obscureText: obscureText,
      style: TextStyle(
        fontSize: 14,
        color: textColor,
      ),
      decoration: InputDecorationStyle.inputDecoration(
        context,
        labelText: labelText,
        isRequired: isRequired,
      ).copyWith(
        fillColor: enabled ? enabledFill : disabledFill,
        counterText: "",
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}