import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'post_data.dart';

class InfoWindowModel extends ChangeNotifier {
  bool showInfoWindow = false;
  bool tempHidden = false;
  PostData post;
  double leftMargin, topMargin;

  void rebuild() {
    notifyListeners();
  }

  void updateData(PostData postData) {
    post = postData;
  }

  void updateVisibility(bool isVisible) {
    showInfoWindow = isVisible;
  }

  void updateWindow(BuildContext context, GoogleMapController mapController,
      LatLng latLng, double infoWindowWidth, double markerOffset) async {

    ScreenCoordinate screenCoordinate = await mapController.getScreenCoordinate(latLng);

    double devicePixelRatio =  Platform.isAndroid ? MediaQuery.of(context).devicePixelRatio : 1.0;
    double left = (screenCoordinate.x.toDouble() / devicePixelRatio) - (infoWindowWidth/2.45);
    double top = (screenCoordinate.y.toDouble() / devicePixelRatio) - markerOffset;

    //print("DPR is $devicePixelRatio Left is $left Top is $top");


    if(left < 0 || top < 0){
      tempHidden = true;
    }
    else{
      tempHidden = false;
      leftMargin = left;
      topMargin = top;
    }
  }

  bool get showWindow => (showInfoWindow == true && tempHidden == false) ? true : false;
  double get marginLeft => leftMargin;
  double get marginTop => topMargin;
  PostData get postData => post;

}
