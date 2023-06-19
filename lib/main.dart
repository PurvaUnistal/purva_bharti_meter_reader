import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'Screens/SplashPage.dart';
import 'package:provider/provider.dart';
import 'features/billHistory/domain/bloc/bill_history_bloc.dart';
import 'features/billPrint/domain/bloc/bill_print_bloc.dart';

void main() async {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => BillPrintBloc()),
        BlocProvider(create: (BuildContext context) => BillHistoryBloc()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          builder: EasyLoading.init(),
         home: SplashPage()
      ),
    );
  }
}

