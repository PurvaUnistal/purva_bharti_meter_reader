part of 'bill_print_bloc.dart';

abstract class BillPrintState extends Equatable {
  const BillPrintState();
}

class BillPrintInitial extends BillPrintState {
  @override
  List<Object> get props => [];
}

class BillPrintPageLoadState extends BillPrintInitial {
  @override
  List<Object> get props => [];
}

class FetchBillPrinterDataState extends BillPrintInitial {

  final bool connected;
  final List availableBluetoothDevices;
  final String connectedPrinterName;
  FetchBillPrinterDataState({required this.connected,
     required this.availableBluetoothDevices, required this.connectedPrinterName});

  @override
  List<Object> get props => [connected, availableBluetoothDevices, connectedPrinterName];
}
