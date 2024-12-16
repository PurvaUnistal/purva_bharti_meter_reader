import 'package:flutter/material.dart';
import 'package:meter_reader_new/Utils/common_widgets/styles_widget.dart';

class ButtonWidget extends StatelessWidget {
  final Function() onPressed;
  final String text;

  const ButtonWidget({Key? key, required this.onPressed, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green.shade800,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
        child: Text(
          text,
          style: Styles.login,
        ),
      ),
    );
  }
}
