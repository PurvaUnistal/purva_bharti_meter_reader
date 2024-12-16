import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:meter_reader_new/Utils/Utils.dart';
import 'package:meter_reader_new/Utils/common_widgets/app_string.dart';
import 'package:meter_reader_new/features/Login/domain/model/login_model.dart';
import 'package:meter_reader_new/service/Apis.dart';
import 'package:meter_reader_new/service/api_helper.dart';

class LoginHelper {
  static Future<dynamic> textFieldValidation(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      if (email.isEmpty) {
        Utils.errorSnackBar(msg: AppString.emailValidation, context: context);
        return false;
      } else if (password.isEmpty) {
        Utils.errorSnackBar(
            msg: AppString.passwordValidation, context: context);
        return false;
      }
      return true;
    } catch (e) {
      log(e.toString());
      Utils.errorSnackBar(msg: e.toString(), context: context);
      return false;
    }
  }

  static getUniqueDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // unique ID on Android
    }
    return null;
  }

  static Future<LoginModel?> loginData(
      {required String email,
      required String password,
      required BuildContext context}) async {
    var deviceId = await getUniqueDeviceId();
    Map<String, String> para = {
      "email": email,
      "password": password,
      "device": deviceId,
    };
    try {
      var res = await ApiHelper.postData(
          urlEndPoint: Apis.auth, body: jsonEncode(para), context: context);
      if(res != null && res["error"] == false){
        return LoginModel.fromJson(res);
      } else if(res != null && res["error"] == true){
        Utils.errorSnackBar(msg:res["messages"], context: context);
        return null;
      }
    } catch (e) {
      log("catchLoginHelper-->${e.toString()}");
      Utils.errorSnackBar(msg: e.toString(), context: context);
      return null;
    }
    return null;
  }
}
