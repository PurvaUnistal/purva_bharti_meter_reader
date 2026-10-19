import 'package:flutter/material.dart';
import 'package:meter_reader_new/Utils/common_widgets/res/styles_widget.dart';

import 'res/environment_config.dart';

class ButtonWidget extends StatelessWidget {
  /// Pass null to disable the button.
  final VoidCallback? onPressed;
  final String? text;

  /// Custom content instead of [text].
  final Widget? child;

  /// Shows a spinner and disables the button.
  final bool loading;

  /// Optional colour overrides (useful inside dialogs).
  final Color? backgroundColor;
  final Color? borderColor;

  const ButtonWidget({
    Key? key,
    required this.onPressed,
    this.text,
    this.child,
    this.loading = false,
    this.backgroundColor,
    this.borderColor,
  })  : assert(text != null || child != null, 'Provide text or child'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final config = EnvironmentConfig.of(context);
    final bg = backgroundColor ?? config?.primaryTheme ?? Theme.of(context).primaryColor;
    final border = borderColor ?? config?.secondaryTheme ?? bg;

    return ElevatedButton(
      onPressed: loading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: Colors.white,
        disabledBackgroundColor: bg.withValues(alpha: 0.6),
        disabledForegroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(width: 2, color: border),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: loading
              ? const SizedBox(
            key: ValueKey('loading'),
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
                strokeWidth: 2, color: Colors.white),
          )
              : KeyedSubtree(
            key: const ValueKey('content'),
            child: child ?? Text(text!, style: Styles.login),
          ),
        ),
      ),
    );
  }
}