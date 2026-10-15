import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:meter_reader_new/Utils/Utils.dart';
import 'package:meter_reader_new/Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import 'package:meter_reader_new/Utils/common_widgets/SharedPerfs/preference_utils.dart';
import 'package:meter_reader_new/Utils/common_widgets/res/app_config.dart';
import 'package:meter_reader_new/service/Apis.dart';
import 'package:meter_reader_new/service/api_server_dio.dart';

class BillHistoryHelper {
  static Future<dynamic> fetchBillHistoryData(
      {required BuildContext context,}) async {
   try {
     String schema = AppConfig.instanceInit()!.loginData.user!.schema.toString();
     String userId =AppConfig.instanceInit()!.loginData.user!.id.toString();
      String url =  Apis.billHistoryAApi + "$userId&schema=$schema";
      log(url);
      var res = await ApiServerDio.getData(urlEndPoint:url);
     if(res != null && res != true){
       return res;
     } else if (res != null && res == true) {
       Utils.errorSnackBar(msg: res["data"], context: context);
       return null;
     }
    } catch (e) {
      return "error";
    }
  }
}
