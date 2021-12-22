import 'package:flutter/material.dart';
import 'package:tasweer/NavBar.dart';
import 'package:tasweer/leaderboard_post_main.dart';
import 'package:tasweer/leaderboard_test.dart';
import 'package:tasweer/HomeScreen1.dart';
import 'users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List<User> leaderboardUsers = [];
List<User> listToDisplay = [];

/*
  REFERENCES -
  1) Divider -
  Deche (2019). Horizontal divider with text in the middle in Flutter? [online] Stack Overflow.
  Available at: https://stackoverflow.com/questions/54058228/horizontal-divider-with-text-in-the-middle-in-flutter
  [Accessed 5 Mar. 2021].

  Asif, S.M. (2019). How to draw a horizontal line in flutter row widgets? [online] Stack Overflow.
  Available at: https://stackoverflow.com/questions/56964776/how-to-draw-a-horizontal-line-in-flutter-row-widgets
  [Accessed 5 Mar. 2021].
‌
*/

class LeaderboardMain extends StatefulWidget {
  @override
  _LeaderboardMainState createState() => _LeaderboardMainState();
}

class _LeaderboardMainState extends State<LeaderboardMain> {
  bool _selected = true;

  void _select() {
    setState(() {
      _selected = !_selected;
    });
  }

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  void getUsers() async {
    QuerySnapshot qSnap = await usersRef.getDocuments();

    setState(() {
      leaderboardUsers = [];
      listToDisplay = [];
      leaderboardUsers = qSnap.documents
          .map((documentSnapshot) => User.fromDocument(documentSnapshot))
          .toList();

      leaderboardUsers.forEach((element) {
        if (element.username.startsWith("Wesley") ||
            element.username.startsWith("Fahim") ||
            element.username.startsWith("Ayushi")) {
          listToDisplay.add(element);
        }
      });

      leaderboardUsers.forEach((element) {
        if (!(element.username.startsWith("Wesley") ||
            element.username.startsWith("Fahim") ||
            element.username.startsWith("Ayushi"))) {
          listToDisplay.add(element);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(
          "Weekly Challenges",
          style: TextStyle(
            fontFamily: 'Helvetica',
            fontSize: 19,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xffededed),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: const Color(0xffededed),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      "#1",
                      style: TextStyle(fontSize: 18),
                    ),
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 23,
                        backgroundImage: NetworkImage(listToDisplay[0].ppURL),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(listToDisplay[0].username),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      "#2",
                      style: TextStyle(fontSize: 18),
                    ),
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 23,
                        backgroundImage: NetworkImage(listToDisplay[1].ppURL),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(listToDisplay[1].username),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "#3",
                      style: TextStyle(fontSize: 18),
                    ),
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 23,
                        backgroundImage: NetworkImage(listToDisplay[2].ppURL),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(listToDisplay[2].username),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              margin: EdgeInsets.only(left: 0.0, right: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (!_selected) {
                            _select();
                          }
                        });
                      },
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              'Leaderboard',
                              style: TextStyle(
                                fontFamily: 'Helvetica',
                                fontSize: 16,
                                color: _selected
                                    ? Colors.black
                                    : const Color(0xff808080),
                              ),
                            ),
                          ),
                          Divider(
                            color:
                                _selected ? Colors.black : Colors.transparent,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  // Expanded(
                  //   child: GestureDetector(
                  //     onTap: () {
                  //
                  //       setState(() {
                  //         if (_selected) {
                  //           _select();
                  //         }
                  //       });
                  //     },
                  //     child: Column(
                  //       children: [
                  //         Container(
                  //           alignment: Alignment.center,
                  //           child: Text(
                  //             'Posts',
                  //             style: TextStyle(
                  //               fontFamily: 'Helvetica',
                  //               fontSize: 16,
                  //               color: _selected ? const Color(0xff808080) : Colors.black,
                  //             ),
                  //           ),
                  //         ),
                  //         Divider(
                  //           color: _selected ? Colors.transparent : Colors.black,
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            Expanded(
              child: _selected ? LeaderboardTest() : LeaderPostMain(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavBar(
        currentIndex: 2,
      ),
    );
  }
}
