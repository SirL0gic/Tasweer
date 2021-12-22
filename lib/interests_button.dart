import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'communities_selection_page.dart';

class InterestsButton extends StatefulWidget {
  final bool isInterestsSelectionButton;
  final String imagePath;
  final String label;

  InterestsButton(
      {this.imagePath, this.label, this.isInterestsSelectionButton = false});

  @override
  _InterestsButtonState createState() => _InterestsButtonState();
}

class _InterestsButtonState extends State<InterestsButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
      return Column(
        children: [
          Badge(
            badgeContent: Icon(Icons.check_circle_outline),
            badgeColor: Colors.green,
            showBadge:
                (isPressed && widget.isInterestsSelectionButton) ? true : false,
            child: OutlineButton(
              child: Image(
                image: AssetImage(widget.imagePath),
                height: 88,
              ),
              highlightedBorderColor: Colors.black,
              onPressed: () {
                setState(() {
                  isPressed = !(isPressed);
                  if (!widget.isInterestsSelectionButton) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CommunitySelector(name: widget.label)));
                  }
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              padding: EdgeInsets.fromLTRB(
                10,
                // Left padding
                10,
                // Top Padding
                10,
                // Right padding
                10, // Bottom Padding
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(
                0, 10, 0, 0),
            child: Text(
              widget.label != "" ? widget.label : "",
              style: TextStyle(
                color: const Color(0xff808080),
                fontSize: 16,
              ),
            ),
          )
        ],
      );
  }
}
