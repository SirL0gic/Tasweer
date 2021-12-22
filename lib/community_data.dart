import 'users.dart';
import 'package:file/file.dart';
import 'package:tasweer/HomeScreen1.dart';
import 'user_tile.dart';

class CommunityData{
  String name;
  String commImgURL;
  List<User> members;
  //List<Message> messages;
  CommunityData({this.name, this.commImgURL, this.members, /*this.messages*/});
}

List<CommunityData> allComms = [
   CommunityData(
    name: "Wesley's Crib",
    commImgURL: "assets/images/Green sea photo.jpg",
    members: [currentUser],
  ),

    CommunityData(
      name: "Fahim's Garage",
      commImgURL: "assets/images/Flo's Cafe.jpg",
      members: [currentUser],
    ),

    CommunityData(
      name: "We Bear Bears",
      commImgURL: "assets/images/Flo's Cafe.jpg",
      members: [currentUser],
    ),

  CommunityData(
    name: "Explorers",
    commImgURL: "assets/images/Flo's Cafe.jpg",
  ),

  CommunityData(
    name: "Car Enthusiasts",
    commImgURL: "assets/images/Flo's Cafe.jpg",
  ),

  CommunityData(
    name: "Nature Lovers",
    commImgURL: "assets/images/Flo's Cafe.jpg",
  ),

];

List<CommunityData> otherComms = [

  CommunityData(
    name: "Explorers",
    commImgURL: "assets/images/Flo's Cafe.jpg",
  ),

  CommunityData(
    name: "Car Enthusiasts",
    commImgURL: "assets/images/Flo's Cafe.jpg",
  ),

  CommunityData(
    name: "Nature Lovers",
    commImgURL: "assets/images/Flo's Cafe.jpg",
  ),

];

// Temp list that's used when creating communities
List<User> communityMembers = [];

List<File> communityImages = [];
