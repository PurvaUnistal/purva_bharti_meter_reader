import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meter_reader/Utils/Utils.dart';
import 'package:meter_reader/Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import 'package:meter_reader/Utils/common_widgets/SharedPerfs/preference_utils.dart';
import 'package:meter_reader/features/billingRequest/domain/model/bp_number_model.dart';
import 'package:meter_reader/features/billingRequest/domain/model/generate_model.dart';
import 'package:meter_reader/service/Apis.dart';
import 'package:meter_reader/service/api_helper.dart';
import 'package:permission_handler/permission_handler.dart';

class BillingRequestHelper{

  static Future<Position?> getCurrentLocation() async {
    await Geolocator.requestPermission();
    await Permission.locationAlways.request();
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (Platform.isAndroid) {
      if (androidInfo.version.sdkInt <= 32) {
        Position   position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        log('latitude : ${position.latitude} longitude : ${position.longitude}');
        return position;
      }  else {
        log("location-->${"Something worng"}");
      }
    }
    return null;
  }

  static Future<BpNumberModel?> getPendingBills({
    required BuildContext context,
    required String bpNumber,
  }) async {
    String schema = await SharedPref.getString(
      key: PrefsValue.schema,
    );
    Map<String, String> para = {
      "schema": schema,
      "bpNumber_search": bpNumber,
    };
    String json = Uri(queryParameters: para).query;
    try {
      var res = await ApiHelper.getData(
          urlEndPoint: Apis.getPendingBillsMeterReader + json, context: context);
      if (res != null && res["error"] == false) {
        return BpNumberModel.fromJson(res);
      }else if (res != null && res["error"] == true) {
        Utils.errorSnackBar(msg: res["data"], context: context);
        return null;
      }
    } catch (e) {
      log("getPendingBillsMeterReader-->${e.toString()}");
      return null;
    }
    return null;
  }

  static Future<dynamic> textValidationCheck({
    required BuildContext context,
    required String bpNumber,
    required String custName,
    required String meterSerial,
    required String previousReading,
    required String currentReading,
    required String meterFile,
  }) async {
    try {
      if (bpNumber.isEmpty) {
        Utils.errorSnackBar(msg: "The BP Number field is required.", context: context);
        return false;
      } else if (custName.isEmpty) {
        Utils.errorSnackBar(msg: "The Name field is required.", context: context);
        return false;
      } else if (meterSerial.isEmpty) {
        Utils.errorSnackBar(msg: "The Meter Number field is required.", context: context);
        return false;
      } else if (previousReading.isEmpty) {
        Utils.errorSnackBar(msg: "The Previous Reading field is required.", context: context);
        return false;
      } else if (currentReading.isEmpty || currentReading == "0.0") {
        Utils.errorSnackBar(msg: "The New Meter Reading field is required.", context: context);
        return false;
      }
      else if (double.parse(previousReading) > double.parse(currentReading)/ 1000) {
        Utils.errorSnackBar(msg: "New Reading should be more than Previous Reading.", context: context);
        return false;
      }
      else if (meterFile.isEmpty) {
        Utils.errorSnackBar(msg: "The Meter File field is required.", context: context);
        return false;
      }

      return true;
    } catch (e) {
      log("textValidationCheck--->${e.toString()}");
      return true;
    }
  }

  static Future<GenerateModel?> generateNGC({
    required BuildContext context,
    required String bpNumber,
    required String meterReading,
    required String meterSerial,
    required String latitude,
    required String longitude,
    required String oldReading,
    required String meterFile,
  }) async {
    String schema = await SharedPref.getString(key: PrefsValue.schema);
    String userId = await SharedPref.getString(key: PrefsValue.userId);
    String dmaId = await SharedPref.getString(key: PrefsValue.dmaId);
    try {
      Map<String, String> para = {
        "schema": schema,
        "user_id": userId,
        "bpNumber": bpNumber,
        "meter_reading": meterReading,
        "meter_serial": meterSerial,
        "generate_by_customer": "0",
        "latitude": latitude,
        "longitude": longitude,
        "old_reading": oldReading,
      };
      var res = await ApiHelper.postDataWithFile(
          urlEndPoint: Apis.generate,
        body: para,
        context: context,
        keyWord1: 'meter_image_file',
        filePath1: meterFile,
      );
      if (res != null && res["error"] == false) {
        return GenerateModel.fromJson(res);
      } else if (res != null && res["error"] == true) {
        Utils.errorSnackBar(msg: res["data"], context: context);
        return null;
      }
    } catch (e) {
      log("generate-->${e.toString()}");
      return null;
    }
    return null;
  }



  static Future<File> cameraCapture() async {
    await Permission.camera.request();
    final XFile? file = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxHeight: 900,
      maxWidth: 1000,
    );
    File files = File(file!.path);
    return files;
  }

  static Future<File> galleryCapture() async {
    await Permission.storage.request();
    final XFile? file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxHeight: 900,
      maxWidth: 1000,
    );
    File files = File(file!.path);
    return files;
  }
  Future<void> clearCache() async {
    Directory path = Directory("/data/user/0/com.unistal.pbg_app/cache/");

    if(await path.exists()) {
      List<FileSystemEntity> files = path.listSync();
      for(FileSystemEntity f in files) {
        if(f is File) {
          await f.delete();
        }
      }
    }

    Directory path2 = Directory("/data/user/0/com.unistal.pbg_app/cache/file_picker/");

    if(await path2.exists()) {
      path2.deleteSync(recursive: true);
    }
  }
}