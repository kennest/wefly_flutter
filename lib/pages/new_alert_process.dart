import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weflyapps/models/models.dart';
import 'package:weflyapps/models/send/alert.dart' as prefix0;

class NewAlertPage extends StatefulWidget {
  @override
  _NewAlertPageState createState() => _NewAlertPageState();
}

class _NewAlertPageState extends State<NewAlertPage> {
  prefix0.Alert a = prefix0.Alert();
  File _image;
  List<File> _listImages = [];
  String loc = "";

  @override
  void initState() {
    super.initState();
    getImage();
  }

  setLocation() async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString("location").split(":");
    a.longitude = data[0].toString();
    a.latitude = data[1].toString();
    print("Alert ->${a.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    a = ModalRoute.of(context).settings.arguments;
    setLocation();
    return Scaffold(
      body: Container(
        child: Center(
          child: Text("${a.categoryId}"),
        ),
      ),
    );
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });

    if (_image != null) {
      if (_image.existsSync()) {
        _listImages.add(_image);
      }
    }

    if (_listImages.length > 0) {}
  }

  void _categoryModalBottomSheet(context, List<Category> list) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              cacheExtent: 8.0,
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                if (File(list[index].local_icone).existsSync()) {
                  return ListTile(
                    leading: Image.file(File(list[index].local_icone)),
                    title: Text(list[index].nom),
                    onTap: () {
                      setState(() {
                        a.categoryId = list[index].id;
                      });
                    },
                  );
                }
              },
            ),
          );
        });
  }
}
