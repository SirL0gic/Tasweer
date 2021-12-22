import 'package:flutter/material.dart';
import 'package:tasweer/comments_screen.dart';
import 'package:tasweer/post_data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasweer/HomeScreen1.dart';
import 'db_ops.dart';
import 'post_location_view.dart';
import 'info_window.dart';
import 'package:provider/provider.dart';
import 'Profile22.dart';
import 'users.dart';

class CustomPopupMenu {
  CustomPopupMenu({this.title, this.icon});

  String title;

  IconData icon;
}

class Post extends StatefulWidget {
  final PostData postData;

  Post({this.postData});

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  bool _isLiked = false;
  List<String> likedIDs = [];
  bool currentUserPost = false;
  List<CustomPopupMenu> choices = [];
  CustomPopupMenu _selectedChoices;

  getPopupMenuButton(BuildContext context) {
      choices = [];
      if (widget.postData.address != ' ') {
        choices.add(CustomPopupMenu(title: 'View on Map', icon: Icons.bookmark));
      }
      if (widget.postData.ownerID == currentUser.id) {
        choices.add(CustomPopupMenu(title: 'Delete', icon: Icons.home));
      } else if (widget.postData.ownerID != currentUser.id)
        choices.add(CustomPopupMenu(title: 'Report', icon: Icons.bookmark));

    return PopupMenuButton(
      elevation: 3.2,
      onSelected: _selected,
      itemBuilder: (context) {
        return choices.map((CustomPopupMenu choice) {
          return PopupMenuItem(
            value: choice,
            child: Text(choice.title),
          );
        }).toList();
      },
    );
  }

  void initState() {
    //super.initState();

    setState(() {
      super.initState();
      choices = [];
      if (widget.postData.address != ' ') {
        choices.add(CustomPopupMenu(title: 'View on Map', icon: Icons.bookmark));
      }
      if (widget.postData.ownerID == currentUser.id) {
        choices.add(CustomPopupMenu(title: 'Delete', icon: Icons.home));
      } else if (widget.postData.ownerID != currentUser.id)
        choices.add(CustomPopupMenu(title: 'Report', icon: Icons.bookmark));
    });

  }

  void _selected(CustomPopupMenu choice) async {
    setState(() {
      _selectedChoices = choice;
    });
    if (_selectedChoices.title == "View on Map") {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(
                  create: (context) => InfoWindowModel(),
                  child: LocationView(
                    address: widget.postData.address,
                    lat: widget.postData.lat,
                    long: widget.postData.long,
                    imgURL: widget.postData.imageURL,
                    post: widget.postData,
                  ))));
    } else if (_selectedChoices.title == "Delete") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Delete Post",
            ),
            content: new Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Are You Sure You Want To Delete This Masterpiece?"),
              ],
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel"),
              ),
              FlatButton(
                  onPressed: () {

                    setState(() {
                      deletePost(widget.postData);
                      choices = [];
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomeScreen()));
                    });
                  },
                  child: Text("Yes, Delete"))
            ],
          );
        },
      );
    }
    else if (_selectedChoices.title == "Report"){
      sendReportedPost(widget.postData);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Reported",
            ),
            content: new Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Thank you, this post has been sent for review."),
              ],
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.postData.likedUserIDs.contains(currentUser.id))
      _isLiked = true;
    else
      _isLiked = false;

    if (widget.postData.ownerID == currentUser.id)
      currentUserPost = true;
    else
      currentUserPost = false;

    return Container(
      child: Column(
        children: [
          (widget.postData.address != ' ')
              ? ListTile(
                  leading: GestureDetector(
                    onTap: () async {
                      DocumentSnapshot docSnap;

                      await getDocWithID(usersRef, widget.postData.ownerID)
                          .then((value) =>
                              value.get().then((value) => docSnap = value));
                      User user = User.fromDocument(docSnap);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Profile22(
                                    user: user,
                                  )));
                    },
                    child: CircleAvatar(
                      radius: 25.0,
                      backgroundImage: NetworkImage(widget.postData.ownerPPURL),
                    ),
                  ),
                  title: GestureDetector(
                    onTap: () async {
                      DocumentSnapshot docSnap;

                      await getDocWithID(usersRef, widget.postData.ownerID)
                          .then((value) =>
                              value.get().then((value) => docSnap = value));
                      User user = User.fromDocument(docSnap);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Profile22(
                                    user: user,
                                  )));
                    },
                    child: Text(
                      widget.postData.username,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  subtitle: GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangeNotifierProvider(
                                  create: (context) => InfoWindowModel(),
                                  child: LocationView(
                                    address: widget.postData.address,
                                    lat: widget.postData.lat,
                                    long: widget.postData.long,
                                    imgURL: widget.postData.imageURL,
                                    post: widget.postData,
                                  ))));
                    },
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${widget.postData.address}",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  trailing: getPopupMenuButton(this.context),
                )
              : ListTile(
                  leading: GestureDetector(
                    onTap: () async {
                      DocumentSnapshot docSnap;

                      await getDocWithID(usersRef, widget.postData.ownerID)
                          .then((value) =>
                              value.get().then((value) => docSnap = value));
                      User user = User.fromDocument(docSnap);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Profile22(
                                    user: user,
                                  )));
                    },
                    child: CircleAvatar(
                      radius: 25.0,
                      backgroundImage: NetworkImage(widget.postData.ownerPPURL),
                    ),
                  ),
                  title: GestureDetector(
                    onTap: () async {
                      DocumentSnapshot docSnap;

                      await getDocWithID(usersRef, widget.postData.ownerID)
                          .then((value) =>
                              value.get().then((value) => docSnap = value));
                      User user = User.fromDocument(docSnap);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Profile22(
                                    user: user,
                                  )));
                    },
                    child: Text(
                      widget.postData.username,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  trailing: getPopupMenuButton(this.context),
                ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: CachedNetworkImage(
              imageUrl: widget.postData.imageURL,
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.05,
                top: 10,
                right: MediaQuery.of(context).size.width * 0.05),
            child: widget.postData.caption != ' '
                ? Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.17,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.postData.username.split(" ").first,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Text(
                            widget.postData.caption,
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  )
                : SizedBox.shrink(),
          ),
          Container(
            //height: 50.0,
            margin:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.02),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(_isLiked ? Icons.favorite : Icons.favorite_border),
                  iconSize: 30,
                  color: _isLiked ? Colors.red : Colors.grey.shade800,
                  onPressed: () {
                    this.setState(() {
                      _isLiked = !_isLiked;
                      if (_isLiked) {
                        widget.postData.likedUserIDs.add(currentUser.id);
                        incrementLikes(
                            widget.postData.ownerID, widget.postData);
                      } else {
                        widget.postData.likedUserIDs.remove(currentUser.id);
                        decrementLikes(
                            widget.postData.ownerID, widget.postData);
                      }
                    });
                  },
                ),
                Container(
                  child: Text(
                    "${widget.postData.likedUserIDs.length}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                IconButton(
                  icon: Icon(Icons.comment),
                  iconSize: 30,
                  onPressed: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                          //builder: (context) => CommentsPage(),
                          builder: (context) => CommentsScreen(
                            post: widget.postData,
                          ),
                        ));
                    this.setState(() {});
                  },
                ),
                Container(
                  child: Text(
                    "${widget.postData.commentsCount}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
