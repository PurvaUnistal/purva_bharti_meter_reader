import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meter_reader/Utils/common_widgets/app_color.dart';

class MeterNumber extends StatelessWidget {
  final TextEditingController controller;
  final bool? autoFocus;
  final bool? enabled;
  final TextInputAction? textInputAction;
  final Color? color;
  final ValueChanged? onChanged;
  final FocusNode? focusNode;
   MeterNumber({Key? key,
        required this.controller,
        this.autoFocus,
        this.enabled,
        this.textInputAction,
        this.onChanged,
        this.color,
        this.focusNode,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 60,
      width: 30,
      child: TextField(
        autofocus: autoFocus ?? false,
        enabled: enabled,
        focusNode: focusNode,
        controller: controller,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        ],
        textInputAction: textInputAction,
        onChanged: onChanged,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            border: border(color:color ?? Colors.white),
            focusedBorder: border(color:color ?? Colors.white),
            disabledBorder: border(color:color ?? Colors.white),
            enabledBorder: border(color:color ?? Colors.white),
            counterText: '',
            hintStyle: TextStyle(color: Colors.black, fontSize: 8.0)),
      ),
    );
  }
  OutlineInputBorder border({required Color color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.0),
      borderSide: BorderSide(
          color: color, style: BorderStyle.solid, width: 0.80),
    );
  }
}
