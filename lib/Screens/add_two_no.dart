import 'package:flutter/material.dart';

class AddTwoNumbers extends StatefulWidget {
  @override
  _AddTwoNumbersState createState() => _AddTwoNumbersState();
}

class _AddTwoNumbersState extends State<AddTwoNumbers> {
  TextEditingController num1controller = new TextEditingController(text: "100");
  TextEditingController num2controller = new TextEditingController(text: "10");
  String result = "0";

  sub(){
    setState(() {
      int sum = int.parse(num1controller.text) -
          int.parse(num2controller.text);
      result = sum.toString();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sub();

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.number,
              controller: num1controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'First Number',
                hintText: 'Enter First Number',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: num2controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Second Number',
                hintText: 'Enter Second Number',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Wrap(
              children: [
                ElevatedButton(
                  child: Text("Addition"),
                  onPressed: () {
                    setState(() {
                      int sum = int.parse(num1controller.text) +
                          int.parse(num2controller.text);
                      result = sum.toString();
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                  width: 20,
                ),
                ElevatedButton(
                  child: Text("Subtraction"),
                  onPressed: () {
                    // setState(() {
                    //   int sum = int.parse(num1controller.text) -
                    //       int.parse(num2controller.text);
                    //   result = sum.toString();
                    // });
                  },
                ),
                SizedBox(
                  height: 20,
                  width: 20,
                ),
                ElevatedButton(
                  child: Text("Multiplication"),
                  onPressed: () {
                    setState(() {
                      int sum = int.parse(num1controller.text) *
                          int.parse(num2controller.text);
                      result = sum.toString();
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                  width: 20,
                ),
                ElevatedButton(
                  child: Text("Division"),
                  onPressed: () {
                    setState(() {
                      int sum = int.parse(num1controller.text) ~/
                          int.parse(num2controller.text);
                      result = sum.toString();
                    });
                  },
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text('Result : $result'),
          ],
        ),
      ),
    );
  }
}