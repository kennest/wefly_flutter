import 'package:flutter/material.dart';
import 'package:weflyapps/services/data_service.dart';
import 'package:weflyapps/models/models.dart';

enum Status { Uninitialized, loading, loaded, error }

class DataRepository with ChangeNotifier {
  DataService dataService = DataService();
  List<ReceivedAlert> _received = List();
  List<Activite> _activities = List();
  List<Activite> _completed = List();
  List<Activite> _uncompleted = List();
  double _percent=0.0;
  Status _status = Status.Uninitialized;

  Status get status => _status;
  List<Activite> get completed => _completed;
  List<ReceivedAlert> get received => _received;
  List<Activite> get activities => _activities;
  List<Activite> get uncompleted => _uncompleted;
  double get percent => _percent;

  Future<void> fetchReceivedAlerts() async {
    _status = Status.loading;
    notifyListeners();
    print('Data loading...');
    _received = await dataService.getReceivedAlert();
    print("Length X-> ${_received.length}");
    _status = Status.loaded;
    notifyListeners();
    print('Data loaded...');
  }

  Future<void> fetchActivities() async {
    _status = Status.loading;
    notifyListeners();
    print('Data loading...');
    _activities = await dataService.getActivities();
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

  computePercent(){
   _percent= (_completed.length*100)/_activities.length;
   _percent=(_percent/100);
   print("Percent X-> ${_percent.toString()}");
   notifyListeners();
  }

}
