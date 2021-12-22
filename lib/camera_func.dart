import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as imageLib;
import 'package:photofilters/photofilters.dart';
import 'package:path/path.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

//import 'package:image_editor_pro/image_editor_pro.dart';
import 'dart:io';
import 'image_upload.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tasweer/HomeScreen1.dart';
import 'db_ops.dart';
import 'gmap.dart';


/**
 * ML Kit for face detection. Taken from:
 * https://firebase.google.com/docs/ml-kit/detect-faces
 *
 * Accessed 1/4/2021
 */

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _selectedImage;
  bool _isLoading = false;
  bool _imageReceived = false;
  imageLib.Image _image;
  String filename;
  bool faceDetected = false;
  bool postEnabled = true;
  bool locationSet = false;
  LocationData location;
  String caption = ' ';

  Widget displayImage(BuildContext context, File image) {
    return Center(
      child: Image.file(
        image,
        width: MediaQuery.of(context).size.width - 8,
        height: MediaQuery.of(context).size.height - 280,
        fit: BoxFit.contain,
      ),
    );
  }

  getPicture(ImageSource source, BuildContext context) async {
    this.setState(() {
      _isLoading = true;
    });
    File img = await ImagePicker.pickImage(source: source);

    if (img != null) {
      filename = basename(img.path);
      this.setState(() {
        _isLoading = false;
      });

      File croppedImage = await ImageCropper.cropImage(
          sourcePath: img.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,
          ],
          // aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 10,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
              toolbarColor: Colors.blueGrey[700],
              toolbarWidgetColor: Colors.white,
              toolbarTitle: "Crop & Rotate",
              backgroundColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: true),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));
      this.setState(() {
        _selectedImage = croppedImage;
        var imgFile = imageLib.decodeImage(_selectedImage.readAsBytesSync());
        _image = imgFile;
        _isLoading = false;
        _imageReceived = true;
        checkForFaces(_selectedImage, caption, context, false);
      });
    } else {
      this.setState(() {
        _isLoading = false;
      });
    }
  }

  List<Filter> filters = presetFiltersList;

  List<Face> _faces;

// Helper funcs for face detection

  checkForFaces(File selectedImage, String caption, BuildContext context,
      bool postPressed) async {
    //print("Caption is $caption");

    var image = FirebaseVisionImage.fromFile(File(selectedImage.path));
    var faceDetector = FirebaseVision.instance.faceDetector();
    List<Face> faces = await faceDetector.processImage(image);
    await faceDetector.close();

    if (mounted) {
      setState(() {
        _selectedImage = File(selectedImage.path);
        _faces = faces;
        if (_faces.length == 0) {
          faceDetected = false;
          if (postPressed) uploadImage(context, caption);
        } else
          faceDetected = true;
      });
    }
  }

  uploadImage(BuildContext context, String caption) async {
    final _storage = FirebaseStorage.instance;
    //final _picker = ImagePicker();
    //PickedFile image;

    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      //
      //Select Image
      //image = await _picker.getImage(source: ImageSource.gallery);
      var file = File(_selectedImage.path);

      if (_selectedImage != null) {
        //Upload to Firebase
        var snapshot = await _storage
            .ref() //
            .child('folder/image' + DateTime.now().toString() + ".jpg")
            .putFile(file)
            .onComplete; //

        var downloadUrl = await snapshot.ref.getDownloadURL(); //

        if (location == null) {
          location = LocationData(address: " ", lat: 0, long: 0);
        }


        print(downloadUrl);

        setState(() {
          storePost(downloadUrl, location, caption);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeScreen(imageURL: downloadUrl)));
        });
      } else {
        print('No Path Received');
      }
    } else {
      print('Grant Permissions and try again');
    }
  }

  Widget addFiltersScreen(BuildContext context) {
    return (!faceDetected)
        ? Scaffold(
            body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: ListView(children: [
              Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      (locationSet)
                          ? Container(
                              margin: EdgeInsets.only(top: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 30,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.82,
                                    //alignment: Alignment.bottomCenter,
                                    child: Text(
                                      location.address,
                                      style: TextStyle(
                                          color: Colors.blueGrey[700],
                                          fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                      //textScaleFactor: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox.shrink(),
                      displayImage(context, _selectedImage),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.blueGrey[100]),
                        alignment: Alignment.center,
                        margin:
                            EdgeInsets.only(left: 15, right: 15, bottom: 20),
                        child: TextField(
                          autocorrect: false,
                          //onEditingComplete: _searchAndNavigate,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 15.0, top: 2),
                            // filled: true,
                            // fillColor: Colors.white,
                            hintText: 'Enter Caption',
                          ),
                          onChanged: (val) {
                            setState(() {
                              caption = val;
                            });
                          },
                        ),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: MaterialButton(
                                  color: Colors.blueGrey[700],
                                  height: 50,
                                  minWidth: 150,
                                  child: Text(
                                    "Add Filters",
                                    style: TextStyle(color: Colors.white),
                                    textScaleFactor: 1.4,
                                  ),
                                  onPressed: () async {
                                    Map file = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PhotoFilterSelector(
                                                  title: Text(
                                                    "Add Filters",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  appBarColor:
                                                      Colors.blueGrey[700],
                                                  filters: filters,
                                                  image: _image,
                                                  filename: filename,
                                                  loader: Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                  fit: BoxFit.contain,
                                                )));
                                    if (file != null &&
                                        file.containsKey('image_filtered')) {
                                      setState(() {
                                        _selectedImage = file['image_filtered'];
                                      });
                                    }
                                  }),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              child: MaterialButton(
                                  color: Colors.blueGrey[700],
                                  height: 50,
                                  minWidth: 150,
                                  child: Text(
                                    "Set Location",
                                    style: TextStyle(color: Colors.white),
                                    textScaleFactor: 1.4,
                                  ),
                                  onPressed: () async {
                                    location = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => GMap()));

                                    if (location != null) {
                                      setState(() {
                                        locationSet = true;
                                      });
                                    }
                                  }),
                            ),
                          ]),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: MaterialButton(
                            color: Colors.green,
                            height: 50,
                            minWidth: 115,
                            child: Text(
                              "Post",
                              style: TextStyle(color: Colors.white),
                              textScaleFactor: 1.4,
                            ),
                            onPressed: () {
                              if (postEnabled) {
                                postEnabled = false;
                                checkForFaces(
                                    _selectedImage, caption, context, true);
                              }
                            }),
                      ),
                    ]),
              ),
            ]),
          ))
        : Scaffold(
            body: Stack(children: <Widget>[
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  displayImage(context, _selectedImage),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Text(
                      "Human Detected! Please Upload an Image that does not contain a Human",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        MaterialButton(
                            color: Colors.blueGrey[700],
                            height: 50,
                            minWidth: 115,
                            child: Text(
                              "Back",
                              style: TextStyle(color: Colors.white),
                              textScaleFactor: 1.4,
                            ),
                            onPressed: () {
                              setState(() {
                                _isLoading = false;
                                _imageReceived = false;
                              });
                            }),
                      ])
                ])
          ]));
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
                    "assets/images/camera.png",
                    //https://www.flaticon.com/authors/dinosoftlabs
                    width: 100,
                  ),
                  SizedBox(height: 15),
                  MaterialButton(
                      color: Colors.blueGrey[700],
                      height: 50,
                      child: Text(
                        "Take Picture",
                        style: TextStyle(color: Colors.white),
                        textScaleFactor: 1.4,
                      ),
                      onPressed: () {
                        getPicture(ImageSource.camera, context);
                      }),
                ]),
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
                      onPressed: () {
                        getPicture(ImageSource.gallery, context);
                      }),
                ]),
              ],
            )
          ],
        ),
        (_isLoading)
            ? Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height * 0.95,
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
    return (_imageReceived)
        ? addFiltersScreen(context)
        : takePictureScreen(context);
  }
}

class PostImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Post Picture",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey[700],
      ),
      body: Stack(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Selection screen(For stage 3).",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      " For now post to feed and profile.",
                      style: TextStyle(fontSize: 20),
                    )
                  ])
            ],
          )
        ],
      ),
    );
  }
}
