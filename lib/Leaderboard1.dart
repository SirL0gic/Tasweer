import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import './NavBar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Leaderboard1 extends StatelessWidget {
  Leaderboard1({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffededed),
      body: Stack(
        children: <Widget>[
          Transform.translate(
            offset: Offset(25.0, 0.0),
            child: Container(
              width: 326.0,
              height: 155.0,
              decoration: BoxDecoration(
                color: const Color(0xffededed),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(133.0, 15.0),
            child:
                // Adobe XD layer: 'podium' (shape)
                Container(
              width: 109.0,
              height: 109.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage(''),
                  fit: BoxFit.fill,
                  colorFilter: new ColorFilter.mode(
                      Colors.black.withOpacity(0.6), BlendMode.dstIn),
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(0.0, 611.0),
            child: SizedBox(
              width: 375.0,
              height: 56.0,
              child: Stack(
                children: <Widget>[
                  Pinned.fromSize(
                    bounds: Rect.fromLTWH(0.0, 0.0, 375.0, 56.0),
                    size: Size(375.0, 56.0),
                    pinLeft: true,
                    pinRight: true,
                    pinTop: true,
                    pinBottom: true,
                    child:
                        // Adobe XD layer: 'Nav Bar' (component)
                        NavBar(currentIndex: 2,),
                  ),
                  /*Pinned.fromSize(
                    bounds: Rect.fromLTWH(102.0, 19.0, 16.0, 16.0),
                    size: Size(375.0, 56.0),
                    fixedWidth: true,
                    fixedHeight: true,
                    child: Component1571(),
                  ),*/
                ],
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(37.5, 151.5),
            child: SvgPicture.string(
              _svg_jz5t7m,
              allowDrawingOutsideViewBox: true,
            ),
          ),
          Transform.translate(
            offset: Offset(61.4, 133.0),
            child: SizedBox(
              width: 103.0,
              child: Text(
                'Leaderboard',
                style: TextStyle(
                  fontFamily: 'Helvetica',
                  fontSize: 15,
                  color: const Color(0xaf808080),
                  height: 2,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Transform.translate(
          //   offset: Offset(242.2, 133.0),
          //   child: SizedBox(
          //     width: 46.0,
          //     child: Text(
          //       'Posts',
          //       style: TextStyle(
          //         fontFamily: 'Helvetica',
          //         fontSize: 15,
          //         color: const Color(0xaf808080),
          //         height: 2,
          //       ),
          //       textAlign: TextAlign.center,
          //     ),
          //   ),
          // ),
          Transform.translate(
            offset: Offset(195.0, 129.0),
            child: Container(
              width: 141.0,
              height: 21.0,
              decoration: BoxDecoration(),
            ),
          ),
          Transform.translate(
            offset: Offset(194.0, 130.0),
            child: Container(
              width: 141.0,
              height: 21.0,
              decoration: BoxDecoration(),
            ),
          ),
        ],
      ),
    );
  }
}

const String _svg_jz5t7m =
    '<svg viewBox="37.5 151.5 300.0 1.0" ><path transform="translate(37.5, 151.5)" d="M 0 0 L 300 0" fill="none" fill-opacity="0.3" stroke="#707070" stroke-width="1" stroke-opacity="0.3" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(37.5, 151.5)" d="M 0 0 L 151 0" fill="none" fill-opacity="0.3" stroke="#000000" stroke-width="1" stroke-opacity="0.3" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
