import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey _screenshotKey = GlobalKey();
  final List<File> _savedArtworks = [];
  int _currentBackgroundIndex = 0;
  int _selectedArtworkIndex = -1;

  final List<String> backgroundImages = [
    'assets/background1.jpg',
    'assets/background2.jpg',
    'assets/background3.jpg',
  ];

  final List<String> artworkImages = [
    'assets/artwork1.png',
    'assets/artwork2.png',
    'assets/artwork3.png',
  ];

  // Define the areas for artwork placement for each background image
  final List<Rect> artworkAreas = [
    Rect.fromLTWH(5, 10, 400, 400), // Area for background1
    Rect.fromLTWH(130, 70, 300, 400), // Area for background2
    Rect.fromLTWH(5, 10, 400, 700), // Area for background3
  ];

  Future<void> _takeScreenshot() async {
    try {
      RenderRepaintBoundary boundary = _screenshotKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage();
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final directory = await getApplicationDocumentsDirectory();
      final path = join(
        directory.path,
        '${DateTime.now()}.png',
      );

      final file = File(path);
      await file.writeAsBytes(pngBytes);

      setState(() {
        _savedArtworks.add(file);
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Stack(
        children: [
          RepaintBoundary(
            key: _screenshotKey,
            child: Stack(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height,
                    viewportFraction: 1.0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentBackgroundIndex = index;
                      });
                    },
                  ),
                  items: backgroundImages.map((imagePath) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(imagePath),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                if (_selectedArtworkIndex != -1)
                  Positioned(
                    left: artworkAreas[_currentBackgroundIndex].left,
                    top: artworkAreas[_currentBackgroundIndex].top,
                    width: artworkAreas[_currentBackgroundIndex].width,
                    height: artworkAreas[_currentBackgroundIndex].height,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Image.asset(
                        artworkImages[_selectedArtworkIndex],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            bottom: 20.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: artworkImages.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedArtworkIndex = index;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        artworkImages[index],
                        width: 80,
                        height: 80,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takeScreenshot,
        child: const Icon(Icons.save),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Page1(images: _savedArtworks),
                  ),
                );
              },
            ),
            const SizedBox(width: 50), // Placeholder for alignment
          ],
        ),
      ),
    );
  }
}

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
