import 'package:flutter/material.dart';
import 'package:meter_reader_new/features/Home/domain/model/propert_type_model.dart';

import 'enums.dart';

class AppConfig {
  static AppConfig? instance;
  RoleType? roleType;
  Client? client;

  static AppConfig? instanceInit() {
    instance ??= AppConfig();
    return instance;
  }

  PropertyTypeModel propertyTypeModel = PropertyTypeModel();

  String _buildName = "";
  String get buildName => _buildName;

  setPropertyCategoryId({required PropertyTypeModel val}) {
    propertyTypeModel = val;
    print("val--- ${val}");
  }

  setBuildName({required String buildName}) {
    _buildName = buildName;
  }

  setClient({required Client client}){
    this.client =  client;
  }

  static DeviceType getDeviceType({BuildContext? context}) {
    var isPortrait =  true;
    if(context != null){
      isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    }

    final MediaQueryData data = MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.single);
    /*   return data.size.shortestSide <= 600
        ? DeviceType.phone
        : DeviceType.tablet;*/
    return isPortrait == true
        ? DeviceType.phone
        : DeviceType.tablet;
  }
}