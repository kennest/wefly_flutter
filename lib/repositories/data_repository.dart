import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weflyapps/repositories/user_repository.dart';
import 'package:weflyapps/services/data_service.dart';
import 'package:weflyapps/models/models.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

enum Status { Uninitialized, loading, loaded, error }

class DataRepository with ChangeNotifier {
  DataService dataService = DataService();
  final UserRepository userRepository;
  List<ReceivedAlert> _received = List();
  List<Activite> _activities = List();
  List<Activite> _completed = List();
  List<Activite> _uncompleted = List();
  double _percent=0.0;
  Status _status = Status.Uninitialized;

  DataRepository(this.userRepository);

  Status get status => _status;
  List<Activite> get completed => _completed;
  List<ReceivedAlert> get received => _received;
  List<Activite> get activities => _activities;
  List<Activite> get uncompleted => _uncompleted;
  double get percent => _percent;

  //Fetch all received alerts
  Future<void> fetchReceivedAlerts() async {
    _status = Status.loading;
    notifyListeners();
    print('Data loading...');
    //Directory dir=Directory("/data/data/com.codebox.apps.wefly.weflyapps/files/Pictures/");
    Directory dir=await getApplicationDocumentsDirectory();
    _received = await dataService.getReceivedAlert();
    var prefs = await SharedPreferences.getInstance();

    for(ReceivedAlert a in _received){
      for(Piece p in a.alerte.properties.pieceJoinAlerte){
        //downloadFile(p.remote_piece);
        doDownload(p.remote_piece);
        Uri uri=Uri.parse(p.remote_piece);
        p.local_piece="${dir.path}${uri.pathSegments.last}";
      }
      doDownload(a.alerte.properties.categorie.remote_icone);
      Uri uri=Uri.parse(a.alerte.properties.categorie.remote_icone);
      a.alerte.properties.categorie.local_icone="${dir.path}${uri.pathSegments.last}";
    }
    print('Received 0-> + ${json.encode(_received.toList())}');
    prefs.setString("received", json.encode(_received.toList()));

    print("Length X-> ${_received.length}");
    _status = Status.loaded;
    notifyListeners();
    print('Data loaded...');
  }

  //Fetch all activities
  Future<void> fetchActivities() async {
    _status = Status.loading;
    notifyListeners();
    print('Data loading...');
    _activities = await dataService.getActivities();
    Directory dir=await getApplicationDocumentsDirectory();
    var prefs = await SharedPreferences.getInstance();

    for(Activite a in _activities){
      for(ImageFile p in a.image){
        doDownload("https://wa.weflysoftware.com/media/${p.remote_image}");
        Uri uri=Uri.parse(p.remote_image);
        p.local_image="${dir.path}${uri.pathSegments.last}";
      }
    }
    prefs.setString("activities", json.encode(activities.toList()));

    _completed=_activities.where((a){
      return a.statutAct=="Achevé";
    }).toList();
    _uncompleted=_activities.where((a){
      return a.statutAct=="Création";
    }).toList();
    computePercent();
    print("Length X-> ${_received.length}");
    print("Completed X-> ${_completed.length}");
    print("Uncompleted X-> ${_uncompleted.length}");
    _status = Status.loaded;
    notifyListeners();
    print('Data loaded...');
  }

  //Compute the percent of activities completed
  computePercent(){
   _percent= (_completed.length*100)/_activities.length;
   _percent=(_percent/100);
   print("Percent X-> ${_percent.toString()}");
   notifyListeners();
  }

  //Download a file
  Future<void> downloadFile(String url)async{
    Directory dir=await getApplicationDocumentsDirectory();
    //Directory path=Directory("/data/com.codebox.apps.wefly.weflyapps/files/Pictures/");
    final taskId = await FlutterDownloader.enqueue(
      url: url,
      savedDir: "${dir.path}",
      showNotification: true, // show download progress in status bar (for Android)
      openFileFromNotification: false, // click on notification to open downloaded file (for Android)
    );
  }

  Future<void> doDownload(String url)async{
    bool isConnected=await hasInternet();
    if(isConnected){
      HttpClient client = new HttpClient();
      Directory dir=await getApplicationDocumentsDirectory();
      //Directory dir=Directory("/data/Pictures/com.codebox.apps.wefly.weflyapps/Pictures/");
      var _downloadData = List<int>();
      Uri uri=Uri.parse(url);
      var fileSave = new File("${dir.path}${uri.pathSegments.last}");
      if(!fileSave.existsSync()){
        client.getUrl(Uri.parse(url))
            .then((HttpClientRequest request) {
          return request.close();
        })
            .then((HttpClientResponse response) {
          response.listen((d) => _downloadData.addAll(d),
              onDone: () {
                fileSave.writeAsBytes(_downloadData);
                print("Download Done!-> ${uri.pathSegments.last}");
              }
          );
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
