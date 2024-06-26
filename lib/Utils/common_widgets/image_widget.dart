import 'dart:io';
import 'package:flutter/material.dart';
import 'package:meter_reader/Utils/common_widgets/app_color.dart';
import 'package:meter_reader/Utils/common_widgets/styles_widget.dart';

class ImageWidget extends StatelessWidget {
  final File imgFile;
  final String? title;
  final String? star;
  final void Function() onPressed;
  const ImageWidget({super.key, required this.imgFile, this.star, this.title, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return  SizedBox(
        width: MediaQuery.of(context).size.width *0.23,
        height:MediaQuery.of(context).size.height* 0.12,
        child: InkWell(
          onTap: onPressed,
          child: imgFile.path.isNotEmpty ? Card(
            child: Stack(
              children: <Widget>[
                Image.file(
                  imgFile,
                  fit: BoxFit.fill,
                  width: MediaQuery.of(context).size.width *0.23,
                  height:MediaQuery.of(context).size.height* 0.12,
                ),
                Container(
                    width: MediaQuery.of(context).size.width/3,
                    height:MediaQuery.of(context).size.width/3,
                    //  color : Colors.white.withOpacity(0.6),
                    child: Center(child: Icon(Icons.refresh, color: AppColor.primer,))),
              ],

            ),
          )
              :Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(flex : 1,child: Text(star ??"",  style:Styles.subStar)),
                    Flexible(flex : 6,child: Text(title  ?? "", style:Styles.subTitle),
                    ),
                  ],
                ),
                Icon(Icons.photo_camera_back_outlined, color: AppColor.primer,size: 18,),
              ],
            ),
          ),
        )
    );
  }
}
