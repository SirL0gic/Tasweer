import 'package:flutter/material.dart';
import 'package:tasweer/HomeScreen1.dart';
import 'package:tasweer/SearchButton.dart';

class Setting extends StatefulWidget {
  Setting({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  void _closeEndDrawer() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    //String assetName = 'assets/icons/home-alt.svg';
    return Drawer(
      child: Stack(
        children: <Widget>[
          Container(
            width: 1000,
            height: 1000,
            color: Color(0xffededed),
            //child: Down3(),
          ),
          //),
          Container(),
          ListView(
            //padding: const EdgeInsets.all(0),
            // Important: Remove any padding from the ListView.
            //padding: EdgeInsets.zero,
            children: <Widget>[
              /*DrawerHeader(
                  child: Text("Settings"),
                  decoration: BoxDecoration(
                    color: Color(0xffededed),
                  ),
                ),*/

              Stack(
                children: <Widget>[
                  /*Container(
                      width: 1000,
                      height: 40,
                      child: Down3()
                  ),*/
                  ListTile(
                    contentPadding: EdgeInsets.fromLTRB(25, 30, 25, 65),
                    title: Text(
                      "Settings",
                      style: TextStyle(
                        //color: Colors.grey[600],
                        color: Colors.blueGrey[400],
                        fontSize: 25,
                        fontFamily: "Helvetica",
                        fontWeight: FontWeight.bold,
                        //fontStyle: FontStyle.italic
                      ),
                    ),
                    trailing: Stack(
                      //width: 10,
                      children: <Widget>[
                        //Padding(padding: EdgeInsets.fromLTRB(0, 0, 30, 0)),
                        Container(
                          width: 45,
                          height: 45,
                          child: SearchButton(),
                        ),
                        Container(
                          width: 45,
                          height: 45,
                          child: IconButton(
                            icon: Icon(
                              Icons.search,
                              //color: Colors.grey[350],
                              color: Colors.blueGrey[200],
                              size: 20,
                            ),
                            /*onPressed: () {
                                showSearch(
                                    context: context, delegate: Search extends SearchDelegate(),
                                ),
                              }*/
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(25, 10, 8, 10),
                title: Text(
                  "Account",
                  style: TextStyle(
                    //color: Colors.grey[600],
                    color: Colors.blueGrey[400],
                    fontSize: 18,
                    fontFamily: "Helvetica",
                    fontWeight: FontWeight.bold,
                    //fontStyle: FontStyle.italic
                  ),
                ),
                leading: Stack(
                  //width: 10,
                  children: <Widget>[
                    Container(
                      width: 45,
                      height: 45,
                      child: SearchButton(),
                    ),
                    Container(
                      width: 45,
                      height: 45,
                      child: Icon(
                        Icons.account_circle_outlined,
                        //color: Colors.grey[350],
                        color: Colors.blueGrey[200],
                        size: 30,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(25, 5, 8, 10),
                title: Text(
                  "Notifications",
                  style: TextStyle(
                    //color: Colors.grey[600],
                    color: Colors.blueGrey[400],
                    fontSize: 18,
                    fontFamily: "Helvetica",
                    fontWeight: FontWeight.bold,
                    //fontStyle: FontStyle.italic
                  ),
                ),
                leading: Stack(
                  //width: 10,
                  children: <Widget>[
                    Container(
                      width: 45,
                      height: 45,
                      child: SearchButton(),
                    ),
                    Container(
                      width: 45,
                      height: 45,
                      child: Icon(
                        Icons.notifications_none_outlined,
                        //color: Colors.grey[350],
                        color: Colors.blueGrey[200],
                        size: 30,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(25, 5, 8, 10),
                title: Text(
                  "Security",
                  style: TextStyle(
                    //color: Colors.grey[600],
                    color: Colors.blueGrey[400],
                    fontSize: 18,
                    fontFamily: "Helvetica",
                    fontWeight: FontWeight.bold,
                    //fontStyle: FontStyle.italic
                  ),
                ),
                leading: Stack(
                  //width: 10,
                  children: <Widget>[
                    Container(
                      width: 45,
                      height: 45,
                      child: SearchButton(),
                    ),
                    Container(
                      width: 45,
                      height: 45,
                      child: Icon(
                        Icons.security_outlined,
                        //color: Colors.grey[350],
                        color: Colors.blueGrey[200],
                        size: 30,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(25, 5, 8, 10),
                title: Text(
                  "Apperance",
                  style: TextStyle(
                    //color: Colors.grey[600],
                    color: Colors.blueGrey[400],
                    fontSize: 18,
                    fontFamily: "Helvetica",
                    fontWeight: FontWeight.bold,
                    //fontStyle: FontStyle.italic
                  ),
                ),
                leading: Stack(
                  //width: 10,
                  children: <Widget>[
                    Container(
                      width: 45,
                      height: 45,
                      child: SearchButton(),
                    ),
                    Container(
                      width: 45,
                      height: 45,
                      child: Icon(
                        Icons.settings_outlined,
                        //color: Colors.grey[350],
                        color: Colors.blueGrey[200],
                        size: 30,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(25, 5, 8, 10),
                title: Text(
                  "Help",
                  style: TextStyle(
                    //color: Colors.grey[600],
                    color: Colors.blueGrey[400],
                    fontSize: 18,
                    fontFamily: "Helvetica",
                    fontWeight: FontWeight.bold,
                    //fontStyle: FontStyle.italic
                  ),
                ),
                leading: Stack(
                  //width: 10,
                  children: <Widget>[
                    Container(
                      width: 45,
                      height: 45,
                      child: SearchButton(),
                    ),
                    Container(
                      width: 45,
                      height: 45,
                      child: Icon(
                        Icons.help_outline,
                        //color: Colors.grey[350],
                        color: Colors.blueGrey[200],
                        size: 30,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(25, 5, 8, 10),
                title: Text(
                  "Invite Friends",
                  style: TextStyle(
                    //color: Colors.grey[600],
                    color: Colors.blueGrey[400],
                    fontSize: 18,
                    fontFamily: "Helvetica",
                    fontWeight: FontWeight.bold,
                    //fontStyle: FontStyle.italic
                  ),
                ),
                leading: Stack(
                  //width: 10,
                  children: <Widget>[
                    Container(
                      width: 45,
                      height: 45,
                      child: SearchButton(),
                    ),
                    Container(
                      width: 45,
                      height: 45,
                      child: Icon(
                        Icons.group_outlined,
                        //color: Colors.grey[350],
                        color: Colors.blueGrey[200],
                        size: 30,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(25, 5, 8, 10),
                title: Text(
                  "Log Out",
                  style: TextStyle(
                    //color: Colors.grey[600],
                    color: Colors.blueGrey[400],
                    fontSize: 18,
                    fontFamily: "Helvetica",
                    fontWeight: FontWeight.bold,
                    //fontStyle: FontStyle.italic
                  ),
                ),
                leading: Stack(
                  //width: 10,
                  children: <Widget>[
                    Container(
                      width: 45,
                      height: 45,
                      child: SearchButton(),
                    ),
                    GestureDetector(
                      onTap: () async{
                        print('Pressed');
                        await gSignIn.signOut();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen(imageURL: '')));
                      },
                      child: Container(
                        width: 45,
                        height: 45,
                        child: Icon(
                          Icons.logout,
                          //color: Colors.grey[350],
                          color: Colors.blueGrey[200],
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
            ],
          ),
          //),
        ],
      ),

      //),
    );
    //);
  }
}

/*class Search extends SearchDelegate {
}*/
