import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Works as before with showDialog(builder: (_) => MessageBoxTwoButtonPopWidget(...)),
/// or use MessageBoxTwoButtonPopWidget.show(...) for the slide-up sheet.
///
/// Confirm UI: a bottom sheet with large, thumb-friendly
/// buttons. For destructive actions the confirm button is press-and-hold,
/// so a stray tap in the field can't log someone out or delete a reading.
///
///   final ok = await MessageBoxTwoButtonPopWidget.show(
///     context,
///     message: 'Log out?',
///     subMessage: 'Unsynced readings stay on this device.',
///     okButtonText: 'Log out',
///     icon: Icons.logout_rounded,
///     destructive: true,
///   );
class MessageBoxTwoButtonPopWidget extends StatelessWidget {
  final String message;
  final String? subMessage;
  final String okButtonText;
  final String cancelButtonText;
  final VoidCallback onPressed;
  final VoidCallback? onCancel;
  final IconData icon;
  final bool destructive;

  const MessageBoxTwoButtonPopWidget({
    super.key,
    required this.message,
    this.subMessage,
    required this.onPressed,
    required this.okButtonText,
    this.onCancel,
    this.cancelButtonText = 'Cancel',
    this.icon = Icons.help_outline_rounded,
    this.destructive = false,
  });

  static Future<bool> show(
      BuildContext context, {
        required String message,
        String? subMessage,
        required String okButtonText,
        String cancelButtonText = 'Cancel',
        IconData icon = Icons.help_outline_rounded,
        bool destructive = false,
      }) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (ctx) => MessageBoxTwoButtonPopWidget(
        onPressed: () => Navigator.of(ctx).pop(true),
        onCancel: () => Navigator.of(ctx).pop(false),
        message: message,
        subMessage: subMessage,
        okButtonText: okButtonText,
        cancelButtonText: cancelButtonText,
        icon: icon,
        destructive: destructive,
      ),
    );
    return result ?? false;
  }

  static const _ink = Color(0xFF141A17);
  static const _muted = Color(0xFF6B7684);
  static const _accent = Color(0xFFFFB020);
  static const _danger = Color(0xFFE5484D);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? const Color(0xFF1C2320) : Colors.white;
    final text = isDark ? Colors.white : _ink;
    final sub = isDark ? Colors.white70 : _muted;
    final tone = destructive ? _danger : _accent;
    final bottom = MediaQuery.of(context).viewPadding.bottom;
    final hasSub = subMessage != null && subMessage!.trim().isNotEmpty;

    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Material(
          color: surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: EdgeInsets.fromLTRB(24, 10, 24, 16 + bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : const Color(0xFFD6DBDF),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 26),
                // Icon with soft concentric rings
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: tone.withOpacity(0.08),
                  ),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: tone.withOpacity(isDark ? 0.25 : 0.16),
                    ),
                    child: Icon(icon, color: tone, size: 30),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 21,
                    height: 1.25,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                    color: text,
                  ),
                ),
                if (hasSub) ...[
                  const SizedBox(height: 8),
                  Text(
                    subMessage!,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, height: 1.45, color: sub),
                  ),
                ],
                const SizedBox(height: 28),
                destructive
                    ? _HoldToConfirmButton(
                  label: okButtonText,
                  color: _danger,
                  onConfirmed: onPressed,
                )
                    : _FilledButton(
                  label: okButtonText,
                  bg: isDark ? Colors.white : _ink,
                  fg: isDark ? _ink : Colors.white,
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    onPressed();
                  },
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: TextButton(
                    onPressed: onCancel ?? () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: sub,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      cancelButtonText,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FilledButton extends StatelessWidget {
  const _FilledButton({
    required this.label,
    required this.bg,
    required this.fg,
    required this.onPressed,
  });

  final String label;
  final Color bg;
  final Color fg;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          elevation: 0,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Text(
          label.isEmpty ? 'OK' : label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

/// Press and hold to fill; releasing early drains it back.
/// Screen-reader users get a normal tap action via Semantics.
class _HoldToConfirmButton extends StatefulWidget {
  const _HoldToConfirmButton({
    required this.label,
    required this.color,
    required this.onConfirmed,
  });

  final String label;
  final Color color;
  final VoidCallback onConfirmed;

  @override
  State<_HoldToConfirmButton> createState() => _HoldToConfirmButtonState();
}

class _HoldToConfirmButtonState extends State<_HoldToConfirmButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
    reverseDuration: const Duration(milliseconds: 300),
  )..addStatusListener((s) {
    if (s == AnimationStatus.completed && !_done) {
      _done = true;
      HapticFeedback.heavyImpact();
      widget.onConfirmed();
    }
  });

  bool _done = false;

  void _start() {
    if (_done) return;
    HapticFeedback.selectionClick();
    _c.forward();
  }

  void _stop() {
    if (!_done) _c.reverse();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.label.isEmpty ? 'Confirm' : widget.label;

    return Semantics(
      button: true,
      label: label,
      hint: 'Double tap to confirm',
      excludeSemantics: true,
      onTap: widget.onConfirmed,
      child: GestureDetector(
        onTapDown: (_) => _start(),
        onTapUp: (_) => _stop(),
        onTapCancel: _stop,
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AnimatedBuilder(
              animation: _c,
              builder: (_, __) => Stack(
                fit: StackFit.expand,
                children: [
                  ColoredBox(color: widget.color.withOpacity(0.14)),
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: _c.value,
                    child: ColoredBox(color: widget.color),
                  ),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _c.value >= 1
                              ? Icons.check_rounded
                              : Icons.touch_app_rounded,
                          size: 20,
                          color: _c.value > 0.5 ? Colors.white : widget.color,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _c.value > 0 ? label : 'Hold to ${label.toLowerCase()}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color:
                            _c.value > 0.5 ? Colors.white : widget.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}