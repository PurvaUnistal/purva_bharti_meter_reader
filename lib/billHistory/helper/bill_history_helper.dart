import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:meter_reader/service/Apis.dart';

class BillHistoryHelper {

  static Future<dynamic> fetchBillHistoryData({required BuildContext context,
     required String userId, required String schema}) async {
      try{
        String url =  Apis.billHistoryAApi+"${userId}&schema=${schema}";
        log(url);
        var res = await get(Uri.parse(url),);
        log(res.body);
        if(res.statusCode == 200){
          return json.decode(res.body);
        }else{
          return "error";
        }
      }catch(e){
        return "error";
      }
  }
}