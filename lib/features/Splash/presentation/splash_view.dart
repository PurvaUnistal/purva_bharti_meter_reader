import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meter_reader/Utils/common_widgets/Routes/routes_name.dart';
import 'package:meter_reader/Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import 'package:meter_reader/Utils/common_widgets/SharedPerfs/preference_utils.dart';
import 'package:meter_reader/Utils/common_widgets/app_string.dart';

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
    String emailId = await SharedPref.getString(key: PrefsValue.emailId);
    String password = await SharedPref.getString(key: PrefsValue.passwordVal);
    Timer(
      const Duration(seconds: 2),
      () async {
        if (emailId.isNotEmpty || password.isNotEmpty) {
          Navigator.pushReplacementNamed(
            context,
            RoutesName.billingRequest,
          );
        } else {
          Navigator.pushReplacementNamed(
            context,
            RoutesName.login,
          );
        }
      },
    );
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
              AssetPath.appLogo,
              width: 200,
              height: 200,
            ),
          ),
        ),
      ),
    );
  }
}
