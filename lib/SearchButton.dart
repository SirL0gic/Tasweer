import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';

class SearchButton extends StatelessWidget {
  SearchButton({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Pinned.fromSize(
          bounds: Rect.fromLTWH(0.0, 0.0, 40.0, 41.0),
          size: Size(40.0, 41.0),
          pinLeft: true,
          pinRight: true,
          pinTop: true,
          pinBottom: true,
          child:
              // Adobe XD layer: 'Shadow' (shape)
              Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(70.0),
              color: const Color(0xffededed),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x80c3bbbb),
                  offset: Offset(10, 10),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
        ),
        Pinned.fromSize(
          bounds: Rect.fromLTWH(0.0, 0.0, 40.0, 41.0),
          size: Size(40.0, 41.0),
          pinLeft: true,
          pinRight: true,
          pinTop: true,
          pinBottom: true,
          child:
              // Adobe XD layer: 'Light' (shape)
              Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(70.0),
              color: const Color(0xffededed),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xffffffff),
                  offset: Offset(-15, -15),
                  blurRadius: 25,
                ),
              ],
            ),
          ),
        ),
        Pinned.fromSize(
          bounds: Rect.fromLTWH(0.0, 0.0, 40.0, 41.0),
          size: Size(40.0, 41.0),
          pinLeft: true,
          pinRight: true,
          pinTop: true,
          pinBottom: true,
          child:
              // Adobe XD layer: 'Base' (shape)
              Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(70.0),
              color: const Color(0xffededed),
            ),
          ),
        ),
      ],
    );
  }
}
