import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_validated_field/password_validated_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/common_widget/RoundedButton.dart';
import '../Utils/common_widget/common_dialog_box.dart';
import '../Utils/common_widget/logout_method.dart';
import '../Utils/custom_toast.dart';
import '../models/change_password_model.dart';
import '../service/api_integration.dart';
import '../utils/global_constant.dart';


class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  ApiIntegration? apiIntegration;
  ChangePasswordResponse? changePasswordResponse;

  TextEditingController newPasswordController =  TextEditingController();
  TextEditingController conformPasswordController =  TextEditingController();

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    apiIntegration = ApiIntegration();
    getSharedPref();
    super.initState();
  }
  String userId = "";
  getSharedPref() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
   setState(() {
     userId  = prefs.getString(GlobalConstants.id)!;
   });
  }

  Future getChangeData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    RegExp upperRegex=  RegExp(r'[A-Z]');
    RegExp smallRegex=  RegExp(r'[a-z]');
    RegExp charRegex=  RegExp(r'[!@#$%^&*(),.?":{}|<>]');

    if(newPasswordController.value.text.isEmpty){
      CustomToast.showToast("Password is required please enter");
      return false;
    } else  if(!smallRegex.hasMatch(newPasswordController.text)){
      CustomToast.showToast("The Password must be at least one Small letter.");
      return false;
    }else  if(!upperRegex.hasMatch(newPasswordController.text)){
      CustomToast.showToast("The Password must be at least one Uppercase letter.");
      return false;
    }
    else if(newPasswordController.text.length < 8){
      CustomToast.showToast("Password must be at least 8 characters long");
      return false;
    }else  if(!charRegex.hasMatch(newPasswordController.text)){
      CustomToast.showToast("The Password must be at least one special character.");
      return false;
    } else if(conformPasswordController.text.isEmpty){
      CustomToast.showToast("Please enter conform password");
      return false;
    }else if(conformPasswordController.text.toString().trim() != newPasswordController.text.toString().trim()){
      CustomToast.showToast("Password does not match. Please re-type again.");
      return false;
    }
    changePasswordResponse = ChangePasswordResponse(
      userId: userId,
      password: newPasswordController.text.trim().toString(),
      confirmPassword: conformPasswordController.text.trim().toString(),
    );
    print("changePasswordResponse==>"+changePasswordResponse!.toJson().toString());
    var res = await apiIntegration!.changePasswordApi(changePasswordResponse!);
    if(res != null){
      print("Not Null");
      CommonDialogBox.showCommonDialog(
          context: context,
          title: "Password Updated",
          subTitle:"Your password has been reset Successfully! \n Now login with your new password",
          okBtnFunction: ()=>  LogOutMethod.logOut(context)
      );

    }else{
      print("Null Data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Change Password"),
        ),
        body: _buildLayout()
    );
  }


  Widget _buildLayout() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: SingleChildScrollView(
          reverse: true,
          physics: AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/images/logo.png", width: 100,height: 100,),
              horgentental(),
              newPasswordValidation(),
              horgentental(),
              _confirmPasswordWidget(),
              horgentental(),
              horgentental(),
             TextButton(
               style: TextButton.styleFrom(
                   foregroundColor: Colors.white,
                   backgroundColor: Colors.blue,
               ),
                 child: Text("Change Password"),
               onPressed: (){
                 TextInput.finishAutofillContext();
               getChangeData();

             },
             ),
              Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom * 1),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildErrorUi(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          message,
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }


  Widget _confirmPasswordWidget() {
    return AppTextFormField(
      autofillHints: [AutofillHints.newPassword],
      controller: conformPasswordController,
      prefixIcon: Icons.lock_outline_rounded,
      hintText: "Confirm Password",
      labelText:"Confirm Password",
    );
  }
  bool isVisibility = true;

  showHide() {
    setState(() {
      isVisibility = !isVisibility;
    });
  }
Widget newPasswordValidation(){
    return PasswordValidatedFields(
      textEditingController: newPasswordController,
      obscureText: isVisibility,
      inputDecoration: InputDecoration(
          prefixIcon:Icon( Icons.lock_outline_rounded),
          suffixIcon: IconButton(
            icon: Icon(isVisibility?Icons.visibility_off : Icons.visibility),
            onPressed:showHide ,
          ),
          hintText: "New Password",
          labelText:"New Password",
          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          )
      ),
      inActiveRequirementColor: Colors.red,
      activeRequirementColor: Colors.green,
      inActiveIcon: Icons.cancel,

      activeIcon: Icons.done_all,
    );
}

  Widget horgentental(){
    return SizedBox(
      height: 15,
    );
  }
}
