import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weflyapps/models/models.dart';
import 'package:weflyapps/models/received_alert.dart';
import 'dart:convert';

class DataService {
  var sent_alert_url = "https://wa.weflysoftware.com/communications/api/alertes/";
  var get_employee_url = "https://wa.weflysoftware.com/communications/api/liste-employes/";
  var received_alert_url =
      "https://wa.weflysoftware.com/communications/api/alerte-receive-status/";
  var send_pieces_url =
      "https://wa.weflysoftware.com/communications/api/files/";
  var get_categories_url =
      "https://wa.weflysoftware.com/communications/api/categorie-alerte/";
  var get_activites_url = "https://wa.weflysoftware.com/noeuds/api/activite/";
  var send_activites_images_url =
      "https://wa.weflysoftware.com/noeuds/api/images/";
  var send_report_url =
      "https://wa.weflysoftware.com/geolocation/get-user-position/";
  Response response;
  var token;
  var prefs;
  bool isConnected;

  //Check Internet Access
  Future<bool> hasInternet() async {
    bool connected;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        connected = true;
      }
    } on SocketException catch (_) {
      print('not connected');
      connected = false;
    }
    return connected;
  }

  //Get received alerts
  Future<List<ReceivedAlert>> getReceivedAlert() async {
    var prefs = await SharedPreferences.getInstance();
    token = await prefs.get("token");
    List<ReceivedAlert> received = [];
    isConnected = await hasInternet();
    if (isConnected) {
      response = await http.get(received_alert_url,
          headers: {HttpHeaders.authorizationHeader: token});
      if (response != null) {
        print(response.body);
        var next = json.decode(utf8.decode(response.bodyBytes))['next'];
        var results = json.decode(utf8.decode(response.bodyBytes))['results'] as List;
        results.forEach((i) async{
          ReceivedAlert a = ReceivedAlert.fromJson(i);
          received.add(a);
        });
        print('Result 0-> + ${json.encode(received.toList())}');
        prefs.setString("received", json.encode(received.toList()));
        print("Size 0-> ${received.length}");
        return received;
      }
    } else {
      var data = prefs.get("received");
      print('Result 1->' + json.decode(data).toString());
      if (data != null) {
        var results = json.decode(data) as List;
        results.forEach((i) async{
          ReceivedAlert a = ReceivedAlert.fromJson(i);
          received.add(a);
        });
        print("Size 1-> ${received.length}");
        return received;
      }
    }
    return received;
  }


  //Get activities
  Future<List<Activite>> getActivities() async {
    var prefs = await SharedPreferences.getInstance();
    token = await prefs.get("token");
    List<Activite> activities = [];
    isConnected = await hasInternet();
    if (isConnected) {
      response = await http.get(get_activites_url,
          headers: {HttpHeaders.authorizationHeader: token});
      if (response != null) {
        print(response.body);
        var next = json.decode(utf8.decode(response.bodyBytes))['next'];
        var results = json.decode(utf8.decode(response.bodyBytes))['results'] as List;
        results.forEach((i) async{
          Activite a = Activite.fromJson(i);
          activities.add(a);
        });
        print('Result 0-> + ${json.encode(activities.toList())}');
        prefs.setString("activities", response.body);
        print("Size 0-> ${activities.length}");
        return activities;
      }
    } else {
      var data = prefs.get("activities");
      print('Result 1->' + json.decode(data).toString());
      if (data != null) {
        var results = json.decode(data)['results'] as List;
        results.forEach((i) async{
          Activite a = Activite.fromJson(i);
          activities.add(a);
        });
        print("Size 1-> ${activities.length}");
        return activities;
      }
    }
    return activities;
  }


}
