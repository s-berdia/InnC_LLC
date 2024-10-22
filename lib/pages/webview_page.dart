import 'package:flutter/material.dart';

class WebViewPage extends StatelessWidget {
  const WebViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Webpage Content'),
      ),
      body: Center(
        child: Text('Welcome to the WebView Page!'),
      ),
    );
  }
}
