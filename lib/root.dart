import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meter_reader_new/Utils/common_widgets/Routes/routes.dart';
import 'package:meter_reader_new/Utils/common_widgets/Routes/routes_name.dart';
import 'package:meter_reader_new/Utils/common_widgets/res/app_color.dart';
import 'package:meter_reader_new/Utils/common_widgets/res/app_config.dart';
import 'package:meter_reader_new/Utils/common_widgets/res/enums.dart';
import 'package:meter_reader_new/Utils/common_widgets/res/singleton.dart';
import 'package:meter_reader_new/features/Login/domain/bloc/login_bloc.dart';
import 'package:meter_reader_new/features/billHistory/domain/bloc/bill_history_bloc.dart';
import 'package:meter_reader_new/features/billPrint/domain/bloc/bill_print_bloc.dart';
import 'package:meter_reader_new/features/billingRequest/domain/bloc/billing_request_bloc.dart';

class Root extends StatefulWidget {
  final Client client;
  const Root({required this.client});
  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {

  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Singleton.instanceInit()?.context = context;
    AppConfig.instanceInit()!.setClient(client: widget.client);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: AppColor.primer));
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (BuildContext context) => LoginBloc()),
          BlocProvider(create: (BuildContext context) => BillingRequestBloc()),
          BlocProvider(create: (BuildContext context) => BillPrintBloc()),
          BlocProvider(create: (BuildContext context) => BillHistoryBloc()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: AppColor.primer,
            hintColor: AppColor.primer,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColor.primer,
            ),
          ),
          initialRoute: RoutesName.splash,
          onGenerateRoute: Routes.generateRoute,
        ));
  }
}
