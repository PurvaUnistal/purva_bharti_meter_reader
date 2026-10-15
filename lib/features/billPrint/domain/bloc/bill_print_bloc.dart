import 'dart:io';

import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meter_reader_new/features/billPrint/domain/model/bill_printer_model.dart';
import 'package:meter_reader_new/features/billPrint/helper/bill_printer_helper.dart';

part 'bill_print_event.dart';
part 'bill_print_state.dart';

class BillPrintBloc extends Bloc<BillPrintEvent, BillPrintState> {
  bool _connected = false;
  bool get connected => _connected;

  List<BluetoothInfo> _availableBluetoothDevices = [];
  List<BluetoothInfo> get availableBluetoothDevices =>
      _availableBluetoothDevices;

  BillPrintModel _billPrintData = BillPrintModel();
  BillPrintModel get billPrintData => _billPrintData;

  String _connectedPrinterName = "";
  String get connectedPrinterName => _connectedPrinterName;

  String _billId = "";
  String get billId => _billId;

  String _schema = "";
  String get schema => _schema;

  bool _isLoader = false;
  bool get isLoader => _isLoader;

  int _failCount = 0;

  BillPrintBloc() : super(BillPrintInitial()) {
    on<BillPrintPageLoaderEvent>(_pageLoad);
    on<BillPrintSetConnectEvent>(_setBluetoothConnect);
    on<BillSetPrintEvent>(_billPrint);
    on<BillReloadPage>(_pageReload);
  }

  // ---------------- Permission ----------------

  /// Asks for the "Nearby devices" permission (Android 12+).
  /// Returns null when granted, otherwise whether it is permanently denied.
  Future<bool?> _askBluetoothPermission() async {
    if (!Platform.isAndroid) return null;

    final statuses = await [
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
    ].request();

    final connect = statuses[Permission.bluetoothConnect]!;
    final scan = statuses[Permission.bluetoothScan]!;

    if (connect.isGranted && scan.isGranted) {
      // Double-check with the printer plugin itself.
      final ok = await PrintBluetoothThermal.isPermissionBluetoothGranted;
      if (ok) return null;
    }
    return connect.isPermanentlyDenied || scan.isPermanentlyDenied;
  }

  /// Reads connection status and paired printers. Only call after permission.
  Future<void> _loadBluetooth() async {
    _connected = (await PrintBluetoothThermal.connectionStatus) == true;
    _availableBluetoothDevices = await PrintBluetoothThermal.pairedBluetooths;
  }

  // ---------------- Handlers ----------------

  Future<void> _pageLoad(
      BillPrintPageLoaderEvent event, Emitter<BillPrintState> emit) async {
    _connected = false;
    _isLoader = false;
    _availableBluetoothDevices = [];
    _billId = event.billId.toString();
    _schema = event.schema;
    emit(BillPrintPageLoadState());

    // Bill data does not need Bluetooth, so load it first.
    final res = await BillPrinterHelper.fetchBillData(
        context: event.context, billId: event.billId, schema: event.schema);
    if (res != "error") {
      _billPrintData = billDataResponse(res);
    }

    final denied = await _askBluetoothPermission();
    if (denied != null) {
      emit(BillPrintPermissionDeniedState(permanentlyDenied: denied));
      return;
    }

    await _loadBluetooth();
    _eventCompleted(emit);
  }

  Future<void> _pageReload(
      BillReloadPage event, Emitter<BillPrintState> emit) async {
    emit(BillPrintPageLoadState());
    _connected = false;
    _isLoader = false;
    _availableBluetoothDevices = [];

    final denied = await _askBluetoothPermission();
    if (denied != null) {
      emit(BillPrintPermissionDeniedState(permanentlyDenied: denied));
      return;
    }

    await _loadBluetooth();
    _eventCompleted(emit);
  }

  Future<void> _setBluetoothConnect(
      BillPrintSetConnectEvent event, Emitter<BillPrintState> emit) async {
    // 1. Phone ka Bluetooth on hai?
    final btOn = await PrintBluetoothThermal.bluetoothEnabled;
    if (!btOn) {
      _emitError(emit, "Bluetooth is off. Turn on Bluetooth and try again.");
      return;
    }

    _isLoader = true;
    _eventCompleted(emit);

    // 2. Pehle se kisi aur printer se connected ho to pehle disconnect karo,
    //    warna naya connect aksar fail hota hai.
    if (await PrintBluetoothThermal.connectionStatus) {
      await PrintBluetoothThermal.disconnect;
    }

    // 3. Connect karo
    bool result = false;
    try {
      result =
      await PrintBluetoothThermal.connect(macPrinterAddress: event.mac);
    } catch (e) {
      debugPrint("connect error: $e");
      result = false;
    }
    _isLoader = false;

    if (result) {
      _connected = true;
      _connectedPrinterName = event.connectedPrinterName;
      _eventCompleted(emit);
    } else {
      _connected = false;
      _connectedPrinterName = "";
      _emitError(
        emit,
        "Could not connect to the printer. Make sure it is switched on, "
            "close to the phone, and not connected to another phone.",
      );
    }
  }

  Future<void> _billPrint(
      BillSetPrintEvent event, Emitter<BillPrintState> emit) async {
    final isConnected = await PrintBluetoothThermal.connectionStatus;
    if (isConnected != true) {
      _connected = false;
      _connectedPrinterName = "";
      _emitError(
          emit, "Printer disconnected. Tap the printer to connect again.");
      return;
    }

    final bytes =
    await BillPrinterHelper.getTicket(billPrintData: billPrintData);
    final result = await PrintBluetoothThermal.writeBytes(bytes);
    debugPrint("Print $result");
    if (result != true) {
      _emitError(emit, "Print failed. Check the printer paper and try again.");
    }
  }

  // ---------------- Emit helpers ----------------

  /// Emits the current list data plus an error message for the SnackBar.
  void _emitError(Emitter<BillPrintState> emit, String message) {
    _failCount++;
    emit(BillPrintConnectFailedState(
      message: message,
      attempt: _failCount,
      connected: connected,
      availableBluetoothDevices: availableBluetoothDevices,
      connectedPrinterName: connectedPrinterName,
      isLoader: isLoader,
    ));
  }

  void _eventCompleted(Emitter<BillPrintState> emit) {
    emit(FetchBillPrinterDataState(
      connected: connected,
      availableBluetoothDevices: availableBluetoothDevices,
      connectedPrinterName: connectedPrinterName,
      isLoader: isLoader,
    ));
  }
}