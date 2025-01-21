import 'package:flutter/material.dart';
import 'package:meter_reader_new/Utils/common_widgets/SharedPerfs/preference_utils.dart';
import 'package:meter_reader_new/Utils/common_widgets/res/app_string.dart';
import 'package:meter_reader_new/Utils/common_widgets/button_widget.dart';
import 'package:meter_reader_new/Utils/common_widgets/res/styles_widget.dart';
import 'package:meter_reader_new/features/Login/presentation/login_view.dart';

class LogoutWidget extends StatelessWidget {
  const LogoutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 4.9,
      margin: EdgeInsets.all(MediaQuery.of(context).size.height * 0.04),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              AppString.logout + "?",
              style: Styles.stars,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Text(
              AppString.logoutMsg,
              textAlign: TextAlign.center,
              style: Styles.title,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 2,
                  child: ButtonWidget(
                      text: AppString.logout,
                      onPressed: () async {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginView()),
                            (route) => false);
                        await SharedPref.clearAll();
                      }),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.03,
                ),
                Flexible(
                  flex: 2,
                  child: ButtonWidget(
                      text: AppString.no,
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
