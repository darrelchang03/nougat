import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:noot_app/screens/home_page.dart';
import 'APost.dart';

class UserProfile extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        title: Text('Nougat'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Icon(
              Icons.account_circle,
              size: 200,
            ),
            SizedBox(height: 20),
            Text(
              "darrel",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Divider(
              color: Colors.grey[600],
              thickness: 2,
              indent: 15,
              endIndent: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push (
                        context,
                        MaterialPageRoute(builder: (context) => APost()),
                      );
                    },
                    child:
                      Image(
                        image: AssetImage('assets/image.png'),
                      ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
