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
  var userId = 0;
  var sent_alert_url =
      "https://wa.weflysoftware.com/communications/api/alertes/";
  var get_employee_url =
      "https://wa.weflysoftware.com/communications/api/liste-employes/";

  var get_current_employee_url =
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
        received = await parseReceivedAlert(response);
        return received;
      }
    }
    return received;
  }

  Future<List<Category>> getCategories() async {
    var prefs = await SharedPreferences.getInstance();
    token = await prefs.get("token");
    isConnected = await hasInternet();
    List<Category> categories = [];
    response = await http.get(get_categories_url,
        headers: {HttpHeaders.authorizationHeader: token});
    categories = await parseCategory(response);
    return categories;
  }

  Future<List<Category>> parseCategory(http.Response response) async {
    List<Category> list = [];
    var results =
        json.decode(utf8.decode(response.bodyBytes))['results'] as List;
    results.forEach((i) async {
      Category c = Category.fromJson(i);
      list.add(c);
    });
    return list;
  }

  Future<List<ReceivedAlert>> parseReceivedAlert(http.Response response) async {
    List<ReceivedAlert> list = [];
    var results =
        json.decode(utf8.decode(response.bodyBytes))['results'] as List;
    results.forEach((i) async {
      ReceivedAlert a = ReceivedAlert.fromJson(i);
      list.add(a);
    });
    print('Received 0-> + ${json.encode(list.toList())}');
    return list;
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
        activities = await parseActivities(response);
        return activities;
      }
    }
    return activities;
  }

  Future<List<Activite>> parseActivities(http.Response response) async {
    List<Activite> list = [];
    var results = [];
    results = json.decode(utf8.decode(response.bodyBytes))['results'] as List;
    results.forEach((i) async {
      Activite a = Activite.fromJson(i);
      list.add(a);
    });
    print('Activities 0-> + ${json.encode(list.toList())}');
    print("Activities 0-> ${list.length}");
    return list;
  }

  //Update activity status
  Future<bool> updateActivite(send.Activite a) async {
    var prefs = await SharedPreferences.getInstance();
    token = await prefs.get("token");
    bool updated = false;
    print("Update act Body json -> ${json.encode(a.toJson())}");
    bool isConnected = await hasInternet();
    if (isConnected) {
      response = await http.put(get_activites_url,
          headers: {HttpHeaders.authorizationHeader: token},
          body: json.encode(a.toJson()));

      print("Update Act resp Code -> ${response.statusCode}");
      if (response.statusCode == 201 || response.statusCode == 200) {
        print(
            "Update Act resp -> ${json.decode(utf8.decode(response.bodyBytes))}");
        String res = json.decode(utf8.decode(response.bodyBytes));
        if (res == a.statutAct) {
          updated = true;
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
      if (response.statusCode == 201 || response.statusCode == 200) {
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
