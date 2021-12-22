import 'package:flutter/material.dart';
import 'post_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasweer/HomeScreen1.dart';
import 'comment_data.dart';
import 'package:uuid/uuid.dart';
import 'db_ops.dart';
import 'post_widget.dart';

class CommentsScreen extends StatefulWidget {

  PostData post;

  CommentsScreen({this.post});

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  bool isSendEnabled = false;

  List<CommentData> _comments = [];
  String commentToAdd = '';

  final commentComposerController = TextEditingController();

  void dispose() {
    commentComposerController.dispose();
    super.dispose();
  }

  void isEmpty() {
    setState(() {
      if (commentComposerController.text.trim() != "") {
        isSendEnabled = true;
      } else {
        isSendEnabled = false;
      }
    });
  }

  void getComments() async{

    print("PostID is ${widget.post.postID}");

    QuerySnapshot qSnap = await globalPostsRef.document(widget.post.postID).collection("comments")
        .orderBy("timestamp", descending: false)
        .getDocuments();

    setState(() {
      _comments = qSnap.documents
          .map((documentSnapshot) => CommentData.fromDocument(documentSnapshot))
          .toList();
    });
  }

  void initState() {
    super.initState();
    if (commentComposerController.text.trim() != "") {
      isSendEnabled = true;
    } else {
      isSendEnabled = false;
    }
    getComments();
  }

  //int index;

  // Upload to DB
  void _addComment() {
    String commentID = Uuid().v4();
    CommentData comment = CommentData(
      commentID: commentID,
      comment: commentToAdd,
      username: currentUser.username,
      userPPURL: currentUser.ppURL,
      isReported: false,
    );

    setState(() {
      _comments.add(comment);
    });

    storeComment(comment, widget.post);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        elevation: 0,
        title: Text(
          "Comments",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[700],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          child: ListView.builder(
              //physics: AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
            if (index < _comments.length) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(_comments[index].userPPURL),
                ),
                title: Row(
                  children: [
                    Text(
                      _comments[index].username.split(" ").first,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded( child: Container(child: Text(_comments[index].comment), )),
                  ],
                ),
                trailing: IconButton(
                  icon: _comments[index].username == currentUser.username ? Icon(
                    Icons.more_horiz,
                  ) : SizedBox.shrink(),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            //title: Text('Hello Everyone'),
                            //content: Text('Body of Alert Dialog'),
                            actions: <Widget>[
                              Container(
                                width: 50.0,
                                height: 20.0,
                              ),
                              FlatButton(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 60.0),
                                  child: Text(
                                    'Report Comment',
                                    style: TextStyle(
                                      fontFamily: 'Helvetica',
                                      fontSize: 16,
                                      color: const Color(0xff9a9a9a),
                                      fontWeight: FontWeight.w700,
                                    ),
                                    //textAlign: TextAlign.right,
                                  ),
                                ),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          title: Text(
                                            'This comment has been sent for review. Thank you',
                                            style: TextStyle(
                                              fontFamily: 'Helvetica',
                                              fontSize: 16,
                                              color: const Color(0xff9a9a9a),
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        );
                                      });
                                },
                              ),
                            ],
                          );
                        });
                  },
                ),
              );
            }
            return null;
          }),
        ),
      ),
      bottomNavigationBar: Transform.translate(
        offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          //height: 100.0,
          height: 80.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            ),
            color: Colors.grey[300],
          ),
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: CircleAvatar(
                    radius: 25.0,
                    backgroundImage:
                    NetworkImage(currentUser.ppURL),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      isEmpty();
                      commentToAdd = value;
                    },
                    onEditingComplete: (){
                      FocusScope.of(context).unfocus();
                      if(isSendEnabled){
                        isSendEnabled = false;
                        commentComposerController.clear();
                        _addComment();
                      }
                    },
                    controller: commentComposerController,
                    decoration: InputDecoration.collapsed(
                      hintText: 'Add a comment',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color:isSendEnabled? Colors.blueGrey[700] : Colors.blueGrey[200],
                  ),
                  onPressed: isSendEnabled? () {
                    FocusScope.of(context).unfocus();
                    isSendEnabled = false;
                    commentComposerController.clear();
                    _addComment();
                  } :null,

                  //disabledColor: Colors.blueGrey[200],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
