import 'package:flutter/material.dart';
import 'dart:io';
import 'main.dart';

class Page1 extends StatelessWidget {
  final List<File> images;

  const Page1({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Page2(image: images[index]),
                ),
              );
            },
            child: Image.file(images[index]),
          );
        },
      ),
    );
  }
}
