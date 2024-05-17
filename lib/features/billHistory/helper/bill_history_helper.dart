import 'dart:developer';
import 'package:flutter/material.dart';

import '../../../../ExportFile/export_file.dart';

class BillHistoryHelper {
  static Future<dynamic> fetchBillHistoryData(
      {required BuildContext context,
      required String userId,
      required String schema}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString(GlobalConstants.token) ?? "";
    try {
      String url = Apis.billHistoryAApi + "$userId&schema=$schema";
      log(url);
      var res = await get(
        Uri.parse(url),
        headers: {'authorization': '$token'},
      );
      log(res.body);
      if (res.statusCode == 200) {
        return json.decode(res.body);
      } else if (res.statusCode == 403) {
        SessionDialogUtils.logOut(context);
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }
}
