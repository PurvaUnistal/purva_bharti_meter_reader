import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:meter_reader_new/Utils/common_widgets/Routes/routes_name.dart';
import 'package:meter_reader_new/Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import 'package:meter_reader_new/Utils/common_widgets/SharedPerfs/preference_utils.dart';
import 'package:meter_reader_new/Utils/common_widgets/app_update_cleaner.dart';
import 'package:meter_reader_new/Utils/common_widgets/res/app_color.dart';
import 'package:meter_reader_new/Utils/common_widgets/res/app_config.dart';
import 'package:meter_reader_new/Utils/common_widgets/res/app_string.dart';
import 'package:meter_reader_new/features/Login/domain/model/login_model.dart';
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
    _getData();
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

  Future<LoginModel?> _getData() async {
    try {
      String? userJson = await SharedPref.getString(key: PrefsValue.userInfo ?? "");
      if (userJson != '') {
        Map<String, dynamic> userMap = jsonDecode(userJson);
        LoginModel loginModel = LoginModel.fromJson(userMap);
        final appConfig = AppConfig.instanceInit();
        if (appConfig != null) {
          await appConfig.setLoginData(newLoginData: loginModel);
        }
        return loginModel;
      }
    } catch (e) {
      debugPrint("Error in _getData: $e");
    }
    return null;
  }

  Future<void> toLogin() async {
    String email = await SharedPref.getString(key: PrefsValue.emailId);
    String password = await SharedPref.getString(key: PrefsValue.passwordVal);
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    AppConfig.instanceInit()?.setBuildNumber(value: "$buildNumber($version)");
    String oldVersion = await SharedPref.getString(key: PrefsValue.buildNumber);
    print("newVersion--${buildNumber}");
    print("oldVersion--${oldVersion}");
    Timer(
      const Duration(seconds: 3),
          () async {
        if(oldVersion == buildNumber){
          if (email.isNotEmpty || password.isNotEmpty) {
            Navigator.pushReplacementNamed(context, RoutesName.homePage);
          }
        } else {
          await AppUpdateCleaner.run();
          Navigator.pushReplacementNamed(context, RoutesName.login);
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              AppIcon.logo(),
              width: 200,
              height: 200,
            ),
          ),
        ),
      ),
    );
  }
}
