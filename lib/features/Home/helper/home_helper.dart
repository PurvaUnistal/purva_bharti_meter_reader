import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:meter_reader_new/Utils/Utils.dart';
import 'package:meter_reader_new/Utils/common_widgets/res/app_config.dart';
import 'package:meter_reader_new/features/Home/domain/model/propert_type_model.dart';
import 'package:meter_reader_new/service/Apis.dart';
import 'package:meter_reader_new/service/api_server_dio.dart';

class HomeHelper {
  static Future<List<PropertyTypeModel>?> getPendingBills({
    required BuildContext context,
  }) async {
    String schema = AppConfig.instanceInit()!.loginData.user!.schema.toString();
    Map<String, String> para = {
      "schema": schema,
      "type": "meterreader",
    };
    String json = Uri(queryParameters: para).query;

    try {
      var res = await ApiServerDio.getData(urlEndPoint: "${Apis.getPropertyCategory}?${json}");
      if (res != null && res != true) {
        final decoded = res is String ? jsonDecode(res) : res;
        final List list = decoded is List
            ? decoded
            : (decoded is Map ? (decoded['data'] ?? []) as List : const []);
        return list
            .map((e) => PropertyTypeModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else if (res == true) {
        Utils.errorSnackBar(msg: "Something went wrong", context: context);
        return null;
      }
    } catch (e) {
      log("getPropertyCategory-->${e.toString()}");
      return null;
    }
    return null;
  }
}
