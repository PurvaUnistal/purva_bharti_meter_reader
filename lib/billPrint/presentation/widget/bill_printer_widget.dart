import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meter_reader/Utils/reused_text_style.dart';
import 'package:meter_reader/billPrint/domain/bloc/bill_print_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:image/image.dart' as imgs;

class BillPrinterWidget extends StatefulWidget {
  const BillPrinterWidget({Key? key}) : super(key: key);

  @override
  State<BillPrinterWidget> createState() => _BillPrinterWidgetState();
}

class _BillPrinterWidgetState extends State<BillPrinterWidget> {

  late var imageBytes = null;
  Image? image;


   @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BillPrintBloc, BillPrintState>(
      builder: (context, state) {
        if(state is BillPrintPageLoadState){
          return Center(child: SpinKitCubeGrid(color: Colors.lightBlueAccent, size: 50),);
        } else if(state is FetchBillPrinterDataState){
          return _itemBuilder(dataState: state);
        }else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _itemBuilder({required FetchBillPrinterDataState dataState}) {

    return Container(
        child:  Column(
          children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text("Bluetooth Printer List", style: TextStyle(fontSize: 16,
                      fontWeight: FontWeight.w600),),
                ),
              ),


            Expanded(
                child: dataState.availableBluetoothDevices.isNotEmpty ?
                ListView.builder(
                    itemCount: dataState.availableBluetoothDevices.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          onTap: () {
                            String select = dataState.availableBluetoothDevices[index];
                            List list = select.split("#");
                            String mac = list[1];
                            print(mac);
                            BlocProvider.of<BillPrintBloc>(context).add(
                                BillPrintSetConnectEvent(mac: mac, connectedPrinterName : select.toString()));
                          },
                          title: Text('${dataState.availableBluetoothDevices[index]}'),
                          trailing:  Checkbox(
                            value: dataState.availableBluetoothDevices[index].toString() ==
                                dataState.connectedPrinterName? true : false,
                            onChanged: (value) {
                              if(value == false){
                                String select = dataState.availableBluetoothDevices[index];
                                List list = select.split("#");
                                String mac = list[1];
                                print(mac);
                                BlocProvider.of<BillPrintBloc>(context).add(
                                    BillPrintSetConnectEvent(mac: mac, connectedPrinterName : select.toString()));
                              }
                            },
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  dataState.availableBluetoothDevices[index].toString() ==
                                  dataState.connectedPrinterName? "Connected" : "Click to connect",
                                style: TextStyle(color: dataState.availableBluetoothDevices[index].toString() ==
                                    dataState.connectedPrinterName? Colors.green : Colors.grey)),
                              dataState.isLoader == true
                                  ? Align(
                                   alignment: Alignment.center,
                                   child: SpinKitCubeGrid(color: Colors.lightBlueAccent, size: 50),)
                                  : SizedBox.shrink(),
                            ],
                          ),
                        ),
                      );
               }) : Center(child: Text("Printer Bluetooth no found \n Please check bluetooth printer connection",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                  fontSize: 14, color: Colors.black
                ),),)
            ),


            GestureDetector(
              onTap: () {
                /* Navigator.push(context,MaterialPageRoute( builder: (context) => LoginScreen()), );*/
              },
              child: Center(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      TextButton(
                        onPressed: () {
                          if(dataState.availableBluetoothDevices.isNotEmpty){
                            if(dataState.connected == false){
                              Fluttertoast.showToast(
                                  msg: "Please select printer",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.grey,
                                  textColor: Colors.white,
                                  fontSize: 14.0
                              );
                            }else{
                              BlocProvider.of<BillPrintBloc>(context).add(
                                  BillSetPrintEvent(context: context));
                            }
                          }else{
                            Fluttertoast.showToast(
                                msg: "Printer Bluetooth no found \n Please check bluetooth printer connection",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.grey,
                                textColor: Colors.white,
                                fontSize: 14.0
                            );
                          }

                        },
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)))),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                              height: 50,
                              width:MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: dataState.connected == true ?
                                  Colors.lightBlueAccent :
                                  Colors.grey,
                                  borderRadius: BorderRadius.all(Radius.circular(10))),
                              child: Center(
                                child: Text("Print Now", style: ReusedTextStyle.login),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
    );
  }
}
