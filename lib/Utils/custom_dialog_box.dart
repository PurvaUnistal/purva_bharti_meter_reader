import 'package:flutter/material.dart';
import 'package:meter_reader/Utils/common_widget/row_widget.dart';

class CustomDialogBox extends StatelessWidget {
  final String? myReading, msg;
  final Function()? onPressed;
  const CustomDialogBox({Key? key, this.myReading, this.msg, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.center,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          RowWidget(leading: "Message :", trailing: msg!),
          RowWidget(leading: "Consumption Reading :", trailing: myReading!),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                child: Text(
                  "Submit",
                  style: TextStyle(color: Colors.white),
                ),
                style: TextButton.styleFrom(
                    backgroundColor: Colors.green.shade800),
                onPressed: onPressed,
              ),
              TextButton(
                child: Text("Cancel", style: TextStyle(color: Colors.white)),
                style: TextButton.styleFrom(
                    backgroundColor: Colors.green.shade800),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
