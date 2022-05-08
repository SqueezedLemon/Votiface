import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Eligible with ChangeNotifier {
  bool isEligible = false;

  Future<bool> checkeligibility(String cNo
  ) async {
    const _url = 'https://vote-face-recog.herokuapp.com/account-api/user/check_citizenship/';
    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'citizenship': cNo,
     
          },
        ),
      );
      print('ddd $cNo');
      final responseData = json.decode(response.body);
      if(response.statusCode == 403){
        print('invalid');
        throw ('Error : No citizenship Record Found');
      }else{
        isEligible = responseData['eligible'];
      }
      print('response $responseData $cNo');

      return isEligible;
    } catch (error) {
      print('error here');
      rethrow;
    }
  }

}