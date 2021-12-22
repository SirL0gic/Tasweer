import 'package:flutter/material.dart';
import 'community_data.dart';
import 'community_page.dart';
import 'users.dart';

class CommunitiesList extends StatefulWidget {
  final List<CommunityData> communitiesList;

  CommunitiesList({this.communitiesList});

  @override
  _CommunitiesListState createState() => _CommunitiesListState();
}

class _CommunitiesListState extends State<CommunitiesList> {
  @override
  Widget build(BuildContext context) {
    if (widget.communitiesList.length == 0) {
      return Expanded(
        child: Container(
          child: Center(
            child: Text(
                "No Communities Available",
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
        ),
      );
    }

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          color: Colors.white,
        ),
        margin: EdgeInsets.only(left: 10, right: 10, top: 5),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          child: ListView.builder(
            itemCount: widget.communitiesList.length,
            itemBuilder: (BuildContext context, int index) {
              CommunityData community = widget.communitiesList[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Community(
                          community: community,
                        ),
                      ));
                },
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.only(left: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(community.commImgURL),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        community.name,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
