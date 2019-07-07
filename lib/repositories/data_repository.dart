import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weflyapps/database/alerts_received_dao.dart';
import 'package:weflyapps/database/app_database.dart';
import 'package:weflyapps/services/data_service.dart';
import 'package:weflyapps/models/models.dart';
import 'package:weflyapps/models/send/activite.dart' as send;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

enum Status { Uninitialized, loading, loaded, error }

class DataRepository with ChangeNotifier {
  DataService dataService = DataService();

  AlertReceivedDao _alertReceivedDao=AlertReceivedDao();

  List<ReceivedAlert> _received = List();

  List<Activite> _activities = List();

  List<Activite> _completed = List();

  List<Activite> _uncompleted = List();

  double _percent = 0.0;

  Status _status = Status.Uninitialized;

  Status get status => _status;

  List<Activite> get completed => _completed;

  List<ReceivedAlert> get received => _received;

  List<Activite> get activities => _activities;

  List<Activite> get uncompleted => _uncompleted;

  double get percent => _percent;

  DataRepository.instance();

  //Fetch all received alerts
  Future<void> fetchReceivedAlerts() async {
    _status = Status.loading;
    notifyListeners();

    _received = await dataService.getReceivedAlert();

    var prefs = await SharedPreferences.getInstance();

    Directory dir = await getApplicationDocumentsDirectory();
    for (ReceivedAlert a in _received) {
      for (Piece p in a.alerte.properties.pieceJoinAlerte) {
        doDownload(p.remote_piece);
        Uri uri = Uri.parse(p.remote_piece);
        p.local_piece = "${dir.path}${uri.pathSegments.last}";
      }
      doDownload(a.alerte.properties.categorie.remote_icone);
      Uri uri = Uri.parse(a.alerte.properties.categorie.remote_icone);
      a.alerte.properties.categorie.local_icone =
          "${dir.path}${uri.pathSegments.last}";
    }

    _received.forEach((f){
      _alertReceivedDao.insert(f);
    });

    print('Received 0-> + ${json.encode(_received.toList())}');
    prefs.setString("received", json.encode(_received.toList()));

    print("Length X-> ${_received.length}");
    _status = Status.loaded;
    notifyListeners();
  }

  //Fetch all activities
  Future<void> fetchActivities() async {
    _status = Status.loading;
    notifyListeners();

    _activities = await dataService.getActivities();

    var prefs = await SharedPreferences.getInstance();

    _completed = _activities.where((a) {
      return a.statutAct == "Achevé";
    }).toList();

    _uncompleted = _activities.where((a) {
      return (a.statutAct == "Création" || a.statutAct == "En cours");
    }).toList();

    computePercent();

    await startDownloadActiviteFile(activities);

    prefs.setString("activities", json.encode(activities.toList()));

    _status = Status.loaded;
    notifyListeners();
  }

  Future<bool> updateActivite(send.Activite a) async {
    bool updated=await dataService.updateActivite(a);
    if(updated) {
      notifyListeners();
      return updated;
    }
    return updated;
  }

  //Compute the percent of activities completed
  computePercent() {
    _percent = (_completed.length * 100) / _activities.length;
    _percent = (_percent / 100);
    print("Percent X-> ${_percent.toString()}");
    notifyListeners();
  }

  startDownloadActiviteFile(List<Activite> list) async {
    Directory dir = await getApplicationDocumentsDirectory();
    for (Activite a in list) {
      print("Act 0 ${a.id} image size-> ${a.images.length}");
      for (ImageFile p in a.images) {
        doDownload("https://wa.weflysoftware.com/media/${p.remote_image}");
        Uri uri = Uri.parse(p.remote_image);
        p.local_image = "${dir.path}${uri.pathSegments.last}";
      }
      print("Act N ${a.id} image size-> ${a.images.length}");
    }
  }

  Future<void> doDownload(String url) async {
    bool isConnected = await hasInternet();
    if (isConnected) {
      HttpClient client = new HttpClient();
      Directory dir = await getApplicationDocumentsDirectory();
      //Directory dir=Directory("/data/Pictures/com.codebox.apps.wefly.weflyapps/Pictures/");
      var _downloadData = List<int>();
      Uri uri = Uri.parse(url);
      var fileSave = new File("${dir.path}${uri.pathSegments.last}");
      if (!fileSave.existsSync()) {
        client.getUrl(Uri.parse(url)).then((HttpClientRequest request) {
          return request.close();
        }).then((HttpClientResponse response) {
          response.listen((d) => _downloadData.addAll(d), onDone: () {
            fileSave.writeAsBytes(_downloadData);
            print("Download Done!-> ${uri.pathSegments.last}");
          });
        });
      }
    }
  }

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
}
