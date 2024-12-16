import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class LoginEvent extends Equatable {}

class LoginPageLoadingEvent extends LoginEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoginSetEmailIdEvent extends LoginEvent {
  final String emailId;

  LoginSetEmailIdEvent({required this.emailId});

  @override
  // TODO: implement props
  List<Object> get props => [emailId];
}

class LoginSetPasswordEvent extends LoginEvent {
  final String password;

  LoginSetPasswordEvent({required this.password});

  @override
  // TODO: implement props
  List<Object> get props => [password];
}

class LoginHideShowPasswordEvent extends LoginEvent {
  final bool isHideShow;

  LoginHideShowPasswordEvent({required this.isHideShow});

  @override
  // TODO: implement props
  List<Object> get props => [isHideShow];
}

class LoginSubmitDataEvent extends LoginEvent {
  final BuildContext context;
  final bool isLoginLoading;

  LoginSubmitDataEvent({required this.context, required this.isLoginLoading});

  @override
  // TODO: implement props
  List<Object> get props => [context, isLoginLoading];
}
