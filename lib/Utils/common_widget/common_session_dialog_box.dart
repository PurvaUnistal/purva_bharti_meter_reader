import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Screens/LoginScreen.dart';
import '../global_constant.dart';

class SessionDialogUtils {
  static SessionDialogUtils _instance = new SessionDialogUtils.internal();

  SessionDialogUtils.internal();

  factory SessionDialogUtils() => _instance;

  static void showCustomDialog(BuildContext context,{required  VoidCallback okBtnFunction}) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Timeout'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Session was expire you need to login again?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Login'),
                onPressed: okBtnFunction,
              ),
            ],
          );
        });
  }

  static void showLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                logOut(context);
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static logOut(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(GlobalConstants.isUserLogIn, false);
      prefs.setString(GlobalConstants.username, '');
      prefs.setString(GlobalConstants.password, '');
      prefs.setString(GlobalConstants.id, '');
      prefs.setString(GlobalConstants.token, '');
      prefs.setString(GlobalConstants.schema, '');
      prefs.setString(GlobalConstants.name, '');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
            (Route<dynamic> route) => false,
      );
    } catch (e) {
      print(e.toString());
    }
  }
}