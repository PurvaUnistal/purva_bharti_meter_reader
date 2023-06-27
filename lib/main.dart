import '../../../../ExportFile/export_file.dart';

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

