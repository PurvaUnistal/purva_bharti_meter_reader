import 'package:flutter/material.dart';
import 'package:meter_reader/billPrint/presentation/widget/bill_printer_widget.dart';

class BillPrinterPage extends StatefulWidget {
  const BillPrinterPage({Key? key}) : super(key: key);

  @override
  State<BillPrinterPage> createState() => _BillPrinterPageState();
}

class _BillPrinterPageState extends State<BillPrinterPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text("Bill Print"), backgroundColor: Colors.lightBlueAccent,),
      body: BillPrinterWidget(),
    );
  }
}
