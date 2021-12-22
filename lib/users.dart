import 'community_data.dart';
import 'post_data.dart';
import 'awards.dart';
import 'user_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/**
 * Code based on GitHub: https://github.com/MarcusNg/flutter_chat_ui
 * This repository is part of the "Apps From Scratch: Flutter Chat UI" series by
 * Marcus Ng. YouTube link: https://www.youtube.com/watch?v=h-igXZCCrrc (Accessed 26/1/2021)
 */

class User {
  final String id;
  String username;
  String ppURL;
  String email;
  int nPosts;
  int nFollowers;
  int nFollowing;
  List<dynamic> followers;
  List<dynamic> following;
  List<CommunityData> userCommunities;
  List<dynamic> awards;

  User({
    this.id,
    this.username,
    this.ppURL,
    this.email,
    this.nPosts,
    this.nFollowers,
    this.nFollowing,
    this.followers,
    this.following,
    this.awards,
    this.userCommunities,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc.documentID,
      email: doc['userEmail'],
      username: doc['username'],
      ppURL: doc['ppURL'],
      userCommunities: doc['communities'] != null ? doc['communities'] : [],
      nPosts: doc['nPosts'],
      nFollowers: doc['nFollowers'],
      nFollowing: doc['nFollowing'],
      followers: List.from(doc['followers']).toList(growable: true),
      following: List.from(doc['following']).toList(growable: true),
    );
  }
}


List<User> users = [];
List<UserTile> userTileList = [];

void createUserTileList(List<User> usersList) {
  for (User user in usersList) {
    userTileList.add(UserTile(
      user: user,
      isSelected: communityMembers.contains(user) ? true : false,
    ));
  }
}



