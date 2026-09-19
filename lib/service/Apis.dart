import 'package:flutter/material.dart';
import 'package:meter_reader_new/Utils/common_widgets/res/environment_config.dart';
import 'package:meter_reader_new/Utils/common_widgets/res/singleton.dart';

class Apis {
 // static get baseUrl = 'http://pbgpl.smartgasnet.com/api/';
  static BuildContext? context = Singleton.instanceInit()?.context;

  static final String baseUrl =
      EnvironmentConfig.of(context!)!.generalUrlBaseFlavour;
 // static String baseUrl = 'https://pbgpluat.smartgasnet.com/api/';
//  static String baseUrl = 'http://142.79.231.30:9097/api/';
   static get auth  => 'auth';
   static get getPropertyCategory => 'getPropertyCategory';
   static get getPendingBillsMeterReader => 'customer/getPendingBillsMeterReader?';
   static get generate  => 'customer/meter-reading/generate';
   static get cgenerate  => 'customer/meter-reading/cgenerate';
   static get billPrintData  => 'customer/getBillsbyBillID?bill_id=';
   static get billHistoryAApi  => 'customer/getAllBillsbyUserID?user_id=';
   static get resetPassword  => "resetpassword";
}
