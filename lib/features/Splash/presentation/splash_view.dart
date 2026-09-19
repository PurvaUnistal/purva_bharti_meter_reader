import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meter_reader_new/Utils/common_widgets/Routes/routes_name.dart';
import 'package:meter_reader_new/Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import 'package:meter_reader_new/Utils/common_widgets/SharedPerfs/preference_utils.dart';
import 'package:meter_reader_new/Utils/common_widgets/res/app_config.dart';
import 'package:meter_reader_new/Utils/common_widgets/res/app_string.dart';
import 'package:meter_reader_new/Utils/common_widgets/res/enums.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    toLogin();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  Future<void> toLogin() async {

    final email = await SharedPref.getString(key: PrefsValue.emailId);
    final password = await SharedPref.getString(key: PrefsValue.passwordVal);
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final newVersion  = await packageInfo.buildNumber;
    AppConfig.instanceInit()?.setBuildName(buildName: packageInfo.buildNumber);
    final oldVersion = await SharedPref.getString(key: PrefsValue.buildNumber);
    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      if (oldVersion == newVersion && (email.isNotEmpty || password.isNotEmpty)) {
        Navigator.pushReplacementNamed(
          context,
         // RoutesName.billingRequest,
          RoutesName.homePage,
        );
      }
      else {
        Navigator.pushReplacementNamed(
          context,
          RoutesName.login,
        );
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              AppConfig.instanceInit()!.client == Client.purvaBharti
                  ? AppIcon.pbgplLogo
                  :AppConfig.instanceInit()!.client == Client.mahaNagar
                  ? AppIcon.mglLogo
                  : AppConfig.instanceInit()!.client == Client.hngpl
                  ? AppIcon.hngplLogo
                  : AppIcon.pbgplLogo,
              width: 200,
              height: 200,
            ),
          ),
        ),
      ),
    );
  }
}
