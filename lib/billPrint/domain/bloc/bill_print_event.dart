part of 'bill_print_bloc.dart';

abstract class BillPrintEvent extends Equatable {
}

class BillPrintPageLoaderEvent extends BillPrintEvent {
   final BuildContext context;
   final dynamic billId;
   final String schema;
   BillPrintPageLoaderEvent({required this.context,
     required this.billId, required this.schema});
  @override
  List<Object?> get props => [context, billId, schema];
}



class BillPrintSetConnectEvent extends BillPrintEvent {
  final String mac;
  final String connectedPrinterName;
  BillPrintSetConnectEvent({required this.mac, required this.connectedPrinterName});
  @override
  List<Object?> get props => [mac,connectedPrinterName];
}

class BillSetPrintEvent extends BillPrintEvent {
   final BuildContext context;
   BillSetPrintEvent({required this.context, required});
   @override
   List<Object?> get props => [ context];
}

class BillReloadPage extends BillPrintEvent {
  final BuildContext context;
  BillReloadPage({required this.context, required });
@override
List<Object?> get props => [ context];
}
