import '../../../../ExportFile/export_file.dart';

class BillPrinterPage extends StatefulWidget {
  const BillPrinterPage({Key? key}) : super(key: key);

  @override
  State<BillPrinterPage> createState() => _BillPrinterPageState();
}

class _BillPrinterPageState extends State<BillPrinterPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text("Bill Print"),
        backgroundColor: Colors.green.shade800,
        actions: [
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Reload',}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],),
      body: BillPrinterWidget(),
    );
  }

  void handleClick(String value) {
    switch (value) {
      case 'Reload':
        BlocProvider.of<BillPrintBloc>(context).add(BillReloadPage(context: context));
        break;
    }
  }
}
