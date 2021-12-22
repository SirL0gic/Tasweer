import 'package:flutter/material.dart';
import 'package:tasweer/leaderboard_new.dart';


class LeaderboardTest extends StatefulWidget {
  @override
  _LeaderboardTestState createState() => _LeaderboardTestState();
}

class _LeaderboardTestState extends State<LeaderboardTest> {
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
          LeaderBoardNew(),
        ],
      ),
    );
  }
}