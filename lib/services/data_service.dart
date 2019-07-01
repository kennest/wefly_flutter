import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weflyapps/models/received_alert.dart';
import 'dart:convert';
import 'package:weflyapps/models/sent_alert.dart';

class DataService {
  var sent_alert_url =
      "https://wa.weflysoftware.com/communications/api/alertes/";
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

  Future<List<ReceivedAlert>> getReceivedAlert() async {
    var prefs = await SharedPreferences.getInstance();
    token = await prefs.get("token");
    List<ReceivedAlert> received = [];
    response = await http.get(received_alert_url,
        headers: {HttpHeaders.authorizationHeader: token});
    if (response != null) {
      print(response.body);
      var next = json.decode(response.body)['next'];
      var results = json.decode(response.body)['results'] as List;
      received = results.map((i) => ReceivedAlert.fromJson(i)).toList();
      prefs.setString("received", received.toString());
      print("Size -> ${received.length}");
    }
    return received;
  }
}
