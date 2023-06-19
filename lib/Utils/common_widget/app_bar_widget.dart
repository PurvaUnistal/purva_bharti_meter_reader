import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget {
  final List<Widget>? actions;
  final String? title;
  const AppBarWidget({Key? key, this.actions, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
          gradient: new LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
            colors: [
              Colors.red,
              Colors.blue.shade900
            ],
          )),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(title!, style: TextStyle(fontSize: 16, color: Colors.white)),
        automaticallyImplyLeading: false,
        actions:actions,
      ),
    );
  }
}
