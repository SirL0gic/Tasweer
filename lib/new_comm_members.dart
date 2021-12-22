import 'package:flutter/material.dart';
import 'community_data.dart';
import 'community_page.dart';
import 'users.dart';
import 'user_tile.dart';

class UsersList extends StatefulWidget {
  // List<UserTile> userTiles;
  // UsersList({this.userTiles});

  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  List<UserTile> userTiles = userTileList;
  bool isSelectedList = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(
                Icons.hourglass_empty_sharp,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                setState(() {
                  isSelectedList = !isSelectedList;
                  if(isSelectedList){
                    List<UserTile> newTiles = [];
                    for (UserTile userTile in userTiles){
                      if(userTile.isSelected)
                        newTiles.add(userTile);
                    }
                    userTiles = newTiles;
                  }
                  else
                    userTiles = userTileList;
                });
              }),
        ],
        title: Text(
          "Create Community",
          style: TextStyle(
            color: Theme
                .of(context)
                .accentColor, // App bar stuff
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          color: Theme
              .of(context)
              .primaryColor,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.chevron_left,
            color: Theme
                .of(context)
                .accentColor,
          ),
        ),
      ),
      backgroundColor: Theme
          .of(context)
          .primaryColor,
      body: userTiles.length == 0?
      Container(
        child: Center(
          child: Text(
            "No Users Available",
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      )
          :
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          color: Colors.white,
        ),
        margin: EdgeInsets.only(left: 10, right: 10, top: 5),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          child: ListView.builder(
            itemCount: userTiles.length,
            itemBuilder: (BuildContext context, int index) {
              return userTiles[index];
            },
          ),
        ),
      ),
    );
  }
}
