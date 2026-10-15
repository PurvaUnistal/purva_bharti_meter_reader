import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'logout_widget.dart';

/// App update (Play Store) ke baad pehli launch pe saara data clear karta hai.
/// main() me runApp se pehle call karo: `await AppUpdateCleaner.run();`
class AppUpdateCleaner {
  static const String _versionKey = 'last_installed_app_version';

  /// true return karta hai agar data clear hua (yaani app update hua tha).
  static Future<bool> run() async {
    try {
      final info = await PackageInfo.fromPlatform();
      // buildNumber = versionCode, har Play Store release me badhna chahiye
      final currentVersion = '${info.version}+${info.buildNumber}';

      final prefs = await SharedPreferences.getInstance();
      final savedVersion = prefs.getString(_versionKey);

      // Same version -> kuch nahi karna
      if (savedVersion == currentVersion) return false;

      debugPrint('App updated: $savedVersion -> $currentVersion, clearing data');

      // 1. Hive + SharedPreferences + Cache + AppConfig (existing logic)
      await LogoutWidget.logout();

      // 2. Optional: app ke private folders ki baaki files bhi hata do
      await _clearAppDirectories();

      // 3. Clear karne ke BAAD naya version save karo,
      //    warna SharedPref.clearAll() isko bhi uda dega
      final freshPrefs = await SharedPreferences.getInstance();
      await freshPrefs.reload();
      await freshPrefs.setString(_versionKey, currentVersion);

      return true;
    } catch (e) {
      debugPrint('AppUpdateCleaner failed: $e');
      return false;
    }
  }

  /// Documents / Support folder ki files delete karta hai (Hive files ko chhod ke,
  /// kyunki Hive ki boxes open ho sakti hain — unhe clearAllHiveData handle karta hai).
  static Future<void> _clearAppDirectories() async {
    final dirs = <Directory>[
      await getApplicationDocumentsDirectory(),
      await getApplicationSupportDirectory(),
    ];

    for (final dir in dirs) {
      if (!await dir.exists()) continue;
      await for (final entity in dir.list()) {
        final name = entity.path.split(Platform.pathSeparator).last;
        if (name.endsWith('.hive') || name.endsWith('.lock')) continue;
        try {
          await entity.delete(recursive: true);
        } catch (e) {
          debugPrint('Skip delete: ${entity.path} -> $e');
        }
      }
    }
  }
}