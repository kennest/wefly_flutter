import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weflyapps/models/models.dart';
import 'package:weflyapps/repositories/data_repository.dart';

class SentPage extends StatefulWidget {
  @override
  _SentPageState createState() => _SentPageState();
}

class _SentPageState extends State<SentPage> {
  DataRepository alertRepository = DataRepository();
  List<ReceivedAlert> received = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setLength();
  }

  setLength() async {
    received = await alertRepository.getReceived();
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
              return ListView.builder(
                itemCount: received.length,
                itemBuilder: (BuildContext context, int pos) {
                  return ListTile(
                    contentPadding: EdgeInsets.all(8.0),
                    leading: CircleAvatar(
                      child: Image.network(
                          received[pos].alerte.properties.categorie.icone),
                    ),
                    title: Text(received[pos].alerte.properties.titre),
                    subtitle: Text(received[pos].alerte.properties.contenu),
                    onTap: (){},
                  );
                },
              );
            case Status.error:
              return Scaffold(
                body: Center(
                  child: FlutterLogo(),
                ),
              );
          }
        }));
  }
}
