import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meter_reader/Utils/Utils.dart';
import 'package:meter_reader/Utils/common_widgets/Loader/DottedLoader.dart';
import 'package:meter_reader/Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import 'package:meter_reader/Utils/common_widgets/SharedPerfs/preference_utils.dart';
import 'package:meter_reader/Utils/common_widgets/app_bar_widget.dart';
import 'package:meter_reader/Utils/common_widgets/button_widget.dart';
import 'package:meter_reader/features/billingRequest/presentation/widgets/ErorrRowWidget.dart';
import 'package:meter_reader/features/billingRequest/presentation/widgets/row_widget.dart';
import 'package:meter_reader/features/billPrint/domain/bloc/bill_print_bloc.dart';
import 'package:meter_reader/features/billingRequest/domain/bloc/billing_request_event.dart';
import 'package:meter_reader/features/billingRequest/domain/bloc/billing_request_state.dart';
import 'package:meter_reader/features/billingRequest/domain/model/bp_number_model.dart';
import 'package:meter_reader/features/billingRequest/helper/billing_request_helper.dart';
import 'package:meter_reader/features/billingRequest/presentation/billing_request_page.dart';

class BillingRequestBloc extends Bloc<BillingRequestEvent, BillingRequestState>{
  BillingRequestBloc() : super(BillingRequestInitState()){
    on<BillingRequestPageLoadingEvent>(_pageLoader);
    on<SyncSearchBPNumberEvent>(_syncSearchBPNumber);
    on<BillingHideShowEvent>(_billingHideShow);
    on<SelectMeterCameraEvent>(_selectMeterCamera);
    on<SelectMeterGalleryEvent>(_selectMeterGallery);
    on<OnChange1Event>(_onChange1Event);
    on<OnChange2Event>(_onChange2Event);
    on<OnChange3Event>(_onChange3Event);
    on<OnChange4Event>(_onChange4Event);
    on<OnChange5Event>(_onChange5Event);
    on<OnChange6Event>(_onChange6Event);
    on<OnChange7Event>(_onChange7Event);
    on<OnChange8Event>(_onChange8Event);
    on<OnChange9Event>(_onChange9Event);
    on<OnChange10Event>(_onChange10Event);
    on<BillingRequestPreviewEvent>(_preview);
    on<BillingRequestSubmitEvent>(_submit);

  }
  String userName = "";
  String scheme = "";
  File meterFile = File("");
  bool isHideShowDetails = false;
  bool isPageLoader = false,
      isBtnLoader = false,
      isSyncLoader = false,
      meterReadCon1 = false,
      meterReadCon2 = false,
      meterReadCon3 = false,
      meterReadCon4 = false,
      meterReadCon5 = false,
      meterReadCon6 = false,
      meterReadCon7 = false,
      meterReadCon8 = false,
      meterReadCon9 = false,
      meterReadCon10 = true;


  BpNumberModel bpNumberModel = BpNumberModel();
  List<DataList> listOfBPNumber = [];
  TextEditingController bpMeterSearchNoController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController custNameController = TextEditingController();
  TextEditingController bpNumberController = TextEditingController();
  TextEditingController buildingNoController = TextEditingController();
  TextEditingController colonyController = TextEditingController();
  TextEditingController streetNameController = TextEditingController();
  TextEditingController townController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController custAddController = TextEditingController();
  TextEditingController meterNumberController = TextEditingController();
  TextEditingController previousReadingController = TextEditingController();
  TextEditingController meterRead1Controller = TextEditingController();
  TextEditingController meterRead2Controller = TextEditingController();
  TextEditingController meterRead3Controller = TextEditingController();
  TextEditingController meterRead4Controller = TextEditingController();
  TextEditingController meterRead5Controller = TextEditingController();
  TextEditingController meterRead6Controller = TextEditingController();
  TextEditingController meterRead7Controller = TextEditingController();
  TextEditingController meterRead8Controller = TextEditingController();
  TextEditingController meterRead9Controller = TextEditingController();
  TextEditingController meterRead10Controller = TextEditingController();
  TextEditingController latController = TextEditingController();
  TextEditingController longController = TextEditingController();

  FocusNode meterRead1Node = FocusNode();
  FocusNode meterRead2Node = FocusNode();
  FocusNode meterRead3Node = FocusNode();
  FocusNode meterRead4Node = FocusNode();
  FocusNode meterRead5Node = FocusNode();
  FocusNode meterRead6Node = FocusNode();
  FocusNode meterRead7Node = FocusNode();
  FocusNode meterRead8Node = FocusNode();
  FocusNode meterRead9Node = FocusNode();
  FocusNode meterRead10Node = FocusNode();

  _pageLoader(BillingRequestPageLoadingEvent event, emit) async {
    emit(BillingRequestInitState());
    isPageLoader = false;
    isHideShowDetails = false;
    isBtnLoader = false;
    isSyncLoader = false;
    meterReadCon1 = false;
    meterReadCon2 = false;
    meterReadCon3 = false;
    meterReadCon4 = false;
    meterReadCon5 = false;
    meterReadCon6 = false;
    meterReadCon7 = false;
    meterReadCon8 = false;
    meterReadCon9 = false;
    meterReadCon10 = true;
    meterFile = File("");
    listOfBPNumber = [];
    bpNumberModel = BpNumberModel();
    bpMeterSearchNoController.text = "";
    mobileNumberController.text = "";
    custNameController.text = "";
    bpNumberController.text = "";
    buildingNoController.text = "";
    colonyController.text = "";
    streetNameController.text = "";
    townController.text = "";
    districtController.text = "";
    pinCodeController.text = "";
    custAddController.text = "";
    meterNumberController.text = "";
    previousReadingController.text = "";
    meterRead1Controller.text = "";
    meterRead2Controller.text = "";
    meterRead3Controller.text = "";
    meterRead4Controller.text = "";
    meterRead5Controller.text = "";
    meterRead6Controller.text = "";
    meterRead7Controller.text = "";
    meterRead8Controller.text = "";
    meterRead9Controller.text = "";
    meterRead10Controller.text = "";
    latController.text = "";
    longController.text = "";
    meterRead1Node = FocusNode();
    meterRead2Node = FocusNode();
    meterRead3Node = FocusNode();
    meterRead4Node = FocusNode();
    meterRead5Node = FocusNode();
    meterRead6Node = FocusNode();
    meterRead7Node = FocusNode();
    meterRead8Node = FocusNode();
    meterRead9Node = FocusNode();
    meterRead10Node = FocusNode();
    userName = await SharedPref.getString(key: PrefsValue.userName);
    scheme = await SharedPref.getString(key: PrefsValue.schema);
    await _setLocation();
    _eventCompleted(emit);
  }

  fetchPendingBillsApi({required BuildContext context, required String bpNumber,emit}) async {
    try{
      if (bpMeterSearchNoController.text.isNotEmpty) {
        isSyncLoader = true;
        _eventCompleted(emit);
        var res = await BillingRequestHelper.getPendingBills(
            context: context, bpNumber: bpNumber);
        if (res?.success != null) {
          isSyncLoader = false;
          _eventCompleted(emit);
          bpNumberModel = res!;
          if (bpNumberModel.success != 400) {
            listOfBPNumber = bpNumberModel.data!;
            custNameController.clear();
            bpNumberController.clear();
            buildingNoController.clear();
            colonyController.clear();
            streetNameController.clear();
            townController.clear();
            pinCodeController.clear();
            meterNumberController.clear();
            for (int i = 0; i < listOfBPNumber.length; i++) {
              bpNumberController.text = listOfBPNumber[i].bpNumber ?? "-";
              custNameController.text = "${listOfBPNumber[i].firstName!} ${listOfBPNumber[i].lastName!}";
              buildingNoController.text = listOfBPNumber[i].houseNumber ?? "-";
              colonyController.text = listOfBPNumber[i].address2 ?? "-";
              streetNameController.text = listOfBPNumber[i].locality ?? "-";
              townController.text = listOfBPNumber[i].town ?? "";
              pinCodeController.text = listOfBPNumber[i].pinCode ?? "-";
              meterNumberController.text = listOfBPNumber[i].meterSerialNumber ?? "-";
              previousReadingController.text = listOfBPNumber[i].replaceStatus == "1"
                  ? listOfBPNumber[i].newMeterOldReading.toString()
                  : listOfBPNumber[i].oldReading.toString();
              mobileNumberController.text =  listOfBPNumber[i].mobileNumber ??"";
            }
          } else {
            Utils.errorSnackBar(msg: res.data!, context: context);
            return null;
          }
        }else{
          isSyncLoader = false;
          _eventCompleted(emit);
        }
        return res;
      } else {
        Utils.errorSnackBar(msg: "Please enter BP Number", context: context);
        return null;
      }}catch(e){
      isSyncLoader = false;
      _eventCompleted(emit);
      log(e.toString());
      Utils.errorSnackBar(msg: e.toString(), context: context);
      return null;
    }
  }


  _syncSearchBPNumber(SyncSearchBPNumberEvent event, emit) async {
    if(bpMeterSearchNoController.text.trim().length == 0){
      mobileNumberController.text = "";
      custNameController.text = "";
      bpNumberController.text = "";
      buildingNoController.text = "";
      colonyController.text = "";
      streetNameController.text = "";
      townController.text = "";
      districtController.text = "";
      pinCodeController.text = "";
      custAddController.text = "";
      meterNumberController.text = "";
      previousReadingController.text = "";
      meterRead1Controller.text = "";
      meterRead2Controller.text = "";
      meterRead3Controller.text = "";
      meterRead4Controller.text = "";
      meterRead5Controller.text = "";
      meterRead6Controller.text = "";
      meterRead7Controller.text = "";
      meterRead8Controller.text = "";
      meterRead9Controller.text = "";
      meterRead10Controller.text = "";
      meterFile = File("");
      _eventCompleted(emit);
    } else{
      await fetchPendingBillsApi(
          context: event.context,
          bpNumber: bpMeterSearchNoController.text.trim().toString(),emit: emit);
    }
    _eventCompleted(emit);
  }
  _billingHideShow(BillingHideShowEvent event, emit) {
    isHideShowDetails = event.isHideShow;
    _eventCompleted(emit);
  }
  _selectMeterCamera(SelectMeterCameraEvent event, emit) async{
    var photo = await BillingRequestHelper.cameraCapture();
    if(photo.path.isNotEmpty){
      meterFile = photo;
    }
    _eventCompleted(emit);
  }

  _selectMeterGallery(SelectMeterGalleryEvent event, emit) async {
    var photo = await BillingRequestHelper.galleryCapture();
    if(photo.path.isNotEmpty){
      meterFile = photo;
    }
    _eventCompleted(emit);
  }

  _setLocation() async {
    var getLocation = await BillingRequestHelper.getCurrentLocation();
    latController = TextEditingController(text: getLocation?.latitude.toString());
    longController = TextEditingController(text: getLocation?.longitude.toString());
    return getLocation;
  }

  _onChange1Event(OnChange1Event event, emit) async {
    if(meterRead1Controller.text.isNotEmpty && meterRead1Controller.text.length == 1){
      meterReadCon1 =  true;
      FocusScope.of(event.context).unfocus();
    }else{
      meterReadCon1 =  false;
    }
    _eventCompleted(emit);
  }

  _onChange2Event(OnChange2Event event, emit) async {
    if(meterRead2Controller.text.isNotEmpty && meterRead2Controller.text.length == 1){
      meterReadCon1 =  true;
      FocusScope.of(event.context).requestFocus(meterRead1Node);
    }else if(meterRead1Controller.text.isNotEmpty && meterRead1Controller.text.length == 1){
      meterReadCon1 =  true;
      FocusScope.of(event.context).requestFocus(meterRead1Node);
    }else{
      meterRead1Controller.clear();
      meterReadCon1 =  false;
    }
    _eventCompleted(emit);
  }

  _onChange3Event(OnChange3Event event, emit) async {
    if(meterRead3Controller.text.isNotEmpty && meterRead3Controller.text.length == 1){
      meterReadCon2 =  true;
      FocusScope.of(event.context).requestFocus(meterRead2Node);
    }else if(meterRead2Controller.text.isNotEmpty && meterRead2Controller.text.length == 1){
      meterReadCon2 =  true;
      FocusScope.of(event.context).requestFocus(meterRead2Node);
    }else{
      meterRead2Controller.clear();
      meterReadCon2 =  false;
    }
    _eventCompleted(emit);
  }

  _onChange4Event(OnChange4Event event, emit) async {
    if(meterRead4Controller.text.isNotEmpty && meterRead4Controller.text.length == 1){
      meterReadCon3 =  true;
      FocusScope.of(event.context).requestFocus(meterRead3Node);
    } else if(meterRead3Controller.text.isNotEmpty && meterRead3Controller.text.length == 1){
      meterReadCon3 =  true;
      FocusScope.of(event.context).requestFocus(meterRead3Node);
    }
    else{
      meterRead3Controller.clear();
      meterReadCon3 =  false;
    }
    _eventCompleted(emit);
  }

  _onChange5Event(OnChange5Event event, emit) async {
    if(meterRead5Controller.text.isNotEmpty && meterRead5Controller.text.length == 1){
      meterReadCon4 =  true;
      FocusScope.of(event.context).requestFocus(meterRead4Node);
    }else if(meterRead4Controller.text.isNotEmpty && meterRead4Controller.text.length == 1){
      meterReadCon4 =  true;
      FocusScope.of(event.context).requestFocus(meterRead4Node);
    }else{
      meterRead4Controller.clear();
      meterReadCon4 =  false;
    }
    _eventCompleted(emit);
  }

  _onChange6Event(OnChange6Event event, emit) async {
    if(meterRead6Controller.text.isNotEmpty && meterRead6Controller.text.length == 1){
      meterReadCon5 =  true;
      FocusScope.of(event.context).requestFocus(meterRead5Node);
    }else if(meterRead5Controller.text.isNotEmpty && meterRead5Controller.text.length == 1){
      meterReadCon5 =  true;
      FocusScope.of(event.context).requestFocus(meterRead5Node);
    }else{
      meterRead5Controller.clear();
      meterReadCon5 =  false;
    }
    _eventCompleted(emit);
  }

  _onChange7Event(OnChange7Event event, emit) async {
    if(meterRead7Controller.text.isNotEmpty && meterRead7Controller.text.length == 1){
      meterReadCon6 =  true;
      FocusScope.of(event.context).requestFocus(meterRead6Node);
    }else if(meterRead6Controller.text.isNotEmpty && meterRead6Controller.text.length == 1){
      meterReadCon6 =  true;
      FocusScope.of(event.context).requestFocus(meterRead6Node);
    }else{
      meterRead6Controller.clear();
      meterReadCon6 =  false;
    }
    _eventCompleted(emit);
  }

  _onChange8Event(OnChange8Event event, emit) async {
    if(meterRead8Controller.text.isNotEmpty && meterRead8Controller.text.length == 1){
      meterReadCon7 =  true;
      FocusScope.of(event.context).requestFocus(meterRead7Node);
    }else if(meterRead7Controller.text.isNotEmpty && meterRead7Controller.text.length == 1){
      meterReadCon7 =  true;
      FocusScope.of(event.context).requestFocus(meterRead7Node);
    }else{
      meterRead7Controller.clear();
      meterReadCon7 =  false;
    }
    _eventCompleted(emit);
  }

  _onChange9Event(OnChange9Event event, emit) async {
    if(meterRead9Controller.text.isNotEmpty && meterRead9Controller.text.length == 1){
      meterReadCon8 =  true;
      FocusScope.of(event.context).requestFocus(meterRead8Node);
    }else if(meterRead8Controller.text.isNotEmpty && meterRead8Controller.text.length == 1){
      meterReadCon8 =  true;
      FocusScope.of(event.context).requestFocus(meterRead8Node);
    }else{
      meterRead8Controller.clear();
      meterReadCon8 =  false;
    }
    _eventCompleted(emit);
  }

  _onChange10Event(OnChange10Event event, emit) async {
    if(meterRead10Controller.text.isNotEmpty && meterRead10Controller.text.length == 1){
      meterReadCon9 =  true;
      FocusScope.of(event.context).requestFocus(meterRead9Node);
    }else if(meterRead9Controller.text.isNotEmpty && meterRead9Controller.text.length == 1){
      meterReadCon9 =  true;
      FocusScope.of(event.context).requestFocus(meterRead9Node);
    }else{
      meterRead9Controller.clear();
      meterReadCon9 =  false;
    }
    _eventCompleted(emit);
  }

  double actualResult = 0.0;
  double sumAllMeterReadController = 0.0;

  subNormalMethod() {
    if(listOfBPNumber.isNotEmpty){
      String replaceStatus = listOfBPNumber[0].replaceStatus.toString();
      print("replaceStatus-->$replaceStatus");
      String oldMeterCurrentReading = listOfBPNumber[0].oldMeterCurrentReading.toString();
      String oldMeterLastReading = listOfBPNumber[0].oldMeterLastReading.toString();
      String newMeterOldReading = listOfBPNumber[0].newMeterOldReading.toString();
      sumAllMeterReadController = double.parse(
          meterRead1Controller.text +
              meterRead2Controller.text +
              meterRead3Controller.text +
              meterRead4Controller.text +
              meterRead5Controller.text +
              meterRead6Controller.text +
              meterRead7Controller.text +
              meterRead8Controller.text +
              meterRead9Controller.text +
              meterRead10Controller.text);
      if (replaceStatus == "0") {
        double sum = sumAllMeterReadController / 1000 - double.parse(previousReadingController.text);
        actualResult = sum;
      } else if (replaceStatus == "1") {
        double oldReading = double.parse(oldMeterCurrentReading) - double.parse(oldMeterLastReading);
        double newReading = sumAllMeterReadController / 1000 - double.parse(newMeterOldReading);
        actualResult = oldReading + newReading;
      }
    }else{

    }

  }



  _preview(BillingRequestPreviewEvent event, emit) async {
    try{
      if(bpMeterSearchNoController.text.isEmpty){
        Utils.errorSnackBar(msg: "The BP Number field is required.", context: event.context);
        return false;
      }else if(meterRead10Controller.text.isEmpty || meterRead9Controller.text.isEmpty || meterRead8Controller.text.isEmpty){
        Utils.errorSnackBar(msg: "Please Enter three Initial Reading.", context: event.context);
        return false;
      }else if(meterFile.path.isEmpty){
        Utils.errorSnackBar(msg: "Please Enter Meter Image.", context: event.context);
        return false;
      }else{
        return processDialog(context: event.context);

      }
    }catch(e){
      isPageLoader = false;
      _eventCompleted(emit);
      log("submit-->${e.toString()}");
    }
  }
  _submit(BillingRequestSubmitEvent event, emit) async {
    try{
      double sum = double.parse(
          meterRead1Controller.text +
              meterRead2Controller.text +
              meterRead3Controller.text +
              meterRead4Controller.text +
              meterRead5Controller.text +
              meterRead6Controller.text +
              meterRead7Controller.text +
              meterRead8Controller.text +
              meterRead9Controller.text +
              meterRead10Controller.text);
      var checkValid = await BillingRequestHelper.textValidationCheck(
          context: event.context,
          bpNumber: bpMeterSearchNoController.text.trim().toString(),
          custName: custNameController.text.trim().toString(),
          meterSerial: meterNumberController.text.trim().toString(),
          previousReading: previousReadingController.text.trim().toString(),
          currentReading: sum.toString(),
          meterFile: meterFile.path.toString());
      if(checkValid == true){
        isBtnLoader = true;
        _eventCompleted(emit);
        var res = await BillingRequestHelper.generateNGC(
            context: event.context,
            bpNumber: bpMeterSearchNoController.text.trim().toString(),
            meterReading: (sumAllMeterReadController / 1000).toString(),
            meterSerial: meterNumberController.text.trim().toString(),
            latitude: latController.text.trim().toString(),
            longitude: longController.text.trim().toString(),
            oldReading: previousReadingController.text.trim().toString(),
            meterFile: meterFile.path.toString());
        if(res != null){
          isBtnLoader = false;
          _eventCompleted(emit);
          await Utils.successSnackBar(msg: res.message!, context: event.context);
          BlocProvider.of<BillPrintBloc>(event.context).add(
              BillPrintPageLoaderEvent(
                  context: event.context,
                  billId: res.billId.toString(),
                  schema: scheme));
          Navigator.pushAndRemoveUntil<dynamic>(
            event.context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => BillingRequestPage(),
            ),
                (route) => false,//if you want to disable back feature set to false
          );
        } else{
          isBtnLoader = false;
          _eventCompleted(emit);
        }
      }
    }catch(e){
      isBtnLoader = false;
      _eventCompleted(emit);
      log("submit-->${e.toString()}");
    }
  }

  Future<void> processDialog({required BuildContext context}) async {
    if(listOfBPNumber.isNotEmpty){
      await  subNormalMethod();
      double myReadingValue = double.parse(
          meterRead1Controller.text +
              meterRead2Controller.text +
              meterRead3Controller.text +
              meterRead4Controller.text +
              meterRead5Controller.text +
              meterRead6Controller.text +
              meterRead7Controller.text +
              meterRead8Controller.text +
              meterRead9Controller.text +
              meterRead10Controller.text);
      var myReading = myReadingValue == '' ? 0.0 : myReadingValue / 1000;
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return Scaffold(
              appBar: AppBarWidget(
                  title: "${ listOfBPNumber[0].replaceStatus.toString() == "1"
                      ? "Replace Status "
                      : "Meter Reader Details"}(${listOfBPNumber[0].replaceStatus.toString()})"
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    RowWidget(
                      leading: "BP Number : ",
                      trailing: bpNumberController.text.toString(),
                    ),
                    RowWidget(
                      leading: "Customer Name : ",
                      trailing: custNameController.text.toString(),
                    ),
                    RowWidget(
                      leading: "Meter Number : ",
                      trailing: meterNumberController.text.toString(),
                    ),
                    listOfBPNumber[0].replaceStatus.toString() == "1"
                        ? RowWidget(
                      leading: "Old Meter Reading Date : ",
                      trailing:
                      listOfBPNumber[0].oldMeterReadingDate.toString(),
                    )
                        : Container(),
                    listOfBPNumber[0].replaceStatus.toString() == "1"
                        ? RowWidget(
                      leading: "New Meter Install Date : ",
                      trailing:
                      listOfBPNumber[0].newMeterInstallDate.toString(),
                    )
                        : Container(),
                    listOfBPNumber[0].replaceStatus.toString() == "1"
                        ? RowWidget(
                      leading: "Old Meter Previous Reading : ",
                      trailing:
                      listOfBPNumber[0].oldMeterLastReading.toString(),
                    )
                        : Container(),
                    listOfBPNumber[0].replaceStatus.toString() == "1"
                        ? RowWidget(
                      leading: "Old Meter Current Reading : ",
                      trailing:
                      listOfBPNumber[0].oldMeterCurrentReading.toString(),
                    )
                        : Container(),
                    listOfBPNumber[0].replaceStatus.toString() == "1"
                        ? RowWidget(
                      leading: "New Meter Initial Reading : ",
                      trailing:
                      listOfBPNumber[0].newMeterOldReading.toString(),
                    )
                        : RowWidget(
                      leading: "Previous Reading : ",
                      trailing: listOfBPNumber[0].oldReading.toString(),
                    ),
                    RowWidget(
                      leading: listOfBPNumber[0].replaceStatus.toString() == "1"
                          ? "New Meter Current Reading : "
                          : "Meter Current Reading : ",
                      trailing: myReading.toStringAsFixed(3),
                    ),
                    RowWidget(
                      leading: "Last Meter Reader Date : ",
                      trailing: listOfBPNumber[0].lastBillGeneratedDate,
                    ),
                    RowWidget(
                      leading: "Last Bill Pay Date : ",
                      trailing: listOfBPNumber[0].lastBillPayDate,
                    ),
                    RowWidget(
                      leading: "Outstanding Amount : ",
                      trailing: listOfBPNumber[0].lastBillPreviousOutstanding,
                    ),
                    if (actualResult >= 0)...[
                      if (actualResult > 5 && actualResult < 25)...[
                        Column(
                          children: [
                            RowWidget(
                              leading: "Message : ",
                              trailing: "This Reading is valid",
                            ),
                            RowWidget(
                              leading: "Consumption Reading : ",
                              trailing: actualResult.toStringAsFixed(3),
                            ),
                          ],
                        )
                      ] else if (actualResult < 5) ...[
                        Column(
                          children: [
                            RowWidget(
                              leading: "Message : ",
                              trailing: "This Reading is Less then 5",
                            ),
                            RowWidget(
                              leading: "Consumption Reading : ",
                              trailing: actualResult.toStringAsFixed(3),
                            ),
                          ],
                        )
                      ] else...[
                        RowWidget(
                          leading: "Message : ",
                          trailing: "This Reading is Greater then 25",
                        ),
                        RowWidget(
                          leading: "Consumption Reading : ",
                          trailing: actualResult.toStringAsFixed(3),
                        ),
                      ]
                    ] else...[
                      ErrorRowWidget(
                        leading: "Message : ",
                        trailing: "This Negative Reading is not valid",
                      ),
                      if(actualResult < 0)...[
                        ErrorRowWidget(
                          leading: "Consumption Reading : ",
                          trailing: actualResult.toStringAsFixed(3),
                        ),
                      ] else...[
                        RowWidget(
                          leading: "Consumption Reading : ",
                          trailing: actualResult.toStringAsFixed(3),
                        ),
                      ]
                    ],
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        isBtnLoader == true ?  DottedLoaderWidget()
                            : ButtonWidget(
                          text: "Accept",
                          onPressed: (){
                            if (actualResult >= 0) {
                              BlocProvider.of<BillingRequestBloc>(context).add(
                                  BillingRequestSubmitEvent(context: context));
                            } else{
                              Utils.errorSnackBar(msg: "This Negative Reading is not valid", context: context);
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                        ButtonWidget(
                          text: "Edit",
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
    }else{
      return  Utils.errorSnackBar(msg: "Error: Incorrect BP/Meter Number", context: context);
    }
  }


  _eventCompleted(emit) {
    emit(BillingRequestFetchDataState(
      userName: userName,
      scheme: scheme,
      isPageLoader: isPageLoader,
      isHideShowDetails: isHideShowDetails,
      isBtnLoader: isBtnLoader,
      isSyncLoader: isSyncLoader,
      meterReadCon1: meterReadCon1,
      meterReadCon2: meterReadCon2,
      meterReadCon3: meterReadCon3,
      meterReadCon4: meterReadCon4,
      meterReadCon5: meterReadCon5,
      meterReadCon6: meterReadCon6,
      meterReadCon7: meterReadCon7,
      meterReadCon8: meterReadCon8,
      meterReadCon9: meterReadCon9,
      meterReadCon10: meterReadCon10,
      meterFile: meterFile,
      bpNumberModel: bpNumberModel,
      listOfBPNumber: listOfBPNumber,
      bpMeterSearchNoController: bpMeterSearchNoController,
      mobileNumberController: mobileNumberController,
      custNameController: custNameController,
      bpNumberController: bpNumberController,
      buildingNoController: buildingNoController,
      streetNameController: streetNameController,
      colonyController: colonyController,
      districtController: districtController,
      pinCodeController: pinCodeController,
      townController: townController,
      custAddController: custAddController,
      meterNumberController: meterNumberController,
      previousReadingController: previousReadingController,
      meterRead1Controller: meterRead1Controller,
      meterRead2Controller: meterRead2Controller,
      meterRead3Controller: meterRead3Controller,
      meterRead4Controller: meterRead4Controller,
      meterRead5Controller: meterRead5Controller,
      meterRead6Controller: meterRead6Controller,
      meterRead7Controller: meterRead7Controller,
      meterRead8Controller: meterRead8Controller,
      meterRead9Controller: meterRead9Controller,
      meterRead10Controller: meterRead10Controller,
      meterRead1Node: meterRead1Node,
      meterRead2Node: meterRead2Node,
      meterRead3Node: meterRead3Node,
      meterRead4Node:meterRead4Node,
      meterRead5Node: meterRead5Node,
      meterRead6Node: meterRead6Node,
      meterRead7Node: meterRead7Node,
      meterRead8Node: meterRead8Node,
      meterRead9Node: meterRead9Node,
      meterRead10Node: meterRead10Node,
    )
    );
  }
}