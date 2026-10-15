part of 'bill_print_bloc.dart';

abstract class BillPrintEvent extends Equatable {
  const BillPrintEvent();
}

class BillPrintPageLoaderEvent extends BillPrintEvent {
  final BuildContext context;
  final dynamic billId;
  final String schema;

  const BillPrintPageLoaderEvent({
    required this.context,
    required this.billId,
    required this.schema,
  });

  @override
  List<Object?> get props => [context, billId, schema];
}

class BillPrintSetConnectEvent extends BillPrintEvent {
  final String mac;
  final String connectedPrinterName;

  const BillPrintSetConnectEvent({
    required this.mac,
    required this.connectedPrinterName,
  });

  @override
  List<Object?> get props => [mac, connectedPrinterName];
}

class BillSetPrintEvent extends BillPrintEvent {
  final BuildContext context;

  const BillSetPrintEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class BillReloadPage extends BillPrintEvent {
  final BuildContext context;

  const BillReloadPage({required this.context});

  @override
  List<Object?> get props => [context];
}