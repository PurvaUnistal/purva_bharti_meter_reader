import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SpinLoaderWidget extends StatelessWidget {
  const SpinLoaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitCubeGrid(color: Colors.lightBlueAccent, size: 50),
    );
  }
}
