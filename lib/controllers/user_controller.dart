import 'package:flutter/widgets.dart';
import 'package:weflyapps/models/models.dart';
import 'package:weflyapps/services/services.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class UserController with ChangeNotifier {
  var authService = AuthService();
  User _user;
  Status _status = Status.Uninitialized;

  User get user => _user;
  Status get status => _status;

  UserController.instance();

  void doLogin(Credential c) async {
    _status = Status.Authenticating;
    notifyListeners();
    bool loggedIn = await authService.login(c.username, c.password);
    if (loggedIn) {
      _status = Status.Authenticated;
      notifyListeners();
    } else {
      _status = Status.Unauthenticated;
      notifyListeners();
    }
  }

  void doLogout() async {
    bool loggedOut = await authService.logout();
    if (loggedOut) {
      print("Logout -> $loggedOut");
      _status = Status.Unauthenticated;
      notifyListeners();
    }
  }
}
