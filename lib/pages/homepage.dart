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
        //padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
    return SizedBox.shrink();
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
                            _selectedArtworkIndex = index;
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
                  icon: const Icon(Icons.add, size: 24, color: Colors.blue),
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
                      _selectedFrameIndex = index;
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
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                // Handle aspect ratio change here
              },
              child: const Text("Landscape"),
            ),
            SizedBox(width: 10),
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
              left: 50,
              top: 50,
              width: 200,
              height: 200,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Image.asset(artworkImages[_selectedArtworkIndex]),
              ),
            ),
          if (_selectedFrameIndex != -1)
            Positioned(
              left: 45,
              top: 45,
              width: 210,
              height: 210,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Image.asset(frameImages[_selectedFrameIndex]),
              ),
            ),
          _buildMenu1(),
          _buildMenu2(),
        ],
      ),
    );
  }
}
