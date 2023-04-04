import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginScreen.dart';
import 'billingRequest.dart';
import '../Utils/global_constant.dart';


class SplashPage extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}
class _PageState extends State<SplashPage> {
  SharedPreferences? pref;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
        statusBarColor: Colors.lightBlueAccent,
        statusBarIconBrightness: Brightness.light));
    return Scaffold(
      resizeToAvoidBottomInset: false,
        extendBody: true,
        body: SafeArea(
          child : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Meter Reader",style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w300),
              ),
              SizedBox(height: 20,),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(100.0),
                  child: Image(
                      image: AssetImage('assets/images/logo.png',)),
                ),
              ),
            ],
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

    onDoneLoading() async {
    pref = await SharedPreferences.getInstance();
    if (pref?.getBool(GlobalConstants.isUserLogIn) != null) {
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MeterRequestScreen()));
    } else {
         Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }
}
