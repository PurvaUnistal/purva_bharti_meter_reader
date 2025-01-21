import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meter_reader_new/Utils/common_widgets/res/app_bar_widget.dart';
import 'package:meter_reader_new/features/billPrint/domain/bloc/bill_print_bloc.dart';
import 'package:meter_reader_new/features/billPrint/presentation/widget/bill_printer_widget.dart';

class BillPrinterPage extends StatefulWidget {
  const BillPrinterPage({Key? key}) : super(key: key);

  @override
  State<BillPrinterPage> createState() => _BillPrinterPageState();
}

class _BillPrinterPageState extends State<BillPrinterPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      appBar: AppBarWidget(
        title: "Bill Print",
        boolLeading: true,
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
        ],
      ),
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
