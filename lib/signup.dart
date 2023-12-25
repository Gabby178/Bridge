import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thebridges/Homepage.dart';
import 'package:thebridges/login.dart';
// import 'package:thebridges/main_page.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  final _confirmpasswordcontroller = TextEditingController();
  final _firstNamecontroller = TextEditingController();
  final _SecondNamecontroller = TextEditingController();
  final _agecontroller = TextEditingController();

  Future signup() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    if (_passwordcontroller.text.trim() !=
        _confirmpasswordcontroller.text.trim()) {
      Navigator.pop(context);

      showErrorMessage('password dont match');
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailcontroller.text.trim(),
              password: _passwordcontroller.text.trim());

      FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
        'username': _emailcontroller.text.split('@')[0],
        'bio': 'Empty bio'
      });

      // Navigate to the homepage after successful signup

      Navigator.pop(context);

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Homepage()));

      addUserDetails(
          _firstNamecontroller.text.trim(),
          _SecondNamecontroller.text.trim(),
          _emailcontroller.text.trim(),
          int.parse(_agecontroller.text.trim()));
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showErrorMessage(e.code);
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.deepPurple,
        title: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    _confirmpasswordcontroller.dispose();
    _agecontroller.dispose();
    _firstNamecontroller.dispose();
    _SecondNamecontroller.dispose();
    super.dispose();
  }

  Future addUserDetails(
      String firstname, String lastname, String email, int age) async {
    await FirebaseFirestore.instance.collection('users').add({
      'first name': firstname,
      'last name': lastname,
      'email': email,
      'age': age,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 100,
              ),
              const Icon(
                Icons.login,
                size: 50,
              ),
              const SizedBox(
                height: 15,
              ),
              //hello again
              const Text(
                'Hello There',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Signup Please',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              //Email
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: _emailcontroller,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: _firstNamecontroller,
                  decoration: InputDecoration(
                    hintText: 'Firstname',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: _SecondNamecontroller,
                  decoration: InputDecoration(
                    hintText: 'SecondName',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: _agecontroller,
                  decoration: InputDecoration(
                    hintText: 'Age',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              //password
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: _passwordcontroller,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              //confirmpassword
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: _confirmpasswordcontroller,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              GestureDetector(
                onTap: signup,
                child: Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8.0)),
                  child: const Center(
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Login(),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.lightBlue,
                  textStyle: const TextStyle(
                    fontSize: 15,
                  ),
                ),
                child: const Text("Login into your Account"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
