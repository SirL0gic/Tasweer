import 'user.dart';
import 'post_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentData {
  String commentID;
  String comment;
  String username;
  String userPPURL;
  bool isReported;

  CommentData({
    this.commentID,
    this.comment,
    this.username,
    this.userPPURL,
    this.isReported,
  });

  factory CommentData.fromDocument(DocumentSnapshot doc) {
    return CommentData(
      commentID: doc['commentID'],
      comment: doc['comment'],
      username: doc['username'],
      userPPURL: doc['userPPURL'],
      isReported: doc['isReported'],
    );
  }
}
