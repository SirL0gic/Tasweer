import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'info_window.dart';
import 'package:provider/provider.dart';
import 'package:clippy_flutter/clippy_flutter.dart';
import 'post_data.dart';
import 'post_widget.dart';

class LocationView extends StatefulWidget {
  String address;
  double lat;
  double long;
  String imgURL;
  PostData post;

  LocationView({this.post, this.address, this.long, this.lat, this.imgURL});

  @override
  _LocationViewState createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {
  Set<Marker> _markers = HashSet<Marker>();
  GoogleMapController _mapController;
  BitmapDescriptor _markerIcon;
  String address;
  bool createMap = false;
  String locationName;
  double lat;
  double long;

  @override
  void initState() {
    super.initState();
    Geolocator().getCurrentPosition().then((location) {
      setState(() {
        createMap = true;
        lat = widget.lat;
        long = widget.long;
        address = widget.address;
      });
    });
  }


  GlobalKey globalKey = new GlobalKey();

  // void _setMarkerIcon() async {
  //   _markerIcon = await BitmapDescriptor.fromAssetImage(
  //       ImageConfiguration(), "assets/marker.png");
  // }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
      lat = widget.lat;
      long = widget.long;
      address = widget.address;
    });
  }

  @override
  Widget build(BuildContext context) {
    final providerObject = Provider.of<InfoWindowModel>(context, listen: false);

    _markers.add(
      Marker(
          markerId: MarkerId("Picture Location"),
          onTap: () {
            providerObject.updateWindow(
                context, _mapController, LatLng(lat, long), 250, 170);
            providerObject.updateData(widget.post);
            providerObject.updateVisibility(true);
            providerObject.rebuild();
          },
          position: LatLng(lat, long),
          infoWindow: InfoWindow(
            title: "$address",
          ),
          icon: _markerIcon),
    );

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
                                  250,
                                  170);
                              providerObject.rebuild();
                            }
                          },
                          compassEnabled: true,
                          onMapCreated: _onMapCreated,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(lat, long),
                            zoom: 9,
                          ),
                          markers: _markers,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                        ),
                      ),
                    ),
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
