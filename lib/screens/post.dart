import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'caption_page.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  List<AssetEntity> cameraRollImages = [];
  List<AssetEntity> selectedCameraRollImages = [];

  @override
  void initState() {
    super.initState();
    _fetchCameraRollImages();
  }

  void _fetchCameraRollImages() async {
    final result = await PhotoManager.requestPermissionExtend();
    if (result.hasAccess) {
      final albums = await PhotoManager.getAssetPathList(onlyAll: true);
      final cameraRoll = albums.first;
      final assets = await cameraRoll.getAssetListRange(start: 0, end: 100);
      setState(() {
        cameraRollImages = assets;
      });
    } else {
      // Handle permission denied
    }
  }

  void _selectImageFromCameraRoll(AssetEntity asset) {
    if (selectedCameraRollImages.contains(asset)) {
      selectedCameraRollImages.remove(asset);
    } else {
      selectedCameraRollImages.add(asset);
    }
    setState(() {});
  }
  List<String> selectedImagesFiles = [];

  void _navigateToCaptionPage() async {
    // final List<dynamic> selectedImagesFiles = selectedCameraRollImages.map((asset) => asset.originFile?.path).toList();
    PermissionState permission = await PhotoManager.requestPermissionExtend();
    if (permission == PermissionState.authorized) {
      List<AssetPathEntity> pathList = await PhotoManager.getAssetPathList();
      List<AssetEntity> selectedImages = [];
      for (AssetPathEntity path in pathList) {
        List<AssetEntity> assets = await path.getAssetListRange(
            start: 0, end: path.assetCount);
        selectedImages.addAll(assets);
      }
      for (AssetEntity asset in selectedImages) {
        File? imageFile = await asset.file;
        if (imageFile != null) {
          selectedImagesFiles.add(imageFile.path);
        }
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              CaptionPage(selectedImages: selectedImagesFiles),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[800],
          title: Text('Create Post'),
          actions: [
            IconButton(
              icon: Icon(Icons.navigate_next),
              onPressed: selectedCameraRollImages.isNotEmpty ? _navigateToCaptionPage : null,
            ),
          ],
        ),
        body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemCount: cameraRollImages.length,
          itemBuilder: (context, index) {
            final asset = cameraRollImages[index];
            final isSelected = selectedCameraRollImages.contains(asset);

            return GestureDetector(
              onTap: () => _selectImageFromCameraRoll(asset),
              child: Stack(
                children: [
                  Image(
                    image: AssetEntityImageProvider(asset),
                    fit: BoxFit.cover,
                  ),
                  if (isSelected)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.blue,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

