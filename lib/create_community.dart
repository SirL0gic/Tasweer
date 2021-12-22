import 'package:flutter/material.dart';
import 'package:file/file.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tasweer/users.dart';
import 'new_comm_members.dart';
import 'community_data.dart';
import 'intermediate.dart';
import 'package:tasweer/HomeScreen1.dart';
import 'db_ops.dart';
import 'package:cached_network_image/cached_network_image.dart';

/**
 * Code for create communities was inspired from Wiggle2 found here:
 * https://github.com/habi39/Wiggle2
 *
 * Accessed 1/4/2021
 **/

class CreateCommunity extends StatefulWidget {
  // List<User> members;
  // CreateCommunity({this.members});
  @override
  _createCommunityState createState() => _createCommunityState();
}

class _createCommunityState extends State<CreateCommunity> {
  String commName = "";
  String imageURL = "";
  //File _image;
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  // The community to create
  CommunityData community;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Create Community",
            style: TextStyle(
              color: Theme.of(context).accentColor, // App bar stuff
            ),
          ),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            color: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.pop(context,null);
            },
            icon: Icon(
              Icons.chevron_left,
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: Container(
          margin: EdgeInsets.only(left: 25, top: 10, right: 25),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Center(
                  child: Column(
                    children: [
                      Container(
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 60,
                          child: ClipOval(
                            child: new SizedBox(
                              width: 180,
                              height: 180,
                              child: (imageURL != "")
                                  ? CachedNetworkImage(
                                imageUrl: imageURL,
                              )
                                  : Image.asset("assets/images/community.png"),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                          color: Colors.black,
                          icon: Icon(Icons.camera_alt, size: 30),
                          onPressed: () async{

                            if(_formKey.currentState.validate()){

                              String result =  await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Cam(name: commName,)),);

                              print("Result = $result");
                              if(result != "")
                                setState(() {
                                  imageURL = result;
                                });
                            }
                          }),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    "Community Name",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: (val) {
                    /* If the text field is empty or contains spaces/special symbols then
                         notify user.
                       */
                    return (val.isEmpty ||
                        (val.contains(
                            new RegExp(r'(\s)+([A-Z][a-z][0-9])*'))))
                        ? 'Please provide a name'
                        : null;
                  },
                  onChanged: (val) {
                    setState(() => commName = val);
                  },
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(8),
                    isDense: true,
                    hintText: 'Name',
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
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton(
                      child: Text(
                        "Add/Remove Members",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UsersList(/*userTiles: userTileList,*/),
                            ));
                      },
                      color: Colors.grey[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: FlatButton(
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async{
                      if (_formKey.currentState.validate()) {
                        /* If the name is valid, create a new community with atleast the
                           current user in it.
                         */

                        String imgURL = "";

                        if(imageURL == "")
                          imageURL = "assets/images/community.png";

                        // Add the current user to the community members list
                        communityMembers.insert(0, currentUser);

                        community = new CommunityData(
                          name: commName,
                          commImgURL: imageURL,
                          members: communityMembers,
                        );

                        communityRef = getDocWithID(communitiesRef, commName);

                        if(communityRef == null)
                          addCommunity(communitiesRef, commName, imageURL);

                        Navigator.pop(context, community);
                      }
                    },
                    color: Colors.grey[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      //side: BorderSide(color: Colors.black)
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
