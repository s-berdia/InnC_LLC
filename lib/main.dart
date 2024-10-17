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
  final List<File> _savedArtworks = [
    // Add some dummy file paths or real ones if you're testing with real files
    // File('path/to/image1.jpg'),
    // File('path/to/image2.jpg'),
  ];
  int _currentBackgroundIndex = 0;
  int _selectedArtworkIndex = -1;
  int _selectedFrameIndex = -1;
  int _currentIndex = 0; // Controls the current tab index
  int? _selectedGalleryImageIndex; // Index to track the selected image for detail view
  double _scale = 1.0;
  double _previousScale = 1.0;
  bool _isSelectingFrame = false;
  String _selectedTab = "artworks"; // Added for tab selection

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

  // To handle the bottom navigation bar taps
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _selectedGalleryImageIndex = null; // Reset when switching tabs
    });
  }

  // Build the initial home page content with the carousel and artworks
  Widget _buildHomePage() {
    return Column(
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
                            left: 50,
                            top: 50,
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

  // Build the gallery content
  Widget _buildGallery() {
    if (_savedArtworks.isEmpty) {
      return Center(child: Text('No images in the gallery'));
    }

    if (_selectedGalleryImageIndex != null) {
      // If an image is selected, show the image detail view
      return _buildImageDetailView();
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: _savedArtworks.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedGalleryImageIndex = index; // Show image detail view
            });
          },
          child: Image.file(_savedArtworks[index]),
        );
      },
    );
  }

  // Build the image detail view for the selected gallery image
  Widget _buildImageDetailView() {
    final selectedImage = _savedArtworks[_selectedGalleryImageIndex!];
    return Column(
      children: [
        Expanded(
          child: Image.file(selectedImage), // Display the full image
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _selectedGalleryImageIndex = null; // Go back to gallery
            });
          },
          child: const Text('Back to Gallery'),
        ),
      ],
    );
  }

  // Controls what content is displayed based on the selected tab
  Widget _buildContent() {
    switch (_currentIndex) {
      case 0:
        return _buildHomePage();
      case 1:
        return Center(child: Text('AR Content'));
      case 2:
        return Center(child: Text('Webpage Content'));
      case 3:
        return _buildGallery();
      default:
        return _buildHomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: _buildContent(), // Shows content based on _currentIndex
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.photo, color: Colors.blue, size: 30.0),
            label: '2D',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera, color: Colors.blue, size: 30.0),
            label: 'AR',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.web, color: Colors.blue, size: 30.0),
            label: 'Webpage',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_album, color: Colors.blue, size: 30.0),
            label: 'Gallery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: Colors.blue, size: 30.0),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
