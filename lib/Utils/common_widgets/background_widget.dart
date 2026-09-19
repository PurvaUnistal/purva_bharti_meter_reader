import 'package:flutter/material.dart';
import 'res/app_color.dart';
import 'res/app_string.dart';

class BackgroundWidget extends StatelessWidget {
  final Widget child;

  const BackgroundWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Positioned.fill(child: child),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                  decoration: BoxDecoration(color: AppColor.primer),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          AppString.companyName,
                          textAlign: TextAlign.start,
                          style:  TextStyle(
                              color: AppColor.white, fontWeight: FontWeight.w800, fontSize: 8),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          AppString.version,
                        style: TextStyle(
                            color: AppColor.white, fontWeight: FontWeight.w800, fontSize: 8),
                        ),
                      ),
                    ],
                  ))),
        ],
      );
  }
}
