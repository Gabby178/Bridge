import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:thebridges/textbox.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  final currentuser = FirebaseAuth.instance.currentUser!;
  final usercollection = FirebaseFirestore.instance.collection("Users");
  //edit field
  Future<void> editFiled(String field) async {
    String newValue = "";
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Edit $field"),
              content: TextField(
                autofocus: true,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: "Enter new $field",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onChanged: (value) {
                  newValue = value;
                },
              ),
              actions: [
                //cancel btn
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.black))),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(newValue),
                  child:
                      const Text('Save', style: TextStyle(color: Colors.black)),
                )
              ],
            ));

    //update in the firestore
    if (newValue.length > 0) {
      await usercollection.doc(currentuser.email).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
        backgroundColor: Colors.grey[900],
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(currentuser.email)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;
              return ListView(
                children: [
                  const SizedBox(
                    height: 50,
                  ),

                  //profile pic
                  const Icon(
                    Icons.person,
                    size: 72,
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  Text(
                    currentuser.email!,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(
                    height: 50,
                  ),

                  //user details
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Text(
                      'My Details',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),

                  //username
                  MyTextBox(
                      text: userData['username'],
                      sectionName: 'Username',
                      onPressed: () => editFiled('username')),

                  //bio
                  MyTextBox(
                      text: userData['bio'],
                      sectionName: 'bio',
                      onPressed: () => editFiled('bio')),

                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Text(
                      'My Posts',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error${snapshot.error}'),
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
