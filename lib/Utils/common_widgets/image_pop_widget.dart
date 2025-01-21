import 'package:flutter/material.dart';
import 'package:meter_reader_new/Utils/common_widgets/button_widget.dart';

import 'res/app_color.dart';

class ImagePopWidget extends StatelessWidget {
  final void Function() onTapGallery, onTapCamera;

  const ImagePopWidget(
      {Key? key, required this.onTapGallery, required this.onTapCamera})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Choose One',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.green.shade800,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                onTap: onTapGallery,
                leading: Icon(Icons.photo_library, color: AppColor.primer1,),
                title: Text('Gallery'),
              ),
              ListTile(
                onTap: onTapCamera,
                leading: Icon(Icons.photo_camera, color: AppColor.primer1,),
                title: Text('Camera'),
              ),
              ButtonWidget(
                text: 'Dismiss',
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
