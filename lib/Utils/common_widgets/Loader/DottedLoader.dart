
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:meter_reader_new/Utils/common_widgets/app_color.dart';

class DottedLoaderWidget extends StatelessWidget {
  const DottedLoaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width * 0.12;
    return SpinKitThreeInOut(
      color: AppColor.primer,
      size: size,
    );
  }
}
