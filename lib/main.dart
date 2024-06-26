import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meter_reader/Utils/common_widgets/Routes/routes.dart';
import 'package:meter_reader/Utils/common_widgets/Routes/routes_name.dart';
import 'package:meter_reader/Utils/common_widgets/app_color.dart';
import 'package:meter_reader/features/Login/domain/bloc/login_bloc.dart';
import 'package:meter_reader/features/billHistory/domain/bloc/bill_history_bloc.dart';
import 'package:meter_reader/features/billPrint/domain/bloc/bill_print_bloc.dart';
import 'package:meter_reader/features/billingRequest/domain/bloc/billing_request_bloc.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
