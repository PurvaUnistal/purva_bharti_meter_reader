import 'dart:developer';
import 'package:flutter/scheduler.dart';
import 'package:meter_reader/Utils/common_widget/row_widget.dart';
import '../models/generate_model.dart';
import '../ExportFile/export_file.dart';

class MeterRequestScreen extends StatefulWidget {
  const MeterRequestScreen({Key? key}) : super(key: key);

  @override
  MeterReadingNumberState createState() => MeterReadingNumberState();
}

class MeterReadingNumberState extends State<MeterRequestScreen> {
  int i = 9;
  BuildContext? ctx;
  bool canProceed = true;
  bool isOffline = false;
  bool dialogIsVisible = false;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  bool progressBar = false;
  bool loading = false;
  String scmAmount = '';
  SharedPreferences? pref;
  var totalAmount;
  final String _takePhotoLabel = 'Take Photo';
  String locationLat = '0';
  String locationLong = '0';
  String address = '';

  PhotoController meterImgController = PhotoController();
  final FocusScopeNode _node = FocusScopeNode();
  final bpNumberSearchController = new TextEditingController();
  final bpNumberFieldController = new TextEditingController();
  final meterNumberController = new TextEditingController();
  final customerNameController = new TextEditingController();
  final customerAddressController = new TextEditingController();
  final previousReadingController = new TextEditingController();
  final previousOutStandingController = new TextEditingController();
  final houseNumberController = new TextEditingController();
  final localityController = new TextEditingController();
  final townController = new TextEditingController();
  final pinCodeController = new TextEditingController();
  final myController1 = new TextEditingController();
  final myController2 = new TextEditingController();
  final myController3 = new TextEditingController();
  final myController4 = new TextEditingController();
  final myController5 = new TextEditingController();
  final myController6 = new TextEditingController();
  final myController7 = new TextEditingController();
  final myController8 = new TextEditingController();
  final myController9 = new TextEditingController();
  final myController10 = new TextEditingController();
  final oldMeterReaderController = new TextEditingController();
  final _controller = new TextEditingController();
  TextEditingController meterSerialNumber = new TextEditingController(text: '');
  TextEditingController fileName1 = TextEditingController();
  PhotoController meterPhotoController = new PhotoController();

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  bool con1 = false,
      con2 = false,
      con3 = false,
      con4 = false,
      con5 = false,
      con6 = false,
      con7 = false,
      con8 = false,
      con9 = false,
      con10 = true;
  ApiIntegration? apiIntegration;
  BPNumberRequestModel? bpNumberRequestModel;
  GenerateRequestModel? generateRequestModel;
  BpNumberModel? bpNumberModel;
  List<DataList> searchList = [];

  int? keyIndex;
  File? meterImage;
  Color? borderColor;
  String token = '';
  String schema = '';
  String userId = '';
  String current = '';
  var totalReading;
  var checkStatus;
  bool checkValue = false;

  getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      schema = pref.getString(GlobalConstants.schema) ?? "";
      userId = pref.getString(GlobalConstants.id) ?? "";
      print("userId--> " + userId);
    });
  }

  @override
  void initState() {
    super.initState();
    apiIntegration = ApiIntegration();
    getData();
    locationConnect();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  double actualResult = 0.0;
  double? allControllerData;

  subNormalMethod() {
    String replaceStatus = searchList[0].replaceStatus.toString();
    print("replaceStatus-->$replaceStatus");
    String oldMeterCurrentReading =
        searchList[0].oldMeterCurrentReading.toString();
    String oldMeterLastReading = searchList[0].oldMeterLastReading.toString();
    String newMeterOldReading = searchList[0].newMeterOldReading.toString();
    if (replaceStatus == "0") {
      setState(() {
        double sum = double.parse(myController1.text +
                    myController2.text +
                    myController3.text +
                    myController4.text +
                    myController5.text +
                    myController6.text +
                    myController7.text +
                    myController8.text +
                    myController9.text +
                    myController10.text) /
                1000 -
            double.parse(previousReadingController.text);
        actualResult = sum;
      });
    } else if (replaceStatus == "1") {
      double oldReading = double.parse(oldMeterCurrentReading) -
          double.parse(oldMeterLastReading);
      double newReading = double.parse(myController1.text +
                  myController2.text +
                  myController3.text +
                  myController4.text +
                  myController5.text +
                  myController6.text +
                  myController7.text +
                  myController8.text +
                  myController9.text +
                  myController10.text) /
              1000 -
          double.parse(newMeterOldReading);
      actualResult = oldReading + newReading;
    }
  }

  Future billMeterReader() async {
    setState(() {
      loading = true;
    });
    bpNumberRequestModel = BPNumberRequestModel(
      schema: schema,
      bpNumber: bpNumberSearchController.text.toString(),
    );
    var response =
        await apiIntegration?.bpNumberSearch(bpNumberRequestModel!, context);
    setState(() {
      try {
        if (response != null) {
          searchList = response!;
          dataClear();
          meterNumberController.text =
              searchList[0].meterSerialNumber.toString();
          bpNumberFieldController.text = searchList[0].bpNumber.toString();
          customerNameController.text = searchList[0].firstName.toString() +
              " " +
              searchList[0].lastName.toString();
          customerAddressController.text =
              searchList[0].houseNumber.toString() +
                  "\n" +
                  searchList[0].locality.toString() +
                  "\n" +
                  searchList[0].town.toString() +
                  "\n" +
                  searchList[0].pinCode.toString();
          previousReadingController.text = searchList[0].replaceStatus == 1
              ? searchList[0].newMeterOldReading.toString()
              : searchList[0].oldReading.toString();
        } else {
          searchList = [];
          dataClear();
        }
      } catch (e) {
        setState(() {
          loading = false;
        });
      }
    });
    if (response != null) {
      setState(() {
        loading = false;
      });
      print("success");
    } else {
      setState(() {
        loading = false;
      });
      /* CustomToast.showToast("Failed");
      print("failed");*/
    }
  }

  Future onClick() async {
    String myReadingValue = myController1.text.toString().trim() +
        myController2.text.toString().trim() +
        myController3.text.toString().trim() +
        myController4.text.toString().trim() +
        myController5.text.toString().trim() +
        myController6.text.toString().trim() +
        myController7.text.toString().trim() +
        myController8.text.toString().trim() +
        myController9.text.toString().trim() +
        myController10.text.toString().trim();
    double myReading = double.parse(myReadingValue) / 1000;
    if (bpNumberFieldController.text.trim().toString() == " ") {
      CustomToast.showToast("Select BP Number");
      return;
    }
    if (customerNameController.text.trim().toString() == " ") {
      CustomToast.showToast("Select Customer Name ");
      return;
    }
    if (customerAddressController.text.trim().toString() == " ") {
      CustomToast.showToast("Select Customer Address ");
      return;
    }
    if (bpNumberFieldController.text.trim().toString() == " ") {
      CustomToast.showToast("Select BP Number");
      return;
    }
    if (meterNumberController.text.trim().toString() == " ") {
      CustomToast.showToast("Select Meeter Number");
      return;
    }
    if (previousReadingController.text.trim().toString() == " ") {
      CustomToast.showToast("Select Previous Reading ");
      return;
    }
    if (myReadingValue.trim() == "") {
      CustomToast.showToast("Enter New Meter Reading");
      return;
    }
    if (meterImgController.imagePath == null ||
        meterImgController.imagePath.toString() == " ") {
      CustomToast.showToast("Select Meter Image");
      return;
    }
    if (double.parse(previousReadingController.text) > myReading) {
      CustomToast.showToast(
          "New Reading should be more than Previous Reading ");
      return;
    }
    setState(() {
      progressBar = true;
    });
    generateRequestModel = GenerateRequestModel(
      bpNumber: bpNumberFieldController.text.toString(),
      schema: schema,
      meter_reading: myReading.toString(),
      meter_serial: meterNumberController.text.toString(),
      generate_by_customer: "0",
      latitude: locationLat,
      longitude: locationLong,
      meter_image_file: meterImgController.imagePath!.path,
      old_reading: previousReadingController.text.toString(),
      user_id: userId,
    );
    // print(GenerateRequestModel.t)
    var response =
        await apiIntegration!.submitGenerateApi(generateRequestModel!, context);
    setState(() {
      try {
        if (response != null) {
          setState(() {
            progressBar = false;
          });
          if (response.code == 200) {
            setState(() {
              progressBar = false;
            });
            CustomToast.showToast(response.message.toString());
            print("success");
            bpNumberSearchController.clear();
            dataClear();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MeterRequestScreen()),
            );
            BlocProvider.of<BillPrintBloc>(context).add(
                BillPrintPageLoaderEvent(
                    context: context,
                    billId: response.billId.toString(),
                    schema: schema));
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => BillPrinterPage()));
          } else if (response.code == 404) {
            ShowCustomToast.showToast(response.message.toString());
            Navigator.of(context).pop();
          } else if (response.code == 400) {
            ShowCustomToast.showToast(response.message.toString());
            Navigator.of(context).pop();
          } else {
            ShowCustomToast.showToast(response.message.toString());
            print("success");
            Navigator.of(context).pop();
          }
        }
      } catch (e) {
        CustomToast.showToast(response!.message.toString());
        progressBar = false;
      }
    });
  }

  dataClear() {
    meterSerialNumber.clear();
    bpNumberFieldController.clear();
    meterNumberController.clear();
    customerNameController.clear();
    customerAddressController.clear();
    previousReadingController.clear();
    previousOutStandingController.clear();
    myController1.clear();
    myController2.clear();
    myController3.clear();
    myController4.clear();
    myController5.clear();
    myController6.clear();
    myController7.clear();
    myController8.clear();
    myController9.clear();
    myController10.clear();
    meterImgController = PhotoController();
  }

  dataTextEnable() {
    myController1.clear();
    myController2.clear();
    myController3.clear();
    myController4.clear();
    myController5.clear();
    myController6.clear();
    myController7.clear();
    myController8.clear();
    myController9.clear();
    myController10.clear();
  }

  @override
  void dispose() {
    _node.dispose();
    oldMeterReaderController.dispose();
    myController1.dispose();
    myController2.dispose();
    myController3.dispose();
    myController4.dispose();
    myController5.dispose();
    myController6.dispose();
    myController7.dispose();
    myController8.dispose();
    myController9.dispose();
    myController10.dispose();
    _controller.dispose();
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.green.shade800,
        statusBarIconBrightness: Brightness.light));
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.green.shade800,
          elevation: 0,
          centerTitle: true,
          title: Text("Meter Reader",
              style: TextStyle(fontSize: 16, color: Colors.white)),
          automaticallyImplyLeading: false,
          actions: [
            PopupMenuButton<String>(
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                return {'Logout', 'History'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 10),
                            child: TextFormField(
                              maxLength: 20,
                              enabled: true,
                              autofocus: true,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.deny(RegExp(r'\s')),
                              ],
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.search,
                              controller: bpNumberSearchController,
                              enableInteractiveSelection: true,
                              cursorColor: greyColor,
                              decoration: InputDecoration(
                                labelText: "BP Number/Meter Number",
                                labelStyle: TextStyle(color: greyColor),
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                suffixIcon: IconButton(
                                  icon: loading
                                      ? SizedBox(
                                          width: 12,
                                          height: 12,
                                          child: CircularProgressIndicator(
                                            color: greyColor,
                                          ))
                                      : Icon(
                                          Icons.sync,
                                          color: greyColor,
                                        ),
                                  onPressed: () {
                                    billMeterReader();
                                  },
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    color: greyColor,
                                    width: 1.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: greyColor,
                                    width: 1.0,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: borderColor == null
                                          ? Colors.teal
                                          : borderColor!,
                                      width: 1.0,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                              ),
                            ),
                          )),
                      CustomTextEmailField(
                        enabled: false,
                        keyboardType: TextInputType.name,
                        controller: customerNameController,
                        validate: false,
                        labelText: "Customer Name",
                        filledColor: Colors.white,
                      ),
                      CustomTextEmailField(
                        enabled: false,
                        keyboardType: TextInputType.streetAddress,
                        maxLines: 4,
                        controller: customerAddressController,
                        validate: false,
                        labelText: "Customer Address",
                        filledColor: Colors.white,
                      ),
                      CustomTextEmailField(
                        enabled: false,
                        keyboardType: TextInputType.number,
                        controller: bpNumberFieldController,
                        validate: false,
                        labelText: "BP Number",
                        filledColor: Colors.white,
                      ),
                      CustomTextEmailField(
                        enabled: false,
                        keyboardType: TextInputType.number,
                        controller: meterNumberController,
                        validate: false,
                        labelText: "Meter Number",
                        filledColor: Colors.white,
                      ),
                      CustomTextEmailField(
                        enabled: false,
                        keyboardType: TextInputType.number,
                        controller: previousReadingController,
                        validate: false,
                        labelText: searchList.isEmpty
                            ? "Previous Reading"
                            : searchList[0].replaceStatus == 1
                                ? "New Meter Initial Reading"
                                : "Previous Reading",
                        filledColor: Colors.white,
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          child: Text("Meter Reading:",
                              style: ReusedTextStyle.currentMeeterReader)),
                      SizedBox(
                        height: 10.0,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: <Widget>[
                            MeterNumber(myController1, false, con2,
                                TextInputAction.done, (_) {
                              if (myController1.text
                                  .toString()
                                  .trim()
                                  .isNotEmpty) {
                                setState(() {
                                  con9 = true;
                                  FocusScope.of(context).unfocus();
                                });
                              } else {
                                setState(() {
                                  con9 = false;
                                });
                              }
                            }, Colors.grey),
                            SizedBox(
                              width: 2.0,
                            ),
                            MeterNumber(myController2, con2, con3,
                                TextInputAction.previous, (_) {
                              if (myController2.text
                                  .toString()
                                  .trim()
                                  .isNotEmpty) {
                                setState(() {
                                  con1 = true;
                                  FocusScope.of(context).previousFocus();
                                });
                              } else {
                                setState(() {
                                  con1 = false;
                                });
                              }
                            }, Colors.grey),
                            SizedBox(
                              width: 2.0,
                            ),
                            MeterNumber(myController3, con3, con4,
                                TextInputAction.previous, (_) {
                              if (myController3.text
                                  .toString()
                                  .trim()
                                  .isNotEmpty) {
                                setState(() {
                                  con2 = true;
                                  FocusScope.of(context).previousFocus();
                                });
                              } else {
                                setState(() {
                                  con2 = false;
                                });
                              }
                            }, Colors.grey),
                            SizedBox(
                              width: 2.0,
                            ),
                            MeterNumber(myController4, con4, con5,
                                TextInputAction.previous, (_) {
                              if (myController4.text
                                  .toString()
                                  .trim()
                                  .isNotEmpty) {
                                setState(() {
                                  con3 = true;
                                  FocusScope.of(context).previousFocus();
                                });
                              } else {
                                setState(() {
                                  con3 = false;
                                });
                              }
                            }, Colors.grey),
                            SizedBox(
                              width: 2.0,
                            ),
                            MeterNumber(myController5, con5, con6,
                                TextInputAction.previous, (_) {
                              if (myController5.text
                                  .toString()
                                  .trim()
                                  .isNotEmpty) {
                                setState(() {
                                  con4 = true;
                                  FocusScope.of(context).previousFocus();
                                });
                              } else {
                                setState(() {
                                  con4 = false;
                                });
                              }
                            }, Colors.grey),
                            SizedBox(
                              width: 2.0,
                            ),
                            MeterNumber(myController6, con6, con7,
                                TextInputAction.previous, (_) {
                              if (myController6.text
                                  .toString()
                                  .trim()
                                  .isNotEmpty) {
                                setState(() {
                                  con5 = true;
                                  FocusScope.of(context).previousFocus();
                                });
                              } else {
                                setState(() {
                                  con5 = false;
                                });
                              }
                            }, Colors.grey),
                            SizedBox(
                              width: 2.0,
                            ),
                            MeterNumber(myController7, con7, con8,
                                TextInputAction.previous, (_) {
                              if (myController7.text
                                  .toString()
                                  .trim()
                                  .isNotEmpty) {
                                setState(() {
                                  con6 = true;
                                  FocusScope.of(context).previousFocus();
                                });
                              } else {
                                setState(() {
                                  con6 = false;
                                });
                              }
                            }, Colors.grey),
                            SizedBox(
                              width: 2.0,
                            ),
                            MeterNumber(myController8, con8, con9,
                                TextInputAction.previous, (_) {
                              if (myController8.text
                                  .toString()
                                  .trim()
                                  .isNotEmpty) {
                                setState(() {
                                  con7 = true;
                                });
                              } else {
                                setState(() {
                                  con7 = false;
                                });
                              }
                              FocusScope.of(context).previousFocus();
                            }, Colors.red),
                            SizedBox(
                              width: 2.0,
                            ),
                            MeterNumber(myController9, con9, con10,
                                TextInputAction.previous, (_) {
                              if (myController9.text
                                  .toString()
                                  .trim()
                                  .isNotEmpty) {
                                setState(() {
                                  con8 = true;
                                });
                              } else {
                                setState(() {
                                  con8 = false;
                                });
                              }
                              FocusScope.of(context).previousFocus();
                            }, Colors.red),
                            SizedBox(
                              width: 2.0,
                            ),
                            MeterNumber(myController10, true, con10,
                                TextInputAction.previous, (_) {
                              log(con10.toString());
                              if (myController10.text
                                  .toString()
                                  .trim()
                                  .isNotEmpty) {
                                setState(() {
                                  con9 = true;
                                  FocusScope.of(context).previousFocus();
                                });
                              } else {
                                setState(() {
                                  con9 = false;
                                });
                              }
                            }, Colors.red),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            meterImgController.imagePath != null
                                ? Image.file(
                                    meterImgController.imagePath!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    'assets/images/placeholder.png',
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                            MaterialButton(
                                color: Colors.green.shade800,
                                child: Text(
                                  _takePhotoLabel,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                onPressed: () async {
                                  _openImageSource(context, meterImgController);
                                }),
                          ]),
                      SizedBox(
                        height: 18,
                      ),
                      MaterialButton(
                        color: Colors.green.shade800,
                        onPressed: () {
                          if (searchList.isEmpty) {
                            CustomToast.showToast(
                                "Please Search Bp Number/Meter Reader");
                          } else if (myController10.text.isEmpty ||
                              myController9.text.isEmpty ||
                              myController8.text.isEmpty) {
                            CustomToast.showToast(
                                "Please Enter three Initial Reading");
                          } else if (meterImgController.imagePath?.path ==
                              null) {
                            CustomToast.showToast("Please Enter Meter Image");
                          } else {
                            processDialog();
                          }
                        },
                        child: Text("Preview",
                            style: TextStyle(
                              color: Colors.white,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> processDialog() async {
    var myReadingValue = myController1.text.toString().trim() +
        myController2.text.toString().trim() +
        myController3.text.toString().trim() +
        myController4.text.toString().trim() +
        myController5.text.toString().trim() +
        myController6.text.toString().trim() +
        myController7.text.toString().trim() +
        myController8.text.toString().trim() +
        myController9.text.toString().trim() +
        myController10.text.toString().trim();
    var myReading =
        myReadingValue == '' ? 0.0 : double.parse(myReadingValue) / 1000;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: 200,
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: double.infinity,
                          color: Colors.green.shade800,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 18.0),
                            child: Text(
                              searchList[0].replaceStatus.toString() == "1"
                                  ? "Replace Status "
                                  : "Meter Reader Details" +
                                      "(" +
                                      searchList[0].replaceStatus.toString() +
                                      ")",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        )),
                    RowWidget(
                      leading: "BP Number : ",
                      trailing: bpNumberFieldController.text.toString(),
                    ),
                    RowWidget(
                      leading: "Customer Name : ",
                      trailing: customerNameController.text.toString(),
                    ),
                    RowWidget(
                      leading: "Customer Address : ",
                      trailing: customerAddressController.text.toString(),
                    ),
                    RowWidget(
                      leading: "Meter Number : ",
                      trailing: meterNumberController.text.toString(),
                    ),
                    searchList[0].replaceStatus.toString() == "1"
                        ? RowWidget(
                            leading: "Old Meter Reading Date : ",
                            trailing:
                                searchList[0].oldMeterReadingDate.toString(),
                          )
                        : Container(),
                    searchList[0].replaceStatus.toString() == "1"
                        ? RowWidget(
                            leading: "New Meter Install Date : ",
                            trailing:
                                searchList[0].newMeterInstallDate.toString(),
                          )
                        : Container(),
                    searchList[0].replaceStatus.toString() == "1"
                        ? RowWidget(
                            leading: "Old Meter Previous Reading : ",
                            trailing:
                                searchList[0].oldMeterLastReading.toString(),
                          )
                        : Container(),
                    searchList[0].replaceStatus.toString() == "1"
                        ? RowWidget(
                            leading: "Old Meter Current Reading : ",
                            trailing:
                                searchList[0].oldMeterCurrentReading.toString(),
                          )
                        : Container(),
                    searchList[0].replaceStatus.toString() == "1"
                        ? RowWidget(
                            leading: "New Meter Initial Reading : ",
                            trailing:
                                searchList[0].newMeterOldReading.toString(),
                          )
                        : RowWidget(
                            leading: "Previous Reading : ",
                            trailing: searchList[0].oldReading.toString(),
                          ),
                    RowWidget(
                      leading: searchList[0].replaceStatus.toString() == "1"
                          ? "New Meter Current Reading : "
                          : "Meter Current Reading : ",
                      trailing: myReading.toStringAsFixed(3),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          child: Text(
                            "Accept",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.green.shade800),
                          onPressed: () {
                            subNormalMethod();
                            if (actualResult >= 0) {
                              if (actualResult > 5 && actualResult < 25) {
                                print("Greater then 25");
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CustomDialogBox(
                                          msg: "Reading is Ok",
                                          myReading: actualResult.toString(),
                                          onPressed: () => onClick());
                                    });
                              } else if (actualResult < 5) {
                                print("less then 5");
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CustomDialogBox(
                                          msg: " Less then 5",
                                          myReading: actualResult.toString(),
                                          onPressed: () => onClick());
                                    });
                              } else {
                                print("25--->" + " Greater then 25");
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CustomDialogBox(
                                          msg: " Greater then 25",
                                          myReading: actualResult.toString(),
                                          onPressed: () => onClick());
                                    });
                              }
                            } else {
                              print("Negative value is not Valid");
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomDialogBox(
                                        msg: "Negative value is not Valid",
                                        myReading: actualResult.toString(),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        });
                                  });
                            }
                          },
                        ),
                        TextButton(
                          child: Text("Edit",
                              style: TextStyle(color: Colors.white)),
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.green.shade800),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ));
        });
  }

  Future<void> _openImageSource(
    BuildContext mContext,
    PhotoController controller,
  ) async {
    return showDialog<void>(
      context: mContext,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose One'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                    title: const Text('Gallery'),
                    onTap: () {
                      Navigator.of(context).pop();
                      getImage(controller, ImageSource.gallery)
                          .then((value) => setState(() {}));
                    }),
                ListTile(
                  title: const Text('Camera'),
                  onTap: () {
                    Navigator.of(context).pop();
                    getImage(controller, ImageSource.camera)
                        .then((value) => setState(() {}));
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Dismiss'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> getImage(
      PhotoController photoController, ImageSource imageSource) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
          source: imageSource,
          maxHeight: 400,
          maxWidth: 300,
          imageQuality: 100);
      setState(() {
        if (pickedFile != null) {
          photoController.imagePath = File(pickedFile.path);
          //return _image;
        } else {
          print('No image selected.');
        }
        //return _image;
      });
    } catch (e) {
      CustomToast.showToast(e.toString());
    }
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        setState(() {
          isOffline = false;
          dialogIsVisible = false;
        });
        break;
      case ConnectivityResult.mobile:
        setState(() {
          isOffline = false;
          dialogIsVisible = false;
        });
        break;
      case ConnectivityResult.none:
        setState(() => isOffline = true);
        buildAlertDialog("Internet connection cannot be established!");
        break;
      default:
        setState(() => isOffline = true);
        break;
    }
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
    } on PlatformException catch (e) {
      print(e.toString());
    }

    if (!mounted) {
      return;
    }
  }

  void buildAlertDialog(String message) {
    SchedulerBinding.instance.addPostFrameCallback((_) => setState(() {
          if (isOffline && !dialogIsVisible) {
            dialogIsVisible = true;
            showDialog(
                barrierDismissible: false,
                context: ctx!,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      message,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14.0),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.portable_wifi_off,
                          color: Colors.redAccent,
                          size: 36.0,
                        ),
                        canProceed
                            ? Text(
                                "Check your internet connection before proceeding.",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12.0),
                              )
                            : Text(
                                "Please! proceed by connecting to a internet connection",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12.0, color: Colors.red),
                              ),
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red)),
                        onPressed: () {
                          SystemChannels.platform
                              .invokeMethod('SystemNavigator.pop');
                        },
                        child: Text("CLOSE THE APP",
                            style: TextStyle(color: Colors.white)),
                      ),
                      TextButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.black)),
                        onPressed: () {
                          if (isOffline) {
                            setState(() {
                              canProceed = false;
                            });
                          } else {
                            Navigator.pop(ctx!);
                          }
                        },
                        child: Text("PROCEED",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  );
                });
          }
        }));
  }

  locationConnect() async {
    Position position = await _getGeoLocationPosition();
    setState(() {
      locationLat = '${position.latitude}';
      locationLong = ' ${position.longitude}';
      print("locationLat-->" + locationLat);
      print("locationLong-->" + locationLong);
      //   GetAddressFromLatLong(position);
    });
  }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<bool> _onBackPressed() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm'),
          content: Text('Do you want to exit the App'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false); //Will not exit the App
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(true); //Will exit the App
              },
            )
          ],
        );
      },
    );
    return Future.value(true);
  }

  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        logOutPop();
        break;
      case 'History':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => BillHistoryPage()));
        break;
    }
  }

  logOutPop() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              content: Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  Positioned(
                    right: -40.0,
                    top: -40.0,
                    child: InkResponse(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: CircleAvatar(
                        child: Icon(Icons.close),
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ),
                  Form(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                "Meter Reader",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              "Do you want logout ?",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.green.shade800),
                            child: Text("OK",
                                style: TextStyle(color: Colors.white)),
                            onPressed: () async {
                              Navigator.of(context, rootNavigator: false).pop();
                              SharedPreferences preferences =
                                  await SharedPreferences.getInstance();
                              await preferences.clear();
                              EasyLoading.showInfo("Logout Successfully");
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ));
  }
}
