import 'package:flutter/material.dart';
import 'package:weflyapps/services/data_service.dart';
import 'package:weflyapps/models/models.dart';

enum Status { Uninitialized, loading, loaded,error }

class DataRepository with ChangeNotifier{

DataService dataService=DataService();
List<ReceivedAlert> _received=List();
Status _status = Status.Uninitialized;

Status get status => _status;
List<ReceivedAlert> get received => _received;


Future<void> fetchReceivedAlerts() async{
  _status=Status.loading;
  notifyListeners();
  print('Data loading...');
  _received=await dataService.getReceivedAlert();
  print("Length X-> ${_received.length}");
  _status=Status.loaded;
  notifyListeners();
  print('Data loaded...');
}
}