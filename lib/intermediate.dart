import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as imageLib;
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';

class Cam extends StatefulWidget {

  String name;

  Cam({this.name});

  @override
  _Cam createState() => _Cam();
}

class _Cam extends State<Cam> {
  File selectedImage;
  bool _isLoading = false;
  bool _imageReceived = false;
  imageLib.Image _image;
  String filename;

  uploadImage(BuildContext context) async {

    final _storage = FirebaseStorage.instance;
    //final _picker = ImagePicker();
    //PickedFile image;


    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) { //
      //Select Image
      //image = await _picker.getImage(source: ImageSource.gallery);
      var file = File(selectedImage.path);

      if (selectedImage != null) {
        //Upload to Firebase
        var snapshot = await _storage
            .ref() //
            .child('community/${widget.name}/profile' + DateTime.now().toString() + ".jpg")
            .putFile(file)
            .onComplete; //

        var downloadUrl = await snapshot.ref.getDownloadURL();
        print("Download URL is $downloadUrl");

        Navigator.pop(context,downloadUrl);

      } else {
        print('No Path Received');
      }
    } else {
      print('Grant Permissions and try again');
    }
  }

  getPicture(BuildContext context, ImageSource source) async {
    File img = await ImagePicker.pickImage(source: source);
    selectedImage = img;
    print("Selected image after getting pic = $selectedImage");
    uploadImage(context);
  }


  Widget takePictureScreen(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: <Widget>[
            SafeArea(
              child: BackButton(
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(children: <Widget>[
                      Image.asset(
                        "assets/images/image-gallery.png",
                        //https://www.flaticon.com/authors/pixel-perfect
                        width: 100,
                      ),
                      SizedBox(height: 15),
                      MaterialButton(
                          color: Colors.blueGrey[700],
                          height: 50,
                          child: Text(
                            "Camera Roll",
                            style: TextStyle(color: Colors.white),
                            textScaleFactor: 1.4,
                          ),
                          onPressed: () async {
                            print("Selected image before getting pic = $selectedImage");
                            await getPicture(context, ImageSource.gallery);
                          }),
                    ]),
                  ],
                )
              ],
            ),
            (_isLoading)
                ? Container(
              color: Colors.white,
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.95,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
                : Center()
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return takePictureScreen(context);
  }
}

