import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class Upload extends StatefulWidget {
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {

  late File file = File('lib/images/a.svg');

  handleTakePhoto() async {
    Navigator.pop(context);
    File file = (await ImagePicker.platform.pickImage(source: ImageSource.camera,
      maxHeight: 675,
      maxWidth: 960,
    )) as File;
    setState(() {
      this.file = file;
    });
  }

  handleChooseFromGallery() async{
   Navigator.pop(context);
   File file = (await ImagePicker.platform.pickImage(source: ImageSource.gallery,
   )) as File;
   setState(() {
     this.file = file;
   });
  }

  selectImage(parentContext) {
    return showDialog(
      context: parentContext,
      builder: (context){
        return SimpleDialog(
          title: Text("Create Post"),
          children: <Widget>[
            SimpleDialogOption(
              child: Text("Photo with Camera"),
              onPressed: handleTakePhoto(),
            ),
            SimpleDialogOption(
              child: Text("Image from Gallery"),
              onPressed: handleChooseFromGallery(),
            ),
            SimpleDialogOption(
                child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      }
    );
  }

  Container buildSplashScreen() {
    return Container(
      color: Colors.grey[700],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset('lib/images/a.svg', height: 260,
          ),
          Padding(
              padding: EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: () => selectImage(context),
                child: Text("Upload Image",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22
                    ,)
                  ,)
              ),
          ),
        ],
      ),
    );
  }

  buildUploadForm() {
    return Text("File loaded");
  }


  @override
  Widget build(BuildContext context) {
    return file.path == ('lib/images/a.svg') ? buildSplashScreen() : buildUploadForm();
  }
}