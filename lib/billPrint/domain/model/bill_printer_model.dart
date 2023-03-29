BillPrintModel billDataResponse(var json) {
  return BillPrintModel.fromJson(json);
}

class BillPrintModel {
  bool? success;
  int? code;
  String? status;
  bool? error;
  Data? data;
  String? qrCode;
  PreviousBill? previousBill;

  BillPrintModel({this.success, this.code, this.status, this.error, this.data, this.qrCode, this.previousBill});

   factory BillPrintModel.fromJson(Map<String, dynamic> json) {
     return BillPrintModel(
         success : json['success'],
         code : json['code'],
         status : json['status'],
         error : json['error'],
         data : json['data'] != null ? new Data.fromJson(json['data']) : null,
         qrCode: json['qrCode'] ?? "HCPL",
         previousBill: json['previous_bill'] != null ? PreviousBill.fromJson(json['previous_bill']) : null,
     );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['code'] = this.code;
    data['status'] = this.status;
    data['error'] = this.error;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class PreviousBill {

  String? previousBillAmount;
  String? previousPayment;
  String? adjustment;

  PreviousBill({this.previousBillAmount, this.previousPayment, this.adjustment});

  factory PreviousBill.fromJson(Map<String, dynamic> json) {
    return PreviousBill(
       previousBillAmount: json['previous_bill_amount'] ?? "0",
      previousPayment: json['previous_payment'] ?? "0",
      adjustment: json['adjustment'] ?? "0",
    );
  }
}

class Data {
  String? lable;
  String? gid;
  dynamic? objectid1;
  dynamic? objectid;
  String? id;
  String? add;
  dynamic? shapeLeng;
  String? projectCode;
  dynamic? shapeLe1;
  dynamic? shapeArea;
  String? dbname;
  String? district;
  String? state;
  dynamic? labelForDashboard;
  String? gstNumber;
  dynamic? panNumber;
  String? gaAddress;
  String? cinNumber;
  dynamic? branchEmail;
  String? customerCare;
  String? vat;
  String? fax;
  String? cst;
  String? firstName;
  String? lastName;
  String? mobileNumber;
  String? emailId;
  String? houseNumber;
  String? locality;
  String? town;
  String? pinCode;
  String? area;
  String? chargeAreaName;
  dynamic? districtName;
  String? schemeName;
  String? bpNumber;
  String? meterNumber;
  String? finalBillAmount;
  String? taxName;
  String? taxPercentageValue;
  String? billNo;
  String? billAmt;
  String? billDueDate;
  String? billPayDate;
  String? custId;
  String? billSta;
  String? billGeneratedDate;
  String? paymentMode;
  String? trn;
  String? differAmt;
  String? differType;
  String? cycleStartDate;
  String? cycleEndDate;
  String? genrerateByCustomer;
  String? billReadingOld;
  String? billApproved;
  String? currentBillReading;
  String? isFirstBill;
  String? actualReadingPrice;
  String? billingTaxAmount;
  String? amountAfterTax;
  String? lateFeePeriod;
  String? billingCycle;
  String? lateFee;
  dynamic? amountAfterLateFee;
  String? gasDepositAmount;
  String? amountAfterGasDeposit;
  String? depositAmount;
  String? amountAfterDeposit;
  String? rebateAmount;
  String? amountAfterRebate;
  String? meterImage;
  dynamic? rejectReason;
  dynamic? rejectDate;
  String? billConfigId;
  String? billingTaxId;
  String? extraCharges;
  String? afterExtraCharge;
  String? equipmentDeposit;
  String? afterEquipmentDeposit;
  String? prevBillAmount;
  String? billLat;
  String? billLong;
  String? adjustment;
  String? paidAmount;
  dynamic? remarks;
  String? balSecurityCharge;
  String? balExtraCharge;
  String? balGasConsumptionCharge;
  String? extraPipe;
  String? userId;
  String? prevSecuritydepositAmount;
  String? prevExtrachargeAmount;
  String? unitCharge;
  dynamic? lateFeeStatus;
  String? website;
  String? billingAddress;


  Data(
      {this.lable,
        this.gid,
        this.objectid1,
        this.objectid,
        this.id,
        this.add,
        this.shapeLeng,
        this.projectCode,
        this.shapeLe1,
        this.shapeArea,
        this.dbname,
        this.district,
        this.state,
        this.labelForDashboard,
        this.gstNumber,
        this.panNumber,
        this.gaAddress,
        this.cinNumber,
        this.branchEmail,
        this.customerCare,
        this.vat,
        this.fax,
        this.cst,
        this.firstName,
        this.lastName,
        this.mobileNumber,
        this.emailId,
        this.houseNumber,
        this.locality,
        this.town,
        this.pinCode,
        this.area,
        this.chargeAreaName,
        this.districtName,
        this.schemeName,
        this.bpNumber,
        this.meterNumber,
        this.finalBillAmount,
        this.taxName,
        this.taxPercentageValue,
        this.billNo,
        this.billAmt,
        this.billDueDate,
        this.billPayDate,
        this.custId,
        this.billSta,
        this.billGeneratedDate,
        this.paymentMode,
        this.trn,
        this.differAmt,
        this.differType,
        this.cycleStartDate,
        this.cycleEndDate,
        this.genrerateByCustomer,
        this.billReadingOld,
        this.billApproved,
        this.currentBillReading,
        this.isFirstBill,
        this.actualReadingPrice,
        this.billingTaxAmount,
        this.amountAfterTax,
        this.lateFeePeriod,
        this.billingCycle,
        this.lateFee,
        this.amountAfterLateFee,
        this.gasDepositAmount,
        this.amountAfterGasDeposit,
        this.depositAmount,
        this.amountAfterDeposit,
        this.rebateAmount,
        this.amountAfterRebate,
        this.meterImage,
        this.rejectReason,
        this.rejectDate,
        this.billConfigId,
        this.billingTaxId,
        this.extraCharges,
        this.afterExtraCharge,
        this.equipmentDeposit,
        this.afterEquipmentDeposit,
        this.prevBillAmount,
        this.billLat,
        this.billLong,
        this.adjustment,
        this.paidAmount,
        this.remarks,
        this.balSecurityCharge,
        this.balExtraCharge,
        this.balGasConsumptionCharge,
        this.extraPipe,
        this.userId,
        this.prevSecuritydepositAmount,
        this.prevExtrachargeAmount,
        this.unitCharge,
        this.lateFeeStatus,
        this.website,
        this.billingAddress});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
        lable: json['ga_label'] ?? "",
        gid : json['gid'] ?? "",
        objectid1 : json['objectid_1'] ?? "",
        objectid : json['objectid'] ?? "",
        id : json['id'] ?? "",
        add : json['add_'] ?? "",
        shapeLeng : json['shape_leng'] ?? "",
        projectCode : json['project_code'] ?? "",
        shapeLe1 : json['shape_le_1'] ?? "",
        shapeArea : json['shape_area'] ?? "",
        dbname : json['dbname'] ?? "HPCL Limited",
        district : json['district'] ?? "",
        state : json['state'] ?? "",
        labelForDashboard : json['label_for_dashboard'] ?? "",
        gstNumber : json['gst_number'] ?? "",
        panNumber : json['pan_number'] ?? "",
        gaAddress : json['ga_address'] ?? "",
        cinNumber : json['cin_number'] ?? "",
        branchEmail : json['branch_email'] ?? "",
        customerCare : json['customer_care'] ?? "",
        vat : json['vat'] ?? "",
        fax : json['fax'] ?? "",
        cst : json['cst'] ?? "",
        firstName : json['first_name'] ?? "",
        lastName : json['last_name'] ?? "",
        mobileNumber : json['mobile_number'] ?? "",
        emailId : json['email_id'] ?? "",
        houseNumber : json['house_number'] ?? "",
        locality : json['locality'] ?? "",
        town : json['town'] ?? "",
        pinCode : json['pin_code'] ?? "",
        area : json['area'] ?? "",
        chargeAreaName : json['charge_area_name'] ?? "",
        districtName : json['district_name'] ?? "",
        schemeName : json['scheme_name'] ?? "",
        bpNumber : json['bp_number'] ?? "",
        meterNumber : json['meter_number'] ?? "",
        finalBillAmount : json['final_bill_amount'] ?? "",
        taxName : json['tax_name'] ?? "",
        taxPercentageValue : json['tax_percentage_value'] ?? "",
        billNo : json['bill_no'] ?? "",
        billAmt : json['bill_amt'] ?? "",
        billDueDate : json['bill_due_date'] ?? "",
        billPayDate : json['bill_pay_date'] ?? "",
        custId : json['cust_id'] ?? "",
        billSta : json['bill_sta'] ?? "",
        billGeneratedDate : json['bill_generated_date'] ?? "",
        paymentMode : json['payment_mode'] ?? "",
        trn : json['trn'] ?? "",
        differAmt : json['differ_amt'] ?? "",
        differType : json['differ_type'] ?? "",
        cycleStartDate : json['cycle_start_date'] ?? "",
        cycleEndDate : json['cycle_end_date'] ?? "",
        genrerateByCustomer : json['genrerate_by_customer'] ?? "",
        billReadingOld : json['bill_reading_old'] ?? "",
        billApproved : json['bill_approved'] ?? "",
        currentBillReading : json['current_bill_reading'] ?? "",
        isFirstBill : json['is_first_bill'] ?? "",
        actualReadingPrice : json['actual_reading_price'] ?? "",
        billingTaxAmount : json['billing_tax_amount'] ?? "",
        amountAfterTax : json['amount_after_tax'] ?? "",
        lateFeePeriod : json['late_fee_period'] ?? "",
        billingCycle : json['billing_cycle'] ?? "",
        lateFee : json['late_fee'] ?? "",
        amountAfterLateFee : json['amount_after_late_fee'] ?? "",
        gasDepositAmount : json['gas_deposit_amount'] ?? "",
        amountAfterGasDeposit : json['amount_after_gas_deposit'] ?? "",
        depositAmount : json['deposit_amount'] ?? "",
        amountAfterDeposit : json['amount_after_deposit'] ?? "",
        rebateAmount : json['rebate_amount'] ?? "",
        amountAfterRebate : json['amount_after_rebate'] ?? "",
        meterImage : json['meter_image'] ?? "",
        rejectReason : json['reject_reason'] ?? "",
        rejectDate : json['reject_date'] ?? "",
        billConfigId : json['bill_config_id'] ?? "",
        billingTaxId : json['billing_tax_id'] ?? "",
        extraCharges : json['extra_charges'] ?? "",
        afterExtraCharge : json['after_extra_charge'] ?? "",
        equipmentDeposit : json['equipment_deposit'] ?? "",
        afterEquipmentDeposit : json['after_equipment_deposit'] ?? "",
        prevBillAmount : json['prev_bill_amount'] ?? "",
        billLat : json['bill_lat'] ?? "",
        billLong : json['bill_long'] ?? "",
        adjustment : json['adjustment'] ?? "",
        paidAmount : json['paid_amount'] ?? "",
        remarks : json['remarks'] ?? "",
        balSecurityCharge : json['bal_security_charge'] ?? "",
        balExtraCharge : json['bal_extra_charge'] ?? "",
        balGasConsumptionCharge : json['bal_gas_consumption_charge'] ?? "",
        extraPipe : json['extra_pipe'] ?? "",
        userId : json['user_id'] ?? "",
        prevSecuritydepositAmount : json['prev_securitydeposit_amount'] ?? "",
        prevExtrachargeAmount : json['prev_extracharge_amount'] ?? "",
        unitCharge : json['unit_charge'] ?? "",
        lateFeeStatus : json['late_fee_status'] ?? "",
        website: json['website'] ?? "",
       billingAddress: json['billing_address'] ?? ""
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['scheme_name'] = this.schemeName;
    data['bp_number'] = this.bpNumber;
    data['meter_number'] = this.meterNumber;
    data['final_bill_amount'] = this.finalBillAmount;
    data['id'] = this.id;
    data['bill_no'] = this.billNo;
    data['bill_amt'] = this.billAmt;
    data['bill_due_date'] = this.billDueDate;
    data['bill_pay_date'] = this.billPayDate;
    data['cust_id'] = this.custId;
    data['bill_sta'] = this.billSta;
    data['bill_generated_date'] = this.billGeneratedDate;
    data['payment_mode'] = this.paymentMode;
    data['trn'] = this.trn;
    data['differ_amt'] = this.differAmt;
    data['differ_type'] = this.differType;
    data['cycle_start_date'] = this.cycleStartDate;
    data['cycle_end_date'] = this.cycleEndDate;
    data['genrerate_by_customer'] = this.genrerateByCustomer;
    data['bill_reading_old'] = this.billReadingOld;
    data['bill_approved'] = this.billApproved;
    data['current_bill_reading'] = this.currentBillReading;
    data['is_first_bill'] = this.isFirstBill;
    data['actual_reading_price'] = this.actualReadingPrice;
    data['billing_tax_amount'] = this.billingTaxAmount;
    data['amount_after_tax'] = this.amountAfterTax;
    data['late_fee_period'] = this.lateFeePeriod;
    data['billing_cycle'] = this.billingCycle;
    data['late_fee'] = this.lateFee;
    data['amount_after_late_fee'] = this.amountAfterLateFee;
    data['gas_deposit_amount'] = this.gasDepositAmount;
    data['amount_after_gas_deposit'] = this.amountAfterGasDeposit;
    data['deposit_amount'] = this.depositAmount;
    data['amount_after_deposit'] = this.amountAfterDeposit;
    data['rebate_amount'] = this.rebateAmount;
    data['amount_after_rebate'] = this.amountAfterRebate;
    data['meter_image'] = this.meterImage;
    data['reject_reason'] = this.rejectReason;
    data['reject_date'] = this.rejectDate;
    data['bill_config_id'] = this.billConfigId;
    data['billing_tax_id'] = this.billingTaxId;
    data['extra_charges'] = this.extraCharges;
    data['after_extra_charge'] = this.afterExtraCharge;
    data['equipment_deposit'] = this.equipmentDeposit;
    data['after_equipment_deposit'] = this.afterEquipmentDeposit;
    data['prev_bill_amount'] = this.prevBillAmount;
    data['bill_lat'] = this.billLat;
    data['bill_long'] = this.billLong;
    data['adjustment'] = this.adjustment;
    data['paid_amount'] = this.paidAmount;
    data['remarks'] = this.remarks;
    data['bal_security_charge'] = this.balSecurityCharge;
    data['bal_extra_charge'] = this.balExtraCharge;
    data['bal_gas_consumption_charge'] = this.balGasConsumptionCharge;
    data['extra_pipe'] = this.extraPipe;
    data['user_id'] = this.userId;
    data['prev_securitydeposit_amount'] = this.prevSecuritydepositAmount;
    data['prev_extracharge_amount'] = this.prevExtrachargeAmount;
    data['unit_charge'] = this.unitCharge;
    data['late_fee_status'] = this.lateFeeStatus;
    return data;
  }
}