import 'package:cloud_firestore/cloud_firestore.dart';

class LocationData {
  String address;
  double lat;
  double long;

  LocationData({this.lat, this.long, this.address});

  factory LocationData.fromDocument(DocumentSnapshot doc) {
    return LocationData(
      address: doc['address'],
      lat: doc['latitude'],
      long: doc['longitude'],
    );
  }
}
