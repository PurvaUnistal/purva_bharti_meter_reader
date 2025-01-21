import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meter_reader_new/Utils/common_widgets/res/app_color.dart';

class OtpTextFieldWidget extends StatelessWidget {

  final bool first;
  final bool last;
  final bool? isEnable;
  final Color? boardColor;
  final GestureTapCallback? onTap;
  final TextEditingController? controller;

  const OtpTextFieldWidget({required this.first, required this.last,
    this.controller,
    this.onTap,
    this.isEnable, this.boardColor}) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width * 0.10,
      width: MediaQuery.of(context).size.width * 0.08,
      child: TextField(
        onTap: onTap,
        controller: controller,
        enabled: isEnable,
        onChanged: (value) {
/*          if (value.length == 1 && last == false) {
            FocusScope.of(context).nextFocus();
          }
          if (value.length == 0 && first == false) {
            FocusScope.of(context).previousFocus();
          }*/
          if(value.isEmpty){
            FocusScope.of(context).nextFocus();
          } else {
            FocusScope.of(context).previousFocus();
          }
        },
        readOnly: isEnable == true ? false : true,
        showCursor: isEnable,
        textAlign: TextAlign.center,
        style: TextStyle(),
        textInputAction:TextInputAction.done,
        keyboardType:Platform.isIOS ?
        TextInputType.numberWithOptions(signed: true, decimal: true)
            : TextInputType.number,
        maxLength: 1,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.deny(',', replacementString: '.'),
          FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})')),
        ],
        decoration: InputDecoration(
          filled: true,
          fillColor: isEnable == false ? Colors.grey[300] : null,
          contentPadding: EdgeInsets.all(0.0),
          counter: Offstage(),
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: boardColor ?? Colors.grey),
              borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: boardColor ?? Colors.grey),
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color:  AppColor.primer),
              borderRadius: BorderRadius.circular(10)),
          hintText: "*",
          hintStyle: TextStyle(color: Colors.grey[400])
        ),
      ),
    );
  }
}