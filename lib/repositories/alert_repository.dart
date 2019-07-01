import 'package:flutter/material.dart';
import 'package:weflyapps/services/data_service.dart';
import 'package:weflyapps/models/models.dart';

enum Status { Uninitialized, loading, loaded,error }
class AlertRepository with ChangeNotifier{
var dataService=DataService();
List<ReceivedAlert> received=[];
Status _status = Status.Uninitialized;

Status get status => _status;

Future<List<ReceivedAlert>> getReceived() async{
  _status=Status.loading;
  notifyListeners();
  received=await dataService.getReceivedAlert();
  if(received.length>0){
    _status=Status.loaded;
    notifyListeners();
  }
  return received;
}
}