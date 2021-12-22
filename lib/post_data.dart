//This contains the data for the posts
import 'users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'loc_data.dart';
import 'package:tasweer/HomeScreen1.dart';

class PostData {
  String imageURL;
  String ownerID;
  String postID;
  String username;
  String ownerPPURL;
  int likesCount;
  int commentsCount;
  String address;
  String caption;
  double lat;
  double long;
  List<dynamic> likedUserIDs;
  List<dynamic> imgTags;

  PostData({
    this.imageURL,
    this.imgTags,
    this.username,
    this.postID,
    this.ownerID,
    this.ownerPPURL,
    this.likesCount,
    this.commentsCount,
    this.address,
    this.lat,
    this.long,
    this.likedUserIDs,
    this.caption
  });

  factory PostData.fromDocument(DocumentSnapshot doc) {
    return PostData(
      postID: doc['postID'],
      username: doc['ownerUsername'],
      ownerPPURL: doc['ownerPPURL'],
      ownerID: doc['ownerID'],
      imageURL: doc['imageURL'],
      long: doc['longitude'],
      lat: doc['latitude'],
      address: doc['address'],
      caption: doc['caption'],
      commentsCount: doc['nComments'],
      likedUserIDs: List.from(doc['likedUserIDs']).toList(growable: true),
      likesCount: doc['nLikes'],
    );
  }

// int getNoofLikes(){
//
// }
}

// A list of all the posts fetched from the backend
List<PostData> postsInformation = [];
