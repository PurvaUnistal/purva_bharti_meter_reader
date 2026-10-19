import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meter_reader_new/Utils/common_widgets/button_widget.dart';
import 'package:meter_reader_new/Utils/common_widgets/res/environment_config.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdateMessage {
  static bool _isShowing = false;

  /// [isLater] == true shows "Not now". Otherwise the update is forced.
  static Future<void> showAlertDialog({
    required BuildContext context,
    required String url,
    bool? isLater,
  }) async {
    if (_isShowing) return;
    _isShowing = true;

    // Read theme colours from the page context.
    final config = EnvironmentConfig.of(context);
    final primary = config?.primaryTheme ?? Theme.of(context).primaryColor;
    final secondary = config?.secondaryTheme ?? primary;

    String version = '';
    try {
      version = (await PackageInfo.fromPlatform()).version;
    } catch (_) {}

    if (!context.mounted) {
      _isShowing = false;
      return;
    }

    await showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Update required',
      barrierColor: Colors.black54,
      transitionDuration: Duration.zero, // no animation
      pageBuilder: (_, __, ___) => _UpdateDialog(
        url: url,
        canSkip: isLater == true,
        version: version,
        primary: primary,
        secondary: secondary,
      ),
    );

    _isShowing = false;
  }
}

enum _Stage { prompt, waiting, returned }

class _UpdateDialog extends StatefulWidget {
  final String url;
  final bool canSkip;
  final String version;
  final Color primary;
  final Color secondary;

  const _UpdateDialog({
    required this.url,
    required this.canSkip,
    required this.version,
    required this.primary,
    required this.secondary,
  });

  @override
  State<_UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<_UpdateDialog>with WidgetsBindingObserver {
  static const _ink = Color(0xFF141A17);
  static const _muted = Color(0xFF6B7684);
  static const _warn = Color(0xFFF08C00);

  _Stage _stage = _Stage.prompt;
  bool _opening = false;

  Color get _tone => _stage == _Stage.returned ? _warn : widget.primary;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Back from Play Store but the app didn't restart → not updated yet.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        _stage == _Stage.waiting &&
        mounted) {
      HapticFeedback.mediumImpact();
      setState(() => _stage = _Stage.returned);
    }
  }

  Future<void> _update() async {
    if (_opening) return;
    HapticFeedback.lightImpact();
    setState(() => _opening = true);

    bool ok = false;
    try {
      ok = await launchUrl(Uri.parse(widget.url),
          mode: LaunchMode.externalApplication);
    } catch (_) {}

    if (!mounted) return;
    setState(() {
      _opening = false;
      if (ok) _stage = _Stage.waiting;
    });
    if (!ok) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(const SnackBar(
        content: Text('Could not open Play Store. Please try again.'),
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  String get _title {
    switch (_stage) {
      case _Stage.prompt:
        return 'Update available';
      case _Stage.waiting:
        return 'Waiting for update';
      case _Stage.returned:
        return 'Update not installed yet';
    }
  }

  String get _message {
    switch (_stage) {
      case _Stage.prompt:
        return 'Install the latest version to keep using the app.';
      case _Stage.waiting:
        return 'Finish the update in Play Store. The app will restart once it’s installed.';
      case _Stage.returned:
        return 'You need the latest version to continue. Tap below to finish updating.';
    }
  }

  IconData get _iconData {
    switch (_stage) {
      case _Stage.prompt:
        return Icons.arrow_downward_rounded;
      case _Stage.waiting:
        return Icons.hourglass_top_rounded;
      case _Stage.returned:
        return Icons.priority_high_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => widget.canSkip,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              clipBehavior: Clip.antiAlias,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Accent bar
                  Container(height: 4, color: _tone),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 26, 24, 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Icon
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: _tone.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(_iconData, color: _tone, size: 28),
                        ),
                        const SizedBox(height: 16),

                        // Version chip
                        if (widget.version.isNotEmpty) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F5F7),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'v${widget.version}  →  New version',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _muted,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],

                        // Title
                        Text(
                          _title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                            color: _ink,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Message
                        Text(
                          _message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 14.5, height: 1.4, color: _muted),
                        ),
                        const SizedBox(height: 24),

                        // Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ButtonWidget(
                            onPressed: _update,
                            loading: _opening,
                            text: _stage == _Stage.prompt
                                ? 'Update now'
                                : 'Open Play Store again',
                            backgroundColor: _stage == _Stage.returned
                                ? _warn
                                : widget.primary,
                            borderColor: _stage == _Stage.returned
                                ? _warn
                                : widget.secondary,
                          ),
                        ),

                        if (widget.canSkip)
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Not now',
                                style: TextStyle(color: _muted)),
                          ),

                        if (!widget.canSkip) ...[
                          const SizedBox(height: 14),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.lock_outline_rounded,
                                  size: 14, color: _muted),
                              SizedBox(width: 6),
                              Text(
                                'This update is required',
                                style: TextStyle(fontSize: 12, color: _muted),
                              ),
                            ],
                          ),
                        ],
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