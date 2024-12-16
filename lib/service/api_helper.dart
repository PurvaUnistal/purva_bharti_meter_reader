import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:meter_reader_new/Utils/Utils.dart';
import 'package:meter_reader_new/Utils/common_widgets/InternetConnectivity/connectivity_helper.dart';
import 'package:meter_reader_new/Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import 'package:meter_reader_new/Utils/common_widgets/SharedPerfs/preference_utils.dart';
import 'package:meter_reader_new/Utils/common_widgets/common_session_dialog_box.dart';
import 'package:mime/mime.dart';

class ApiHelper {
  static Future<dynamic> getData(
      {var urlEndPoint, required BuildContext context}) async {
    try {
      if (await ConnectivityHelper.allConnectivityCheck(context: context) ==
          false) {
        return null;
      }
      String token = await SharedPref.getString(key: PrefsValue.token) ?? "";
      Map<String, String> headers = {"Authorization": token};
      final response = await get(Uri.parse(urlEndPoint),headers: headers);
      log("URL-->${urlEndPoint.toString()}");
      log(urlEndPoint + "==> " + response.body);
      if (response.statusCode == 200) {
        return jsonDecode(response.body.toString());
      } else if (response.statusCode == 400) {
        return jsonDecode(response.body.toString());
      } else if (response.statusCode == 401) {
        return jsonDecode(response.body.toString());
      } else if (response.statusCode == 404) {
        return jsonDecode(response.body.toString());
      } else if (response.statusCode == 500) {
        return jsonDecode(response.body.toString());
      } else {
        log("apiError-->ApiHelperElse");
        return null;
      }
    } catch (e) {
      log("ApiServer-->${e.toString()}");
      if (e is SocketException) {
        log("SocketException : ${e.toString()}");
        Utils.warningSnackBar(msg: "No Internet", context: context);
      } else if (e is TimeoutException) {
        log("TimeoutException : ${e.toString()}");
        Utils.warningSnackBar(
            msg: "Timeout, Please try again", context: context);
      } else {
        log("Unhandled exception : ${e.toString()}");
        Utils.warningSnackBar(msg: e.toString(), context: context);
      }
      return null;
    }
  }

  static Future<dynamic> postData({required String urlEndPoint, var body, required BuildContext context}) async {
    try {
      if (await ConnectivityHelper.allConnectivityCheck(context: context) ==
          false) {
        return null;
      }
      String token = await SharedPref.getString(key: PrefsValue.token) ?? "";
      Map<String, String> headers = {"Authorization": token};
      var res = await post(Uri.parse(urlEndPoint), body: body, headers: headers);
      log(res.body);
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else if (res.statusCode == 403) {
        return SessionDialogUtils.logOut(context: context);
      } else if (res.statusCode == 401) {
        return jsonDecode(res.body);
      } else if (res.statusCode == 415) {
        return jsonDecode(res.body);
      }else if (res.statusCode == 500) {
        return jsonDecode(res.body);
      }
    } catch (e) {
      print("catch--->" + e.toString());
      Utils.errorSnackBar(msg: e.toString(), context: context);
      return null;
    }
  }

  static Future<dynamic> postDataWithFile({
    var urlEndPoint,
    var body,
    required BuildContext context,
    required String filePath1,
    required String keyWord1,
  }) async {
    String token = await SharedPref.getString(key: PrefsValue.token) ?? "";
   try {
      if (await ConnectivityHelper.allConnectivityCheck(context: context) == false) {
        return null;
      }
      Map<String, String> headers = {"Authorization": token};
      var request = MultipartRequest("POST", Uri.parse(urlEndPoint));
      if (filePath1.isNotEmpty) {
        final mimeTypeData =
            lookupMimeType(filePath1, headerBytes: [0xFF, 0xD8])!.split('/');
        var uploadFile1 = await MultipartFile.fromPath(keyWord1, filePath1,
            contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
        request.files.add(uploadFile1);
      }
      request.fields.addAll(body);
      request.headers.addAll(headers);
    var response = await request.send();
    if (response.statusCode == 200) {
      var responseData = await response.stream.toBytes();
      var result = json.decode(String.fromCharCodes(responseData));
      log("result-->${result.toString()}");
      return result;
    } else if (response.statusCode == 401) {
      var responseData = await response.stream.toBytes();
      var result = json.decode(String.fromCharCodes(responseData));
      log(result.toString());
      return result;
    } else if (response.statusCode == 415) {
      var responseData = await response.stream.toBytes();
      var result = json.decode(String.fromCharCodes(responseData));
      log(result.toString());
      return result;
    } else if (response.statusCode == 400) {
      var responseData = await response.stream.toBytes();
      var result = json.decode(String.fromCharCodes(responseData));
      log(result.toString());
      return result;
    } else {
      var responseData = await response.stream.toBytes();
      var result = json.decode(String.fromCharCodes(responseData));
      log(result.toString());
      return result;
    }
    } catch (e) {
      log("postDataWithFile-->${e.toString()}");
      return null;
    }
  }
}

enum Api { error }
