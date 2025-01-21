import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meter_reader_new/features/billingRequest/domain/model/bp_number_model.dart';

abstract class BillingRequestState extends Equatable {}

class BillingRequestPageLoaderState extends BillingRequestState {
  final BuildContext context;
  BillingRequestPageLoaderState({required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [context];
}

class BillingRequestInitState extends BillingRequestState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class BillingRequestFetchDataState extends BillingRequestState {
  final String userName;
  final String scheme;
  final bool isHideShowDetails;
  final bool isPageLoader;
  final bool isBtnLoader;
  final bool isSyncLoader;
  final bool meterReadCon1;
  final bool meterReadCon2;
  final bool meterReadCon3;
  final bool meterReadCon4;
  final bool meterReadCon5;
  final bool meterReadCon6;
  final bool meterReadCon7;
  final bool meterReadCon8;
  final bool meterReadCon9;
  final bool meterReadCon10;
  final File meterFile;
  final BpNumberModel? bpNumberModel;
  final List<DataList> listOfBPNumber;
  final TextEditingController bpMeterSearchNoController;
  final TextEditingController bpNumberController;
  final TextEditingController mobileNumberController;
  final TextEditingController custNameController;
  final TextEditingController buildingNoController;
  final TextEditingController colonyController;
  final TextEditingController streetNameController;
  final TextEditingController townController;
  final TextEditingController districtController;
  final TextEditingController pinCodeController;
  final TextEditingController custAddController;
  final TextEditingController meterNumberController;
  final TextEditingController previousReadingController;
  final TextEditingController meterRead1Controller;
  final TextEditingController meterRead2Controller;
  final TextEditingController meterRead3Controller;
  final TextEditingController meterRead4Controller;
  final TextEditingController meterRead5Controller;
  final TextEditingController meterRead6Controller;
  final TextEditingController meterRead7Controller;
  final TextEditingController meterRead8Controller;
  final TextEditingController meterRead9Controller;
  final TextEditingController meterRead10Controller;
  final TextEditingController userAddressController;
  final FocusNode meterRead1Node;
  final FocusNode meterRead2Node;
  final FocusNode meterRead3Node;
  final FocusNode meterRead4Node;
  final FocusNode meterRead5Node;
  final FocusNode meterRead6Node;
  final FocusNode meterRead7Node;
  final FocusNode meterRead8Node;
  final FocusNode meterRead9Node;
  final FocusNode meterRead10Node;
  final Set<Marker> markers;
  final LatLng latLng;
  final MapType currentMapType;
  final Completer<GoogleMapController> mapController;
  final double accuracy;
//  final List<TextEditingController> currentReadingController;

  BillingRequestFetchDataState({
    required this.userName,
    required this.scheme,
    required this.isPageLoader,
    required this.isHideShowDetails,
    required this.isBtnLoader,
    required this.isSyncLoader,
    required this.meterReadCon1,
    required this.meterReadCon2,
    required this.meterReadCon3,
    required this.meterReadCon4,
    required this.meterReadCon5,
    required this.meterReadCon6,
    required this.meterReadCon7,
    required this.meterReadCon8,
    required this.meterReadCon9,
    required this.meterReadCon10,
    required this.meterFile,
    required this.bpNumberModel,
    required this.listOfBPNumber,
    required this.bpMeterSearchNoController,
    required this.bpNumberController,
    required this.mobileNumberController,
    required this.custNameController,
    required this.buildingNoController,
    required this.colonyController,
    required this.streetNameController,
    required this.townController,
    required this.districtController,
    required this.pinCodeController,
    required this.custAddController,
    required this.meterNumberController,
    required this.previousReadingController,
    required this.meterRead1Controller,
    required this.meterRead2Controller,
    required this.meterRead3Controller,
    required this.meterRead4Controller,
    required this.meterRead5Controller,
    required this.meterRead6Controller,
    required this.meterRead7Controller,
    required this.meterRead8Controller,
    required this.meterRead9Controller,
    required this.meterRead10Controller,
    required this.meterRead1Node,
    required this.meterRead2Node,
    required this.meterRead3Node,
    required this.meterRead4Node,
    required this.meterRead5Node,
    required this.meterRead6Node,
    required this.meterRead7Node,
    required this.meterRead8Node,
    required this.meterRead9Node,
    required this.meterRead10Node,
    required this.markers,
    required this.latLng,
    required this.currentMapType,
    required this.mapController,
    required this.userAddressController,
    required this.accuracy,
  //  required this.currentReadingController,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [
    userName,
    scheme,
    isPageLoader,
    isHideShowDetails,
    isBtnLoader,
    isSyncLoader,
    meterReadCon1,
    meterReadCon2,
    meterReadCon3,
    meterReadCon4,
    meterReadCon5,
    meterReadCon6,
    meterReadCon7,
    meterReadCon8,
    meterReadCon9,
    meterReadCon10,
    meterFile,
    bpNumberModel,
    listOfBPNumber,
    bpMeterSearchNoController,
    bpNumberController,
    mobileNumberController,
    custNameController,
    buildingNoController,
    colonyController,
    streetNameController,
    townController,
    districtController,
    pinCodeController,
    custAddController,
    meterNumberController,
    previousReadingController,
    meterRead1Controller,
    meterRead2Controller,
    meterRead3Controller,
    meterRead4Controller,
    meterRead5Controller,
    meterRead6Controller,
    meterRead7Controller,
    meterRead8Controller,
    meterRead9Controller,
    meterRead10Controller,
    meterRead1Node,
    meterRead2Node,
    meterRead3Node,
    meterRead4Node,
    meterRead5Node,
    meterRead6Node,
    meterRead7Node,
    meterRead8Node,
    meterRead9Node,
    meterRead10Node,
    currentMapType,
    markers,
    latLng,
    currentMapType,
    mapController,
    userAddressController,
    accuracy,
   // currentReadingController,
  ];
}