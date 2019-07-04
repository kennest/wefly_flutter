import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';
import 'package:weflyapps/models/models.dart';
import 'package:weflyapps/models/send/activite.dart' as send;
import 'package:weflyapps/models/received_alert.dart';
import 'package:location/location.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class DataService {
  var sent_alert_url =
      "https://wa.weflysoftware.com/communications/api/alertes/";
  var get_employee_url =
      "https://wa.weflysoftware.com/communications/api/liste-employes/";
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
  var location = Location();

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
        var next = json.decode(utf8.decode(response.bodyBytes))['next'];
        var results =
            json.decode(utf8.decode(response.bodyBytes))['results'] as List;
        results.forEach((i) async {
          ReceivedAlert a = ReceivedAlert.fromJson(i);
          received.add(a);
        });
        print('Received 0-> + ${json.encode(received.toList())}');
        prefs.setString("received", json.encode(received.toList()));
        print("Received 0-> ${received.length}");
        return received;
      }
    } else {
      var data = prefs.get("received");
      print('Received 1->' + json.decode(data).toString());
      if (data != null) {
        var results = json.decode(data) as List;
        results.forEach((i) async {
          ReceivedAlert a = ReceivedAlert.fromJson(i);
          received.add(a);
        });

        print("Received 1-> ${received.length}");
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
        var next = json.decode(utf8.decode(response.bodyBytes))['next'];
        var results =
            json.decode(utf8.decode(response.bodyBytes))['results'] as List;
        results.forEach((i) async {
          Activite a = Activite.fromJson(i);
          activities.add(a);
        });
        print('Activities 0-> + ${json.encode(activities.toList())}');
        prefs.setString("activities", json.encode(activities.toList()));
        print("Activities 0-> ${activities.length}");
        return activities;
      }
    } else {
      var data = prefs.get("activities");
      print('Activities 1->' + json.decode(data).toString());
      if (data != null) {
        var results = json.decode(data) as List;
        results.forEach((i) async {
          Activite a = Activite.fromJson(i);
          activities.add(a);
        });
        print("Activities 1-> ${activities.length}");
        return activities;
      }
    }
    return activities;
  }

  //Update activity status
  Future<bool> updateActivite(send.Activite a) async {
    var prefs = await SharedPreferences.getInstance();
    token = await prefs.get("token");
    bool updated=false;
    print("Update act Body json -> ${json.encode(a.toJson())}");
    bool isConnected = await hasInternet();
    if (isConnected) {
      response = await http.put(get_activites_url,
          headers: {HttpHeaders.authorizationHeader: token},
          body: json.encode(a.toJson()));

      print("Update Act resp Code -> ${response.statusCode}");
      if (response.statusCode == 201 || response.statusCode==200) {
        print("Update Act resp -> ${json.decode(utf8.decode(response.bodyBytes))}");
        String res=json.decode(utf8.decode(response.bodyBytes));
        if(res==a.statutAct){
          updated=true;
          a.images.forEach((i) async {
            await sendActiviteImage(i, a);
          });
          return updated;
        }
      }
      return updated;
    }
  }

  //Send activivity Image
  Future<void> sendActiviteImage(ImageFile image, send.Activite a) async {
    bool isConnected = await hasInternet();
    var prefs = await SharedPreferences.getInstance();
    token = await prefs.get("token");
    if (isConnected) {
      Uri uri = Uri.parse(image.local_image);
      File f = File(image.local_image);
      List<int> imageBytes = await f.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      Map data = {
        'image': base64Image,
        'id_activite': a.id,
        'piece_name': uri.pathSegments.last
      };

      print("Send Act Images Body json-> ${json.encode(data)}");

      response = await http.post(send_activites_images_url,
          headers: {HttpHeaders.authorizationHeader: token},
          body: json.encode(data));

      print("Send Act Image resp Code -> ${response.statusCode}");
      if (response.statusCode == 201 || response.statusCode==200) {
        print("Send Act Images resp -> ${json.decode(response.body)}");
      }
    }
  }

  getLocation() async {
    location.onLocationChanged().listen((LocationData currentLocation) {
      print(currentLocation.latitude);
      print(currentLocation.longitude);
    });
  }
}
