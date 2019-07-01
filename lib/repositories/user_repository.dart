import 'package:flutter/widgets.dart';
import 'package:weflyapps/models/models.dart';
import 'package:weflyapps/services/services.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class UserRepository with ChangeNotifier {
  var authService = AuthService();
  User _user;

  Status _status = Status.Uninitialized;

  User get user => _user;

  Status get status => _status;

  void doLogin(Credential c) async {
    _status=Status.Authenticating;
    notifyListeners();
    bool loggedIn = await authService.login(c.username, c.password);
    if(loggedIn){
      _status=Status.Authenticated;
      notifyListeners();
    }else{
      _status=Status.Unauthenticated;
      notifyListeners();
    }
  }

  void doLogout()async{
    bool loggedOut=await authService.logout();
    if(loggedOut){
      _status=Status.Unauthenticated;
      notifyListeners();
    }
  }
}
