import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weflyapps/models/models.dart';
import 'package:weflyapps/repositories/user_repository.dart';
import 'pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  UserRepository userRepository;
  TextEditingController userCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userRepository = UserRepository();
    _checkToken();
    userCtrl.text="kenyoulai@gmail.com";
    passCtrl.text="admin12345";
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
    return ChangeNotifierProvider<UserRepository>.value(
      value: userRepository,
      child: Consumer(builder: (context, UserRepository user, child) {
        switch (user.status) {
          case Status.Uninitialized:
            return body();
          case Status.Authenticating:
            return Scaffold(
              body:Center(
                child: CircularProgressIndicator(),
              ),
            );
          case Status.Authenticated:
            return HomePage();
          case Status.Unauthenticated:
            return body();
        }
      }),
    );
  }

  Widget body() {
    return Scaffold(
      body: SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/bg.jpg'),
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.5), BlendMode.srcATop),
                      fit: BoxFit.cover)),
              child: Container(
                margin: EdgeInsets.fromLTRB(20.0, 200.0, 20.0, 200.0),
                padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                color: Colors.white.withOpacity(0.95),
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      child:Image.asset(
                      'assets/images/logo.png',),
                      backgroundColor: Colors.white.withOpacity(0.95),
                    ),
                    TextFormField(
                      controller: userCtrl,
                      decoration: InputDecoration(labelText: "Username"),
                    ),
                    TextFormField(
                      controller: passCtrl,
                      decoration: InputDecoration(labelText: "password",),
                      obscureText: true,
                    ),
                    RaisedButton(
                      child: Text("Login"),
                      onPressed: () {
                        Credential c = Credential(userCtrl.text, passCtrl.text);
                        userRepository.doLogin(c);
                      },
                    )
                  ],
                ),
              ))),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //Provider.of<UserRepository>(context).dispose();
  }
}
