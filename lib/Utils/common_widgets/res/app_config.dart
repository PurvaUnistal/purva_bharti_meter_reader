import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:meter_reader_new/features/Home/domain/model/propert_type_model.dart';
import 'package:meter_reader_new/features/Login/domain/model/login_model.dart';
import 'enums.dart';
import 'environment_config.dart';

class AppConfig {
  static AppConfig? instance;
  static String? baseUrl;
  String buildNumber = "";
  RoleType? roleType;
  Client? client;
  LoginModel loginData = LoginModel();
  PropertyTypeModel propertyTypeModel = PropertyTypeModel();

  static AppConfig? instanceInit() {
    instance ??= AppConfig();
    return instance;
  }

  static void init(BuildContext context) {
    baseUrl = EnvironmentConfig.of(context)!.generalUrlBaseFlavour;
    log("baseUrl --> $baseUrl");
  }

  setBuildNumber({required String value}) {
    buildNumber = value;
  }

  setLoginData({required LoginModel newLoginData}) {
    this.loginData = newLoginData;
  }

  setPropertyCategoryId({required PropertyTypeModel val}) {
    propertyTypeModel = val;
    print("val--- ${val}");
  }

  setClient({required Client client}) {
    this.client = client;
  }

  static void reset() {
    final old = instance;
    instance = AppConfig()
      ..buildNumber = old?.buildNumber ?? ""
      ..client = old?.client;
  }
}
