import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weflyapps/pages/home/received_page.dart';
import 'package:weflyapps/pages/home/sent_page.dart';
import 'package:weflyapps/repositories/user_repository.dart';
import 'package:weflyapps/services/data_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  PageController _pageController=PageController();
  var currentIndex=0;
  DataService dataService;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dataService=DataService();
    dataService.getReceivedAlert();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wefly"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Provider.of<UserRepository>(context).doLogout();
            },
          )
        ],
      ),
      drawer: Drawer(
        elevation: 5.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ListTile(
              title: Text("Profile"),
              onTap: () {},
            ),
            ListTile(
              title: Text("Parametres"),
              onTap: () {},
            )
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        children: <Widget>[SentPage(), ReceivedPage()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.green[800],
        onTap: (pos){
          print(pos);
            _pageController.animateToPage(pos, duration: Duration(seconds: 1), curve: Curves.decelerate);
            setState(() {
              currentIndex=pos;
            });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.send),title: Text("Send")),
          BottomNavigationBarItem(icon: Icon(Icons.receipt),title: Text("Received")),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){},
      ),
    );
  }
}
