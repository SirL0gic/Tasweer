import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tasweer/interests_button.dart';
import 'package:tasweer/NavBar.dart';
import 'search_screen.dart';
import 'package:tasweer/HomeScreen1.dart';
import 'users.dart';
import 'community_data.dart';

/*
Disabled keyboard on text field click using code from:
(https://github.com/flutter/flutter/issues/16863 | diegolaballos commented on Oct 26, 2018 •)

(Accessed 1/2/2020)

This was done because the keyboard should be enabled on the search screen only.
 */

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class Communities extends StatefulWidget {
  final List<String> list = [];
      //List.generate(currentUser.userCommunities.length, (index) => currentUser.userCommunities[index].name);

  @override
  _CommunitiesState createState() => _CommunitiesState();
}

class _CommunitiesState extends State<Communities> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Communities",
          style: TextStyle(
            color: const Color(0xff808080), // App bar stuff
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          margin: EdgeInsets.only(top: 6.6),
          child: ListView(
            children: [
              Row(
                  // Search bar goes here
                  children: [
                    SizedBox(
                      width: 50,
                    ),
                    Expanded(
                      child: TextField(
                        focusNode: AlwaysDisabledFocusNode(),
                        onTap: () {
                          showSearch(
                              context: context, delegate: Search(widget.list));
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          isDense: true,
                          hintText: 'Search',
                          prefixIcon: Icon(Icons.search),
                          enabledBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(
                              color: const Color(0xff808080),
                            ),
                          ),
                          focusedBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(
                              color: const Color(0xff808080),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                  ]),
              Container(
                margin: EdgeInsets.only(top: 22.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InterestsButton(
                      imagePath: "assets/images/art.png",
                      label: "Art",
                      isInterestsSelectionButton: false,
                    ),
                    InterestsButton(
                      imagePath: "assets/images/koala.png",
                      label: "Animals",
                    ),
                    InterestsButton(
                      imagePath: "assets/images/sport.png",
                      label: "Sports",
                    ),
                  ], // The first row of categories
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InterestsButton(
                      imagePath: "assets/images/nature.png",
                      label: "Nature",
                    ),
                    InterestsButton(
                      imagePath: "assets/images/tech.png",
                      label: "Tech",
                    ),
                    InterestsButton(
                      imagePath: "assets/images/gaming.png",
                      label: "Gaming",
                    ),
                  ], // The second row of categories
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InterestsButton(
                      imagePath: "assets/images/architecture.png",
                      label: "Architecture",
                    ),
                    InterestsButton(
                      imagePath: "assets/images/fashion.png",
                      label: "Fashion",
                    ),
                    InterestsButton(
                      imagePath: "assets/images/reading.png",
                      label: "Reading",
                    ),
                  ], // The third row of categories
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xffededed),

      // Nav bar goes here
      bottomNavigationBar: NavBar(
        currentIndex: 1,
      ),
    );
  }
}
