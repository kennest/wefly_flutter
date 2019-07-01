import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  String loginUrl = "https://wa.weflysoftware.com/login/";
  Response response;

  //Do login
  Future<bool> login(String username, String password) async {
    Map data = {"username":username,"password":password};
    response = await http.post(loginUrl,body: json.encode(data));
    if (response != null) {
      print('Response -> ${response.body}');
      var token = json.decode(response.body)['token'];
      print(token);
      var pref = await SharedPreferences.getInstance();
      pref.setString("token", "JWT $token");
      return true;
    } else {
      return false;
    }
  }

  //Do logout
  Future<bool> logout() async {
    var pref = await SharedPreferences.getInstance();
    pref.remove("token");
    return true;
  }
}
