import 'package:flutter/material.dart';
import 'package:tasweer/communities_page.dart';
import 'package:tasweer/HomeScreen1.dart';
import 'package:tasweer/Leaderboard1.dart';
import 'package:tasweer/Profile22.dart';
import 'explore_screen.dart';
import 'leaderboard_main.dart';
import 'Profile22.dart';


/**
 * Nav bar based on this video:
 * https://www.youtube.com/watch?v=WG4y47qGPX4
 *
 * Accessed 1/4/2021
 */

class NavBar extends StatefulWidget {
  int currentIndex;
  NavBar({
    this.currentIndex,
  });

  @override
  State<StatefulWidget> createState() =>
      _NavBarState(currentIndex: this.currentIndex);

}
class _NavBarState extends State<NavBar> {
  int currentIndex;
  _NavBarState({
    this.currentIndex,
  });

  List<Widget> _pages = <Widget> [
    HomeScreen(imageURL: '',),
    Communities(),
    LeaderboardMain(),
    ExploreTest(),
    Profile22(),
  ];


  onT(int index) {
    setState(() {
      if (index != currentIndex) {
        currentIndex = index;
        //print(currentIndex);
        Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext context) => _pages[currentIndex]));
      }});
  }



  @override
  Widget build(BuildContext context) {
    return new Container(
        //alignment: Alignment.bottomCenter,
        color: const Color(0xffdedede),

        child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onT,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Colors.grey,
        selectedItemColor: const Color(0xfff97e7e),
        unselectedItemColor: Colors.grey[700],
        items: [
          BottomNavigationBarItem(
            label: "Home",
            icon: Padding(
                padding: EdgeInsets.all(1.0),
                child: Icon(Icons.home_filled)
            ),
            //backgroundColor: const Color(0xffdedede),
          ),
          BottomNavigationBarItem(
            //icon: SvgPicture.asset("icons/community.svg"),
            //icon: Icon(Typicons.th),
            label: "Community",
            icon: Padding(
                padding: EdgeInsets.all(1.0),
                child: Icon(Icons.apps)
            ),
          ),
          BottomNavigationBarItem(
            label: "Leaderboard",
            icon: Padding(
                padding: EdgeInsets.all(1.0),
                child: Icon(Icons.emoji_events)
            ),
          ),
          BottomNavigationBarItem(
            label: "Explore",
            icon: Padding(
                padding: EdgeInsets.all(1.0),
                child: Icon(Icons.explore)
            ),
          ),
          BottomNavigationBarItem(
            label: "Profile",
            icon: Padding(
                padding: EdgeInsets.all(1.0),
                child: Icon(Icons.person)
            ),
          ),
        ],
        ),
    );
  }
}
