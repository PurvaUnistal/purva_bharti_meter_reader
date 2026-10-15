import 'package:flutter/material.dart';
import 'package:meter_reader_new/Utils/common_widgets/res/styles_widget.dart';

import 'res/environment_config.dart';

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
        backgroundColor:EnvironmentConfig.of(context)!.primaryTheme,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            width: 2,
            color:  EnvironmentConfig.of(context)!.secondaryTheme,
          ),

        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
        child: Text(
          text,
          style: Styles.login,
        ),
      ),
    );
  }
}
