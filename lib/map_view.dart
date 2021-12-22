import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'post_data.dart';
import 'HomeScreen1.dart';
import 'info_window.dart';
import 'post_widget.dart';
import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:fluster/fluster.dart';
import 'post_data.dart';

class MapView extends StatefulWidget {
  MapView({Key key}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  Set<Marker> _markers = HashSet<Marker>();
  GoogleMapController _mapController;
  BitmapDescriptor _markerIcon;
  String address;
  bool createMap = false;
  Position currentLocation;
  String locationName;
  bool doneEnabled = true;
  Map<String, PostData> _mapPostsList;
  final double _infoWindowWidth = 250;
  final double _markerOffset = 170;

  @override
  void initState() {
    super.initState();
    _setMarkerIcon();
    Geolocator().getCurrentPosition().then((location) {
      setState(() {
        currentLocation = location;
        createMap = true;
      });
    });

    /**
     * Found out how to convert list to map from https://bezkoder.com/dart-convert-list-map/
     * (Accessed 29/03/2021)
     **/
    _mapPostsList = {};
    postsList.forEach((post) => _mapPostsList[post.postID] = post);
  }

  void _setMarkerIcon() async {
    _markerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), "assets/marker.png");
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
      lat = currentLocation.latitude;
      long = currentLocation.longitude;
      _mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target:
                  LatLng(currentLocation.latitude, currentLocation.longitude),
              zoom: 8)));
    });
  }

  double lat;
  double long;

  _searchAndNavigate() {
    FocusScope.of(context).unfocus();
    Geolocator().placemarkFromAddress(address).then((result) {
      _mapController
          .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target:
            LatLng(result[0].position.latitude, result[0].position.longitude),
        zoom: 8,
      )));
    });
  }

  @override
  Widget build(BuildContext context) {
    final providerObject = Provider.of<InfoWindowModel>(context, listen: false);

    setState(() {
      _mapPostsList.forEach((key, value) {
        if (!(value.lat == 0 && value.long == 0)) {
          _markers.add(Marker(
              markerId: MarkerId(value.postID),
              position: LatLng(value.lat, value.long),
              onTap: () {
                providerObject.updateWindow(
                    context,
                    _mapController,
                    LatLng(value.lat, value.long),
                    _infoWindowWidth,
                    _markerOffset);

                providerObject.updateData(value);
                providerObject.updateVisibility(true);
                providerObject.rebuild();
              }));
        }
      });
    });

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(
            title: Text('Set Location'),
          ),
          body: createMap
              ? Stack(children: <Widget>[
                  Consumer<InfoWindowModel>(
                    builder: (context, model, child) {
                      return Stack(
                        children: [
                          child,
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Visibility(
                              visible: providerObject.showInfoWindow,
                              child: (providerObject.post == null ||
                                      !providerObject.showInfoWindow)
                                  ? Container()
                                  : Container(
                                      margin: EdgeInsets.only(
                                        left: providerObject.leftMargin,
                                        top: providerObject.topMargin,
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                gradient: LinearGradient(
                                                    colors: [
                                                      Colors.white,
                                                      Colors.white
                                                    ],
                                                    end: Alignment.bottomCenter,
                                                    begin: Alignment.topCenter),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey,
                                                    offset: Offset(0.0, 1.0),
                                                    blurRadius: 6,
                                                  )
                                                ]),
                                            height: 130,
                                            width: 180,
                                            padding: EdgeInsets.all(10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute<bool>(
                                                        builder: (BuildContext
                                                            context) {
                                                          return Center(
                                                            child: Scaffold(
                                                                appBar: AppBar(
                                                                  title: Text(
                                                                    'Post',
                                                                  ),
                                                                  elevation: 0,
                                                                ),
                                                                body: Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          top:
                                                                              10),
                                                                  child:
                                                                      ListView(
                                                                    children: <
                                                                        Widget>[
                                                                      Container(
                                                                          child:
                                                                              Post(
                                                                        postData:
                                                                            providerObject.post,
                                                                      )),
                                                                    ],
                                                                  ),
                                                                )),
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  },
                                                  child: Image.network(
                                                    providerObject
                                                        .post.imageURL,
                                                    height: 100,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Triangle.isosceles(
                                            edge: Edge.BOTTOM,
                                            child: Container(
                                              color: Colors.blue,
                                              width: 20,
                                              height: 15,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                            ),
                          )
                        ],
                      );
                    },
                    child: Positioned(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            providerObject.showInfoWindow = false;
                          });
                        },
                        child: GoogleMap(
                          onTap: (position) {
                            if (providerObject.showInfoWindow) {
                              providerObject.updateVisibility(false);
                              providerObject.rebuild();
                            }
                          },
                          onCameraMove: (position) {
                            if (providerObject.post != null) {
                              providerObject.updateWindow(
                                  context,
                                  _mapController,
                                  LatLng(providerObject.post.lat,
                                      providerObject.post.long),
                                  _infoWindowWidth,
                                  _markerOffset);
                              providerObject.rebuild();
                            }
                          },
                          compassEnabled: true,
                          onMapCreated: _onMapCreated,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(currentLocation.latitude,
                                currentLocation.longitude),
                            zoom: 9,
                          ),
                          markers: _markers,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 62.0,
                    left: MediaQuery.of(context).size.width * 0.06,
                    right: MediaQuery.of(context).size.width * 0.06,
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white),
                        //width: MediaQuery.of(context).size.width * 0.8,
                        child: TextField(
                          autocorrect: false,
                          onEditingComplete: _searchAndNavigate,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.only(left: 15.0, top: 15.0),
                              // filled: true,
                              // fillColor: Colors.white,
                              hintText: 'Search location',
                              suffixIcon: IconButton(
                                icon: Icon(Icons.search),
                                color: Colors.blueGrey[700],
                                onPressed: _searchAndNavigate,
                                iconSize: 30.0,
                              )),
                          onChanged: (val) {
                            setState(() {
                              if (val != '')
                                doneEnabled = false;
                              else
                                doneEnabled = true;

                              address = val;
                            });
                          },
                        )),
                  ),
                ])
              : Center(
                  child: Text(
                    'Loading. Please wait...',
                    style: TextStyle(fontSize: 20.0),
                  ),
                )),
    );
  }
}
