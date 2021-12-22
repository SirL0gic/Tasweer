import 'package:flutter/material.dart';
import './NavBar.dart';
import 'camera_func.dart';
import 'post_data.dart';
import 'post_widget.dart';
import 'users.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'db_ops.dart';
import 'map_view.dart';
import 'package:provider/provider.dart';
import 'info_window.dart';


/**
 * Implemented google sign in for flutter from:
 * https://www.youtube.com/playlist?list=PLxefhmF0pcPkC__GnBhBmGl4013eBYLWh
 * (Accessed 1/4/2021)
 */

final gSignIn = GoogleSignIn();

final CollectionReference usersRef = Firestore.instance.collection('users');

final CollectionReference globalPostsRef =
    Firestore.instance.collection('posts');

final CollectionReference reportedPostsRef =
    Firestore.instance.collection('reportedPosts');

final CollectionReference communitiesRef =
    Firestore.instance.collection('communities');

final CollectionReference leaderboardRef = Firestore.instance.collection('leaderboard');

Future<DocumentReference> currentUserRef;
Future<DocumentReference> communityRef;

User currentUser;
List<PostData> postsList = [];
List<PostData> followersPosts = [];

class HomeScreen extends StatefulWidget {
  String imageURL;

  HomeScreen({this.imageURL});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool hasSignedIn = false;

  @override
  void initState() {
    super.initState();

    gSignIn.onCurrentUserChanged.listen((gSignInAccount) {
      manageSignIn(gSignInAccount);
    }, onError: (gError) {
      print("Error Occurred" + gError);
    });

    gSignIn.signInSilently(suppressErrors: false).then((gSignInAccount) {
      manageSignIn(gSignInAccount);
    }).catchError((gError) {
      print("Error Occurred" + gError);
    });
  }

  void getPosts() async {
    // QuerySnapshot qSnap = await usersRef
    //     .document(currentUser.id)
    //     .collection("userPosts")
    //     .orderBy("timestamp", descending: true)
    //     .getDocuments();

    QuerySnapshot qSnap = await globalPostsRef
        .orderBy("timestamp", descending: true)
        .getDocuments();

    setState(() {
      postsList = qSnap.documents
          .map((documentSnapshot) => PostData.fromDocument(documentSnapshot))
          .where((element) =>
              currentUser.following.contains(element.ownerID) ||
              currentUser.id == element.ownerID)
          .toList();
    });
  }

  void manageSignIn(GoogleSignInAccount gSignInAccount) async {
    if (gSignInAccount != null) {
      setState(() {
        hasSignedIn = true;
        saveUserInfoToFirestore();
      });
    } else {
      setState(() {
        hasSignedIn = false;
      });
    }
  }

  void logUserIn() {
    gSignIn.signIn();
  }

  void saveUserInfoToFirestore() async {
    final gCurrentUser = gSignIn.currentUser;
    DocumentSnapshot documentSnapshot =
        await usersRef.document(gCurrentUser.id).get();

    if (!documentSnapshot.exists) {
      String username = gCurrentUser.displayName;
      await addUser(usersRef, gCurrentUser.id, gCurrentUser.email,
          gCurrentUser.displayName, gCurrentUser.photoUrl);

      documentSnapshot = await usersRef.document(gCurrentUser.id).get();
    }

    currentUserRef = getDocWithID(usersRef, gCurrentUser.id);
    currentUser = User.fromDocument(documentSnapshot);
    getPosts();
  }

  Widget googleLoginButton() {
    return OutlineButton(
        onPressed: logUserIn,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
        splashColor: Colors.grey,
        borderSide: BorderSide(color: Colors.grey),
        child: Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                    image: AssetImage('assets/images/google_logo.png'),
                    height: 35),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text('Sign in with Google',
                        style: TextStyle(color: Colors.grey, fontSize: 25)))
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    if (hasSignedIn) {

      /**
       * Found out about disabling the android back button using WillPopScope here:
       * https://stackoverflow.com/questions/45916658/how-to-deactivate-or-override-the-android-back-button-in-flutter
       * (Accessed 1/4/2021)
       */

      return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(

                            builder: (context) => ChangeNotifierProvider(
                                create: (context) => InfoWindowModel(),
                                child: MapView())));
                  },
                  icon: Icon(
                    Icons.map,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.notifications_none_outlined,
                    color: Colors.black,
                  ),
                ),
                FlatButton(
                  height: 45,
                  minWidth: 125,
                  color: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onPressed: () {
                    // gSignIn.signOut();
                  },
                  child: Text(
                    "Home",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 19,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                  },
                  icon: Icon(
                    Icons.messenger_outline_rounded,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyHomePage()));
                  },
                  icon: Icon(
                    Icons.add_a_photo_outlined,
                  ),
                ),
              ],
            ),
          ),
          body: Container(
            margin: EdgeInsets.only(top: 15),
            child: (postsList.length != 0)
                ? ListView.builder(
                    itemCount: postsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final PostData postInfo = postsList[index];
                      return new Post(
                        postData: postInfo,
                      );
                    },
                  )
                : Container(
                    alignment: Alignment.center,
                    child: Text(
                      "    Follow Users from the\nExplore Page to View Posts\n    Or Post One Yourself :)",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                  ),
          ),
          bottomNavigationBar: NavBar(
            currentIndex: 0,
          ),
        ),
      );
    } else {
      return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: Container(
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 300,
                    width: 300,
                    child: SvgPicture.asset("assets/images/AlternateLogo.svg",
                        semanticsLabel: 'Tasweer Logo'),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  googleLoginButton(),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
