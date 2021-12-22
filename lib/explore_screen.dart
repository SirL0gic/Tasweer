import 'package:flutter/material.dart';
import 'package:tasweer/NavBar.dart';
import 'package:tasweer/HomeScreen1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasweer/Profile22.dart';
import 'users.dart';
import 'post_data.dart';
import 'post_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';


class ExploreTest extends StatefulWidget {
  //final TextEditingController nameController = TextEditingController();

  ExploreTest({
    Key key,
  }) : super(key: key);

  @override
  _ExploreTestState createState() => _ExploreTestState();
}

class _ExploreTestState extends State<ExploreTest> {
  bool showSearch = false;
  String name;
  List<Post> posts = [];

  // void _changeText() {
  //   setState(() {
  //     _showText = !_showText;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    getPosts();
  }

  void getPosts() async {
    QuerySnapshot qSnap =
        await globalPostsRef.orderBy("nLikes", descending: true).getDocuments();

    setState(() {
      postsList = qSnap.documents
          .map((documentSnapshot) => PostData.fromDocument(documentSnapshot))
          .toList();
    });

    postsList.forEach((element) {
      posts.add(Post(
        postData: element,
      ));
    });
  }

  /**
   * makePostTile() and the GridView code was taken from https://github.com/Edenik/InstaDart-Flutter-Instagram-Clone
   * profile_screen.dart
   *
   * The code has been adapted to fit in our application.
   */

  GridTile makePostTile(Post post) {
    return GridTile(
        child: GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute<bool>(
          builder: (BuildContext context) {
            return Center(
              child: Scaffold(
                  appBar: AppBar(
                    title: Text(
                      'Post',
                    ),
                    elevation: 0,
                  ),
                  body: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: ListView(
                      children: <Widget>[
                        Container(child: post),
                      ],
                    ),
                  )),
            );
          },
        ),
      ),
      child: Image(
        image: CachedNetworkImageProvider(post.postData.imageURL),
        fit: BoxFit.cover,
      ),
    ));
  }

  Widget displayPosts() {
    if (postsList.isEmpty) {
      return Container(
          alignment: Alignment.center,
          child: Text(
            "No Posts Available",
            style: TextStyle(
              fontSize: 20,
              color: Colors.black54,
              height: 1.5,
            ),
          ));
    }

    List<GridTile> gridTiles = [];
    posts.forEach((element) => gridTiles.add(makePostTile(element)));

    return GridView.count(
      crossAxisCount: 3,
      childAspectRatio: 1.0,
      mainAxisSpacing: 2.0,
      crossAxisSpacing: 2.0,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: gridTiles,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() {
          showSearch = false;
        });
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Explore", style: TextStyle(
            fontFamily: 'Helvetica',
            fontSize: 19,
            color: Colors.black,
          ),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
        ),
        body: Column(
          children: [
            Card(
              child: TextField(
                onTap: () {
                  setState(() {
                    showSearch = true;
                  });
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search), hintText: 'Search...'),
                onChanged: (val) {
                  setState(() {
                    name = val;
                    name.toLowerCase();
                  });
                },
              ),
            ),
            /**
             * Got idea of wrapping Flexible inside a StreamBuilder from:
             * https://stackoverflow.com/questions/51400549/how-to-wrap-a-streambuilder-class-with-a-column-or-listview-class-in-flutter
             * (Accessed 1/4/2021)
             */
            showSearch
                ? Flexible(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: (name != "" && name != null)
                          ? usersRef
                              .where("userSearchParams",
                                  arrayContains: name.toLowerCase())
                              .snapshots()
                          : usersRef.snapshots(),
                      builder: (context, snapshot) {
                        return (snapshot.connectionState ==
                                ConnectionState.waiting)
                            ? Center(child: CircularProgressIndicator())
                            : ListView.builder(
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot data =
                                      snapshot.data.documents[index];
                                  return GestureDetector(
                                    onTap: () async {
                                      // DocumentSnapshot docSnap;
                                      //
                                      // await getDocWithID(usersRef, data['id'])
                                      //     .then((value) =>
                                      //     value.get().then((value) => docSnap = value));
                                      User user = User.fromDocument(data);

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Profile22(
                                                    user: user,
                                                  )));
                                    },
                                    child: ListTile(
                                      title: Row(
                                        children: <Widget>[
                                          // CircleAvatar(
                                          //   child: Image.network(
                                          //     data['ppURL'],
                                          //     width: 100,
                                          //     fit: BoxFit.fill,
                                          //   ),
                                          // ),
                                          CircleAvatar(
                                            radius: 25,
                                            backgroundColor: Colors.white,
                                            child: CircleAvatar(
                                              radius: 23,
                                              backgroundImage:
                                                  NetworkImage(data['ppURL']),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 25,
                                          ),
                                          Text(
                                            data['username'],
                                            style: TextStyle(
                                              // fontWeight: FontWeight.w700,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                      },
                    ),
                  )
                : displayPosts(),
          ],
        ),
        bottomNavigationBar: NavBar(
          currentIndex: 3,
        ),
      ),
    );
  }

// Widget build(BuildContext context) {
//   return Scaffold(
//     /* appBar: AppBar(
//       title: Text('my first app'),
//       centerTitle: true,
//       backgroundColor: Colors.red[600],
//     ),  */
//
//     body: SingleChildScrollView(
//       physics: AlwaysScrollableScrollPhysics(),
//       child: Column(
//         children: <Widget>[
//           Container(
//             margin: EdgeInsets.only(
//               top: 100.0,
//             ),
//             //padding: const EdgeInsets.all(15.0),
//             child: Row(
//               // Search bar goes here
//               children: [
//                 SizedBox(
//                   width: 50,
//                 ),
//                 Expanded(
//                   child: FlatButton(
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(40.0),
//                         side: BorderSide(color: const Color(0xff808080))),
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
//                       child: Row(
//                         children: [
//                           Icon(Icons.search, color: Colors.grey.shade400),
//                           Text(
//                             'Search',
//                             style: TextStyle(
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     onPressed: () =>  showSearch(
//                         context: context, delegate: Search([])),
//                   ),
//                 ),
//                 SizedBox(
//                   width: 50,
//                 ),
//               ],
//             ),
//           ),
//
//           Container(
//             margin: EdgeInsets.only(left: 55.0, top: 20.0),
//             child: Row(
//               children: <Widget>[
//                 Text(
//                   'Featured Works',
//                   style: TextStyle(
//                     fontFamily: 'Helvetica',
//                     fontSize: 16,
//                     color: const Color(0xff808080),
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//                 SizedBox(
//                   width: 130.0,
//                 ),
//                 Container(
//                   width: 45.0,
//                   height: 45.0,
//                   child: FloatingActionButton(
//                     onPressed: () => Navigator.push(context, MaterialPageRoute(
//                         builder: (context) => Interests())),
//                     backgroundColor: Colors.purple,
//
//                     //tooltip: 'Increment',
//                     child: Icon(
//                       Icons.filter_alt_sharp,
//                       size: 25.0,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             //crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.all(16.0), //15
//                 child: Container(
//                   //padding: EdgeInsets.all(30.0),
//                   //color: Colors.cyan,
//                   width: 123.0,
//                   height: 122.0,
//
//                   decoration: BoxDecoration(
//                     color: Colors.cyan,
//                     image: const DecorationImage(
//                       image: const AssetImage(
//                           'assets/images/Purple photo.jpg'),
//                       fit: BoxFit.cover,
//                     ),
//                     border: Border.all(
//                       color: const Color(0xff707070),
//                       width: 1.0,
//                     ),
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                 ),
//               ),
//
//               //SizedBox(width: 10.0,),
//
//               Padding(
//                 padding: const EdgeInsets.all(20.0), //15
//                 child: Container(
//                   //padding: EdgeInsets.all(30.0),
//
//                   width: 123.0,
//                   height: 122.0,
//
//                   decoration: BoxDecoration(
//                     color: Colors.cyan,
//                     image: const DecorationImage(
//                       image: const AssetImage(
//                           'assets/images/Red lantern photo.jpg'),
//                       fit: BoxFit.cover,
//                     ),
//                     border: Border.all(
//                       color: const Color(0xff707070),
//                       width: 1.0,
//                     ),
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             //crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.all(16.0), //15
//                 child: Container(
//                   //padding: EdgeInsets.all(30.0),
//                   //color: Colors.cyan,
//                   width: 123.0,
//                   height: 122.0,
//
//                   decoration: BoxDecoration(
//                     color: Colors.cyan,
//                     image: const DecorationImage(
//                       image: const AssetImage(
//                           'assets/images/Orange street.jpg'),
//                       fit: BoxFit.cover,
//                     ),
//                     border: Border.all(
//                       color: const Color(0xff707070),
//                       width: 1.0,
//                     ),
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                 ),
//               ),
//
//               //SizedBox(width: 10.0,),
//
//               Padding(
//                 padding: const EdgeInsets.all(20.0), //15
//                 child: Container(
//                   //padding: EdgeInsets.all(30.0),
//
//                   width: 123.0,
//                   height: 122.0,
//
//                   decoration: BoxDecoration(
//                     color: Colors.cyan,
//                     image: const DecorationImage(
//                       image: const AssetImage(
//                           'assets/images/Flo\'s Cafe.jpg'),
//                       fit: BoxFit.cover,
//                     ),
//                     border: Border.all(
//                       color: const Color(0xff707070),
//                       width: 1.0,
//                     ),
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             //crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.all(16.0), //15
//                 child: Container(
//                   //padding: EdgeInsets.all(30.0),
//                   //color: Colors.cyan,
//                   width: 123.0,
//                   height: 122.0,
//
//                   decoration: BoxDecoration(
//                     color: Colors.cyan,
//                     image: const DecorationImage(
//                       image: const AssetImage(
//                           'assets/images/Green photo.jpg'),
//                       fit: BoxFit.cover,
//                     ),
//                     border: Border.all(
//                       color: const Color(0xff707070),
//                       width: 1.0,
//                     ),
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                 ),
//               ),
//
//               //SizedBox(width: 10.0,),
//
//               Padding(
//                 padding: const EdgeInsets.all(20.0), //15
//                 child: Container(
//                   //padding: EdgeInsets.all(30.0),
//
//                   width: 123.0,
//                   height: 122.0,
//
//                   decoration: BoxDecoration(
//                     color: Colors.cyan,
//                     image: const DecorationImage(
//                       image: const AssetImage(
//                           'assets/images/Orange Photo.jpg'),
//                       fit: BoxFit.cover,
//                     ),
//                     border: Border.all(
//                       color: const Color(0xff707070),
//                       width: 1.0,
//                     ),
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//
//           //CHANGE TEXT ON CLICKING BUTTON
//           /*   FlatButton(
//                               child:
//                               //Text(
//                                 //_showText ? Text('Hello') : Text('Bye'),
//                                 _showText ? SizedBox(
//                                   width: 50,
//                                   height: 50,
//                                   child: Text(
//                                     'Hello',
//                                     style: TextStyle(
//                                       color: Colors.blue,
//                                     ),
//                                   ),
//                                 ) : Text('Bye'),
//                                 //textAlign: TextAlign.center,
//                               //),
//                               onPressed: () => _changeText(),
//
//                             ),  */
//         ],
//       ),
//     ),
//     // ],
//
//     // ),
//
//     //  ),
//
//     /*
//     floatingActionButton: FloatingActionButton(
//       onPressed: () => print('Hello'),
//       tooltip: 'Increment',
//       child: Icon(Icons.add),
//     ), */
//    bottomNavigationBar: NavBar(currentIndex: 3,),
//   );
//}
}
