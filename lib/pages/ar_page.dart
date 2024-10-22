import 'package:flutter/material.dart';

class ARPage extends StatelessWidget {
  const ARPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AR Content'),
      ),
      body: Center(
        child: Text('Welcome to the AR Page!'),
      ),
    );
  }
}
