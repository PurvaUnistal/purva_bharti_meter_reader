import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  Color get primaryTheme {
    switch (flavors) {
      case EnvironmentFlavors.prodPBGPL:
        return Colors.green.shade800;
      case EnvironmentFlavors.prodMGL:
        return Colors.green.shade800;
      case EnvironmentFlavors.prodHNGPL:
        // TODO: Handle this case.
        throw UnimplementedError();
}  }

  Color get secondaryTheme {
    switch (flavors) {
      case EnvironmentFlavors.prodPBGPL:
        return Color(0xFFF5C400);

      case EnvironmentFlavors.prodMGL:
        return Color(0xFFF5C400);
      case EnvironmentFlavors.prodHNGPL:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}