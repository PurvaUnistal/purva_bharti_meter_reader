import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_validated_field/src/requirement_widget.dart';

class CustomPasswordValidatedFields extends StatefulWidget {
  final InputDecoration inputDecoration;
  final TextEditingController? textEditingController;
  final TextInputAction textInputAction;
  final void Function()? onEditComplete;
  final String Function(String?)? onFieldSubmitted;
  final FocusNode? focusNode;
  final Color? cursorColor;
  final TextStyle? textStyle;
  final IconData activeIcon;
  final IconData inActiveIcon;
  final Color activeRequirementColor;
  final Color inActiveRequirementColor;
  final bool obscureText;
  final Iterable<String>? autofillHints;
  final TextInputType keyboardType;

  CustomPasswordValidatedFields({Key? key,
    this.inputDecoration = const InputDecoration(
        hintText: "Enter password",
        prefixIcon: Icon(Icons.lock),
        border: OutlineInputBorder()),
    this.textEditingController,
    this.textInputAction = TextInputAction.done,
    this.onEditComplete,
    this.onFieldSubmitted,
    this.focusNode,
    this.cursorColor,
    this.textStyle,
    this.inActiveIcon = Icons.check_circle_outline_rounded,
    this.activeIcon = Icons.check_circle_rounded,
    this.inActiveRequirementColor = Colors.grey,
    this.obscureText = true,
    this.autofillHints,
    this.keyboardType = TextInputType.text,
    this.activeRequirementColor = Colors.blue,
  }) : super(key: key);

  @override
  _CustomPasswordValidatedFieldsState createState() =>
      _CustomPasswordValidatedFieldsState();
}

class _CustomPasswordValidatedFieldsState extends State<CustomPasswordValidatedFields> {
  String _pass = "";
  final formGlobalKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formGlobalKey,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            PassCheckRequirements(
              passCheck: _pass.contains(RegExp(r'[A-Z]')),
              requirementText: "1 Uppercase [A-Z]",
              activeColor: widget.activeRequirementColor,
              inActiveColor: widget.inActiveRequirementColor,
              inActiveIcon: widget.inActiveIcon,
              activeIcon: widget.activeIcon,
            ),
            PassCheckRequirements(
              passCheck: _pass.contains(RegExp(r'[a-z]')),
              requirementText: "1 lowercase [a-z]",
              activeColor: widget.activeRequirementColor,
              inActiveColor: widget.inActiveRequirementColor,
              inActiveIcon: widget.inActiveIcon,
              activeIcon: widget.activeIcon,
            ),
            PassCheckRequirements(
              passCheck: _pass.contains(RegExp(r'[0-9]')),
              requirementText: "1 numeric value [0-9]",
              activeColor: widget.activeRequirementColor,
              inActiveColor: widget.inActiveRequirementColor,
              inActiveIcon: widget.inActiveIcon,
              activeIcon: widget.activeIcon,
            ),
            PassCheckRequirements(
              passCheck: _pass.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')),
              requirementText: "1 special character [#, \$, % etc..]",
              activeColor: widget.activeRequirementColor,
              inActiveColor: widget.inActiveRequirementColor,
              inActiveIcon: widget.inActiveIcon,
              activeIcon: widget.activeIcon,
            ),
            PassCheckRequirements(
              passCheck: _pass.length >= 6,
              requirementText: "minimum length should be 6 char long",
              activeColor: widget.activeRequirementColor,
              inActiveColor: widget.inActiveRequirementColor,
              inActiveIcon: widget.inActiveIcon,
              activeIcon: widget.activeIcon,
            ),
            SizedBox(height: 10.0),
            TextFormField(
              maxLength: 20,
              inputFormatters: [
                FilteringTextInputFormatter.deny(
                    RegExp(r'\s')),
              ],
              autofillHints: [AutofillHints.password],
              textInputAction: widget.textInputAction,
              controller: widget.textEditingController,
              keyboardType: TextInputType.text,
              obscureText: widget.obscureText,
              decoration: widget.inputDecoration,
              onEditingComplete: widget.onEditComplete,
              onFieldSubmitted: widget.onFieldSubmitted,
              focusNode: widget.focusNode,
              cursorColor: widget.cursorColor,
              style: widget.textStyle,
              textCapitalization: TextCapitalization.words,
              onChanged: (value) {
                setState(() {
                  _pass = value;
                  formGlobalKey.currentState!.validate();
                  value = widget.textEditingController!.text.trim().toString();
                  print(_pass);
                });
              },
              validator:passwordValidation,
            ),
          ],
        ),
      ),
    );
  }

  String? passwordValidation(String? value) {
    bool passValid = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$').hasMatch(value!);
    if (value.trim().isEmpty) {
      return "Password cannot be emtpy!";
    } if(value.length < 6){
      return "Password must be atleast 6 characters long";
    }
    if(value.length > 20){
      return "Password must be less than 20 characters";
    }else if (!passValid) {
      return "Requirement(s) missing!";
    }
    return null;
  }
}
