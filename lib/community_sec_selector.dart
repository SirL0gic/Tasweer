/**
 * A section selection bar for a community screen. The two sections are: Chat and Posts.
 **/

import "package:flutter/material.dart";

class CommunitySectionSelector extends StatefulWidget {
  @override
  _CommunitySectionSelectorState createState() =>
      _CommunitySectionSelectorState();
}

class _CommunitySectionSelectorState extends State<CommunitySectionSelector> {
  // A variable to check if the chat section is selected
  bool isChatSelected = true;

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 5, right: 5),
      child: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (!isChatSelected) isChatSelected = !isChatSelected;
                  });
                },
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Chat",
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                    Divider(
                      color: isChatSelected ? Colors.black : Colors.grey,
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
                    if (isChatSelected) isChatSelected = !isChatSelected;
                  });
                },
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Posts",
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                    Divider(
                      color: isChatSelected ? Colors.grey : Colors.black,
                      thickness: 1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
