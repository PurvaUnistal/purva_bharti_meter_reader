import 'package:flutter/cupertino.dart';
import 'package:meter_reader_new/Utils/common_widgets/res/enums.dart';
import 'package:meter_reader_new/Utils/common_widgets/res/environment_config.dart';
import 'package:meter_reader_new/root.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var configurationApp = EnvironmentConfig(
    child: Root(client: Client.mahaNagar),
    flavors: EnvironmentFlavors.prodMGL,
  );
  runApp(configurationApp);
}