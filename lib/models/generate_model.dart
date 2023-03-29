class GenerateModel {
  bool? error;
  int? code;
  String? pdf;
  String? message;
  dynamic? billId;

  GenerateModel({this.error, this.code, this.pdf, this.message, this.billId});

  GenerateModel.fromJson(Map<String, dynamic> json) {
    error = json['error'] ?? "";
    code = json['code'] ?? "";
    pdf = json['pdf'] ?? "";
    message = json['message'] ?? "";
    billId = json['BillID'] ?? "0";
  }
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['code'] = this.code;
    data['pdf'] = this.pdf;
    data['message'] = this.message;
    data['BillID'] = this.billId;
    return data;
  }
}


class GenerateRequestModel{
  final String? schema;
  final String? bpNumber;
  final String? meter_reading;
  final String? meter_serial;
  final String? meter_image_file;
  final String? generate_by_customer;
  final String? latitude;
  final String? longitude;
  final String? old_reading;
  final String? user_id ;

  const GenerateRequestModel( {
    this.bpNumber,
    this.schema,
    this.meter_reading,
    this.generate_by_customer,
    this.latitude,
    this.longitude,
    this.meter_image_file,
    this.meter_serial,
    this.old_reading,
    this.user_id
  });
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "bpNumber": bpNumber?.trim(),
      "meter_reading": meter_reading.toString().trim(),
      "meter_serial": meter_serial.toString().trim(),
      "meter_image_file": meter_image_file.toString().trim(),
      "schema": schema.toString().trim(),
      "generate_by_customer": generate_by_customer.toString().trim(),
      "latitude": latitude.toString().trim(),
      "longitude": longitude.toString().trim(),
      "old_reading": old_reading.toString().trim(),
      "user_id": user_id?.trim(),
    };
    return map ;
  }
}

