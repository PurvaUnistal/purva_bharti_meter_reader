import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:meter_reader/Utils/Utils.dart';
import 'package:meter_reader/Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import 'package:meter_reader/Utils/common_widgets/SharedPerfs/preference_utils.dart';
import 'package:meter_reader/service/Apis.dart';
import 'package:meter_reader/service/api_helper.dart';

class BillHistoryHelper {
  static Future<dynamic> fetchBillHistoryData(
      {required BuildContext context,}) async {
    try {
      String schema = await SharedPref.getString(
        key: PrefsValue.schema,
      );
      String userId = await SharedPref.getString(
        key: PrefsValue.userId,
      );
      String url =  Apis.billHistoryAApi + "$userId&schema=$schema";
      log(url);
      var res = await ApiHelper.getData(urlEndPoint:url ,context: context);
     if(res != null && res["error"] == false){
       return res;
     } else if (res != null && res["error"] == true) {
       Utils.errorSnackBar(msg: res["data"], context: context);
       return null;
     }
    } catch (e) {
      return "error";
    }
  }
}
