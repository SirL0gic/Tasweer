import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tasweer/interests_button.dart';
import 'package:tasweer/HomeScreen1.dart';

class Interests extends StatefulWidget {
  @override
  _InterestsState createState() => _InterestsState();
}

class _InterestsState extends State<Interests> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Interests",
            style: TextStyle(
              color: const Color(0xff808080), // App bar stuff
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xffededed),
          elevation: 0,
          leading: IconButton(
            color: const Color(0xffededed),
            icon: Icon(
              Icons.chevron_left,
              color: const Color(0xff808080),
            ),
            onPressed: (){Navigator.pop(context);},
          )),
      body: Container(
        margin: EdgeInsets.only(top: 15),
        child: Column(
          children: [
            Center(
              child: Text(
                "Choose Your Interests",
                style: TextStyle(
                  color: const Color(0xff808080),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 26.4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InterestsButton(
                    imagePath: "assets/images/art.png",
                    label: "Art",
                    isInterestsSelectionButton: true,
                  ),
                  InterestsButton(
                    imagePath: "assets/images/koala.png",
                    label: "Animals",
                    isInterestsSelectionButton: true,
                  ),
                  InterestsButton(
                    imagePath: "assets/images/sport.png",
                    label: "Sports",
                    isInterestsSelectionButton: true,
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
                    isInterestsSelectionButton: true,
                  ),
                  InterestsButton(
                    imagePath: "assets/images/tech.png",
                    label: "Tech",
                    isInterestsSelectionButton: true,
                  ),
                  InterestsButton(
                    imagePath: "assets/images/gaming.png",
                    label: "Gaming",
                    isInterestsSelectionButton: true,
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
                    isInterestsSelectionButton: true,
                  ),
                  InterestsButton(
                    imagePath: "assets/images/fashion.png",
                    label: "Fashion",
                    isInterestsSelectionButton: true,
                  ),
                  InterestsButton(
                    imagePath: "assets/images/reading.png",
                    label: "Reading",
                    isInterestsSelectionButton: true,
                  ),
                ], // The third row of categories
              ),
            )
          ],
        ),
      ),
      backgroundColor: const Color(0xffededed),
      floatingActionButton: Container(
        width: 57.5,
        height: 60,
        child: FittedBox(
          child: FloatingActionButton(
            child: Icon(
              Icons.chevron_right,
              color: const Color(0xff808080),
            ),
            backgroundColor: const Color(0xffededed),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => HomeScreen(imageURL: '')));
            },
          ),
        ),
      ),
    );
  }
}
