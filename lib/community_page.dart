/**
 * Some code elements have been taken from Github: https://github.com/MarcusNg/flutter_chat_ui
 * This repository is part of the "Apps From Scratch: Flutter Chat UI" series by
 * Marcus Ng. YouTube link: https://www.youtube.com/watch?v=h-igXZCCrrc (Accessed 26/1/2021)
 */

import 'package:flutter/material.dart';
import 'package:tasweer/community_sec_selector.dart';

import 'community_data.dart';
import 'community_posts.dart';
import 'users.dart';
import 'package:tasweer/HomeScreen1.dart';

class Community extends StatefulWidget {
  // The name of the community
  final CommunityData community;
  Community({this.community});

  @override
  _CommunityState createState() => _CommunityState();
}

class _CommunityState extends State<Community> {

  @override
  Widget build(BuildContext context) {
    // Variable to store if the current user is a member of the community.

   bool isMember = currentUser.userCommunities.contains(widget.community);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${widget.community.name}",
              style: TextStyle(
                color: Theme
                    .of(context)
                    .accentColor, // App bar stuff
              ),
            ),
            IconButton(
              color: Theme
                  .of(context)
                  .primaryColor,
              onPressed: () {},
              icon: Icon(
                Icons.more_vert,
                color: Theme
                    .of(context)
                    .accentColor,
              ),
            ),
          ],
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
      /**
       * Idea and code for this scroll effect was taken from:
       * https://stackoverflow.com/questions/59904719/instagram-profile-header-layout-in-flutter
       *
       * The code has been adapted for our application.
       */
      body: NestedScrollView(
        headerSliverBuilder: (context, _) {
          return [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          alignment: Alignment.centerLeft,
                          child: CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 35,
                              backgroundImage: AssetImage(
                                  widget.community.commImgURL),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              //margin: EdgeInsets.only(top: 10),
                              child: Text(
                                widget.community.name,
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  color: Theme
                                      .of(context)
                                      .primaryColor,
                                  onPressed: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //       builder: (context) => ChatScreen(
                                    //           community: widget.community)
                                    //     ));
                                  },
                                  icon: Icon(
                                    Icons.chat,
                                    color: Theme
                                        .of(context)
                                        .accentColor,
                                  ),
                                ),
                                FlatButton(
                                  child: isMember? Text(
                                    "Joined",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ) : Text(
                                    "Join",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  onPressed: () {},
                                  color: Colors.grey[600],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Description",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ];
        },
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 30, right: 30),
              child: Padding(
                padding: const EdgeInsets.only(top: 15),
                child:
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                        },
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                "Posts",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Theme
                                      .of(context)
                                      .accentColor,
                                ),
                              ),
                            ),
                            Divider(
                              color: Colors.black,
                              thickness: 1,
                            )
                          ],
                        ),
                      ),
                    ),
                ),
              ),

            /*
        Container for body of page goes here. Body of page will change based on which section is
        selected (chat or posts)
       */
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 15),
                    child: CommPosts(community: widget.community,)),
              ),

            /*
           Nav Bar comes here
           */
          ],
        ),
      ),
    );
  }
}
