import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:meter_reader_new/features/Home/presentation/widget/bluetooth_permission_view.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:meter_reader_new/Utils/Utils.dart';
import 'package:meter_reader_new/Utils/common_widgets/res/styles_widget.dart';
import 'package:meter_reader_new/features/billPrint/domain/bloc/bill_print_bloc.dart';

class BillPrinterWidget extends StatefulWidget {
  const BillPrinterWidget({Key? key}) : super(key: key);

  @override
  State<BillPrinterWidget> createState() => _BillPrinterWidgetState();
}

class _BillPrinterWidgetState extends State<BillPrinterWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BillPrintBloc, BillPrintState>(
      // Connect / print fail hone par message dikhao
      listenWhen: (previous, current) => current is BillPrintConnectFailedState,
      listener: (context, state) {
        if (state is BillPrintConnectFailedState) {
          Utils.errorSnackBar(msg: state.message, context: context);
        }
      },
      builder: (context, state) {
        // Permission check sabse pehle
        if (state is BillPrintPermissionDeniedState) {
          return BluetoothPermissionView(
              permanentlyDenied: state.permanentlyDenied);
        }
        if (state is BillPrintPageLoadState) {
          return Center(
            child: SpinKitCubeGrid(color: Colors.green.shade800, size: 50),
          );
        }
        if (state is FetchBillPrinterDataState) {
          return _itemBuilder(dataState: state);
        }
        return const SizedBox.shrink();
      },
    );
  }

  /// print_bluetooth_thermal already gives the MAC address separately,
  /// so there is no "name#mac" string to split.
  void _connect(BluetoothInfo device, FetchBillPrinterDataState dataState) {
    if (dataState.isLoader) return; // already connecting
    final mac = device.macAdress.trim();
    if (mac.isEmpty) {
      Utils.errorSnackBar(msg: "Printer address not found", context: context);
      return;
    }
    context.read<BillPrintBloc>().add(
      BillPrintSetConnectEvent(mac: mac, connectedPrinterName: mac),
    );
  }

  bool _isConnected(BluetoothInfo device, FetchBillPrinterDataState s) =>
      s.connected && device.macAdress.trim() == s.connectedPrinterName;

  Widget _itemBuilder({required FetchBillPrinterDataState dataState}) {
    final devices = dataState.availableBluetoothDevices;

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Bluetooth Printer List",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        // One loader for the whole list instead of one inside every tile.
        if (dataState.isLoader)
          LinearProgressIndicator(
            color: Colors.green.shade800,
            backgroundColor: Colors.green.shade100,
          ),
        Expanded(
          child: devices.isEmpty
              ? const Center(
            child: Text(
              "Printer Bluetooth not found\nPlease pair the printer in phone Bluetooth settings",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
          )
              : ListView.builder(
            itemCount: devices.length,
            itemBuilder: (context, index) {
              final device = devices[index];
              final connected = _isConnected(device, dataState);

              return Card(
                child: ListTile(
                  onTap: () => _connect(device, dataState),
                  title: Text(
                    'Name: ${device.name}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(device.macAdress),
                      const SizedBox(height: 2),
                      Text(
                        connected ? "Connected" : "Tap to connect",
                        style: TextStyle(
                          color: connected ? Colors.green : Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  trailing: Icon(
                    connected
                        ? Icons.check_circle_rounded
                        : Icons.print_outlined,
                    color: connected ? Colors.green : Colors.grey,
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextButton(
            onPressed: () {
              if (devices.isEmpty) {
                Utils.errorSnackBar(
                  msg:
                  "Printer Bluetooth not found\nPlease check bluetooth printer connection",
                  context: context,
                );
              } else if (!dataState.connected) {
                Utils.errorSnackBar(
                    msg: "Please select printer", context: context);
              } else {
                context
                    .read<BillPrintBloc>()
                    .add(BillSetPrintEvent(context: context));
              }
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              ),
            ),
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: dataState.connected
                    ? Colors.green.shade800
                    : Colors.grey,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Center(child: Text("Print Now", style: Styles.login)),
            ),
          ),
        ),
      ],
    );
  }
}