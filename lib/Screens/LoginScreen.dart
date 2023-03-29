import 'dart:async';
import 'dart:convert';
import 'dart:convert' show json;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/Constants.dart';
import '../Utils/CustomEmailTextField.dart';
import '../Utils/global_constant.dart';
import '../Utils/reused_text_style.dart';
import '../models/GeneralResponse.dart';
import '../models/login_model.dart';
import '../service/Apis.dart';
import 'billingRequest.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool validate = false;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  BuildContext? ctx;
  bool canProceed = true;
  bool isOffline = false;
  bool dialogIsVisible = false;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  Rect? rect;

  bool _isObscure = true;
  var check = true;

  @override
  void initState() {
    initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return new Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      body: Center(
        child: SingleChildScrollView(
          child: Visibility(
            visible: check,
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 30),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 7.0,
                  shadowColor: Colors.teal,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 30,),
                                Container(
                                  child: new CircleAvatar(
                                    radius: 60,
                                    backgroundColor: Colors.lightBlueAccent,
                                    child: Container(
                                        width: 80,
                                        height: 80,
                                        child: Image(image: AssetImage('assets/images/logo.png',))),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 60),
                        Container(
                            alignment: Alignment.bottomCenter,
                            child: CustomTextEmailField(
                              enabled : true,
                              controller: emailController,
                              validate: true,
                              labelText: "User Name",
                              filledColor: Colors.white,
                            )),
                        SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Container(
                            color: Colors.white,
                            child: Theme(
                              data: new ThemeData(
                                  primaryColor: greyColor,
                                  hintColor: Colors.green,
                                  colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.orange)),
                              child: TextField(
                                controller: _passwordController,
                                obscureText: _isObscure,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9@-]")),
                                ],
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                    labelStyle: listItemSubTitleStyle.copyWith(fontSize: 16, color: Colors.black87),
                                    border: new OutlineInputBorder(
                                      borderSide: new BorderSide(color: Colors.white),
                                      borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
                                    ),
                                    labelText: 'Password',
                                    suffixIcon: IconButton(
                                        icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                                        onPressed: () {
                                          setState(() {
                                            _isObscure = !_isObscure;
                                          });
                                        })),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 5,),
                        GestureDetector(
                          onTap: () {
                            /* Navigator.push(context,MaterialPageRoute( builder: (context) => LoginScreen()), );*/
                          },
                          child: Center(
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      btnClick();
                                    },
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Container(
                                          height: 50,
                                          width:MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              color: Colors.lightBlueAccent,
                                              borderRadius: BorderRadius.all(Radius.circular(10))),
                                          child: Center(
                                            child: Text("Login Now",style: ReusedTextStyle.login),
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment:Alignment.bottomCenter,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                                    child: Container(
                                        width: 30, height: 30,
                                        child: Image.asset('assets/images/unistal.png')),
                                  ),
                                  Text("Powered By Unistal Systems Pvt.Ltd.")
                                ],
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                            child: Container(
                                width: 200,
                                height: 30,
                                child: Image.asset('assets/images/smartgasnet.png')),
                          ),
                        ),
                        SizedBox(height: 30,),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  btnClick() async {
    var username = emailController.text;
    var password = _passwordController.text;

    if (username.length == 0 && username == "") {
      _toastMsg('Enter User Name');
      return;
    }
    if (password.length == 0 && password == "") {
      _toastMsg('Enter Password');
      return;
    }

    var jwt = await attemptLogIn(username, password,);
    try {
      LoginModel lgd = new LoginModel.fromJson(json.decode(jwt));
      print("jwt--->" +jwt);
      if ((lgd.status.toString().contains("200") && lgd.user!.role!.contains("billing"))) {
        EasyLoading.dismiss();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool(GlobalConstants.isUserLogIn, true);
        prefs.setString(GlobalConstants.password, password);
        prefs.setString(GlobalConstants.id, lgd.user!.id.toString());
        prefs.setString(GlobalConstants.schema, lgd.user!.schema.toString());
        prefs.setString(GlobalConstants.token, lgd.token!);
        prefs.setString(GlobalConstants.username,lgd.user!.name.toString());
        prefs.setString(GlobalConstants.email, lgd.user!.email.toString());
        EasyLoading.showInfo(lgd.messages.toString());
        Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => MeterRequestScreen()),
              (Route<dynamic> route) => false,);
      } else if (lgd.status==400) {
        EasyLoading.dismiss();
        _toastMsg('Incorrect Username and Password');
      }
      else if (lgd.status==401) {
        EasyLoading.dismiss();
        _toastMsg('Incorrect Username and Password');
      } else{
        EasyLoading.dismiss();
        _toastMsg('Incorrect Username and Password');
      }
    } catch (e) {
      GeneralResponse lgd = new GeneralResponse.fromJson(json.decode(jwt));
      if (lgd.status==401) {
        EasyLoading.dismiss();
        _toastMsg('Incorrect Username and Password');
      }
    }

  }

  Future<String> attemptLogIn( String email, String password) async {
    final data = {"email":email, "password":password};
    print("DATA-->$data");
    final jsonString = json.encode(data);
    var res = await http.post((Uri.parse(Apis.auth)), body: jsonString);
    print("Apis auth Url" + Apis.auth);
    print("login----> ${Apis.baseUrl + Apis.auth}");
    setState(() {
      EasyLoading.dismiss();
    });
    return res.body;
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
    // Platform messages may fail, so we use a try/catch PlatformException.
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
        showDialog(barrierDismissible: false,context: ctx!,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(message,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.0),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.portable_wifi_off, color: Colors.redAccent, size: 36.0,),
                    canProceed
                        ? Text("Check your internet connection before proceeding.",textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.0),
                    )
                        : Text("Please! proceed by connecting to a internet connection",textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.red),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    style:  ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
                    onPressed: () {
                      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                    },
                    child: Text("CLOSE THE APP",style: TextStyle(color: Colors.white)),
                  ),
                  TextButton(
                    style:  ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black)),
                    onPressed: () {
                      if (isOffline) {
                        setState(() {
                          canProceed = false;
                        });
                      } else {
                        Navigator.pop(ctx!);
                        //your code
                      }
                    },
                    child: Text("PROCEED",style: TextStyle(color: Colors.white)),
                  ),
                ],
              );
            });
      }
    }));
  }



  _toastMsg(String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 14.0
    );
  }


}
