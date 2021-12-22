/**
 * Some code elements have been taken from Github: https://github.com/MarcusNg/flutter_chat_ui
 * This repository is part of the "Apps From Scratch: Flutter Chat UI" series by
 * Marcus Ng. YouTube link: https://www.youtube.com/watch?v=h-igXZCCrrc (Accessed 26/1/2021)
 */

import 'package:flutter/material.dart';
import 'package:tasweer/users.dart';
import 'community_data.dart';
import 'communities_list_widget.dart';
import 'create_community.dart';
import 'package:tasweer/HomeScreen1.dart';

class CommunitySelector extends StatefulWidget {
  // The name of the community
  final String name;
  CommunitySelector({this.name});

  @override
  _CommunitySelectorState createState() => _CommunitySelectorState();
}

class _CommunitySelectorState extends State<CommunitySelector> {
  // A variable to check if the 'My Communities' section is selected
  bool isMyCommunitiesSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.name}",
          style: TextStyle(
            color: Theme.of(context).accentColor, // App bar stuff
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          color: Theme.of(context).primaryColor,
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.chevron_left,
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 30, right: 30),
            child: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (!isMyCommunitiesSelected) isMyCommunitiesSelected = !isMyCommunitiesSelected;
                        });
                      },
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              "My Communities",
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                          ),
                          Divider(
                            color: isMyCommunitiesSelected ? Colors.red : Colors.grey,
                            thickness: 1,
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isMyCommunitiesSelected) isMyCommunitiesSelected = !isMyCommunitiesSelected;
                        });
                        //print("isChatSelected = $isChatSelected");
                      },
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              "Other Communities",
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                          ),
                          Divider(
                            color: isMyCommunitiesSelected ? Colors.grey : Colors.red,
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

          /*
        Container for body of page goes here. Body of page will be list view.
       */

          CommunitiesList(
              communitiesList: isMyCommunitiesSelected? currentUser.userCommunities :
              otherComms),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.add,
          color: Colors.red,
        ),
        onPressed: ()async{

          if(userTileList.isEmpty){
            //Create a list of user tiles. This will be used when adding users to communities
            createUserTileList(users);
          }
          CommunityData newCommunity = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateCommunity()),);

          if(newCommunity != null){

            print("Community members = $communityMembers");

            setState(() {
              // Add the current community to all the users communityLists
              for(User user in communityMembers){
                user.userCommunities.add(newCommunity);
              }

              // Add the new community to the list of all communities
              allComms.add(newCommunity);

              // Refreshing the community members list.
              communityMembers = [];
            });
          }

        },
      ),
    );
  }
}


_getNewCommunity(BuildContext context) async {
  // Navigator.push returns a Future that completes after calling
  // Navigator.pop on the Selection Screen.
  final newComm = await Navigator.push(
    context,
    // Create the SelectionScreen in the next step.
    MaterialPageRoute(builder: (context) => CreateCommunity()),
  );

  return newComm;
}
