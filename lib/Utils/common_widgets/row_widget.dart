import 'package:flutter/material.dart';

class RowWidget extends StatelessWidget {
  final String leading;
  final String trailing;
  const RowWidget({Key? key, required this.leading, required this.trailing})
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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              )),
              Flexible(
                  child: Text(trailing,
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 12)))
            ],
          ),
        ),
        Divider()
      ],
    );
  }
}
