import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;
import 'package:carousel_slider/carousel_slider.dart';

List<CameraDescription>? cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
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
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  final List<File> _recentPictures = [];
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

  @override
  void initState() {
    super.initState();
    if (cameras != null) {
      _controller = CameraController(cameras![0], ResolutionPreset.medium);
      _initializeControllerFuture = _controller!.initialize();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;

      final XFile image = await _controller!.takePicture();

      final path = join(
        (await getTemporaryDirectory()).path,
        '${DateTime.now()}.png',
      );

      await image.saveTo(path);

      setState(() {
        _recentPictures.add(File(path));
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
            Center(
              child: Image.asset(
                artworkImages[_selectedArtworkIndex],
                fit: BoxFit.contain,
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
        onPressed: _takePicture,
        child: const Icon(Icons.camera_alt),
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
                    builder: (context) => Page1(images: _recentPictures),
                  ),
                );
              },
            ),
            const SizedBox(width: 50),  // Placeholder for alignment
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