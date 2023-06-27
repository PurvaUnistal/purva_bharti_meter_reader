import '../../../../ExportFile/export_file.dart';

class ApiHelper{
  static get baseUrl => Apis.baseUrl;

  static Future<dynamic> getData({required String url, required BuildContext context}) async {
    try{
      Uri  uri = Uri.parse(baseUrl+url);
      var res = await get(uri);
      if(res.statusCode == 200){
        return jsonDecode(res.body);
      } else{
        return Api.error;
      }
    }catch(e){
      CustomToast.showToast(e.toString());
      return Api.error;
    }
  }

  static Future<dynamic> postData({required String url, @required var body}) async {
    try{
      var res =  await post(Uri.parse(url), body: body);
      print(res.body);
      if(res.statusCode == 200){
        return jsonDecode(res.body);
      }else{
        return Api.error;
      }
    }catch(e){
      print(e.toString());
      CustomToast.showToast(e.toString());
      return Api.error;
    }
  }
}

enum Api{error}