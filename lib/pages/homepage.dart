import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';


class HomePage extends StatefulWidget {
  final Function(int) setIndex;

  const HomePage({super.key, required this.setIndex});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final GlobalKey _screenshotKey = GlobalKey();
  final List<String> backgroundImages = [
    'assets/1.jpg',
    'assets/2.jpg',
    'assets/3.jpg',
    'assets/4.jpg',
    'assets/5.jpg',
    'assets/6.jpg',
    'assets/7.jpg',
    'assets/8.jpg',
    'assets/9.jpg',
    'assets/10.jpg',
    'assets/11.jpg',
    'assets/12.jpg',
    'assets/13.jpg',
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
  final List<Offset> defaultArtworkPositions = [
    Offset(0.12, 0.12), // For background 0
    Offset(0.12, 0.12), // For background 1
    Offset(0.12, 0.12), // For background 2
    Offset(0.12, 0.15), // For background 3
    Offset(0.12, 0.08), // For background 4
    Offset(0.12, 0.15), // For background 5
    Offset(0.12, 0.2), // For background 6
    Offset(0.12, 0.2), // For background 7
    Offset(0.12, 0.12), // For background 8
    Offset(0.12, 0.2), // For background 9
    Offset(0.12, 0.2), // For background 10
    Offset(0.12, 0.2), // For background 11
    Offset(0.12, 0.2), // For background 12
  ];

  static const double artworkSize = 300.0;
  int _currentBackgroundIndex = 0;
  int _selectedArtworkIndex = -1;
  int _selectedFrameIndex = -1;
  String _selectedTab = "artworks";
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    setState(() {
      if (_tabController.index == 0) {
        _selectedTab = "artworks";
      } else if (_tabController.index == 1) {
        _selectedTab = "frames";
      } else if (_tabController.index == 2) {
        _selectedTab = "ratios";
      }
    });
  }

  Widget _buildMenu1() {
    return Positioned(
      bottom: 100,
      left: 20,
      right: 20,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10.0,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: Colors.cyan.shade200,
            borderRadius: BorderRadius.circular(25.0),
          ),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black54,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: const [
            Tab(
              text: 'Artwork',
            ),
            Tab(
              text: 'Frame',
            ),
            Tab(
              text: 'Aspect Ratio',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenu2() {
    if (_selectedTab == "artworks") {
      return _buildArtworkMenu();
    } else if (_selectedTab == "frames") {
      return _buildFrameMenu();
    } else if (_selectedTab == "ratios") {
      return _buildRatioMenu();
    }
    return const SizedBox.shrink();
  }

  Widget _buildArtworkMenu() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SizedBox(
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    artworkImages.length,
                        (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_selectedArtworkIndex == index) {
                              _selectedArtworkIndex = -1;
                            } else {
                              _selectedArtworkIndex = index;
                            }
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5.0,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: Image.asset(artworkImages[index], fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5.0,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(Icons.add, size: 24, color: Colors.blue),
                  onPressed: () {
                    widget.setIndex(3); // Navigate to Gallery page using index 3
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFrameMenu() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SizedBox(
        height: 80,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              frameImages.length,
                  (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_selectedFrameIndex == index) {
                        _selectedFrameIndex = -1;
                      } else {
                        _selectedFrameIndex = index;
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5.0,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Image.asset(frameImages[index], fit: BoxFit.cover),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRatioMenu() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SizedBox(
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Handle aspect ratio change here
              },
              child: const Text("Portrait"),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                // Handle aspect ratio change here
              },
              child: const Text("Landscape"),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                // Handle aspect ratio change here
              },
              child: const Text("Square"),
            ),
          ],
        ),
      ),
    );
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
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }).toList(),
          ),
          if (_selectedArtworkIndex != -1)
            Positioned(
              top: MediaQuery.of(context).size.height * defaultArtworkPositions[_currentBackgroundIndex].dy,
              left: MediaQuery.of(context).size.width * defaultArtworkPositions[_currentBackgroundIndex].dx,
              child: SizedBox(
                width: artworkSize,
                height: artworkSize,
                  child: Image.asset(
                    artworkImages[_selectedArtworkIndex],
                    fit: BoxFit.contain,
                  ),
              ),
            ),
          if (_selectedFrameIndex != -1)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.25,
              left: MediaQuery.of(context).size.width * 0.25,
              child: SizedBox(
                width: 210,
                height: 210,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Image.asset(frameImages[_selectedFrameIndex]),
                ),
              ),
            ),
          _buildMenu1(),
          _buildMenu2(),
        ],
      ),
    );
  }
}
