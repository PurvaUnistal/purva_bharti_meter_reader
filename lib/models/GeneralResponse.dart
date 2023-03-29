// To parse this JSON data, do
//
//     final generalResponse = generalResponseFromJson(jsonString);

import 'dart:convert';

GeneralResponse generalResponseFromJson(String str) => GeneralResponse.fromJson(json.decode(str));

String generalResponseToJson(GeneralResponse data) => json.encode(data.toJson());

class GeneralResponse {
    int? status;
    bool? error;
    String? messages;
    String? token;
    User? user;
    String? exptime;

    GeneralResponse(
        {this.status,
            this.error,
            this.messages,
            this.token,
            this.user,
            this.exptime});

    GeneralResponse.fromJson(Map<String, dynamic> json) {
        status = json['status'];
        error = json['error'];
        messages = json['messages'];
        token = json['token'];
        user = json['user'] != null ? new User.fromJson(json['user']) : null;
        exptime = json['exptime'];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['status'] = this.status;
        data['error'] = this.error;
        data['messages'] = this.messages;
        data['token'] = this.token;
        if (this.user != null) {
            data['user'] = this.user?.toJson();
        }
        data['exptime'] = this.exptime;
        return data;
    }
}

class User {
    String? id;
    String? bpNumber;
    String? dmaId;
    String? name;
    String? schema;
    String? crn;
    String? mobileNumber;
    String? serial_number;
    String? email;
    String? dateOfRegistration;
    String? address;
    String? area;
    String? locality;
    String? town;
    String? pincode;
    String? district;
    String? states;

    User(
        {this.id,
            this.bpNumber,
            this.dmaId,
            this.name,
            this.schema,
            this.crn,
            this.mobileNumber,
            this.serial_number,
            this.email,
            this.dateOfRegistration,
            this.address,
            this.area,
            this.locality,
            this.town,
            this.pincode,
            this.district,
            this.states});

    User.fromJson(Map<String, dynamic> json) {
        id = json['id'];
        bpNumber = json['bp_number'];
        dmaId = json['dma_id'];
        name = json['name'];
        schema = json['schema'];
        crn = json['crn'];
        mobileNumber = json['mobile_number'];
        serial_number = json['serial_number'];
        email = json['email'];
        dateOfRegistration = json['date_of_registration'];
        address = json['address'];
        area = json['area'];
        locality = json['locality'];
        town = json['town'];
        pincode = json['pincode'];
        district = json['district'];
        states = json['states'];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['bp_number'] = this.bpNumber;
        data['dma_id'] = this.dmaId;
        data['name'] = this.name;
        data['schema'] = this.schema;
        data['crn'] = this.crn;
        data['mobile_number'] = this.mobileNumber;
        data['serial_number'] = this.serial_number;
        data['email'] = this.email;
        data['date_of_registration'] = this.dateOfRegistration;
        data['address'] = this.address;
        data['area'] = this.area;
        data['locality'] = this.locality;
        data['town'] = this.town;
        data['pincode'] = this.pincode;
        data['district'] = this.district;
        data['states'] = this.states;
        return data;
    }
}