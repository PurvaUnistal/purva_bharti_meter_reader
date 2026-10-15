import 'package:flutter/material.dart';

class AppNavigator {
  AppNavigator._();

  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  static NavigatorState get _nav {
    final nav = navigatorKey.currentState;
    if (nav == null) {
      throw Exception("Navigator not initivalized");
    }
    return nav;
  }

  // ================= PUSH =================
  static Future<T?> push<T>(Widget page) {
    return _nav.push<T>(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  // ================= REPLACE =================
  static Future<T?> pushReplacement<T, TO>(Widget page) {
    return _nav.pushReplacement<T, TO>(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  // ================= CLEAR STACK =================
  static Future<T?> pushAndRemoveUntil<T>(Widget page) {
    return _nav.pushAndRemoveUntil<T>(
      MaterialPageRoute(builder: (_) => page),
          (route) => false,
    );
  }

  // ================= POP =================
  static void pop<T>([T? result]) {
    if (_nav.canPop()) {
      _nav.pop(result);
    }
  }

  // ================= SAFE DIALOG (IMPORTANT FIX FOR YOU) =================
  static Future<T?> showDialogBox<T>({
    required Widget child,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: navigatorKey.currentContext!,
      barrierDismissible: barrierDismissible,
      builder: (_) => child,
    );
  }
}