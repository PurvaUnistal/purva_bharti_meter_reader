import 'package:flutter/material.dart';
import 'package:meter_reader_new/Utils/common_widgets/res/styles_widget.dart';

class MessageBoxTwoButtonPopWidget extends StatelessWidget {
  final String message;
  final String? subMessage;
  final String okButtonText;
  final VoidCallback onPressed;

  const MessageBoxTwoButtonPopWidget(
      {required this.message,
      this.subMessage,
      required this.onPressed,
      required this.okButtonText});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _closeButton(context: context),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.05,
                        right: MediaQuery.of(context).size.width * 0.05),
                    child: Column(
                      children: [
                        Text(message,),
                        Text(subMessage ?? "",),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Container(
                    height: 1.0,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey[350],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Cancel",
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: onPressed,
                            child: Text(
                              okButtonText ?? "OK",
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _closeButton({required BuildContext context}) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.05,
              right: MediaQuery.of(context).size.width * 0.05,
              top: MediaQuery.of(context).size.width * 0.05,
            ),
            child: Text(
              "Alert !", textAlign: TextAlign.center,style: Styles.stars,
            ),
          ),
        ),
      ],
    );
  }
}
