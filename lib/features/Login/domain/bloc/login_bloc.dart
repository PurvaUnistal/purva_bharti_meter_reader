import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meter_reader_new/Utils/common_widgets/InternetConnectivity/connectivity_helper.dart';
import 'package:meter_reader_new/Utils/common_widgets/Routes/routes_name.dart';
import 'package:meter_reader_new/Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import 'package:meter_reader_new/Utils/common_widgets/SharedPerfs/preference_utils.dart';
import 'package:meter_reader_new/features/Login/domain/bloc/login_event.dart';
import 'package:meter_reader_new/features/Login/domain/bloc/login_state.dart';
import 'package:meter_reader_new/features/Login/domain/model/login_model.dart';
import 'package:meter_reader_new/features/Login/helper/login_helper.dart';
import 'package:package_info_plus/package_info_plus.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitState()) {
    on<LoginPageLoadingEvent>(_pageLoad);
    on<LoginSetEmailIdEvent>(_setEmailId);
    on<LoginSetPasswordEvent>(_setPassword);
    on<LoginHideShowPasswordEvent>(_setHideShowPassword);
    on<LoginSubmitDataEvent>(_setSubmitLoginData);
  }

  String emailId = "";
  String password = "";
  String deviceId = "";


  bool _isPageLoader = false;

  bool get isPageLoader => _isPageLoader;

  bool _isPassword = false;

  bool get isPassword => _isPassword;

  LoginModel _loginModel = LoginModel();

  LoginModel get loginModel => _loginModel;

  _pageLoad(LoginPageLoadingEvent event, emit) async {
    emailId = "";
    password = "";
    _isPassword = true;
    _isPageLoader = false;

    _eventCompleted(emit);
  }

  _setEmailId(LoginSetEmailIdEvent event, emit) {
    emailId = event.emailId.toString().replaceAll(" ", "");
  }

  _setPassword(LoginSetPasswordEvent event, emit) {
    password = event.password.toString().replaceAll(" ", "");
  }

  _setHideShowPassword(LoginHideShowPasswordEvent event, emit) {
    _isPassword = event.isHideShow;
    _eventCompleted(emit);
  }

  _setSubmitLoginData(LoginSubmitDataEvent event, emit) async {
    if (await ConnectivityHelper.allConnectivityCheck(context: event.context) ==
        false) {
      return;
    }
    var validationCheck = await LoginHelper.textFieldValidation(
        email: emailId, password: password, context: event.context);
    if (validationCheck == true) {
      try {
        _isPageLoader = true;
        _eventCompleted(emit);
        var res = await LoginHelper.loginData(
            email: emailId, password: password, context: event.context);
        if (res != null) {
          _isPageLoader = false;
          _eventCompleted(emit);
          if (res.user != null) {
            _loginModel = res;
            if (res.status == 200 && res.user?.role == "billing") {
              PackageInfo packageInfo = await PackageInfo.fromPlatform();
              String buildNumber = packageInfo.buildNumber;
              await SharedPref.setString(key: PrefsValue.buildNumber,value: buildNumber);
              await SharedPref.setString(
                  key: PrefsValue.passwordVal, value: password);
              await SharedPref.setString(
                  key: PrefsValue.emailId, value: emailId);
              await SharedPref.setString(
                  key: PrefsValue.userId, value: res.user!.id!);
              await SharedPref.setString(
                  key: PrefsValue.token, value: res.token!);
              await SharedPref.setString(
                  key: PrefsValue.schema, value: res.user!.schema!);
              await SharedPref.setString(
                  key: PrefsValue.userName, value: res.user!.name!);
              await SharedPref.setString(
                  key: PrefsValue.userRole, value: res.user!.role!);
              Navigator.pushReplacementNamed(
                event.context,
              //  RoutesName.billingRequest,
                RoutesName.homePage,
              );
            }
          }
        } else {
          _isPageLoader = false;
          _eventCompleted(emit);
        }
      } catch (e) {
        _isPageLoader = false;
        _eventCompleted(emit);
        log("catchLoginBloc-->${e.toString()}");
      }
    }
    _eventCompleted(emit);
  }

  _eventCompleted(Emitter<LoginState> emit) {
    emit(LoginFetchDataState(
      isPageLoader: isPageLoader,
      isPassword: isPassword,
    ));
  }
}
