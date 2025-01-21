import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meter_reader_new/Utils/common_widgets/res/styles_widget.dart';

import 'app_color.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool? boolLeading;
  final Widget? leading;
  final List<Widget>? actions;
  final Widget? tabBar;

  const AppBarWidget(
      {Key? key,
      this.title,
      this.leading,
      this.boolLeading,
      this.actions,
      this.tabBar})
      : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: boolLeading ?? false,
      systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: AppColor.primer),
      iconTheme: IconThemeData(color: AppColor.white),
      backgroundColor: AppColor.primer,
      elevation: 0,
      leading: leading,
      title: Text(
        title ?? "",
        style: Styles.login,
      ),
      actions: actions ?? [],
    );
  }
}
