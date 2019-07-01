import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  _SplashPageState createState() => _SplashPageState();
}



class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkToken();
  }

  _checkToken()async{
    var prefs=await SharedPreferences.getInstance();
    if(prefs.containsKey("token")){
      print('Token -> ${prefs.get("token")}');
      Navigator.pushNamed(context, '/home');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(begin:Alignment.topCenter,end: Alignment.bottomCenter,colors: [Colors.green[700],Colors.green[300],Colors.green[100]],tileMode: TileMode.mirror)
          ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/logo.png',
              height: 180.0,
              width: 180.0,
            ),
            RaisedButton(onPressed: (){
              Navigator.of(context).pushNamed('/login');
            },child: Text("Suivant"),)
          ],
        )
        
      ),
    ));
  }
}
