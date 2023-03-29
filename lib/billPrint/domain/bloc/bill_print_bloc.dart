import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meter_reader/billPrint/domain/model/bill_printer_model.dart';
import 'package:meter_reader/billPrint/helper/bill_printer_helper.dart';

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

  BillPrintBloc() : super(BillPrintInitial()) {
    on<BillPrintPageLoaderEvent>(_pageLoad);
    on<BillPrintSetConnectEvent>(_setBluetoothConnect);
    on<BillSetPrintEvent>(_billPrint);
  }

  _pageLoad(BillPrintPageLoaderEvent event, emit) async {

    _connected = false;
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
    final String? result = await BluetoothThermalPrinter.connect(event.mac);
    if (result == "true") {
       _connected =  true;
       _connectedPrinterName =  event.connectedPrinterName;
       _eventCompleted(emit);
    }
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

  _eventCompleted(Emitter<BillPrintState> emit) {
    emit(FetchBillPrinterDataState(connected: connected,
        availableBluetoothDevices: availableBluetoothDevices,
        connectedPrinterName: connectedPrinterName));
  }
}
