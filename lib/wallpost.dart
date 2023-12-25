import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thebridges/Comment.dart';
import 'package:thebridges/delete_button.dart';
import 'package:thebridges/helper.dart';
import 'package:thebridges/likes_button.dart';
import 'package:thebridges/mycommentbutton.dart';

class Wallpost extends StatefulWidget {
  final String message;
  final String user;
  final String postid;
  final List<String> likes;

  const Wallpost({
    super.key,
    required this.message,
    required this.user,
    required this.postid,
    required this.likes,
  });

  @override
  State<Wallpost> createState() => _WallpostState();
}

class _WallpostState extends State<Wallpost> {
//user
  final currentuser = FirebaseAuth.instance.currentUser;
  bool isliked = false;
  final _commentcontroller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isliked = widget.likes.contains(currentuser?.email);
  }

  void toggleLike() {
    setState(() {
      isliked = !isliked;
    });

    //
    DocumentReference postref =
        FirebaseFirestore.instance.collection('Users Posts').doc(widget.postid);
    if (isliked) {
      postref.update({
        'likes': FieldValue.arrayUnion([currentuser?.email])
      });
    } else {
      postref.update({
        'likes': FieldValue.arrayRemove([currentuser?.email])
      });
    }
  }

  void addComment(String commentText) {
    FirebaseFirestore.instance
        .collection("Users Posts")
        .doc(widget.postid)
        .collection("Comments")
        .add({
      "CommentText": commentText,
      "CommentedBy": currentuser!.email,
      "CommentTime": Timestamp.now(),
    });
  }

  void ShowCommentDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Add Comment'),
              content: TextField(
                controller: _commentcontroller,
                decoration: InputDecoration(hintText: 'Write a commnt..'),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      addComment(_commentcontroller.text);

                      Navigator.pop(context);

                      _commentcontroller.clear();
                    },
                    child: const Text(
                      'Post',
                    )),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _commentcontroller.clear();
                    },
                    child: const Text(
                      'Cancel',
                    )),
              ],
            ));
  }

  void deletepost() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Cancel"),
              content: Text("Are you sure you want to delete"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                    )),
                TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      //delete comment
                      final commentdocs = await FirebaseFirestore.instance
                          .collection("Users Posts")
                          .doc(widget.postid)
                          .collection("Comments")
                          .get();

                      for (var doc in commentdocs.docs) {
                        await FirebaseFirestore.instance
                            .collection("Users Posts")
                            .doc(widget.postid)
                            .collection("Comments")
                            .doc(doc.id)
                            .delete();
                      }
                      FirebaseFirestore.instance
                          .collection("Users Posts")
                          .doc(widget.postid)
                          .delete();
                      //     .then((value) => print("post deleted"))
                      //     .catchError((error) =>
                      //         print("failed to delete post: $error"));

                      // Navigator.pop(context);
                    },
                    child: const Text(
                      'Delete',
                    )),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.all(25),
      padding: const EdgeInsets.all(25),
      child: Column(
        //wallpost
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: 20,
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //user
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.user,
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                  if (widget.user == currentuser!.email)
                    MyWidget(onTap: deletepost),
                ],
              ),
              const SizedBox(
                height: 5,
              ),

              //message
              Text(
                widget.message,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
//like button

                  Likebutton(isliked: isliked, onclicked: toggleLike),

                  const SizedBox(
                    height: 5,
                  ),
                  Text(widget.likes.length.toString()),
                ],
              ),

              const SizedBox(
                width: 10,
              ),

              //comment
              Column(
                children: [
//like button

                  CommentButton(ontap: ShowCommentDialog),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text('0', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),

          //comments under the post
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Users Posts")
                .doc(widget.postid)
                .collection("Comments")
                .orderBy("CommentTime", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              //show loading Circle if no data yet

              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((doc) {
                  //get the comment
                  final commentData = doc.data() as Map<String, dynamic>;

                  //return th comment
                  return Comment(
                    text: commentData["CommentText"],
                    user: commentData["CommentedBy"],
                    time: formatdata(commentData["CommentTime"]),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
