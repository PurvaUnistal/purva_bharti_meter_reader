
class Apis {

 static String baseUrl = 'http://142.79.231.30:8084/api/';
 // static String baseUrl = 'https://citygas.hpcl.co.in/api/';
 static String login = 'login';
 static String auth =  baseUrl+'auth';
 static String getPendingBillsMeterReader =  baseUrl+'customer/getPendingBillsMeterReader';
 static String generate =  baseUrl+'customer/meter-reading/generate';
 static String billPrintData = baseUrl +'customer/getBillsbyBillID?bill_id=';
 static String billHistoryAApi = baseUrl +'customer/getAllBillsbyUserID?user_id=';
}
