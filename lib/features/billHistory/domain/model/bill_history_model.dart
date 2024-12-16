List<BillHistoryModel> billHistoryResponse(var json) {
  return List<BillHistoryModel>.from(
      json.map((x) => BillHistoryModel.formJson(x)));
}

class BillHistoryModel {

  dynamic billId;
  String? meterNumber;
  String? bpNumber;
  String? fistName;
  String? lastName;
  dynamic mobileNumber;
  String? houseNumber;
  String? locality;
  String? area;

  BillHistoryModel(
  {this.billId,
    this.meterNumber,
    this.bpNumber,
    this.fistName,
    this.lastName,
    this.mobileNumber,
    this.houseNumber,
    this.locality,
    this.area});

  factory BillHistoryModel.formJson(Map<String, dynamic>  json) {
    return BillHistoryModel(
       billId: json['BillID'] ?? "0",
       meterNumber: json['meter_number'] ?? "0",
       bpNumber: json['bp_number'] ?? "0",
       fistName: json['first_name'] ?? "",
       lastName: json['last_name'] ?? "",
       mobileNumber: json['mobile_number'] ?? "0",
       houseNumber: json['house_number'] ?? "",
       locality: json['locality'] ?? "",
       area: json['area'] ?? "",
    );
  }
}