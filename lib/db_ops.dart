import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasweer/HomeScreen1.dart';
import 'package:uuid/uuid.dart';
import 'users.dart';
import 'gmap.dart';
import 'post_data.dart';
import 'comment_data.dart';

setSearchParam(String username) {
  List<String> userSearchList = [];
  String temp = "";
  username = username.split(" ").first;
  for (int i = 0; i < username.length; i++) {
    temp = temp + username[i];
    userSearchList.add(temp.toLowerCase());
  }
  return userSearchList;
}

void addUser(CollectionReference ref, String id, String email, String username,
    String ppURL) async {
  // Call the user's CollectionReference to add a new user
  await ref
      .document(id)
      .setData(
        {
          "id": id,
          "userEmail": email,
          "username": username,
          "ppURL": ppURL,
          "nFollowers": 0,
          "nFollowing": 0,
          "nPosts": 0,
          "followers": [],
          "following": [],
          "userSearchParams": setSearchParam(username),
        },
      )
      .then((value) => print("User Added"))
      .catchError((error) => print("Failed to add user: $error"));

  await leaderboardRef
      .document(id)
      .setData(
        {
          "id": id,
          "username": username,
          "ppURL": ppURL,
          "totalPoints": 0,
          "rank": 0
        },
      )
      .then((value) => print("User Added"))
      .catchError((error) => print("Failed to add user: $error"));
}

Future<DocumentReference> getDocWithID(
    CollectionReference ref, String id) async {
  DocumentReference doc = await ref.document(id);

  if (doc != null) return doc;

  return null;
}

void storePost(String url, LocationData locData, String caption) async {
  String postID = Uuid().v4();

  DocumentReference docRef = await usersRef
      .document("${currentUser.id}")
      .collection("userPosts")
      .document("$postID");

  // Store the post under the user's post collection
  docRef.setData({
    "postID": postID,
    "ownerID": currentUser.id,
    "ownerPPURL": currentUser.ppURL,
    "ownerUsername": currentUser.username,
    "timestamp": DateTime.now().millisecondsSinceEpoch,
    "nLikes": 0,
    "nComments": 0,
    "imageURL": url,
    "likedUserIDs": [],
    "caption": caption,
  });

  if (locData != null) {
    await docRef.updateData({
      "address": locData.address,
      "latitude": locData.lat,
      "longitude": locData.long,
    });
  }

  docRef = await globalPostsRef.document(postID);

  // Store post under global posts collection
  docRef.setData({
    "postID": postID,
    "ownerID": currentUser.id,
    "ownerPPURL": currentUser.ppURL,
    "ownerUsername": currentUser.username,
    "timestamp": DateTime.now().millisecondsSinceEpoch,
    "nLikes": 0,
    "nComments": 0,
    "imageURL": url,
    "likedUserIDs": [],
    "caption": caption,
  });

  if (locData != null) {
    await docRef.updateData({
      "address": locData.address,
      "latitude": locData.lat,
      "longitude": locData.long,
    });
  }

  int nPosts;

  await usersRef
      .document("${currentUser.id}")
      .collection("userPosts")
      .getDocuments()
      .then((value) => nPosts = value.documents.length);

  // Increment the posts counter in the user's document
  await usersRef.document("${currentUser.id}").updateData({
    'nPosts': nPosts,
  });

  // Get the updated user info from firestore
  usersRef
      .document("${currentUser.id}")
      .get()
      .then((value) => currentUser = User.fromDocument(value));
}

void sendReportedPost(PostData post) async {
  await reportedPostsRef.document(post.postID).setData({
    "postID": post.postID,
    "ownerID": currentUser.id,
    "ownerPPURL": currentUser.ppURL,
    "ownerUsername": currentUser.username,
    "timestamp": DateTime.now().millisecondsSinceEpoch,
    "nLikes": 0,
    "nComments": 0,
    "imageURL": post.imageURL,
    "likedUserIDs": [],
    "caption": post.caption,
    "address": post.address,
    "latitude": post.lat,
    "longitude": post.long,
  });
}

void deletePost(PostData post) async {
  // Delete from global posts collection.
  await globalPostsRef.document(post.postID).delete();

  // Delete from user's posts collection
  await usersRef
      .document(post.ownerID)
      .collection("userPosts")
      .document(post.postID)
      .delete();

  int nPosts;

  // Decrement the posts count
  await usersRef
      .document("${currentUser.id}")
      .collection("userPosts")
      .getDocuments()
      .then((value) => nPosts = value.documents.length);

  // Decrement the posts counter in the user's document
  await usersRef.document("${currentUser.id}").updateData({
    'nPosts': nPosts,
  });
}

// follower is the person who clicks the follow button. followee is the person being followed

void followUnfollow(User follower, User followee) async {
  DocumentReference docRef;
  int nFollowers;
  int nFollowing;

  // Get a reference to the followee doc
  docRef = await usersRef.document(followee.id);
  nFollowers = followee.followers.length;
  nFollowing = followee.following.length;

  // Update followee doc's followers list with followerID along with the count of their followers and following.
  docRef.updateData({
    "followers": followee.followers,
    "nFollowers": followee.nFollowers,
    "nFollowing": followee.nFollowing,
  });

  // Get reference to follower's doc
  docRef = await usersRef.document(follower.id);
  nFollowers = follower.followers.length;
  nFollowing = follower.following.length;

  // Update follower doc's following list with followeeID along with the count of their followers and following.
  docRef.updateData({
    "following": follower.following,
    "followers": follower.followers,
    "nFollowing": follower.nFollowing,
  });
}

void storeComment(CommentData comment, PostData post) async {
  String commentID = Uuid().v4();
  int nComments;

  print("Owner ID is = ${post.ownerID}");
  //Updating the owner's comments sub collection.
  DocumentReference docRef = await usersRef
      .document(post.ownerID)
      .collection("userPosts")
      .document(post.postID)
      .collection("comments")
      .document(commentID);

  docRef.get().then((value) => nComments = value['nComments']);

  // Store the comment under the user's post collection
  docRef.setData({
    "commentID": commentID,
    "comment": comment.comment,
    "username": currentUser.username,
    "userPPURL": currentUser.ppURL,
    "isReported": false,
    "timestamp": DateTime.now().millisecondsSinceEpoch,
  });

  //Get and update comment count
  await usersRef
      .document(post.ownerID)
      .collection("userPosts")
      .document(post.postID)
      .collection("comments")
      .getDocuments()
      .then((value) => nComments = value.documents.length);

  await usersRef
      .document(post.ownerID)
      .collection("userPosts")
      .document(post.postID)
      .updateData({
    "nComments": nComments,
  });

  // Store the comment under the global post collection
  docRef = await globalPostsRef
      .document(post.postID)
      .collection("comments")
      .document(commentID);

  // Store post under global posts collection
  docRef.setData({
    "commentID": commentID,
    "comment": comment.comment,
    "username": currentUser.username,
    "userPPURL": currentUser.ppURL,
    "isReported": false,
    "timestamp": DateTime.now().millisecondsSinceEpoch,
  });

  //Get and update comment count
  await globalPostsRef
      .document(post.postID)
      .collection("comments")
      .getDocuments()
      .then((value) => nComments = value.documents.length);

  await globalPostsRef.document(post.postID).updateData({
    "nComments": nComments,
  });
}

void incrementLikes(String ownerID, PostData post) async {
  await usersRef
      .document(ownerID)
      .collection("userPosts")
      .document(post.postID)
      .updateData({
    "likedUserIDs": post.likedUserIDs,
    "nLikes": post.likedUserIDs.length,
  });

  await globalPostsRef.document(post.postID).updateData({
    "likedUserIDs": post.likedUserIDs,
    "nLikes": post.likedUserIDs.length,
  });
}

void decrementLikes(String ownerID, PostData post) async {
  await usersRef
      .document(ownerID)
      .collection("userPosts")
      .document(post.postID)
      .updateData({
    "likedUserIDs": post.likedUserIDs,
    "nLikes": post.likedUserIDs.length,
  });

  await globalPostsRef.document(post.postID).updateData({
    "likedUserIDs": post.likedUserIDs,
    "nLikes": post.likedUserIDs.length,
  });
}

Future<void> addCommunity(
    CollectionReference ref, String name, String dpURL) async {
  // Call the user's CollectionReference to add a new user
  return await ref
      .document(name)
      .setData(
        {
          "id": name,
          "name": name,
          "imgURL": dpURL,
        },
      )
      .then((value) => print("User Added"))
      .catchError((error) => print("Failed to add user: $error"));
}
