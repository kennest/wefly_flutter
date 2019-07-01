import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weflyapps/pages/home/received_page.dart';
import 'package:weflyapps/pages/home/sent_page.dart';
import 'package:weflyapps/repositories/data_repository.dart';
import 'package:weflyapps/repositories/user_repository.dart';
import 'package:weflyapps/services/data_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  DataRepository dataRepository;
  var currentIndex = 0;
  DataService dataService;

  @override
  void initState() {
    super.initState();
    dataRepository = DataRepository();
    dataService = DataService();
    dataService.getReceivedAlert();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (_) => dataRepository,
      child: Consumer(builder: (context, DataRepository data, _) {
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
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  "Bonjour Oulai Kennest.",
                  style: TextStyle(color: Colors.green[800], fontSize: 40.0),
                ),
                Container(
                  margin: EdgeInsets.all(5.0),
                  height: 140.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.green[800]),
                  child: Wrap(
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.fromLTRB(8.0, 15.0, 10.0, 0.0),
                                child: Row(
                                  children: <Widget>[
                                    CircleAvatar(
                                      child:Icon(Icons.add_alert),
                                    ),
                                    Text("Feu de Brousse",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                                child: Text(
                                  "Description of the last alert",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.fromLTRB(35.0,45.0,0.0,0.0),
                              child: FloatingActionButton(
                                backgroundColor: Colors.white,
                                onPressed: () {},
                                child: Text("Ok",style: TextStyle(color: Colors.green[800]),),
                              ))
                        ],
                      ),
                    ],
                  )

                ),
                SizedBox(
                  height: 8.0,
                ),
                Container(
                    margin: EdgeInsets.all(5.0),
                    height: 140.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.white),
                    child: Wrap(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.fromLTRB(8.0, 15.0, 10.0, 0.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text("Vos activites de la journee",
                                          style: TextStyle(
                                              color: Colors.green[800],
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                                  child: Text(
                                    "1 sur 4 completés",
                                    style: TextStyle(color: Colors.green),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                                padding: EdgeInsets.fromLTRB(35.0,45.0,0.0,0.0),
                                child: FloatingActionButton(
                                  backgroundColor: Colors.green[800],
                                  onPressed: () {},
                                  child: Text("24%",style: TextStyle(color: Colors.white),),
                                ))
                          ],
                        ),
                      ],
                    )

                ),
              ],
            ),
          ),
          bottomNavigationBar: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.flag),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.receipt),
                onPressed: () {},
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.green[800],
            child: Icon(Icons.add),
            onPressed: () {},
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Provider.of<UserRepository>(context).dispose();
  }
}
