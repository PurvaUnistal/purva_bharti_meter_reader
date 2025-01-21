import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meter_reader_new/Utils/common_widgets/res/app_color.dart';

class CustomTextEmailField extends StatelessWidget {
  CustomTextEmailField({
    this.controller,
    this.hintText,
    this.labelText,
    this.helpText,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassword,
    this.enabled,
    this.readOnly,
    this.borderColor,
    this.onChanged,
    this.validate,
    this.errortxt,
    this.onTap,
    this.filledColor,
    this.prefixWidget,
    this.initialValue,
    this.horizontalPadding = 15,
    this.verticalPadding = 0,
    this.maxLines ,
    this.keyboardType ,
    this.textInputAction,
    this.autofillHints,

  });

  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final bool? validate;
  final String? errortxt;
  final Function(dynamic value)? onChanged;
  final String? helpText;
  final IconData? prefixIcon;
  final IconButton? suffixIcon;
  final bool? isPassword;
  final bool? enabled;
  final bool? readOnly;
  final Color? borderColor;
  final GestureTapCallback? onTap;
  final Color? filledColor;
  final Widget? prefixWidget;
  final String? initialValue;
  final double? horizontalPadding;
  final double? verticalPadding;
  final int? maxLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  // final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding ?? 15, vertical: verticalPadding ?? 0),
      child: TextFormField(
        readOnly: false,
        autofillHints:autofillHints,
        inputFormatters: [FilteringTextInputFormatter.deny(' ')],
        initialValue: initialValue,
        maxLines: maxLines,
        keyboardType: keyboardType,
        textInputAction :textInputAction,
        controller: controller,
        obscureText: null == isPassword ? false : true,
        onChanged: onChanged,
        autofocus: false,
        toolbarOptions: ToolbarOptions(
          cut: true,
          copy: false,
          selectAll: true,
          paste: false,
        ),
        enableInteractiveSelection: validate,
        onTap: onTap,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
            alignLabelWithHint: true,
            labelText: labelText ?? null,
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            errorText: validate! ? null : errortxt,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: AppColor.grey,width: 1.0,),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColor.grey, width: 1.0,),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: borderColor == null ? Colors.teal : borderColor!,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            fillColor: filledColor,
            filled: true,
            hintText: null == hintText ? '' : hintText,
            helperText: null == helpText ? '' : helpText,
            prefixIcon: null == prefixIcon ? null : Icon(prefixIcon),
            suffixIcon: suffixIcon ,
            enabled: enabled!,
            prefix: prefixWidget),
      ),
    );
  }
}