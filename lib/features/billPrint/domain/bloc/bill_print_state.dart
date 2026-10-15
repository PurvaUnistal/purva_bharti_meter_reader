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
  final List<BluetoothInfo> availableBluetoothDevices;
  final String connectedPrinterName;
  final bool isLoader;

  FetchBillPrinterDataState({
    required this.connected,
    required this.availableBluetoothDevices,
    required this.connectedPrinterName,
    required this.isLoader,
  });

  @override
  List<Object> get props =>
      [connected, availableBluetoothDevices, connectedPrinterName, isLoader];
}

/// "Nearby devices" (Bluetooth) permission is not granted.
/// [permanentlyDenied] = true means Android will not show the popup again,
/// so the user has to enable it from app settings.
class BillPrintPermissionDeniedState extends BillPrintState {
  final bool permanentlyDenied;

  const BillPrintPermissionDeniedState({required this.permanentlyDenied});

  @override
  List<Object> get props => [permanentlyDenied];
}

/// Same data as [FetchBillPrinterDataState] (so the list keeps showing),
/// plus a message the UI shows once as a SnackBar.
/// [attempt] changes every time so the same message can be shown again.
class BillPrintConnectFailedState extends FetchBillPrinterDataState {
  final String message;
  final int attempt;

  BillPrintConnectFailedState({
    required this.message,
    required this.attempt,
    required super.connected,
    required super.availableBluetoothDevices,
    required super.connectedPrinterName,
    required super.isLoader,
  });

  @override
  List<Object> get props => [...super.props, message, attempt];
}