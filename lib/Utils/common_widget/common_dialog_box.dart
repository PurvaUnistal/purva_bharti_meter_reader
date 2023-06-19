import 'package:flutter/material.dart';

class CommonDialogBox{

  CommonDialogBox.internal();
  static CommonDialogBox _instance = CommonDialogBox.internal();
  factory CommonDialogBox()=> _instance;

  static showCommonDialog({
    required BuildContext context,
    required String title,
    required String subTitle,
    required VoidCallback okBtnFunction
  }){
    showDialog(context: context,builder: (_){
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(subTitle),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Login'),
            onPressed: okBtnFunction,
          ),
        ],
      );
    }
    );
  }




}