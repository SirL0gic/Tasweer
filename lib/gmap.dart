import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class GMap extends StatefulWidget {
  GMap({Key key}) : super(key: key);

  @override
  _GMapState createState() => _GMapState();
}

class LocationData {
  String address;
  double lat;
  double long;

  LocationData({this.lat, this.long, this.address});
}

class _GMapState extends State<GMap> {
  Set<Marker> _markers = HashSet<Marker>();
  GoogleMapController _mapController;
  BitmapDescriptor _markerIcon;
  String address;
  bool createMap = false;
  Position currentLocation;
  String locationName;
  bool doneEnabled = true;

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
  }

  void _setMarkerIcon() async {
    _markerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), "assets/marker.png");
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
      Geolocator()
          .placemarkFromCoordinates(
              currentLocation.latitude, currentLocation.longitude)
          .then((value) {
        if (value[0].locality == '')
          locationName = value[0].name + ', ' + value[0].country;
        else if (value[0].locality == value[0].name)
          locationName = value[0].locality + ', ' + value[0].country;
        else
          locationName = value[0].locality + ', ' + value[0].country;
      });
      lat = currentLocation.latitude;
      long = currentLocation.longitude;
      _markers.add(
        Marker(
            markerId: MarkerId("CurrentLocation"),
            position:
                LatLng(currentLocation.latitude, currentLocation.longitude),
            infoWindow: InfoWindow(
              title: "Your Location",
            ),
            icon: _markerIcon),
      );
    });
  }

  double lat;
  double long;

  _searchAndNavigate() {
    _markers.clear();
    Geolocator().placemarkFromAddress(address).then((result) {
      lat = result[0].position.latitude;
      long = result[0].position.longitude;
      // if (result[0].locality == '')
      //   locationName = result[0].name + ", " + result[0].country;
      // else
      //   locationName = result[0].name +
      //       ", " +
      //       result[0].locality +
      //       ", " +
      //       result[0].country;
      if (result[0].locality == '')
        locationName = result[0].name + ', ' + result[0].country;
      else if (result[0].locality == result[0].name)
        locationName = result[0].locality + ', ' + result[0].country;
      else if (result[0].country == '') {
        if (result[0].locality == '')
          locationName = result[0].name;
        else
          locationName = result[0].name + result[0].locality;
      } else
        locationName = result[0].name +
            ', ' +
            result[0].locality +
            ', ' +
            result[0].country;
      setState(() {
        _markers.add(
          Marker(
              markerId: MarkerId("Selected Location"),
              position: LatLng(lat, long),
              infoWindow: InfoWindow(
                title: "Selected Location",
              ),
              icon: _markerIcon),
        );
      });

      _mapController
          .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target:
            LatLng(result[0].position.latitude, result[0].position.longitude),
        zoom: 12,
      )));

      setState(() {
        doneEnabled = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Set Location'),
        ),
        body: createMap
            ? Stack(children: <Widget>[
                GoogleMap(
                  compassEnabled: true,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                        currentLocation.latitude, currentLocation.longitude),
                    zoom: 9,
                  ),
                  markers: _markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
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
                (doneEnabled)
                    ? Container(
                        alignment: Alignment.bottomCenter,
                        margin: EdgeInsets.only(bottom: 20),
                        child: FlatButton(
                          child: Text(
                            "    Done    ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          onPressed: () {
                            LocationData loc = LocationData(
                                lat: lat, long: long, address: locationName);
                            print("Location name = $locationName");
                            Navigator.pop(context, loc);
                          },
                          color: Colors.blueGrey.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            //side: BorderSide(color: Colors.black)
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
              ])
            : Center(
                child: Text(
                  'Loading. Please wait...',
                  style: TextStyle(fontSize: 20.0),
                ),
              ));
  }
}
