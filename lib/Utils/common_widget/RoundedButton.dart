import 'package:flutter/material.dart';

import '../../../../ExportFile/export_file.dart';


class RoundedButton extends StatelessWidget {
  RoundedButton({ this.colour, this.title, this.onPressed});
  final Color? colour;
  final String? title;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(25.0),
        child: MaterialButton(
          onPressed: onPressed,
          //Go to login screen.
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            title!,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class AppTextFormField extends StatelessWidget {
  final VoidCallback? passwordOnPressed;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final  TextInputAction? textInputAction;
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final int? maxLength;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;
  final Iterable<String>? autofillHints;
  const AppTextFormField({Key? key,
    this.passwordOnPressed,
    this.onChanged,
    this.keyboardType,
    this.textInputAction,
    this.controller,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.autofillHints,
    this.validator,
    this.maxLength,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        inputFormatters: [
          FilteringTextInputFormatter.deny(
              RegExp(r'\s')),
        ],
        maxLength:maxLength,
        validator:validator,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onChanged:onChanged,
        controller: controller,
        obscureText: true,
        textCapitalization: TextCapitalization.words,
        autofillHints: autofillHints,
        decoration:  InputDecoration(
            hintText: hintText,
            label: Text(labelText!),
            prefixIcon: Icon(prefixIcon),
            hintStyle: TextStyle(color: Colors.black),
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
      ),
    );
  }
}



