import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:meter_reader/billPrint/domain/model/bill_printer_model.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:image/image.dart' as imgs;
import '../../service/Apis.dart';

class BillPrinterHelper {


  static Future<dynamic> fetchBillData({required BuildContext context,
    required dynamic billId, required String schema}) async {
      try{
        String url =  Apis.billPrintData+"${billId}&schema=${schema}";
        log(url);
        var res = await get(Uri.parse(url),);
        log(res.body);
        if(res.statusCode == 200){
          return json.decode(res.body);
        }else{
          return "error";
        }
      }catch(e){
        return "error";
      }
  }

  static Future<List<int>> getTicket({required BillPrintModel billPrintData}) async {
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile,);

    try {
      final ByteData byteImage = await rootBundle.load('assets/images/hpcl_logo.png');
       final assetsIMage = imgs.decodeImage(byteImage.buffer.asUint8List());
       bytes += generator.image(assetsIMage!);
    } catch (e) {
      print(e);
    }

    bytes += generator.text("  ${billPrintData.data!.lable.toString().toUpperCase()}",
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
        ),
        linesAfter: 1);

    bytes += generator.text(
        "A wholly owned subsidiary of  ${billPrintData.data!.lable.toString().toUpperCase()}",
        styles: PosStyles(align: PosAlign.center));

    bytes += generator.text(
        "${billPrintData.data!.district.toString()}, ${billPrintData.data!.state.toString()}",
        styles: PosStyles(align: PosAlign.center));

    bytes += generator.text('GSTN No : ${billPrintData.data!.gstNumber.toString()}',
        styles: PosStyles(align: PosAlign.center));

    bytes += generator.text('PIPED NATURAL GAS INVOICE DOMESTIC PROVISIONAL',
        styles: PosStyles(align: PosAlign.center));

    bytes += generator.text('INVOICE',
        styles: PosStyles(align: PosAlign.center));

    bytes += generator.text('IN : ${billPrintData.data!.billNo.toString()}, PAN No : ${billPrintData.data!.panNumber.toString()}',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.hr();

    bytes += generator.text('Billing Address/Contact Us:',
        styles: PosStyles(align: PosAlign.center));

    bytes += generator.text('${billPrintData.data!.billingAddress.toString()}',
        styles: PosStyles(align: PosAlign.center));

    bytes += generator.text('IN PH. ${billPrintData.data!.customerCare.toString()}',
        styles: PosStyles(align: PosAlign.center));

    bytes += generator.text('OR Visit us at',
        styles: PosStyles(align: PosAlign.center));

    bytes += generator.text('${billPrintData.data!.website.toString()} to view pay your bill.',
        styles: PosStyles(align: PosAlign.center));

    bytes += generator.text('Address Of Registered Office: ${billPrintData.data!.gaAddress.toString()}',
        styles: PosStyles(align: PosAlign.center));

    bytes += generator.text('Corporate Identification No- ${billPrintData.data!.cinNumber.toString()}',
        styles: PosStyles(align: PosAlign.center));

    bytes += generator.text('Telephone Number. ${billPrintData.data!.customerCare.toString()}',
        styles: PosStyles(align: PosAlign.center));

    bytes += generator.text('Fax Number - Fax: +91-${billPrintData.data!.fax.toString()}',
        styles: PosStyles(align: PosAlign.center));

    bytes += generator.text('Website Address:- ${billPrintData.data!.website.toString()}',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.hr();

    bytes += generator.text('BP Number : ${billPrintData.data!.bpNumber.toString()}',
        styles: PosStyles(align: PosAlign.center));

    bytes += generator.text('${billPrintData.data!.firstName.toString()}  ${billPrintData.data!.lastName.toString()}',
        styles: PosStyles(align: PosAlign.center));

    bytes += generator.text('${billPrintData.data!.houseNumber.toString()}, ${billPrintData.data!.area.toString()}, ${billPrintData.data!.town.toString()}, ${billPrintData.data!.pinCode.toString()}',
        styles: PosStyles(align: PosAlign.center));

    bytes += generator.text('Mobile Number : ${billPrintData.data!.mobileNumber.toString()}',
        styles: PosStyles(align: PosAlign.center));

    bytes += generator.text('Email : ${billPrintData.data!.emailId.toString()}',
        styles: PosStyles(align: PosAlign.left));

    bytes += generator.text('Invoice Number : ${billPrintData.data!.billNo.toString()}',
        styles: PosStyles(align: PosAlign.left));

    bytes += generator.text('Meter Number : ${billPrintData.data!.meterNumber.toString()}',
        styles: PosStyles(align: PosAlign.center));

    bytes += generator.text('Bill Date : ${billPrintData.data!.billGeneratedDate.toString()}',
        styles: PosStyles(align: PosAlign.center));

    bytes += generator.text('Bill Due Date : ${billPrintData.data!.billDueDate.toString()}',
        styles: PosStyles(align: PosAlign.center));

         bytes += generator.row([
           PosColumn(
             text: '=====================  ',
             width: 6,
             styles: PosStyles(align: PosAlign.center),
           ),
           PosColumn(
             text: '  ================== ',
             width: 6,
             styles: PosStyles(align: PosAlign.center),
           ),
    ]);
    bytes += generator.row([

      PosColumn(
        text: '|  Previous Balance  ',
        width: 6,
        styles: PosStyles(align: PosAlign.center),
      ),
      PosColumn(
        text: '|  Previous Payment  |',
        width: 6,
        styles: PosStyles(align: PosAlign.center),
      ),
    ]);

    bytes += generator.row([
      PosColumn(
        text: '=====================  ',
        width: 6,
        styles: PosStyles(align: PosAlign.center),
      ),
      PosColumn(
        text: '  ================== ',
        width: 6,
        styles: PosStyles(align: PosAlign.center),
      ),
    ]);

    String balanceValue =  "${billPrintData.previousBill!.previousBillAmount.toString()}";
    String balanceValueSpace =  "";
    for(int i = 0; i < 18; i++){
      if(i > balanceValue.length-1){
        balanceValueSpace += " ";
      }
    }
    String totalBalance = "${balanceValueSpace+balanceValue}";

    String paymentValue =  "${billPrintData.previousBill!.previousPayment.toString()}";
    String paymentValueSpace =  "";
    for(int i = 0; i < 18; i++){
      if(i > paymentValue.length-1){
        paymentValueSpace += " ";
      }
    }
    String totalPayment = "${paymentValueSpace+paymentValue}";


    bytes += generator.row([
      PosColumn(
        text: '|${totalBalance}  ',
        width: 6,
        styles: PosStyles(align: PosAlign.right,),
      ),
      PosColumn(
        text: '|${totalPayment}  |',
        width: 6,
        styles: PosStyles(align: PosAlign.right,),
      ),
    ]);

    bytes += generator.text(
        "   ",
        styles: PosStyles(align: PosAlign.center));

    // Current Bill Amount -
    bytes += generator.row([
      PosColumn(
        text: '=====================  ',
        width: 6,
        styles: PosStyles(align: PosAlign.center),
      ),
      PosColumn(
        text: '  ================== ',
        width: 6,
        styles: PosStyles(align: PosAlign.center),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: '|  Current Bill Amount  ',
        width: 6,
        styles: PosStyles(align: PosAlign.center),
      ),
      PosColumn(
        text: '|    Due Amount     |',
        width: 6,
        styles: PosStyles(align: PosAlign.center),
      ),
    ]);

    bytes += generator.row([
      PosColumn(
        text: '=====================  ',
        width: 6,
        styles: PosStyles(align: PosAlign.center),
      ),
      PosColumn(
        text: '  ================== ',
        width: 6,
        styles: PosStyles(align: PosAlign.center),
      ),
    ]);

    String currentValue =  "${billPrintData.data!.amountAfterGasDeposit.toString()}";
    String currentValueSpace =  "";
    for(int i = 0; i < 18; i++){
      if(i > currentValue.length-1){
        currentValueSpace += " ";
      }
    }
    String totalCurrent = "${currentValueSpace+currentValue}";

    String dueAmountValue =  "${billPrintData.data!.finalBillAmount.toString()}";
    String dueAmountValueSpace =  "";
    for(int i = 0; i < 18; i++){
      if(i > dueAmountValue.length-1){
        dueAmountValueSpace += " ";
      }
    }
    String totaldueAmount = "${dueAmountValueSpace+dueAmountValue}";


    bytes += generator.row([
      PosColumn(
        text: '|${totalCurrent}  ',
        width: 6,
        styles: PosStyles(align: PosAlign.right,),
      ),
      PosColumn(
        text: '|${totaldueAmount}  |',
        width: 6,
        styles: PosStyles(align: PosAlign.right,),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: '=====================  ',
        width: 6,
        styles: PosStyles(align: PosAlign.center),
      ),
      PosColumn(
        text: '  ================== ',
        width: 6,
        styles: PosStyles(align: PosAlign.center),
      ),
    ]);

    bytes += generator.hr(ch: '=', linesAfter: 1);

    bytes += generator.text('Previous Reading : ${billPrintData.data!.billReadingOld.toString()}',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('Current Reading : : ${billPrintData.data!.currentBillReading.toString()}',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.hr(ch: "=");

    bytes += generator.text('Total (Rs.) : ${billPrintData.data!.finalBillAmount.toString()}',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.hr(ch: '=', linesAfter: 1);


    bytes += generator.hr(ch: '=', linesAfter: 1);
    bytes += generator.text('Total (Rs.) : ${billPrintData.data!.amountAfterGasDeposit.toString()}',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.hr(ch: "=");

    bytes += generator.text('Current Invoice Amount           : ${billPrintData.data!.actualReadingPrice.toString()}',
        styles: PosStyles(align: PosAlign.left));
    bytes += generator.text('${billPrintData.data!.taxName.toString().replaceAll("@", "")}                       : ${billPrintData.data!.billingTaxAmount.toString()}',
        styles: PosStyles(align: PosAlign.left));
    bytes += generator.text('Total Amount                     : ${billPrintData.data!.amountAfterTax.toString()}',
        styles: PosStyles(align: PosAlign.left));
    bytes += generator.text('PAYABLE Amount (Rs.)   ${billPrintData.data!.finalBillAmount.toString()}',
        styles: PosStyles(align: PosAlign.center));

    bytes += generator.text('*Cheque/DD Should be payable to "${billPrintData.data!.lable.toString()}" (Cash payment are not accepted).',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('UPI-Scan & Pay : ',
        styles: PosStyles(align: PosAlign.center));


    try {
      bytes += generator.cut();
      final image =  await getQrCodeBytes(data: "${billPrintData.qrCode}" );
      final img = imgs.decodeImage(image);
      bytes += generator.imageRaster(img!);

    } catch (e) {
      print(e);
    }

    bytes += generator.hr(ch: '=');
    bytes += generator.text('Customer Signature : ',
        styles: PosStyles(align: PosAlign.center, bold: true),linesAfter: 1);

    bytes += generator.text("Email              : ${billPrintData.data!.emailId.toString()}",
        styles: PosStyles(align: PosAlign.center), linesAfter: 1);
    bytes += generator.text("Toll free number  : 18001029282",
        styles: PosStyles(align: PosAlign.center), linesAfter: 1);

    bytes += generator.cut();
    return bytes;
  }


  static Future<dynamic> getQrCodeBytes({required String data}) async {
    const bool gapless = true;
    const int errorCorrectLevel = QrErrorCorrectLevel.M;
    const double size = 155;
    final double actualQRCodeSize = _getActualQRCodeSize(
      text: data,
      size: size,
      gapless: gapless,
      errorCorrectLevel: errorCorrectLevel,
    );
    final image = await QrPainter(
      data: data,
      version: QrVersions.auto,
      color: Colors.black,
      emptyColor: Colors.white,
      gapless: gapless,
      errorCorrectionLevel: errorCorrectLevel,
    ).toImageData(actualQRCodeSize);

    return image?.buffer.asUint8List();
  }

  static double _getActualQRCodeSize({
    required String text,
    required double size,
    required bool gapless,
    required int errorCorrectLevel,
  }) {
    // These calculations are from `_PaintMetrics._calculateMetrics`
    final double gap = gapless ? 0 : 0.25;
    final QrCode qrCode = QrCode.fromData(
      data: text,
      errorCorrectLevel: errorCorrectLevel,
    );

    final double gapTotal = (qrCode.moduleCount - 1) * gap;

    final double actualQRCodeSize;
    double pixelSize = (size - gapTotal) / qrCode.moduleCount;
    pixelSize = (pixelSize * 2).roundToDouble() / 2;

    actualQRCodeSize = (pixelSize * qrCode.moduleCount) + gapTotal;

    return actualQRCodeSize;
  }

  static Future<dynamic> writeToFile(ByteData data, String path) async {
    final buffer = data.buffer;
    return await File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes)
    );
  }

}