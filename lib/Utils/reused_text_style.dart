import 'package:flutter/material.dart';

class ReusedTextStyle{

  static const TextStyle billAmount = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Colors.black87
  );

  static const TextStyle amount = TextStyle(
      fontWeight: FontWeight.w200,
      color: Colors.grey,
      fontSize: 16,
      shadows: [
/*        Shadow(
            color: Colors.black,
            blurRadius: 1,
            offset: Offset(1, 1)),*/
      ]
  );

  static const TextStyle userName = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Colors.black87
  );

  static const TextStyle viewBill = TextStyle(
      fontWeight:FontWeight.bold,
      letterSpacing:0.1,
      fontSize: 18,
      color: Colors.blue);

  static const TextStyle bpNumber = TextStyle(
      fontWeight:FontWeight.w300,
      fontSize:16,
      decoration:TextDecoration.underline,
      color: Colors.black87
  );

  static const TextStyle menus = TextStyle(
      fontSize: 12,
      color: Colors.black87
  );
  static const TextStyle pngSERVICES = TextStyle(
      fontWeight:
      FontWeight.w300,
      fontSize: 16,
      color: Colors.black87
  );
  static const TextStyle bottomCaption = TextStyle(color: Colors.black);
  static const TextStyle number = TextStyle(
      color: Colors.grey
  );

  static const TextStyle login = TextStyle(
    color: Colors.white,
    fontSize: 15,
  );
  static const TextStyle dataColumnStyle =  TextStyle(
  fontStyle: FontStyle.italic,
  color: Colors.white,
  );
  static const TextStyle inVoiceDOWNLOAD =  TextStyle(
      color: Colors.white,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold);
  static const TextStyle currentMeeterReader =  TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      color: Colors.black);

}