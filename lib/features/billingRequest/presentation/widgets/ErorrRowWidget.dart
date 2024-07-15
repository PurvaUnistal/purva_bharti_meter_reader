import 'package:flutter/material.dart';
import 'package:meter_reader/Utils/common_widgets/styles_widget.dart';

class ErrorRowWidget extends StatelessWidget {
  final String leading;
  final String trailing;
  const ErrorRowWidget({Key? key, required this.leading, required this.trailing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  child: Text(
                    leading,
                    style: Styles.texts,
                  )),
              Flexible(
                  child: Text(trailing,textAlign: TextAlign.center,
                      style:Styles.titleE))
            ],
          ),
        ),
        Divider()
      ],
    );
  }
}
