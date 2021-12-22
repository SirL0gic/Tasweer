import 'package:flutter/material.dart';
import 'package:tasweer/leaderboard_data.dart';

class LeaderPosts extends StatefulWidget {
  @override
  _LeaderPostsState createState() => _LeaderPostsState();
}

class _LeaderPostsState extends State<LeaderPosts> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        //height: 300.0,
        decoration: BoxDecoration(
          color: const Color(0xffededed),
        /*  borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ), */
        ),

        child: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: lb.length,
          itemBuilder: (context, index) {
            //final LeaderYT leaderboard = lb[index];

            lb.sort((a, b) => a.rank.compareTo(b.rank));
            final LeaderYT leaderboard = lb[index];

            /*  for(int i=0; i<= index; i++) {
              print(lb[i].rank);
              for(int j = i+1; j < index; j++) {
            if(lb[i].rank > lb[j].rank) { */

            return Container(
              margin: EdgeInsets.only(left: 8.0, right: 8.0),
              child: ListTile(
                title: Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 15.0, right: 6.0),
                            child: CircleAvatar(
                              radius: 23.0,
                              backgroundImage: AssetImage(leaderboard.lbUser.profilePic),
                              //AssetImage(),
                            ),
                          ),
                          Text(
                            leaderboard.lbUser.username,
                            style: TextStyle(
                              fontFamily: 'Helvetica',
                              fontSize: 16,
                              color: const Color(0xff808080),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 200.0,
                        margin:
                            EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.transparent,
                            width: 5.5,
                          ),
                          image: DecorationImage(
                            image: AssetImage(leaderboard.leaderPost),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
