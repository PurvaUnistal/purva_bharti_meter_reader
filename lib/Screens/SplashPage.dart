import 'package:flutter/material.dart';

import '../ExportFile/export_file.dart';

class SplashPage extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light));
    return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        body: SafeArea(
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Meter Reader",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w300),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(100.0),
                    child: Image(
                        image: AssetImage(
                      'assets/images/logo.png',
                    )),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("Version : 1"),
                    Text("Date : 07-03-2024"),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<Timer> loadData() async {
    return Timer(Duration(seconds: 3), onDoneLoading);
  }

  bool _isLogin = false;
  onDoneLoading() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLogin = prefs.getBool(GlobalConstants.isUserLogIn) ?? false;
    String? changePassword = prefs.getString(GlobalConstants.changePassword);
    /* if(changePassword == "0"){
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ChangePasswordPage()),
              (Route<dynamic> route) => false,
        );
      }else{*/
    if (_isLogin) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => MeterRequestScreen()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
    //   }
  }
}
