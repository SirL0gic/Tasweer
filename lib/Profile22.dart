import 'package:flutter/material.dart';
import 'package:tasweer/Setting.dart';
import './NavBar.dart';
import 'camera_func.dart';
import 'package:tasweer/HomeScreen1.dart';
import 'post_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'db_ops.dart';

import 'post_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'users.dart';

/**
 * Settings drawer was taken from here:
 * https://flutter.dev/docs/cookbook/design/drawer
 * Accessed 1/4/2021
 */

class Profile22 extends StatefulWidget {
  User user;

  Profile22({this.user});

  @override
  _Profile22State createState() => _Profile22State();
}

class _Profile22State extends State<Profile22> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool gridViewActive = true;
  bool isFollowing = false;
  List<Post> posts = [];

  void initState() {
    super.initState();
    initUser();
    getPosts();
  }

  void initUser() async {
    if (widget.user == null) widget.user = currentUser;

    DocumentSnapshot documentSnapshot =
        await usersRef.document(widget.user.id).get();
    widget.user = User.fromDocument(documentSnapshot);

    setState(() {
      if (widget.user.followers.contains(currentUser.id))
        isFollowing = true;
      else
        isFollowing = false;
    });
  }

  void _openEndDrawer() {
    _scaffoldKey.currentState.openEndDrawer();
  }

  void getPosts() async {
    QuerySnapshot qSnap = await usersRef
        .document(widget.user.id)
        .collection("userPosts")
        .orderBy("timestamp", descending: true)
        .getDocuments();

    setState(() {
      postsList = qSnap.documents
          .map((documentSnapshot) => PostData.fromDocument(documentSnapshot))
          .toList();
    });

    postsList.forEach((element) {
      posts.add(Post(
        postData: element,
      ));
    });
  }

  Widget createProfileHeader() {
    var _blockSize = MediaQuery.of(context).size.width / 7;
    return Container(
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Container(
              margin: EdgeInsets.only(top: 20.0),
              child: Row(children: <Widget>[
                Column(
                  children: [
                    CircleAvatar(
                      radius: 43,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(widget.user.ppURL),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(widget.user.username),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: 20.0,
                      left: MediaQuery.of(context).size.width * 0.05),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Column(
                            children: [
                              Text("${widget.user.nPosts}",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 5,
                              ),
                              Text("Posts")
                            ],
                          ),
                          SizedBox(
                            width: _blockSize / 2 + 8,
                          ),
                          Column(
                            children: [
                              Text("${widget.user.nFollowers}",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 5,
                              ),
                              Text("Followers")
                            ],
                          ),
                          SizedBox(
                            width: _blockSize / 2 + 8,
                          ),
                          Column(
                            children: [
                              Text("${widget.user.nFollowing}",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 5,
                              ),
                              Text("Following")
                            ],
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            (widget.user.id == currentUser.id)
                                ? FlatButton(
                                    child: Text(
                                      "Edit Profile",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () {},
                                    color: const Color(0xfff07079),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      //side: BorderSide(color: Colors.black)
                                    ),
                                  )
                                : FlatButton(
                                    child: Text(
                                      !isFollowing ? "Follow" : "Unfollow",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        /**
                                   * Remove the other user from the current user's
                                   * following list and remove the current user from
                                   * the other user's followers list.
                                   */
                                        if (isFollowing) {
                                          isFollowing = false;

                                          currentUser.nFollowing--;
                                          currentUser.following
                                              .remove(widget.user.id);

                                          widget.user.nFollowers--;
                                          widget.user.followers
                                              .remove(currentUser.id);
                                        }

                                        /**
                                   * Else add the other user to the current user's
                                   * following list and add the current user to the
                                   * other user's followers list.
                                   */
                                        else {
                                          isFollowing = true;

                                          currentUser.nFollowing++;
                                          currentUser.following
                                              .add(widget.user.id);

                                          widget.user.nFollowers++;
                                          widget.user.followers
                                              .add(currentUser.id);
                                        }
                                      });

                                      followUnfollow(currentUser, widget.user);
                                    },
                                    color: const Color(0xfff07079),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      //side: BorderSide(color: Colors.black)
                                    ),
                                  ),
                            SizedBox(
                              width: _blockSize / 2,
                            ),
                            FlatButton(
                              child: Text(
                                "Awards",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              color: const Color(0xfff07079),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                //side: BorderSide(color: Colors.black)
                              ),
                              onPressed: () {},
                              // UNCOMMENT ONLY IF AWARDS PAGE IS AVAILABLE
                              /* onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Awards()),
                                  );
                                },*/
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            child: Container(
              margin: EdgeInsets.only(bottom: 5),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          gridViewActive = true;
                        });
                      },
                      child: Column(
                        children: [
                          IconButton(
                            icon: Icon(Icons.grid_on),
                            color: gridViewActive ? Colors.black : Colors.grey,
                            onPressed: () {
                              setState(() {
                                gridViewActive = true;
                              });
                            },
                          ),
                          Divider(
                            color: gridViewActive ? Colors.black : Colors.grey,
                            thickness: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          gridViewActive = false;
                        });
                      },
                      child: Column(
                        children: [
                          IconButton(
                            icon: Icon(Icons.format_list_bulleted),
                            color: gridViewActive ? Colors.grey : Colors.black,
                            onPressed: () {
                              setState(() {
                                gridViewActive = false;
                              });
                            },
                          ),
                          Divider(
                            color: gridViewActive ? Colors.grey : Colors.black,
                            thickness: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /**
   * makePostTile() and the GridView code was taken from https://github.com/Edenik/InstaDart-Flutter-Instagram-Clone
   * profile_screen.dart
   *
   * The code has been adapted to fit in our application.
   */

  GridTile makePostTile(Post post) {
    return GridTile(
        child: GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute<bool>(
          builder: (BuildContext context) {
            return Center(
              child: Scaffold(
                  appBar: AppBar(
                    title: Text(
                      'Post',
                    ),
                    elevation: 0,
                  ),
                  body: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: ListView(
                      children: <Widget>[
                        Container(child: post),
                      ],
                    ),
                  )),
            );
          },
        ),
      ),
      child: Image(
        image: CachedNetworkImageProvider(post.postData.imageURL),
        fit: BoxFit.cover,
      ),
    ));
  }

  Widget displayPosts() {
    if (postsList.isEmpty) {
      return Container(
          alignment: Alignment.center,
          child: Text(
            "No Posts Available",
            style: TextStyle(
              fontSize: 20,
              color: Colors.black54,
              height: 1.5,
            ),
          ));
    }

    if (gridViewActive) {
      List<GridTile> gridTiles = [];
      posts.forEach((element) => gridTiles.add(makePostTile(element)));

      return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: gridTiles,
      );
    } else {
      //return Container();
      return Column(
        children: posts,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            "${widget.user.username}",
            style: TextStyle(
              fontFamily: 'Helvetica',
              fontSize: 19,
              color: Colors.black,
              //fontWeight: FontWeight.w700,
            ),
          ),
          backgroundColor: const Color(0xffededed),
          actions: [
            IconButton(
              icon: Icon(Icons.add, color: Colors.black),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyHomePage()));
              },
            ),
            IconButton(
              icon: Icon(Icons.menu, color: Colors.black),
              onPressed: _openEndDrawer,
            )
          ],
        ),
        endDrawer: Setting(),
        backgroundColor: const Color(0xffededed),
        body: ListView(children: [
          createProfileHeader(),
          displayPosts(),
        ]),
        bottomNavigationBar: NavBar(
          currentIndex: 4,
        ),
      ),
    );
  }
}
