import 'package:flutter/material.dart';
import 'package:meter_reader/Utils/common_widgets/app_color.dart';
import 'package:meter_reader/Utils/common_widgets/row_widget.dart';
import 'package:meter_reader/Utils/common_widgets/styles_widget.dart';

class CustomDialogBox extends StatelessWidget {
  final String? myReading, msg;
  final Function()? onPressed;
  const CustomDialogBox({Key? key, this.myReading, this.msg, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.center,
      insetPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
          borderRadius:
          BorderRadius.all(Radius.circular(5.0))),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          RowWidget(leading: "Message :", trailing: msg??""),
          RowWidget(leading: "Consumption Reading :", trailing: myReading??""),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(color: AppColor.primer)
                    )),
                  ),
                  child:  Text("Submit",style: Styles.labels,),
                  onPressed: onPressed!,
                ),
              ),
              Flexible(
                child: TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      side: BorderSide(color: AppColor.primer)
                    )),
                  ),
                  child: Text("Cancel",style: Styles.labels,),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
