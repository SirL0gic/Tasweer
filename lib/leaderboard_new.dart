import 'package:flutter/material.dart';
import 'package:tasweer/HomeScreen1.dart';
//import 'package:tasweer/environmentalAccount.dart';
//import 'package:tasweer/environmentalAccount.dart';
import 'package:tasweer/leaderboard_data.dart';
import 'leaderboard_main.dart';
import 'users.dart';
import 'package:tasweer/Profile22.dart';

/*
  REFERENCES - 
  1) Sorting by rank - 
  Nomnom (2018). Sort a list of objects in Flutter (Dart) by property value. [online] Stack Overflow. 
  Available at: https://stackoverflow.com/questions/53547997/sort-a-list-of-objects-in-flutter-dart-by-property-value 
  [Accessed 10 Mar. 2021].

  2) Spacing out ech listtile - 
  AhabLives (2019). Flutter: How to evenly space ListTiles in ListView. [online] Stack Overflow. 
  Available at: https://stackoverflow.com/questions/55127463/flutter-how-to-evenly-space-listtiles-in-listview/57034446 
  [Accessed 16 Mar. 2021].

‌  3) How to apply border for a Circular Image - 
  Ijas, M. (2020). Circle Image with border in Flutter | Medium | Medium. [online] Medium. 
  Available at: https://medium.com/@mohammedijas/circle-image-avatar-with-border-in-flutter-513cdf82df43 
  [Accessed 16 Mar. 2021].

‌  4) How to update screen on coming back to original page -
  jack_the_beast (2020). Flutter: update screen when coming back from another. [online] Stack Overflow. 
  Available at: https://stackoverflow.com/questions/63074836/flutter-update-screen-when-coming-back-from-another 
  [Accessed 21 Mar. 2021].

‌  5) How to use then - 
  Jelena Lecic (2019). When to use async, await, then and Future in Dart? - Jelena Lecic - Medium. [online] Medium. 
  Available at: https://jelenaaa.medium.com/when-to-use-async-await-then-and-future-in-dart-5e00e64ab9b1 
  [Accessed 22 Mar. 2021].

‌  6) Leaderboard Representation - 
  Ng, M. (2019). Flutter Chat UI Tutorial | Apps From Scratch. YouTube. 
  Available at: https://www.youtube.com/watch?v=h-igXZCCrrc&t=1991s 
  [Accessed 8 Mar. 2021].
‌
*/

class LeaderBoardNew extends StatefulWidget {
  @override
  _LeaderBoardNewState createState() => _LeaderBoardNewState();
}

class _LeaderBoardNewState extends State<LeaderBoardNew> {
 
  var _boxSelected = new List(1);
  var _boxSelectedCopy = new List(1);

  var a;

  Color boxColor(int index) {
    if (_boxSelectedCopy.contains(index)) {
      a = Colors.cyan[200];
      return a;
    } 
 
    else {
      return Colors.transparent;
    }
  }

  Future<dynamic> nextPage(BuildContext context) {
    return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
      
        decoration: BoxDecoration(
          color: const Color(0xffededed),
         
        ),

        child: ListView.separated(
          itemCount: listToDisplay.length,
          itemBuilder: (context, index) {

             final User user = listToDisplay[index];
             return GestureDetector(
               onTap: () async {

                 Navigator.push(
                     context,
                     MaterialPageRoute(
                         builder: (context) => Profile22(
                           user: user,
                         )));
               },
               child: ListTile(
                 title: Row(
                   children: <Widget>[
                     // CircleAvatar(
                     //   child: Image.network(
                     //     data['ppURL'],
                     //     width: 100,
                     //     fit: BoxFit.fill,
                     //   ),
                     // ),
                     CircleAvatar(
                       radius: 25,
                       backgroundColor: Colors.white,
                       child: CircleAvatar(
                         radius: 23,
                         backgroundImage:
                         NetworkImage(user.ppURL),
                       ),
                     ),
                     SizedBox(
                       width: 25,
                     ),
                     Text(
                      user.username,
                       style: TextStyle(
                         // fontWeight: FontWeight.w700,
                         fontSize: 20,
                       ),
                     ),
                   ],
                 ),
                 trailing: CircleAvatar(
                   radius: 26.0,
                   backgroundColor: (user.username.startsWith('Wesley'))
                       ? Colors.yellow[900]
                       : (user.username.startsWith('Aysuhi'))
                       ? Colors.blueGrey[300]
                       : (user.username.startsWith('Fahim'))
                       ? Colors.brown[500]
                       : Colors.blueGrey[700],
                   child: CircleAvatar(
                     backgroundColor: (user.username.startsWith('Wesley'))
                         ? Colors.yellow[700]
                         : (user.username.startsWith('Ayushi'))
                         ? Colors.blueGrey[200]
                         : (user.username.startsWith('Fahim'))
                         ? Color(0xffCD7F32)
                         : Colors.red[700],
                     radius: 23.0,
                     child: Icon(
                       Icons.emoji_events_rounded,
                       color: Colors.white70,
                       size: 35.0,
                     ),
                   ),
                 ),
               ),
             );
            //
            //
            //
            // return Container(
            //   margin: EdgeInsets.only(left: 15.0, right: 15.0),
            //   decoration: BoxDecoration(
            //
            //     color: boxColor(index),
            //
            //     border: Border.all(
            //       color: Colors.grey,
            //     ),
            //     borderRadius: BorderRadius.all(Radius.elliptical(10, 10)),
            //   ),
            //
            //   child: ListTile(
            //
            //     onTap: () {
            //       if (!_boxSelected.contains(index)) {
            //         setState(() {
            //
            //           _boxSelected[0] = index;
            //           _boxSelectedCopy = List.from(_boxSelected);
            //
            //
            //
            //           nextPage(context).then((value) {
            //             setState(() {
            //                      _boxSelectedCopy[0] = null;
            //                                     });
            //
            //             //print('Hello');
            //           });
            //
            //
            //         });
            //       } else if (_boxSelected.contains(index)) {
            //         setState(() {
            //
            //           _boxSelected[0] = null;
            //         });
            //       }
            //     },
            //     leading: CircleAvatar(
            //       radius: 23.0,
            //       backgroundImage: AssetImage(leaderboard.lbUser.profilePic),
            //
            //     ),
            //
            //     title: Container(
            //
            //       child: Row(
            //         children: [
            //           Expanded(
            //             child: Align(
            //               alignment: Alignment.centerLeft,
            //               child: Padding(
            //                 padding: const EdgeInsets.only(right: 0.0),
            //                 child: Row(
            //                   children: [
            //                     Align(
            //                       child: Column(
            //                         crossAxisAlignment:
            //                             CrossAxisAlignment.start,
            //                         mainAxisAlignment: MainAxisAlignment.center,
            //                         children: [
            //                           Padding(
            //                             padding: const EdgeInsets.only(
            //                                 left: 8.0, top: 5),
            //                             child: Text(
            //                               leaderboard.lbUser.username,
            //                               style: TextStyle(
            //                                 fontFamily: 'Helvetica',
            //                                 fontSize: 16,
            //                                 color: Colors.black,
            //                                 fontWeight: FontWeight.w700,
            //                               ),
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ),
            //           ),
            //
            //
            //         ],
            //       ),
            //     ),
            //
            //
            //
            //
            //   ),
            // );
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 7,
            );
          },
        ),
      ),
    );
  }
}
