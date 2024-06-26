import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meter_reader/features/billPrint/domain/model/bill_printer_model.dart';
import 'package:meter_reader/features/billPrint/helper/bill_printer_helper.dart';

part 'bill_print_event.dart';
part 'bill_print_state.dart';

class BillPrintBloc extends Bloc<BillPrintEvent, BillPrintState> {

  bool _connected = false;
  bool get connected => _connected;

  List _availableBluetoothDevices = [];
  List get availableBluetoothDevices => _availableBluetoothDevices;

  BillPrintModel _billPrintData =  BillPrintModel();
  BillPrintModel get billPrintData => _billPrintData;

  String _connectedPrinterName =  "";
  String get connectedPrinterName => _connectedPrinterName;

  String _billId = "";
  String get billId => _billId;

  String _schema = "";
  String get schema => _schema;

  bool _isLoader =  false;
  bool get isLoader => _isLoader;

  BillPrintBloc() : super(BillPrintInitial()) {
    on<BillPrintPageLoaderEvent>(_pageLoad);
    on<BillPrintSetConnectEvent>(_setBluetoothConnect);
    on<BillSetPrintEvent>(_billPrint);
    on<BillReloadPage>(_pageReload);
  }

  _pageLoad(BillPrintPageLoaderEvent event, emit) async {
    _connected = false;
    _isLoader =  false;
    String? isConnected = await BluetoothThermalPrinter.connectionStatus;
    if (isConnected == "true") {
      _connected =  true;
    }
    _availableBluetoothDevices = [];
    emit(BillPrintPageLoadState());
    List? bluetoothList = await BluetoothThermalPrinter.getBluetooths;
    _availableBluetoothDevices = bluetoothList!;
    var res =  await BillPrinterHelper.fetchBillData(context: event.context,
         billId: event.billId, schema: event.schema);
    if(res != "error"){
      _billPrintData =  billDataResponse(res);
    }
    _eventCompleted(emit);
  }

  _setBluetoothConnect(BillPrintSetConnectEvent event, emit) async {
    _isLoader = true;
    _eventCompleted(emit);
    final String? result = await BluetoothThermalPrinter.connect(event.mac);
    if (result == "true") {
       _connected =  true;
       _connectedPrinterName =  event.connectedPrinterName;
    }
    _isLoader = false;
    _eventCompleted(emit);
  }

  _billPrint(BillSetPrintEvent event, emit) async {
    String? isConnected = await BluetoothThermalPrinter.connectionStatus;
    if (isConnected == "true") {
      List<int> bytes = await BillPrinterHelper.getTicket(billPrintData: billPrintData);
      final result = await BluetoothThermalPrinter.writeBytes(bytes);
      print("Print $result");
    } else {

    }
  }

  _pageReload(BillReloadPage event, emit) async {
    emit(BillPrintPageLoadState());
    _connected = false;
    _isLoader =  false;
    String? isConnected = await BluetoothThermalPrinter.connectionStatus;
    if (isConnected == "true") {
      _connected =  true;
    }
    _availableBluetoothDevices = [];
    List? bluetoothList = await BluetoothThermalPrinter.getBluetooths;
    _availableBluetoothDevices = bluetoothList!;
    _eventCompleted(emit);
  }

  _eventCompleted(Emitter<BillPrintState> emit) {
    emit(FetchBillPrinterDataState(connected: connected,
        availableBluetoothDevices: availableBluetoothDevices,
        connectedPrinterName: connectedPrinterName, isLoader: isLoader));
  }
}
