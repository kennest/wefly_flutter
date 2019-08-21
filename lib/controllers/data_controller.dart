import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weflyapps/database/activities_dao.dart';
import 'package:weflyapps/database/alerts_received_dao.dart';
import 'package:weflyapps/database/app_database.dart';
import 'package:weflyapps/database/categories_dao.dart';
import 'package:weflyapps/services/data_service.dart';
import 'package:weflyapps/models/models.dart';
import 'package:weflyapps/models/send/activite.dart' as send;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:location/location.dart';

enum Status { Uninitialized, loading, loaded, error }

class DataController with ChangeNotifier {
  DataService dataService = DataService();
  var location = Location();

  AlertReceivedDao _alertReceivedDao = AlertReceivedDao();
  ActivitiesDao _activitiesDao = ActivitiesDao();
  CategoriesDao _categoriesDao = CategoriesDao();

  List<ReceivedAlert> _received = List();

  List<Activite> _activities = List();

  List<Activite> _completed = List();

  List<Activite> _uncompleted = List();

  List<Category> _categories = List();

  double _percent = 0.0;

  Status _status = Status.Uninitialized;

  Status get status => _status;

  List<Activite> get completed => _completed;

  List<ReceivedAlert> get received => _received;

  List<Activite> get activities => _activities;

  List<Activite> get uncompleted => _uncompleted;

  List<Category> get categories => _categories;

  double get percent => _percent;

  DataController.instance();

  //Fetch all received alerts
  Future<void> fetchReceivedAlerts() async {
    _status = Status.loading;
    notifyListeners();

    bool isConnected = await hasInternet();

    if (isConnected) {
      _received = await dataService.getReceivedAlert();
      await startDownloadAlertFile(_received);
      _received.forEach((f) {
        _alertReceivedDao.insert(f);
      });
    } else {
      _received = await _alertReceivedDao.getAllSortedByName();
      for (ReceivedAlert a in _received) {
        for (Piece p in a.alerte.properties.pieceJoinAlerte) {
          print("piece -> ${p.local_piece} ");
        }
      }
    }

    print('Received 0-> + ${json.encode(_received.toList())}');
    _status = Status.loaded;
    notifyListeners();
  }

  //Fetch all activities
  Future<void> fetchActivities() async {
    _status = Status.loading;
    notifyListeners();

    bool isConnected = await hasInternet();

    if (isConnected) {
      _activities = await dataService.getActivities();
      await startDownloadActiviteFile(_activities);
      _activities.forEach((f) async {
        await _activitiesDao.insert(f);
      });
      print("Activities length 0-> ${_activities.length}");
    } else {
      _activities = await _activitiesDao.getAllSortedByName();
      print("Activities length N-> ${_activities.length}");
    }

    _completed = _activities.where((a) {
      return a.statutAct == "Achevé";
    }).toList();

    _uncompleted = _activities.where((a) {
      return (a.statutAct == "Création" || a.statutAct == "En cours");
    }).toList();

    computePercent();

    _status = Status.loaded;
    notifyListeners();
  }

  Future<void> fetchCategories() async {
    _status = Status.loading;
    notifyListeners();

    bool isConnected = await hasInternet();
    if (isConnected) {
      _categories = await dataService.getCategories();
      for (Category c in _categories) {
        Directory dir = await getApplicationDocumentsDirectory();
        await doDownload(c.remote_icone);
        Uri uri = Uri.parse(c.remote_icone);
        c.local_icone = "${dir.path}${uri.pathSegments.last}";
      }

      _categories.forEach((n) {
        _categoriesDao.insert(n);
      });
    } else {
      _categories = await _categoriesDao.getAllSortedById();
    }
    _status = Status.loaded;
    notifyListeners();
  }

  Future<bool> updateActivite(send.Activite a) async {
    bool updated = await dataService.updateActivite(a);
    if (updated) {
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

//attempt to download image of the activities
  startDownloadActiviteFile(List<Activite> list) async {
    Directory dir = await getApplicationDocumentsDirectory();
    for (Activite a in list) {
      print("Act 0 ${a.id} image size-> ${a.images.length}");
      for (ImageFile p in a.images) {
        await doDownload(
            "https://wa.weflysoftware.com/media/${p.remote_image}");
        Uri uri = Uri.parse(p.remote_image);
        p.local_image = "${dir.path}${uri.pathSegments.last}";
        print("Local image -> ${p.local_image}");
      }
      print("Act N ${a.id} image size-> ${a.images.length}");
    }
  }

//attempt to download image of the received alerts
  startDownloadAlertFile(List<ReceivedAlert> list) async {
    Directory dir = await getApplicationDocumentsDirectory();
    for (ReceivedAlert a in list) {
      for (Piece p in a.alerte.properties.pieceJoinAlerte) {
        await doDownload(p.remote_piece);
        Uri uri = Uri.parse(p.remote_piece);
        p.local_piece = "${dir.path}${uri.pathSegments.last}";
      }
      await doDownload(a.alerte.properties.categorie.remote_icone);
      Uri uri = Uri.parse(a.alerte.properties.categorie.remote_icone);
      a.alerte.properties.categorie.local_icone =
          "${dir.path}${uri.pathSegments.last}";
    }
  }

//Pure download task
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
            print("Download Done! -> ${uri.pathSegments.last}");
            notifyListeners();
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

  getLocation() async {
    var prefs = await SharedPreferences.getInstance();
    location.onLocationChanged().listen((LocationData currentLocation) {
      String loc = "${currentLocation.longitude}:${currentLocation.latitude}";
      prefs.setString("location", loc);
      print(currentLocation.latitude);
      print(currentLocation.longitude);
    });
  }
}
