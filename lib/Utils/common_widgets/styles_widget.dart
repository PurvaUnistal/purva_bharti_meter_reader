
import 'package:flutter/material.dart';
import 'package:meter_reader/Utils/common_widgets/app_color.dart';

class Styles {
  static TextStyle rel = TextStyle(
      color: AppColor.primer, fontWeight: FontWeight.w800, fontSize: 8);
  static TextStyle login = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static TextStyle title = TextStyle(
      fontSize: 12, color: Colors.green.shade800, fontWeight: FontWeight.bold);
  static TextStyle title1 =
      TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold);

  static TextStyle subTitle =
      const TextStyle(fontSize: 8, fontWeight: FontWeight.w800);
  static TextStyle subStar = const TextStyle(
      fontSize: 8, fontWeight: FontWeight.w800, color: Colors.red);

  static TextStyle stars = const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 15, color: Colors.red);
  static TextStyle table = const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white);

  static TextStyle labels = TextStyle(
      fontWeight: FontWeight.w400, fontSize: 12, color: Colors.green.shade800);

  static TextStyle texts = const TextStyle(
      fontWeight: FontWeight.normal, fontSize: 12, color: Colors.black);
}
