import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:noot_app/screens/profile.dart';
import '../auth.dart';
import 'package:noot_app/screens/feed.dart';
import 'package:noot_app/screens/post.dart';
import 'package:noot_app/screens/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noot_app/screens/create_account.dart';
import 'package:noot_app/models/user.dart';
import 'search2.dart';
import 'upload.dart';
import 'package:firebase_storage/firebase_storage.dart';


UserModel? currentUser;
var currentUserRef = FirebaseAuth.instance.currentUser!;
final DateTime timestamp = DateTime.now();
var usersRef = FirebaseFirestore.instance.collection('users');
final Reference storageRef = FirebaseStorage.instance.ref();

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  createUserInFirestore () async {
    // Check if user exits in users collection in database (searching their id)
    usersRef = FirebaseFirestore.instance.collection('users');
    currentUserRef = FirebaseAuth.instance.currentUser!;
    DocumentSnapshot doc = await usersRef.doc(currentUserRef.uid).get();
    var username;

    if(!doc.exists) {
      // If the user doesn't exist, then take them to create account page
      username = await Navigator.push(context, MaterialPageRoute
        (builder: (context) => CreateAccount()));

      // Get username from create account, use it to make new user document in users collection
      usersRef.doc(currentUserRef!.uid).set({
        "id": currentUserRef.uid,
        "username": username,
        "photoUrl": currentUserRef.photoURL,
        "email": currentUserRef.email,
        "displayName": currentUserRef.displayName,
        "bio": "",
        "timestamp": timestamp
      });
      doc = await usersRef.doc(currentUserRef.uid).get();

    }
    currentUser = UserModel.fromDocument(doc);
  }

  final List<Widget> _pages = [
    UserFeed(),
    PostPage(),
    SearchPage(),
    UserProfile(),
  ];


  @override
  Widget build(BuildContext context) {
    createUserInFirestore();
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle_rounded), label: ''),
        ],
      ),
    );
  }
}
