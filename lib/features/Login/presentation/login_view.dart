import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meter_reader_new/Utils/common_widgets/Loader/DottedLoader.dart';
import 'package:meter_reader_new/Utils/common_widgets/Routes/routes_name.dart';
import 'package:meter_reader_new/Utils/common_widgets/res/app_bar_widget.dart';
import 'package:meter_reader_new/Utils/common_widgets/res/app_color.dart';
import 'package:meter_reader_new/Utils/common_widgets/res/app_config.dart';
import 'package:meter_reader_new/Utils/common_widgets/res/app_string.dart';
import 'package:meter_reader_new/Utils/common_widgets/background_widget.dart';
import 'package:meter_reader_new/Utils/common_widgets/button_widget.dart';
import 'package:meter_reader_new/Utils/common_widgets/res/enums.dart';
import 'package:meter_reader_new/Utils/common_widgets/text_form_widget.dart';
import 'package:meter_reader_new/features/Login/domain/bloc/login_bloc.dart';
import 'package:meter_reader_new/features/Login/domain/bloc/login_event.dart';
import 'package:meter_reader_new/features/Login/domain/bloc/login_state.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  @override
  void initState() {
    BlocProvider.of<LoginBloc>(context).add(LoginPageLoadingEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: RoutesName.login,
        boolLeading: false,

      ),
      body: SafeArea(
        child: BackgroundWidget(
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              if (state is LoginFetchDataState) {
                return Center(
                  child: _buildLayout(dataState: state),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLayout({required LoginFetchDataState dataState}) {
    var h = MediaQuery
        .of(context)
        .size
        .height;
    return SingleChildScrollView(
      child: Stack(
        clipBehavior: Clip.none,
        alignment: AlignmentDirectional.topCenter,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Align(
              alignment: Alignment.center,
              child: Container(
                height: h * 0.6,
                child: Card(
                  elevation: 8,
                  shadowColor: AppColor.primer1,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _emailWidget(dataState: dataState),
                        _sizedBox(),
                        _passwordWidget(dataState: dataState),
                        _sizedBox(),
                        _sizedBox(),
                        _loginBtnWidget(dataState: dataState),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: -80,
            left: .0,
            right: .0,
            child: _logoWidget(),
          ),
        ],
      ),
    );
  }

  Widget _logoWidget() {
    var h = MediaQuery
        .of(context)
        .size
        .height;
    var w = MediaQuery
        .of(context)
        .size
        .width;
    return Padding(
      padding: const EdgeInsets.all(23.0),
      child: Image.asset(
        AppConfig.instanceInit()!.client == Client.purvaBharti
            ? AppIcon.pbgplLogo
            : AppConfig.instanceInit()!.client == Client.mahaNagar
            ? AppIcon.mglLogo
            : AppConfig.instanceInit()!.client == Client.hngpl
            ? AppIcon.hngplLogo
            : AppIcon.pbgplLogo,
        width: w * 0.4,
        height: h * 0.16,
      ),
    );
  }

  Widget _smartGasNetLogo() {
    var h = MediaQuery
        .of(context)
        .size
        .height;
    var w = MediaQuery
        .of(context)
        .size
        .width;
    return Padding(
      padding: const EdgeInsets.all(23.0),
      child: Image.asset(
        AppIcon.smartgasnet,
        width: w * 0.2,
        height: h * 0.2,
      ),
    );
  }

  Widget _emailWidget({required LoginFetchDataState dataState}) {
    return TextFieldWidget(
      label: AppString.emailLabel,
      hintText: AppString.emailLabel,
      autofillHints: const [AutofillHints.email, AutofillHints.password],
      keyboardType: TextInputType.emailAddress,
      prefixIcon: Icon(Icons.email, color: AppColor.primer,),
      onChanged: (val) {
        BlocProvider.of<LoginBloc>(context).add(
            LoginSetEmailIdEvent(emailId: val.toString().replaceAll(" ", "")));
      },
    );
  }

  Widget _passwordWidget({required LoginFetchDataState dataState}) {
    return TextFieldWidget(
      label: AppString.passwordLabel,
      hintText: AppString.passwordLabel,
      autofillHints: const [ AutofillHints.password, AutofillHints.email],
      keyboardType: TextInputType.visiblePassword,
      prefixIcon: Icon(Icons.password, color: AppColor.primer,
      ),
      suffixIcon: IconButton(
        icon: Icon(
          dataState.isPassword ? Icons.visibility_off : Icons.visibility,
          color: Colors.green.shade800,
        ),
        onPressed: () {
          BlocProvider.of<LoginBloc>(context).add(LoginHideShowPasswordEvent(
              isHideShow: dataState.isPassword == true ? false : true));
        },
      ),
      obscureText: dataState.isPassword,
      onChanged: (val) {
        BlocProvider.of<LoginBloc>(context).add(LoginSetPasswordEvent(
            password: val.toString().replaceAll(" ", "")));
      },
    );
  }

  Widget _loginBtnWidget({required LoginFetchDataState dataState}) {
    return dataState.isPageLoader == false
        ? ButtonWidget(
        text: AppString.login,
        onPressed: () {
          FocusScope.of(context).unfocus();
          TextInput.finishAutofillContext();
          BlocProvider.of<LoginBloc>(context).add(
              LoginSubmitDataEvent(context: context, isLoginLoading: true));
        })
        : DottedLoaderWidget();
  }

  Widget _sizedBox() {
    var h = MediaQuery
        .of(context)
        .size
        .height;
    return SizedBox(
      height: h * 0.03,
    );
  }
}
