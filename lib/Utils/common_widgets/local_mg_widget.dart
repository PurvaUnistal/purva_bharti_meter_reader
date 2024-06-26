import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class LocalImgWidget extends StatelessWidget {
  final File file;
  final Function() onTap;

  const LocalImgWidget({
    required this.file,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 3,
      height: MediaQuery.of(context).size.width / 3,
      child: InkWell(
        onTap: onTap,
        child: DottedBorder(
          color: Colors.green.shade800,
          strokeWidth: 1,
          child: file.path == "" || file.path.isEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Center(
                      child: Icon(Icons.photo_camera_back_outlined),
                    ),
                    Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.02),
                      child: Text("Photo"),
                    ),
                  ],
                )
              : Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.file(
                          file,
                          fit: BoxFit.fill,
                          width: MediaQuery.of(context).size.width / 3,
                          height: MediaQuery.of(context).size.width / 4.5,
                        )
                      ],
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.width / 3,
                        color: Colors.white.withOpacity(0.6),
                        child: Center(
                            child: Icon(Icons.refresh,
                                color: Colors.green.shade800))),
                  ],
                ),
        ),
      ),
    );
  }
}
