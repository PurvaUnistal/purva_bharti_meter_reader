import 'package:flutter/material.dart';
import 'package:meter_reader_new/Utils/common_widgets/res/environment_config.dart';


class InputDecorationStyle {
  static InputDecoration inputDecoration(
      BuildContext context, {
        String? labelText,
        bool isRequired = false,
        Widget? suffixIcon,
        IconData? prefixIcon,
        double? fontSize,
        FontWeight? fontWeight,
      }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = EnvironmentConfig.of(context)!.primaryTheme;

    final fillColor = isDark
        ? theme.colorScheme.surfaceContainerHighest
        : Colors.white;

    final textColor = theme.colorScheme.onSurface;         // ✅ auto light/dark
    final hintColor = theme.colorScheme.onSurfaceVariant;  // ✅ softer hint

    return InputDecoration(
      filled: true,
      fillColor: fillColor,
      isDense: true,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12),

      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: primaryColor)
          : null,

      suffixIcon: suffixIcon,

      label: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: labelText ?? '',
              style: TextStyle(
                color: textColor,
                fontSize: fontSize ?? 12,
                fontWeight: fontWeight ?? FontWeight.w500,
              ),
            ),
            if (isRequired)
              const TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
        maxLines: 1,                       // ✅ never wrap
        overflow: TextOverflow.ellipsis,   // ✅ show "..." if too long
        softWrap: false,
      ),

      hint: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: labelText ?? '',
              style: TextStyle(
                color: textColor,
                fontSize: fontSize ?? 14,
                fontWeight: fontWeight ?? FontWeight.w500,
              ),
            ),
            if (isRequired)
              const TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
      ),

      hintStyle: TextStyle(
        color: hintColor,
        fontSize: fontSize ?? 14,
        fontWeight:  fontWeight ?? FontWeight.w500,
      ),

      // ✅ Theme-aware label style (when floating)
      labelStyle: TextStyle(
        color: textColor,
        fontSize: fontSize ?? 14,
        fontWeight:  fontWeight ?? FontWeight.w500,
      ),

      // ✅ Floating label color when focused
      floatingLabelStyle: TextStyle(
        color: primaryColor,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColor, width: 1.2),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark
              ? primaryColor.withOpacity(0.6)
              : primaryColor,
          width: 1.2,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColor, width: 1.5),
      ),

      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? Colors.grey.shade700 : Colors.grey.shade400,
          width: 1.0,
        ),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }
}