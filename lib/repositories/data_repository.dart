import 'package:flutter/material.dart';
import 'package:weflyapps/services/data_service.dart';
import 'package:weflyapps/models/models.dart';

enum Status { Uninitialized, loading, loaded,error }
class DataRepository with ChangeNotifier{
var dataService=DataService();
List<ReceivedAlert> _received=[];
Status _status = Status.Uninitialized;

Status get status => _status;

List<ReceivedAlert> get received => _received;

Future<List<ReceivedAlert>> getReceived() async{
  _status=Status.loading;
  notifyListeners();
  _received=await dataService.getReceivedAlert();
  notifyListeners();
  if(_received.length>0){
    _status=Status.loaded;
    notifyListeners();
  }
  return _received;
}
}