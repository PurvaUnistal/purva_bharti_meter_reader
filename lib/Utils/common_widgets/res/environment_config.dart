import 'package:flutter/cupertino.dart';
import 'enums.dart';

class EnvironmentConfig extends InheritedWidget {
  final EnvironmentFlavors flavors;

  const EnvironmentConfig({required super.child, required this.flavors});

  static EnvironmentConfig? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType();
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    throw UnimplementedError();
  }

  String get generalUrlBaseFlavour {
    print("flavor-->${flavors}");
    switch (flavors) {
      case EnvironmentFlavors.prodPBGPL:
        return "https://pbgpluat.smartgasnet.com/api/";
      case EnvironmentFlavors.prodMGL:
       // return "https://mgl.smartgasnet.com/api/";
        return "https://mgl.smartgasnet.com/api/";
      case EnvironmentFlavors.prodHNGPL:
        return "https://hngpl.smartgasnet.com/api/";
    }
  }
}