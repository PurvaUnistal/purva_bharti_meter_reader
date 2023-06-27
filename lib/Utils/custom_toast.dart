import '../../../../ExportFile/export_file.dart';

class CustomToast {
  static showToast(String message) {
    Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.green, textColor: Colors.white, fontSize: 16.0);
  }
}

class ShowCustomToast {
  static showToast(String message) {
    Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 5, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
  }

  static scaffoldMsg(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

class ValidateCustomToast {
  static _showToastMsg(String msgType, String msg) {
    if (msgType == "success") {
      return Fluttertoast.showToast(
        msg: msg,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
      );
    } else if (msgType == "error") {
      return Fluttertoast.showToast(
        msg: msg,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
      );
    } else {
      return Fluttertoast.showToast(
        msg: msg,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
      );
    }
  }
}

Future<void> _showMyDialog(String myReading, previousReading, msg, Function() onPressed) async {
  var context;
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(myReading),
        actions: <Widget>[
          TextButton(child: Text('Ok'), onPressed: onPressed),
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
