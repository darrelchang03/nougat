import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noot_app/screens/home_page.dart';
import 'package:noot_app/screens/post.dart';
import 'dart:io';
import 'package:noot_app/screens/profile.dart';
import 'package:firebase_storage/firebase_storage.dart';


class CaptionPage extends StatefulWidget {
  final List<dynamic> selectedImages;

  CaptionPage({required this.selectedImages});

  @override
  _CaptionPageState createState() => _CaptionPageState();
}

class _CaptionPageState extends State<CaptionPage> {

  TextEditingController _captionController = TextEditingController();
  TextEditingController _ingredientController = TextEditingController();
  TextEditingController _recipeController = TextEditingController();
  final PageController _pageController = PageController();
  double _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onPageChanged(int pageIndex) {
    setState(() {
      _currentPage = pageIndex.toDouble();
    });
  }

  uploadImage(filepath) async {
    UploadTask uploadTask = storageRef.child("post_.jpg").putFile(File(filepath));
    TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
    String downloadURL = await snapshot.ref.getDownloadURL();
    return downloadURL;

  }



  void _sharePost() async {
    final userId = currentUserRef.uid; //
    final caption = _captionController.text.trim();
    final ingredients = _ingredientController.text.trim();
    final recipe = _recipeController.text.trim();
    final timestamp = DateTime.now();

    List<String> imageUrls = [];

    for(int i=0; i<widget.selectedImages.length; i++) {
      String downloadUrl = await uploadImage(widget.selectedImages[i]);
      imageUrls.add(downloadUrl);
    }

    final post = Post(
      userId: userId,
      // imageUrls: uploadImage(widget.selectedImages.map((image) => image).toList()),
      imageUrls: imageUrls,
      caption: caption,
      ingredients: ingredients,
      recipe: recipe,
      timestamp: timestamp,
    );

    await post.savePost();

    // Show success message or navigate to home page
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Post shared successfully')),
    );
    // Navigator.push(context, MaterialPageRoute(builder: (context) => const ))
    // go to post that was just created
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[800],
          title: Text('Caption Post'),
          actions: [
            IconButton(
              icon: Icon(Icons.upload),
              onPressed: _sharePost,
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              // child: ListView.builder(
              //   itemCount: widget.selectedImages.length,
              //   itemBuilder: (context, index) {
              //     final image = widget.selectedImages[index];
              //   },
              // ),
              child:

                Stack(
                  children: [
                    PageView.builder(
                    itemCount: widget.selectedImages.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Image.file(File(widget.selectedImages[index]));
                    },
                  ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: DotsIndicator(
                          dotsCount: widget.selectedImages.length,
                          position: _currentPage.round(),
                          decorator: DotsDecorator(
                            size: Size.square(10),
                            activeSize: Size(20, 10),
                            color: Colors.grey,
                            activeColor: Colors.white,
                          ),
                        ),
                    )
                ]),

            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: _captionController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Write a caption',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: _ingredientController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'List ingredients used',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: _recipeController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Write your recipe here',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Post {
  final String userId;
  final List<dynamic> imageUrls;
  final String caption;
  final String ingredients;
  final String recipe;
  final DateTime timestamp;

  Post({
    required this.userId,
    required this.imageUrls,
    required this.caption,
    required this.ingredients,
    required this.recipe,
    required this.timestamp,
  });

  Future<void> savePost() async {
    final usersDocRef = FirebaseFirestore.instance.collection('users').doc(currentUserRef.uid);
    final postDocRef = usersDocRef.collection('posts').doc();
    // final postDocRef = FirebaseFirestore.instance.collection('users.' + currentUserRef.uid + '.posts').doc();

    await postDocRef.set({
      'userId': userId,
      'imageUrls': imageUrls,
      'caption': caption,
      'ingredients': ingredients,
      'recipe': recipe,
      'timestamp': timestamp,
    });
  }
}
