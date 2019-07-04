import 'dart:io';

import 'package:flutter/material.dart';
import 'package:weflyapps/models/models.dart';
import 'package:weflyapps/repositories/user_repository.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class ActivityDetailPage extends StatefulWidget {
  const ActivityDetailPage({Key key}) : super(key: key);

  @override
  _ActivityDetailPageState createState() => _ActivityDetailPageState();
}

class _ActivityDetailPageState extends State<ActivityDetailPage> {
  UserRepository userRepository;
  File _image;

  @override
  void initState() {
    super.initState();
    userRepository = UserRepository();
  }

  @override
  Widget build(BuildContext context) {
    Activite activite = ModalRoute.of(context).settings.arguments;
    print("Act ${activite.id} image size ->${activite.images.length}");
    return Scaffold(
      appBar: AppBar(
        title: Text("${activite.titre} ${activite.statutAct}"),
        actions: <Widget>[],
      ),
      body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 10.0),
                height: 200.0,
                child:  Container(
                  child: activite.images.length > 0
                      ? ListView.builder(
                    itemCount: activite.images.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 150.0,
                        width: 150.0,
                        margin: EdgeInsets.fromLTRB(5.0,10.0,5.0,5.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            image: DecorationImage(
                                image: File(activite
                                    .images[index].local_image)
                                    .existsSync()
                                    ? FileImage(File(activite
                                    .images[index].local_image))
                                    : NetworkImage(activite
                                    .images[index].remote_image))),
                      );
                    },
                  )
                      : Center(
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.note,
                            size: 50.0,
                          ),
                          Text("No Pictures")
                        ],
                      )),
                ),
              )
            ],
          )
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "status",
        child: activite.statutAct=="Achevé"?Icon(Icons.check):Icon(Icons.sync),
        onPressed: (){
          getImage();
        },
      ),
    );
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }
}
