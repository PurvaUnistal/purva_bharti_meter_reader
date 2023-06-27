import '../models/generate_model.dart';
import 'api_helper.dart';
import 'package:http/http.dart' as http;
import '../../../../ExportFile/export_file.dart';

class ApiIntegration {


  Future<dynamic> bpNumberSearch(BPNumberRequestModel bpNumberRequestModel, BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString(GlobalConstants.token) ?? "";
    String queryString = Uri(queryParameters: bpNumberRequestModel.toJson()).query;
    var billsMeterReaderUrl = Apis.getPendingBillsMeterReader + '?' + queryString;
    print("getPendingBillsMeterReader-->" + billsMeterReaderUrl);
    try {
      final response = await http.get(Uri.parse(billsMeterReaderUrl),headers: {'authorization': '$token'}).timeout(Duration(seconds: 10));
      print("getPendingBillsMeterReader--->" + response.body);
      print("statusCode-->" + response.statusCode.toString());

      if (response.statusCode == 200) {
        BpNumberModel resp = BpNumberModel.fromJson(jsonDecode(response.body.toString()));
        return resp.data;
      } else if(response.statusCode == 403){
        SessionDialogUtils.logOut(context);
      }else if (response.statusCode == 500) {
        var resMessage = jsonDecode(response.body.toString());
        if (resMessage['data'] != null) {
          print("500-->" + resMessage['data']);
          ShowCustomToast.showToast(resMessage['data'].toString());
        }
        return null;
      } else if (response.statusCode == 400) {
        var resMessage = jsonDecode(response.body.toString());
        if (resMessage['data'] != null) {
          print("500-->" + resMessage['data']);
          ShowCustomToast.showToast(resMessage['data'].toString());
        }
        return null;
      }
    } on TimeoutException catch (e, s) {
      print("TimeoutException-->${e.message.toString()}");
      ShowCustomToast.scaffoldMsg(context, 'Your Server Side Is Slow');
    } catch (e) {
      print('catch error--> : $e');
      return null;
    }
  }

  Future<GenerateModel?> submitGenerateApi(GenerateRequestModel generateRequestModel, BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString(GlobalConstants.token) ?? "";
    try {
      var request = http.MultipartRequest("Post", Uri.parse(Apis.generate));
      Map<String, String> requestBody = <String, String>{
        "schema": generateRequestModel.schema.toString(),
        "bpNumber": generateRequestModel.bpNumber.toString(),
        "meter_reading": generateRequestModel.meter_reading.toString(),
        "meter_serial": generateRequestModel.meter_serial.toString(),
        "generate_by_customer": generateRequestModel.generate_by_customer.toString(),
        "latitude": generateRequestModel.latitude.toString(),
        "longitude": generateRequestModel.longitude.toString(),
        "old_reading": generateRequestModel.old_reading.toString(),
        "user_id": generateRequestModel.user_id.toString(),
        // "meter_image_file": generateRequestModel.meter_image_file,
      };
      request.headers["authorization"] = token;
      request.fields.addAll(requestBody);
      if (!(generateRequestModel.meter_image_file == null || generateRequestModel.meter_image_file == " ")) {
        var meterImage = await http.MultipartFile.fromPath("meter_image_file", generateRequestModel.meter_image_file.toString());
        request.files.add(meterImage);
      }
      print("Request" + requestBody.toString());
      var response = await request.send().timeout(Duration(seconds: 10));
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      print("Apis Generate Url" + Apis.generate);
      print("Response-->" + response.toString() + "responseString :" + responseString);
      if (response.statusCode == 200) {
        return GenerateModel.fromJson(json.decode(responseString));
      }else if(response.statusCode == 403){
        SessionDialogUtils.logOut(context);
      } else {
        return null;
      }
    } on TimeoutException catch (e, s) {
      print("TimeoutException-->${e.message.toString()}");
      ShowCustomToast.scaffoldMsg(context, 'Your Server Side Is Slow');
    } catch (e) {
      print('catch error--> : $e');
      ShowCustomToast.scaffoldMsg(context, e.toString());
      return null;
    }
    return null;
  }

  Future<ChangePasswordModel?> changePasswordApi(ChangePasswordResponse changePasswordResponse)async{
    String url = Apis.resetPassword;
    var res = await ApiHelper.postData(url: url, body: changePasswordResponse.toJson());
    try{
      if(res != null){
        return ChangePasswordModel.fromJson(res);
      } else{
        print("Null Data");
      }
    }catch(e){
      print(e.toString());
      CustomToast.showToast(e.toString());
    }
    return null;
  }
}
