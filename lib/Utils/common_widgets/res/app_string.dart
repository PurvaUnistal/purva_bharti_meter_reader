import 'app_config.dart';

class AppIcon {
  static String pbgplLogo = 'assets/icons/pbg_logo.png';
  static String mglLogo = 'assets/icons/mgl_logo.png';
  static String smartgasnet = 'assets/icons/smartgasnet.png';
}

class AppString {
  static String version =
      "Version : ${AppConfig.instanceInit()?.buildName} Meter Reader(14/08/2025)";
  static String companyName = "© Unistal Systems Pvt. Ltd.";
  static String GA = "GA ";
  static String userName = "User Name ";
  static String no = "No";
  static String preview = "Preview";
  static String submit = "Submit";
  static String login = "Login";
  static String logout = "Logout";
  static String logoutMsg =
      "Are you sure you want to logout? Once you logout, you will be return to login screen";
  static String star = "* ";
  static String emailLabel = "Enter Email Id";
  static String passwordLabel = "Enter Password";
  static String emailValidation = "Please enter email id";
  static String passwordValidation = "Please enter password";
  static String bpNumberSync = "BP/Meter Number...";
  static String bpNumber = "BP Number";
  static String mobileNumber = "Mobile Number";
  static String name = "Customer Name";
  static String buildName = "Building Name";
  static String colonyName = "Colony/Society/Apartment Name";
  static String streetName = "Lane/Street Name";
  static String town = "Town";
  static String district = "District";
  static String pinCode = "Pin Code";
  static String meterNumber = "Meter Number";
  static String preReading1 = "Previous Reading";
  static String preReading2 = "New Meter Initial Reading";
  static String photo = "Meter Photo";
  static String noData = "No Data Found";
}
