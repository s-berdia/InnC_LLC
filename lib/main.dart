import 'package:flutter/material.dart';
import 'pages/homepage.dart';
import 'pages/ar_page.dart';
import 'pages/webview_page.dart';
import 'pages/gallery_page.dart';
import 'pages/settings_page.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  List<File> _savedArtworks = [];

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _initializePages();
  }

  void _initializePages() {
    _pages = [
      HomePage(setIndex: _setIndex),
      const ARPage(),
      const WebViewPage(),
      GalleryPage(savedArtworks: _savedArtworks),
      const SettingsPage(),
    ];
  }

  void _setIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.blue,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.photo),
            label: '2D',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'AR',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.web),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_album),
            label: 'Gallery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
