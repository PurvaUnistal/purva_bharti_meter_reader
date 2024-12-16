import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {}

class LoginInitState extends LoginState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoginFetchDataState extends LoginInitState {
  final bool isPageLoader;
  final bool isPassword;

  LoginFetchDataState({
    required this.isPageLoader,
    required this.isPassword,
  });

  @override
  List<Object> get props => [
        isPageLoader,
        isPassword,
      ];
}
