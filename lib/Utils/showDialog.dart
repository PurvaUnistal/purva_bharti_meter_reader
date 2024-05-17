import 'package:flutter/material.dart';

import '../../../../ExportFile/export_file.dart';

class ShowDialog extends StatelessWidget {
  final String? text;
  const ShowDialog( {Key? key,this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,height: 50,
      child: AlertDialog(
        content: Text(text.toString()),
        actions: <Widget>[
          TextButton(
            child: Text('Ok'),
            onPressed: () {
              print('Confirmed');
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

