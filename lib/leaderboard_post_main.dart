import 'package:flutter/material.dart';
import 'package:tasweer/leaderboard_post_data.dart';
import 'package:tasweer/leaderboard_posts.dart';
import 'NavBar.dart';

class LeaderPostMain extends StatefulWidget {
  @override
  _LeaderPostMainState createState() => _LeaderPostMainState();
}

class _LeaderPostMainState extends State<LeaderPostMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    /*  appBar: AppBar(
        title: Text('my first app'),
        centerTitle: true,
        backgroundColor: Colors.red[600],
      ), */
      body: Column(
        children: [
          LeaderPosts(),
        ],
      ),
    );
  }
}
