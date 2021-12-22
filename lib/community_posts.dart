import 'package:flutter/material.dart';
import 'community_data.dart';
import 'post_data.dart';
import 'post_widget.dart';

class CommPosts extends StatefulWidget {
  final CommunityData community;

  CommPosts({this.community});

  @override
  _CommPostsState createState() => _CommPostsState();
}

class _CommPostsState extends State<CommPosts> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
            height: 500,
            child: (postsInformation.length != 0)
                ? ListView.builder(
                    itemCount: postsInformation.length,
                    itemBuilder: (BuildContext context, int index) {
                      final PostData postInfo = postsInformation[index];
                      return new Post(
                        postData: postInfo,
                      );
                    },
                  )
                : SizedBox.shrink(),
          ),
    );
  }
}
