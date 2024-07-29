import 'package:flutter/material.dart';
import 'dart:io';

class Page2 extends StatelessWidget {
  final File image;

  const Page2({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
      ),
      body: Column(
        children: <Widget>[
          Image.file(image),
          ElevatedButton(
            onPressed: () {
              // Add framing and buying logic here
            },
            child: const Text('Frame and Buy'),
          ),
        ],
      ),
    );
  }
}
