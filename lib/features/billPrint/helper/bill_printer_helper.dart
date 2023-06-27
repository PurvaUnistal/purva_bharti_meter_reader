import 'dart:developer';
import 'package:image/image.dart' as imgs;
import '../../../../ExportFile/export_file.dart';

class BillPrinterHelper {
  static Future<dynamic> fetchBillData({required BuildContext context, required dynamic billId, required String schema}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString(GlobalConstants.token) ?? "";
    try {
      String url = Apis.billPrintData + "$billId&schema=$schema";
      log(url);
      var res = await get(
        Uri.parse(url),headers: {'authorization': '$token'});
      log(res.body);
      if (res.statusCode == 200) {
        return json.decode(res.body);
      } else if(res.statusCode == 403){
        SessionDialogUtils.logOut(context);
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  static Future<List<int>> getTicket({required BillPrintModel billPrintData}) async {
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(
      PaperSize.mm80,
      profile,
    );

    try {
      final ByteData byteImage = await rootBundle.load('assets/images/hpcl_logo.png');
      final assetsIMage = imgs.decodeImage(byteImage.buffer.asUint8List());
      bytes += generator.image(assetsIMage!);
    } catch (e) {
      print(e);
    }

    /*bytes += generator.text("  ${billPrintData.data!.lable.toString().toUpperCase()}",
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
        ),
        linesAfter: 1);*/

    // TODO:  First block
    bytes += generator.text("${billPrintData.data!.district.toString()}, ${billPrintData.data!.state.toString()}", styles: PosStyles(align: PosAlign.center));

    bytes += generator.text('GSTIN Number : ${billPrintData.data!.gstNumber.toString()}', styles: PosStyles(align: PosAlign.center));

    bytes += generator.text('PIPED NATURAL GAS INVOICE DOMESTIC PROVISIONAL', styles: PosStyles(align: PosAlign.center));

    bytes += generator.text('INVOICE NUMBER   : ${billPrintData.data!.billNo.toString()}', styles: PosStyles(align: PosAlign.right));
    bytes += generator.text('Corporate Identification No. : ${billPrintData.data!.billNo.toString()}', styles: PosStyles(align: PosAlign.right));

    bytes += generator.text('Toll Free Number : ${billPrintData.data!.customerCare.toString()}', styles: PosStyles(align: PosAlign.right));
    bytes += generator.hr();
    // TODO:  Second block
    bytes += generator.text('BP Number : ${billPrintData.data!.bpNumber.toString()}', styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('${billPrintData.data!.firstName.toString()} ${billPrintData.data!.lastName.toString()}', styles: PosStyles(align: PosAlign.center));
    bytes += generator.text(
        '${billPrintData.data!.houseNumber.toString()}, ${billPrintData.data!.area.toString()}, ${billPrintData.data!.town.toString()},\n'
        ' ${billPrintData.data!.pinCode.toString()}',
        styles: PosStyles(align: PosAlign.center));

    /* bytes += generator.row([
      PosColumn(text: 'Mobile Number', width: 6, styles: PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(text: '${billPrintData.data!.mobileNumber.toString()}', width: 6, styles: PosStyles(align: PosAlign.right)),
    ]);
    bytes += generator.row([
      PosColumn(text: 'Meter Number', width: 6, styles: PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(text: '${billPrintData.data!.meterNumber.toString()}', width: 6, styles: PosStyles(align: PosAlign.right)),
    ]);*/
    bytes += generator.text('Mobile Number         : ${billPrintData.data!.mobileNumber.toString()}', styles: PosStyles(align: PosAlign.left));
    bytes += generator.text('Meter Number          : ${billPrintData.data!.meterNumber.toString()}', styles: PosStyles(align: PosAlign.left));
    bytes += generator.text('Bill Date             : ${billPrintData.data!.billGeneratedDate.toString()}', styles: PosStyles(align: PosAlign.left));
    bytes += generator.text('Due Date              : ${billPrintData.data!.billDueDate.toString()}', styles: PosStyles(align: PosAlign.left));
    bytes += generator.text('', styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('    Pay before due date to avoid late fee', styles: PosStyles(align: PosAlign.center));
    bytes += generator.hr();

    // TODO:  Third block

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
        text: '|Previous Bill',
        width: 4,
        styles: PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: '|     Previous payment received|',
        width: 8,
        styles: PosStyles(align: PosAlign.right),
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

    String balanceValue = "${billPrintData.previousBill!.previousBillAmount.toString()}";
    String balanceValueSpace = "";
    for (int i = 0; i < 18; i++) {
      if (i > balanceValue.length - 1) {
        balanceValueSpace += " ";
      }
    }
    String totalBalance = "${balanceValueSpace + balanceValue}";

    String paymentValue = "${billPrintData.previousBill!.previousPayment.toString()}";
    String paymentValueSpace = "";
    for (int i = 0; i < 18; i++) {
      if (i > paymentValue.length - 1) {
        paymentValueSpace += " ";
      }
    }
    String totalPayment = "${paymentValueSpace + paymentValue}";

    bytes += generator.row([
      PosColumn(
        text: '|$totalBalance  ',
        width: 6,
        styles: PosStyles(
          align: PosAlign.right,
        ),
      ),
      PosColumn(
        text: '|$totalPayment  |',
        width: 6,
        styles: PosStyles(
          align: PosAlign.right,
        ),
      ),
    ]);

    bytes += generator.text("   ", styles: PosStyles(align: PosAlign.center));

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

    String currentValue = "${billPrintData.data!.amountAfterGasDeposit.toString()}";
    String currentValueSpace = "";
    for (int i = 0; i < 18; i++) {
      if (i > currentValue.length - 1) {
        currentValueSpace += " ";
      }
    }
    String totalCurrent = "${currentValueSpace + currentValue}";

    String dueAmountValue = "${billPrintData.data!.finalBillAmount.toString()}";
    String dueAmountValueSpace = "";
    for (int i = 0; i < 18; i++) {
      if (i > dueAmountValue.length - 1) {
        dueAmountValueSpace += " ";
      }
    }
    String totaldueAmount = "${dueAmountValueSpace + dueAmountValue}";

    bytes += generator.row([
      PosColumn(
        text: '|$totalCurrent  ',
        width: 6,
        styles: PosStyles(
          align: PosAlign.right,
        ),
      ),
      PosColumn(
        text: '|$totaldueAmount  |',
        width: 6,
        styles: PosStyles(
          align: PosAlign.right,
        ),
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

    bytes += generator.hr();

    // TODO:  Fourth block

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
        text: '|  Previous Reading  ',
        width: 6,
        styles: PosStyles(align: PosAlign.center),
      ),
      PosColumn(
        text: '|  Current Reading  |',
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
    String previousValue = "${billPrintData.data!.billReadingOld.toString()}";
    String previousValueSpace = "";
    for (int i = 0; i < 18; i++) {
      if (i > previousValue.length - 1) {
        previousValueSpace += " ";
      }
    }
    String totalPrevious = "${previousValueSpace + previousValue}";
    String currentReadingValue = "${billPrintData.data!.currentBillReading.toString()}";
    String currentReadingValueSpace = "";
    for (int i = 0; i < 18; i++) {
      if (i > currentReadingValue.length - 1) {
        currentReadingValueSpace += " ";
      }
    }
    String totalCurrentReading = "${currentReadingValueSpace + currentReadingValue}";
    bytes += generator.row([
      PosColumn(
        text: '|$totalPrevious  ',
        width: 6,
        styles: PosStyles(
          align: PosAlign.right,
        ),
      ),
      PosColumn(
        text: '|$totalCurrentReading  |',
        width: 6,
        styles: PosStyles(
          align: PosAlign.right,
        ),
      ),
    ]);
    bytes += generator.text("   ", styles: PosStyles(align: PosAlign.center));
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
        text: '|  Net Consumption (SCM) ',
        width: 6,
        styles: PosStyles(align: PosAlign.center),
      ),
      PosColumn(
        text: '|    DPNG rate(RS/SCM)     |',
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
    String scmValue = "${billPrintData.consumption.toStringAsFixed(3)}";
    String scmValueSpace = "";
    for (int i = 0; i < 18; i++) {
      if (i > scmValue.length - 1) {
        scmValueSpace += " ";
      }
    }
    String totalSCM = "${scmValueSpace + scmValue}";
    String dpngValue = "${billPrintData.pricePerUnit.toString()}";
    String dpngValueSpace = "";
    for (int i = 0; i < 18; i++) {
      if (i > currentReadingValue.length - 1) {
        dpngValueSpace += " ";
      }
    }
    String totalDPNG = "${dpngValueSpace + dpngValue}";
    bytes += generator.row([
      PosColumn(
        text: '|$totalSCM  ',
        width: 6,
        styles: PosStyles(
          align: PosAlign.right,
        ),
      ),
      PosColumn(
        text: '|$totalDPNG  |',
        width: 6,
        styles: PosStyles(
          align: PosAlign.right,
        ),
      ),
    ]);
    bytes += generator.text("   ", styles: PosStyles(align: PosAlign.center));
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
    bytes += generator.hr();

    // TODO:  Fifth block

    bytes += generator.text('Current Invoice Amount           : ${billPrintData.data!.actualReadingPrice.toString()}', styles: PosStyles(align: PosAlign.left));
    bytes += generator.text('${billPrintData.data!.taxName.toString().replaceAll("@", "")}                       : ${billPrintData.data!.billingTaxAmount.toString()}',
        styles: PosStyles(align: PosAlign.left));
    bytes += generator.text('Total Payble                     : ${billPrintData.data!.finalBillAmount.toString()}', styles: PosStyles(align: PosAlign.left));
    bytes += generator.text('', styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('    HPCL does not accept cash/Cheque/DD ', styles: PosStyles(align: PosAlign.center, bold: true));
    //  bytes += generator.text('Visit us at :\n https://citygas.hpcl.co.in/customer\n (to pay or view bill)', styles: PosStyles(align: PosAlign.center));
    // bytes += generator.hr(ch: '=');
    bytes += generator.hr();
    bytes += generator.text('Payment options', styles: PosStyles(align: PosAlign.center));
    bytes += generator.hr(ch: '=');
    bytes += generator.text('UPI-Scan & Pay : ', styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('', styles: PosStyles(align: PosAlign.center));
    try {
      //   bytes += generator.cut();
      final image = await getQrCodeBytes(data: "${billPrintData.qrCode}");
      final img = imgs.decodeImage(image);
      bytes += generator.imageRaster(img!);
    } catch (e) {
      print(e.toString());
    }
    bytes += generator.text('', styles: PosStyles(align: PosAlign.center));
    bytes += generator.hr(ch: '=');
    bytes += generator.text('or pay online:\n        https://citygas.hpcl.co.in/customer', styles: PosStyles(align: PosAlign.center));
    bytes += generator.hr(ch: '=');
    //   bytes += generator.text('or pay online :\n https://citygas.hpcl.co.in/customer', styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('or\n         register in BBPS and Pay', styles: PosStyles(align: PosAlign.center));
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
    return await File(path).writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }
}
