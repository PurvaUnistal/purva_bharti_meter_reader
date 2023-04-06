import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/custom_toast.dart';
import '../Utils/global_constant.dart';
import '../models/bp_number_model.dart';
import 'package:http/http.dart' as http;
import '../models/generate_model.dart';
import 'Apis.dart';


class ApiIntegration{

  Future<dynamic> bpNumberSearch(BPNumberRequestModel bpNumberRequestModel) async{
    String queryString = Uri(queryParameters: bpNumberRequestModel.toJson()).query;
    var billsMeterReaderUrl = Apis.getPendingBillsMeterReader+'?' + queryString;
    print("getPendingBillsMeterReader-->"+ billsMeterReaderUrl);
     var response = await http.get(Uri.parse(billsMeterReaderUrl));
    print("getPendingBillsMeterReader--->" + response.body);
      print("statusCode-->"+response.statusCode.toString());
      try {
        if (response.statusCode == 200) {
          BpNumberModel resp = BpNumberModel.fromJson(jsonDecode(response.body.toString()));
            return resp.data;
        } else if (response.statusCode == 500) {
          var resMessage =  jsonDecode(response.body.toString());
          if(resMessage['data'] != null){
            print("500-->" +resMessage['data']);
            ShowCustomToast.showToast(resMessage['data'].toString());
          }
          return null;
        } else if (response.statusCode == 400) {
          var resMessage =  jsonDecode(response.body.toString());
          if(resMessage['data'] != null){
            print("500-->" +resMessage['data']);
            ShowCustomToast.showToast(resMessage['data'].toString());
          }
          return null;
        }
      }
      catch (e) {
        print('catch error--> : $e');
        return null;
      }
  }

  Future<GenerateModel> submitgenerateApi(GenerateRequestModel generateRequestModel) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString(GlobalConstants.token) ?? "";
    var request = await http.MultipartRequest("Post", Uri.parse(Apis.generate));

    Map<String, String> requestBody = <String, String>{
      "schema": generateRequestModel.schema.toString(),
      "bpNumber": generateRequestModel.bpNumber.toString(),
      "meter_reading": generateRequestModel.meter_reading.toString(),
      "meter_serial": generateRequestModel.meter_serial.toString(),
      "generate_by_customer": generateRequestModel.generate_by_customer.toString(),
      "latitude": generateRequestModel.latitude.toString(),
      "longitude": generateRequestModel.longitude.toString(),
      "old_reading":generateRequestModel.old_reading.toString(),
      "user_id":generateRequestModel.user_id.toString(),
    // "meter_image_file": generateRequestModel.meter_image_file,
    };
    request.headers["authorization"] = token;
      request.fields.addAll(requestBody);
      if (!(generateRequestModel.meter_image_file == null ||generateRequestModel.meter_image_file == " ")) {
        var meterImage = await http.MultipartFile.fromPath( "meter_image_file", generateRequestModel.meter_image_file.toString());
        request.files.add(meterImage);
      }
    print("Request" + requestBody.toString());
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print("Apis Generate Url" + Apis.generate);
    print("Response-->" + response.toString() + "responseString :" + responseString);
    {
      if (response.statusCode == 200) {
        return GenerateModel.fromJson(json.decode(responseString));
      } else if(response.statusCode == 400){
        GenerateModel res =   GenerateModel.fromJson(json.decode(responseString));
        print("400-->" + res.toString());
        return res;
      } else if(response.statusCode == 404){
        GenerateModel res =   GenerateModel.fromJson(json.decode(responseString));
        print("404-->" + res.toString());
        return res;
      }else if(response.statusCode == 500){
        GenerateModel res =   GenerateModel.fromJson(json.decode(responseString));
        print("500-->" + res.toString());
        return res;
      } else {
        throw Exception('Failed to load data!');
      }
    }
  }

  }
