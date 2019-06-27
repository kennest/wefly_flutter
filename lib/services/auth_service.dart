import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';

class AuthService {
  var login_url = "https://wa.weflysoftware.com/login/";
  Response response;

  Future<bool> login(String username, String password) async {
    response = await http.post(login_url);
    if (response != null) {
      var token = json.decode(response.body)['token'];
      print(token);
      return true;
    } else {
      return false;
    }
  }
}
