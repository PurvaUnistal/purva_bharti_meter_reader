import 'package:flutter/material.dart';

import '../../../../ExportFile/export_file.dart';

class ButtonWidget extends StatelessWidget {
  final String? text;
  final VoidCallback? onPressed;
  const ButtonWidget({Key? key, this.text, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
   //   width: double.infinity,
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(26)),
          gradient: new LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
            colors: [
              Colors.red,
              Colors.blue.shade900
            ],
          )),
      child: TextButton(
        child: Text(text!,style: const TextStyle(color: Colors.white)),
        onPressed: onPressed,
      ),
    );
  }
}
