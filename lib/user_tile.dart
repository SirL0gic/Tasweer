import 'package:flutter/material.dart';
import 'community_data.dart';
import 'users.dart';

class UserTile extends StatefulWidget {
  User user;
  // List<User> communityMembers;
  bool isSelected;

  UserTile({this.user, this.isSelected});
  @override
  _UserTileState createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(left: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(widget.user.ppURL),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                widget.user.username,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          ),
          IconButton(
            icon: widget.isSelected? Icon(Icons.check_box_outlined) :
            Icon(Icons.check_box_outline_blank),
            onPressed: (){setState(() {
              widget.isSelected = !widget.isSelected;
              if(widget.isSelected){
                //print("User is ${widget.user.username}");
                if(communityMembers == null)
                    communityMembers = [];

                print("HA list is $communityMembers and length is ${communityMembers.length}");
                communityMembers.add(widget.user);
                print("User ${widget.user.username} added");
                print("List is $communityMembers");
              }
              else if(!widget.isSelected && communityMembers != null &&
                  communityMembers.contains(widget.user)){
                print("User ${widget.user.username} is present in the list");
                communityMembers.remove(widget.user);
                print("User ${widget.user.username} removed");
                print("List is $communityMembers");
              }
            });},
          ),
        ],
      ),
    );
  }
}
