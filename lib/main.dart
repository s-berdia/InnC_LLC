import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'package:flutter/gestures.dart';

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

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final GlobalKey _screenshotKey = GlobalKey();
  final List<File> _savedArtworks = [];
  int _currentBackgroundIndex = 0;
  int _selectedArtworkIndex = -1;
  int _selectedFrameIndex = -1;
  double _scale = 1.0;
  double _previousScale = 1.0;
  bool _isSelectingFrame = false;
  String _selectedTab = "artworks";  // Added for tab selection

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

  final List<String> frameImages = [
    'assets/frame1.jpg',
    'assets/frame2.png',
    'assets/frame3.png',
  ];

  final List<String> imageRatios = ["Portrait", "Landscape", "Square"];

  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  Future<void> _shareScreenshot() async {
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

      await Share.shareFiles([file.path], text: 'Check out my artwork!');
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
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                RepaintBoundary(
                  key: _screenshotKey,
                  child: SizedBox.expand(
                    child: Transform.scale(
                      scale: _scale,
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
                              left: 50, // Adjusted for display
                              top: 50,  // Adjusted for display
                              width: 200,
                              height: 200,
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Image.asset(artworkImages[_selectedArtworkIndex]),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                _buildMenu2(),
              ],
            ),
          ),
          _buildMenu1(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,  // Default to first tab (2D)
        onTap: (index) {
          if (index == 0) {
            // Stay on 2D page
          } else if (index == 1) {
            // AR page (currently blank)
          } else if (index == 2) {
            // Webpage (currently blank)
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Page1(images: _savedArtworks)),
            );
          } else if (index == 4) {
            // Settings page (currently blank)
          }
        },
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
            label: 'Webpage',
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

  Widget _buildMenu1() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        onTap: (index) {
          setState(() {
            if (index == 0) {
              _selectedTab = "artworks";
            } else if (index == 1) {
              _selectedTab = "frames";
            } else {
              _selectedTab = "ratios";
            }
          });
        },
        tabs: const [
          Tab(text: 'Artworks'),
          Tab(text: 'Frames'),
          Tab(text: 'Image Ratio'),
        ],
      ),
    );
  }

  Widget _buildMenu2() {
    if (_selectedTab == "artworks") {
      return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: SizedBox(
          height: 100,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                artworkImages.length,
                    (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedArtworkIndex = index;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(artworkImages[index], width: 80, height: 80),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
    } else if (_selectedTab == "frames") {
      return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: SizedBox(
          height: 100,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                frameImages.length,
                    (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedFrameIndex = index;
                        _selectedTab = "artworks";  // Return to Artworks tab after selecting frame
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(frameImages[index], width: 80, height: 80),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
    } else {
      return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: SizedBox(
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imageRatios.map((ratio) {
              return ElevatedButton(
                onPressed: () {
                  // Handle aspect ratio change here
                },
                child: Text(ratio),
              );
            }).toList(),
          ),
        ),
      );
    }
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
