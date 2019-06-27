import 'package:flutter/widgets.dart';
import 'package:weflyapps/services/services.dart';

class UserRepository with ChangeNotifier{
  var authService=AuthService();
}