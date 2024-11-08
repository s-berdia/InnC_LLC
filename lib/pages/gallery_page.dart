import 'package:flutter/material.dart';
import 'dart:io';

class GalleryPage extends StatelessWidget {
  final List<File> savedArtworks;

  const GalleryPage({Key? key, required this.savedArtworks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery Page'),
      ),
      body: savedArtworks.isEmpty
          ? Center(child: Text('No images in the gallery'))
          : GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: savedArtworks.length,
        itemBuilder: (context, index) {
          return Image.file(savedArtworks[index]);
        },
      ),
    );
  }
}
