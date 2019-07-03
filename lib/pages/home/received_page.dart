import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weflyapps/models/models.dart';
import 'package:weflyapps/repositories/data_repository.dart';

class ReceivedPage extends StatefulWidget {
  @override
  _SentPageState createState() => _SentPageState();
}

class _SentPageState extends State<ReceivedPage> {
  DataRepository alertRepository = DataRepository();
  List<ReceivedAlert> received = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setLength();
  }

  setLength() async {
     await alertRepository.fetchReceivedAlerts();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        builder: (_) => alertRepository,
        child: Consumer(builder: (context, DataRepository alert, _) {
          switch (alert.status) {
            case Status.Uninitialized:
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            case Status.loading:
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            case Status.loaded:
              return Scaffold(
                  body: RefreshIndicator(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: received.length,
                  itemBuilder: (BuildContext context, int pos) {
                    return _buildCard(received[pos]);
                  },
                ),
                onRefresh: () {
                  Provider.of<DataRepository>(context).fetchReceivedAlerts();
                },
              ));
            case Status.error:
              return Scaffold(
                body: Center(
                  child: FlutterLogo(),
                ),
              );
          }
        }));
  }

  Widget cardItem(ReceivedAlert a) {
    Widget item;
    String ext = p.extension(a.alerte.properties.pieceJoinAlerte[1].piece);
    if (ext == ".jpg" || ext == ".png" || ext == ".jpeg") {
      print('Extension-> $ext');
      item = InkWell(
        child: Container(
          margin: EdgeInsets.all(15.0),
          height: 100.0,
          width: 100.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              image: DecorationImage(
                  image: CachedNetworkImageProvider(
                      a.alerte.properties.pieceJoinAlerte[1].piece),
                  fit: BoxFit.cover)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                a.alerte.properties.titre,
                style: TextStyle(color: Colors.white),
              ),
              Text(
                a.alerte.properties.contenu,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        onTap: () {
          print('Clicked-> ${a.alerte.properties.titre}');
        },
      );
    }
    return item;
  }

  _buildCard(ReceivedAlert a) {
    String ext = p.extension(a.alerte.properties.pieceJoinAlerte[1].piece);
    if (ext == ".jpg" || ext == ".png" || ext == ".jpeg") {
      return Padding(
        padding: EdgeInsets.only(top: 8.0, left: 10.0, bottom: 300.0),
        child: InkWell(
          onTap: (){},
          child: Container(
            height: 100.0,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(7.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 3.0,
                      spreadRadius: 3.0
                  )
                ]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
                      child: Image.network(a.alerte.properties.pieceJoinAlerte[1].piece,
                        fit: BoxFit.cover,
                        height: 100.0,
                        width: 100.0,
                      ),
                    ),
                Positioned(
                    top: 92.0,
                    left: 60.0,
                    child: a.alerte.properties.asPoly ? Container(
                      height: 15.0,
                      width: 55.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: Color(0xFFF75A4C),
                            style: BorderStyle.solid,
                            width: 0.25
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Text(
                          'Polygon',
                          style: TextStyle(
                              fontFamily: 'Arial-Rounded',
                              fontSize: 10.0,
                              color: Color(0xFFF75A4C)
                          ),
                        ),
                      ),
                    ) : Container()
                )
                  ],
                ),
                Container(
                  width: 125.0,
                  padding: EdgeInsets.only(left: 4.0),
                  child: Text(a.alerte.properties.titre,
                    style: TextStyle(
                        fontFamily: 'Arial-Rounded',
                        color: Color(0xFF440206),
                        fontSize: 15.0
                    ),
                  ),
                ),
                SizedBox(height: 5.0),
                Padding(
                  padding: EdgeInsets.only(left: 4.0),
                  child: Text('${a.alerte.properties.surface}',
                    style: TextStyle(

                        fontFamily: 'Arial-Rounded',
                        color: Color(0xFFF75A4C)
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Padding(
                    padding: EdgeInsets.only(left: 4.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.account_box, color: Color(0xFFF75A4C), size: 15.0),
                        SizedBox(width: 5.0),
                        Text(a.alerte.properties.creerPar.user.username,
                          style: TextStyle(
                              fontFamily: 'Arial-Rounded',
                              fontSize: 12.0,
                              color: Colors.grey
                          ),
                        )
                      ],
                    )
                )
              ],
            ),
          ),
        )

      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    alertRepository.dispose();
  }
}
