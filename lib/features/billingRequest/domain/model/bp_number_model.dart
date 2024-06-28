class BpNumberModel {
  bool? success;
  int? code;
  bool? error;
  String? status;
//  List<DataList> data;
  dynamic data;
  BpNumberModel({this.success, this.code, this.error, this.status, this.data});

  BpNumberModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    error = json['error'];
    status = json['status'];
    try {
      if (json['data'] != null) {
        data = <DataList>[];
        json['data'].forEach((v) {
          data.add(new DataList.fromJson(v));
        });
      }
    } catch (exception) {
      print('catch error model--> : $exception');
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['code'] = this.code;
    data['error'] = this.error;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataList {
  String? firstName;
  String? middleName;
  String? lastName;
  String? crn;
  String? bpNumber;
  String? houseNumber;
  String? address2;
  String? locality;
  String? town;
  String? pinCode;
  String? amount;
  String? oldReading;
  String? billNo;
  String? currentBillReading;
  String? meterSerialNumber;
  String? depositName;
  String? depositAmount;
  String? createdOn;
  String? status;
  String? schemeMonth;
  String? schemeType;
  String? dateFrom;
  String? dateTo;
  String? schemeCode;
  String? gasDepositAmount;
  String? equipmentDepositAmount;
  String? id;
  String? interestAmount;
  String? createdAt;
  String? updatedAt;
  String? rejectComments;
  String? customerCount;
  String? registrationGst;
  String? interestTax;
  String? rebateId;
  String? totalAmount;
  String? firstDepositAmount;
  String? nextCycleAmount;
  String? equipmentIncludeInBill;
  String? registrationRefunded;
  String? equipmentRefunded;
  String? gasRefunded;
  String? totalAmountWith;
  String? firstDepositAmountWith;
  String? depositAmountExcludingTaxWith;
  String? registrationGstWith;
  String? depositAmountWith;
  String? benifitApplicable;
  String? approvalStatus;
  String? approvalDate;
  String? gasDepositInFirstBill;
  String? dmaId;
  String? actualWorkStart;
  String? delayReason;
  String? meterType;
  String? meterMake;
  String? meterNumber;
  String? pipe;
  String? fittings;
  String? meterReading;
  String? meterReadingDate;
  String? meterPhoto;
  String? tfNumber;
  String? latitudeTf;
  String? longitudeTf;
  String? latitudeHg;
  String? longitudeHg;
  String? workCompletedDate;
  String? workCompletedImage;
  String? custAckImage;
  String? custAckDate;
  String? feasibilityId;
  String? extraPipe;
  String? extraPrice;
  String? cementingOfHoles;
  String? clampingPvc;
  String? claminngCopper;
  String? meterTesting;
  String? paintaingofGIpipe;
  String? conversionDate;
  String? typeOfNr;
  String? ngc;
  String? regulators;
  String? extraPipeId;
  String? isometricImage;
  String? isometricDate;
  String? pneumaticDate;
  String? pneumaticImage;
  String? mobileNumber;
  String? custId;
  dynamic replaceStatus;
  dynamic replaceId;
  dynamic oldMeterLastReading;
  dynamic oldMeterCurrentReading;
  dynamic newMeterOldReading;
  dynamic oldMeterReadingDate;
  dynamic newMeterInstallDate;
  dynamic lastBillGeneratedDate;
  dynamic lastBillPayDate;
  dynamic lastBillPreviousOutstanding;

  DataList({
    this.firstName,
    this.middleName,
    this.lastName,
    this.crn,
    this.bpNumber,
    this.houseNumber,
    this.address2,
    this.locality,
    this.town,
    this.pinCode,
    this.amount,
    this.oldReading,
    this.billNo,
    this.currentBillReading,
    this.meterSerialNumber,
    this.depositName,
    this.depositAmount,
    this.createdOn,
    this.status,
    this.schemeMonth,
    this.schemeType,
    this.dateFrom,
    this.dateTo,
    this.schemeCode,
    this.gasDepositAmount,
    this.equipmentDepositAmount,
    this.id,
    this.interestAmount,
    this.createdAt,
    this.updatedAt,
    this.rejectComments,
    this.customerCount,
    this.registrationGst,
    this.interestTax,
    this.rebateId,
    this.totalAmount,
    this.firstDepositAmount,
    this.nextCycleAmount,
    this.equipmentIncludeInBill,
    this.registrationRefunded,
    this.equipmentRefunded,
    this.gasRefunded,
    this.totalAmountWith,
    this.firstDepositAmountWith,
    this.depositAmountExcludingTaxWith,
    this.registrationGstWith,
    this.depositAmountWith,
    this.benifitApplicable,
    this.approvalStatus,
    this.approvalDate,
    this.gasDepositInFirstBill,
    this.dmaId,
    this.actualWorkStart,
    this.delayReason,
    this.meterType,
    this.meterMake,
    this.meterNumber,
    this.pipe,
    this.fittings,
    this.meterReading,
    this.meterReadingDate,
    this.meterPhoto,
    this.tfNumber,
    this.latitudeTf,
    this.longitudeTf,
    this.latitudeHg,
    this.longitudeHg,
    this.workCompletedDate,
    this.workCompletedImage,
    this.custAckImage,
    this.custAckDate,
    this.feasibilityId,
    this.extraPipe,
    this.extraPrice,
    this.cementingOfHoles,
    this.clampingPvc,
    this.claminngCopper,
    this.meterTesting,
    this.paintaingofGIpipe,
    this.conversionDate,
    this.typeOfNr,
    this.ngc,
    this.regulators,
    this.extraPipeId,
    this.isometricImage,
    this.isometricDate,
    this.pneumaticDate,
    this.pneumaticImage,
    this.mobileNumber,
    this.custId,
    this.replaceStatus,
    this.replaceId,
    this.oldMeterLastReading,
    this.oldMeterCurrentReading,
    this.newMeterOldReading,
    this.oldMeterReadingDate,
    this.newMeterInstallDate,
    this.lastBillGeneratedDate,
    this.lastBillPayDate,
    this.lastBillPreviousOutstanding,
  });

  DataList.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'] ?? "";
    middleName = json['middle_name'] ?? "";
    lastName = json['last_name'] ?? "";
    crn = json['crn'] ?? "";
    bpNumber = json['bp_number'] ?? "";
    houseNumber = json['house_number'] ?? "";
    address2 = json['address2'] ?? "";
    locality = json['locality'] ?? "";
    town = json['town'] ?? "";
    pinCode = json['pin_code'] ?? "";
    amount = json['amount'] ?? "";
    oldReading = json['old_reading'] ?? "0.00";
    billNo = json['bill_no'] ?? "";
    currentBillReading = json['current_bill_reading'] ?? "";
    meterSerialNumber = json['meter_serial_number'] ?? "";
    depositName = json['deposit_name'] ?? "";
    depositAmount = json['deposit_amount'] ?? "";
    createdOn = json['created_on'] ?? "";
    status = json['status'] ?? "";
    schemeMonth = json['scheme_month'] ?? "";
    schemeType = json['scheme_type'] ?? "";
    dateFrom = json['date_from'] ?? "";
    dateTo = json['date_to'] ?? "";
    schemeCode = json['scheme_code'] ?? "";
    gasDepositAmount = json['gas_deposit_amount'] ?? "";
    equipmentDepositAmount = json['equipment_deposit_amount'] ?? "";
    id = json['id'] ?? "";
    interestAmount = json['interest_amount'] ?? "";
    createdAt = json['created_at'] ?? "";
    updatedAt = json['updated_at'] ?? "";
    rejectComments = json['reject_comments'] ?? "";
    customerCount = json['customer_count'] ?? "";
    registrationGst = json['registration_gst'] ?? "";
    interestTax = json['interest_tax'] ?? "";
    rebateId = json['rebate_id'] ?? "";
    totalAmount = json['totalAmount'] ?? "";
    firstDepositAmount = json['firstDepositAmount'] ?? "";
    nextCycleAmount = json['nextCycleAmount'] ?? "";
    equipmentIncludeInBill = json['equipment_include_in_bill'] ?? "";
    registrationRefunded = json['registration_refunded'] ?? "";
    equipmentRefunded = json['equipment_refunded'] ?? "";
    gasRefunded = json['gas_refunded'] ?? "";
    totalAmountWith = json['totalAmountWith'] ?? "";
    firstDepositAmountWith = json['firstDepositAmountWith'] ?? "";
    depositAmountExcludingTaxWith =
        json['deposit_amount_excluding_tax_with'] ?? "";
    registrationGstWith = json['registration_gst_with'] ?? "";
    depositAmountWith = json['deposit_amount_with'] ?? "";
    benifitApplicable = json['benifit_applicable'] ?? "";
    approvalStatus = json['approval_status'] ?? "";
    approvalDate = json['approval_date'] ?? "";
    gasDepositInFirstBill = json['gas_deposit_in_first_bill'] ?? "";
    dmaId = json['dma_id'] ?? "";
    actualWorkStart = json['actual_work_start'] ?? "";
    delayReason = json['delay_reason'] ?? "";
    meterType = json['meter_type'] ?? "";
    meterMake = json['meter_make'] ?? "";
    meterNumber = json['meter_number'] ?? "";
    pipe = json['pipe'] ?? "";
    fittings = json['fittings'] ?? "";
    meterReading = json['meter_reading'] ?? "";
    meterReadingDate = json['meter_reading_date'] ?? "";
    meterPhoto = json['meter_photo'] ?? "";
    tfNumber = json['tf_number'] ?? "";
    latitudeTf = json['latitude_tf'] ?? "";
    longitudeTf = json['longitude_tf'] ?? "";
    latitudeHg = json['latitude_hg'] ?? "";
    longitudeHg = json['longitude_hg'] ?? "";
    workCompletedDate = json['work_completed_date'] ?? "";
    workCompletedImage = json['work_completed_image'] ?? "";
    custAckImage = json['cust_ack_image'] ?? "";
    custAckDate = json['cust_ack_date'] ?? "";
    feasibilityId = json['feasibility_id'] ?? "";
    extraPipe = json['extra_pipe'] ?? "";
    extraPrice = json['extra_price'] ?? "";
    cementingOfHoles = json['cementing_of_holes'] ?? "";
    clampingPvc = json['clamping_pvc'] ?? "";
    claminngCopper = json['claminng_copper'] ?? "";
    meterTesting = json['meter_testing'] ?? "";
    paintaingofGIpipe = json['paintaingofGIpipe'] ?? "";
    conversionDate = json['conversion_date'] ?? "";
    typeOfNr = json['type_of_nr'] ?? "";
    ngc = json['ngc'] ?? "";
    regulators = json['regulators'] ?? "";
    extraPipeId = json['extra_pipe_id'] ?? "";
    isometricImage = json['isometric_image'] ?? "";
    isometricDate = json['isometric_date'] ?? "";
    pneumaticDate = json['pneumatic_date'] ?? "";
    pneumaticImage = json['pneumatic_image'] ?? "";
    mobileNumber = json['mobile_number'] ?? "";
    custId = json['cust_id'] ?? "";
    replaceStatus = json["replace_status"] ?? "0";
    replaceId = json["replace_id"] ?? "";
    oldMeterLastReading = json["old_meter_last_reading"] ?? "0.00";
    oldMeterCurrentReading = json["old_meter_current_reading"] ?? "0.00";
    newMeterOldReading = json["new_meter_old_reading"] ?? "0.00";
    oldMeterReadingDate = json["old_meter_reading_date"] ?? "";
    lastBillGeneratedDate= json["last_bill_generated_date"] ?? "";
    lastBillPayDate= json["last_bill_pay_date"] ?? "";
    lastBillPreviousOutstanding= json["last_bill_previous_outstanding"] ?? "";

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['middle_name'] = this.middleName;
    data['last_name'] = this.lastName;
    data['crn'] = this.crn;
    data['bp_number'] = this.bpNumber;
    data['address2'] = this.address2;
    data['house_number'] = this.houseNumber;
    data['locality'] = this.locality;
    data['town'] = this.town;
    data['pin_code'] = this.pinCode;
    data['amount'] = this.amount;
    data['old_reading'] = this.oldReading;
    data['bill_no'] = this.billNo;
    data['current_bill_reading'] = this.currentBillReading;
    data['meter_serial_number'] = this.meterSerialNumber;
    data['deposit_name'] = this.depositName;
    data['deposit_amount'] = this.depositAmount;
    data['created_on'] = this.createdOn;
    data['status'] = this.status;
    data['scheme_month'] = this.schemeMonth;
    data['scheme_type'] = this.schemeType;
    data['date_from'] = this.dateFrom;
    data['date_to'] = this.dateTo;
    data['scheme_code'] = this.schemeCode;
    data['gas_deposit_amount'] = this.gasDepositAmount;
    data['equipment_deposit_amount'] = this.equipmentDepositAmount;
    data['id'] = this.id;
    data['interest_amount'] = this.interestAmount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['reject_comments'] = this.rejectComments;
    data['customer_count'] = this.customerCount;
    data['registration_gst'] = this.registrationGst;
    data['interest_tax'] = this.interestTax;
    data['rebate_id'] = this.rebateId;
    data['totalAmount'] = this.totalAmount;
    data['firstDepositAmount'] = this.firstDepositAmount;
    data['nextCycleAmount'] = this.nextCycleAmount;
    data['equipment_include_in_bill'] = this.equipmentIncludeInBill;
    data['registration_refunded'] = this.registrationRefunded;
    data['equipment_refunded'] = this.equipmentRefunded;
    data['gas_refunded'] = this.gasRefunded;
    data['totalAmountWith'] = this.totalAmountWith;
    data['firstDepositAmountWith'] = this.firstDepositAmountWith;
    data['deposit_amount_excluding_tax_with'] =
        this.depositAmountExcludingTaxWith;
    data['registration_gst_with'] = this.registrationGstWith;
    data['deposit_amount_with'] = this.depositAmountWith;
    data['benifit_applicable'] = this.benifitApplicable;
    data['approval_status'] = this.approvalStatus;
    data['approval_date'] = this.approvalDate;
    data['gas_deposit_in_first_bill'] = this.gasDepositInFirstBill;
    data['dma_id'] = this.dmaId;
    data['actual_work_start'] = this.actualWorkStart;
    data['delay_reason'] = this.delayReason;
    data['meter_type'] = this.meterType;
    data['meter_make'] = this.meterMake;
    data['meter_number'] = this.meterNumber;
    data['pipe'] = this.pipe;
    data['fittings'] = this.fittings;
    data['meter_reading'] = this.meterReading;
    data['meter_reading_date'] = this.meterReadingDate;
    data['meter_photo'] = this.meterPhoto;
    data['tf_number'] = this.tfNumber;
    data['latitude_tf'] = this.latitudeTf;
    data['longitude_tf'] = this.longitudeTf;
    data['latitude_hg'] = this.latitudeHg;
    data['longitude_hg'] = this.longitudeHg;
    data['work_completed_date'] = this.workCompletedDate;
    data['work_completed_image'] = this.workCompletedImage;
    data['cust_ack_image'] = this.custAckImage;
    data['cust_ack_date'] = this.custAckDate;
    data['feasibility_id'] = this.feasibilityId;
    data['extra_pipe'] = this.extraPipe;
    data['extra_price'] = this.extraPrice;
    data['cementing_of_holes'] = this.cementingOfHoles;
    data['clamping_pvc'] = this.clampingPvc;
    data['claminng_copper'] = this.claminngCopper;
    data['meter_testing'] = this.meterTesting;
    data['paintaingofGIpipe'] = this.paintaingofGIpipe;
    data['conversion_date'] = this.conversionDate;
    data['type_of_nr'] = this.typeOfNr;
    data['ngc'] = this.ngc;
    data['regulators'] = this.regulators;
    data['extra_pipe_id'] = this.extraPipeId;
    data['isometric_image'] = this.isometricImage;
    data['isometric_date'] = this.isometricDate;
    data['pneumatic_date'] = this.pneumaticDate;
    data['pneumatic_image'] = this.pneumaticImage;
    data['mobile_number'] = this.mobileNumber;
    data['cust_id'] = this.custId;
    data['replace_status'] = this.replaceStatus;
    data['replace_id'] = this.replaceId;
    data['old_meter_last_reading'] = this.oldMeterLastReading;
    data['old_meter_current_reading'] = this.oldMeterCurrentReading;
    data['new_meter_old_reading'] = this.newMeterOldReading;
    data['old_meter_reading_date'] = this.oldMeterReadingDate;
    data['new_meter_install_date'] = this.newMeterInstallDate;
    data["last_bill_generated_date"] = this.lastBillGeneratedDate.toIso8601String();
    data["last_bill_pay_date"] = this.lastBillPayDate.toIso8601String();
    data["last_bill_previous_outstanding"] = this.lastBillPreviousOutstanding;
    return data;
  }
}



class BPNumberRequestModel {
  final String? schema;
  final String? bpNumber;
  BPNumberRequestModel({this.schema, this.bpNumber});
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "schema": schema?.trim(),
      "bpNumber_search": bpNumber?.trim(),
    };
    return map;
  }
}
