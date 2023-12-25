import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thebridges/drawer.dart';
import 'package:thebridges/profile.dart';
import 'package:thebridges/wallpost.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final user = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();

  void signoutuser() {
    FirebaseAuth.instance.signOut();
  }

  void postmessage() {
    if (textController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("Users Posts").add({
        'UserEmail': user.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
        'likes': [],
      });
    }

    setState(() {
      textController.clear();
    });
  }

//navigate to profilepage
  void gotoProfilePage() {
    Navigator.pop(context);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Profilepage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Text('The Bridge'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: signoutuser,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      drawer: MyDrawer(
        onProfiletap: gotoProfilePage,
        onsignoutap: signoutuser,
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Users Posts")
                .orderBy(
                  "TimeStamp",
                  descending: false,
                )
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      //get the message
                      final post = snapshot.data!.docs[index];
                      return Wallpost(
                        message: post['Message'],
                        user: post['UserEmail'],
                        postid: post.id,
                        likes: List<String>.from(post['likes'] ?? []),
                      );
                    });
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error:${snapshot.error}'),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          )),

          //post message

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  width: 290, // Adjust the width as needed
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: 'Write Something on the Bridge',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),

              //post button
              IconButton(
                  onPressed: postmessage, icon: Icon(Icons.arrow_circle_up))
            ],
          ),
          Text('Signed in as ${user.email}'),
        ],
      ),
    );
  }
}





// MaterialButton(
          //   onPressed: () {
          //     FirebaseAuth.instance.signOut();
          //   },
          //   color: Colors.deepPurple[200],
          //   child: const Text('Sign Out'),
          // )


          // Sign in the user after successful registration

        // await FirebaseAuth.instance.signInWithEmailAndPassword(
        //   email: _emailcontroller.text.trim(),
        //   password: _passwordcontroller.text.trim(),
        // );
