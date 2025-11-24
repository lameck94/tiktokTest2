import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hands-Free Scroll Demo',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      debugShowCheckedModeBanner: false,
      home: const AutoScrollFeed(),
    );
  }
}

class AutoScrollFeed extends StatefulWidget {
  const AutoScrollFeed({super.key});

  @override
  State<AutoScrollFeed> createState() => _AutoScrollFeedState();
}

class _AutoScrollFeedState extends State<AutoScrollFeed> {
  final PageController _pageController = PageController();

  Timer? _timer;
  bool _isAutoScrolling = false;

  final Duration _scrollInterval = const Duration(seconds: 4);

  final List<String> _simulatedVideos = [
    "Exploring the Dolomites 🏔️",
    "Cooking: The Ultimate Pasta Dish 🍝",
    "Daily Coding Tips 💻",
    "Cute Cat Compilation 😻",
    "Historical Facts You Didn't Know 📜",
    "Sunset Over the Ocean 🌅",
    "DIY Home Renovation Hacks 🛠️",
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  // Start/stop auto scroll toggle
  void _toggleAutoScroll() {
    if (_isAutoScrolling) {
      _stopAutoScroll();
    } else {
      _startAutoScroll();
    }
    setState(() {});
  }

  void _startAutoScroll() {
    _isAutoScrolling = true;
    _timer = Timer.periodic(_scrollInterval, (timer) {
      if (_pageController.hasClients) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _stopAutoScroll({bool userInitiated = false}) {
    _timer?.cancel();
    _isAutoScrolling = false;

    if (userInitiated) {
      // Optional snackbar
    }
  }

  // FULL video card + swipe + touch
  Widget _buildVideoCard(int index) {
    final randomColor =
        Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(0.8);

    final title = _simulatedVideos[index % _simulatedVideos.length];

    return GestureDetector(
      // User touches screen → pause auto scroll
      onTapDown: (_) {
        if (_isAutoScrolling) {
          _stopAutoScroll(userInitiated: true);
          setState(() {});
        }
      },

      // Swipe left/right actions
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity == null) return;

        if (details.primaryVelocity! < 0) {
          // Swipe Left → Like
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("❤️ You liked this video")),
          );
        } else if (details.primaryVelocity! > 0) {
          // Swipe Right → Comment
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("💬 Comment Action")),
          );
        }
      },

      child: Container(
        color: Colors.black,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            // Fake video container
            Center(
              child: Container(
                height: 220,
                width: 330,
                decoration: BoxDecoration(
                  color: randomColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    "Video ${index + 1}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            // Username + caption
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '@user_funky_${index + 1}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 16),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Detect manual scroll → stop auto scroll
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (_isAutoScrolling) {
                if (notification is ScrollStartNotification &&
                    notification.dragDetails != null) {
                  _stopAutoScroll(userInitiated: true);
                  setState(() {});
                }
              }
              return false;
            },
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: 100,
              itemBuilder: (_, index) => _buildVideoCard(index),
            ),
          ),

          // Floating toggle button
          Positioned(
            bottom: 40,
            right: 20,
            child: FloatingActionButton.extended(
              onPressed: _toggleAutoScroll,
              icon: Icon(
                _isAutoScrolling
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_fill,
                size: 28,
              ),
              label: Text(
                _isAutoScrolling ? 'Auto-Scrolling ON' : 'Start Auto-Scroll',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor:
                  _isAutoScrolling ? Colors.redAccent : Colors.teal,
              foregroundColor: Colors.white,
            ),
          ),

          // Top bar
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: AppBar(
              title: const Text(
                'Simulated Video Feed',
                style: TextStyle(color: Colors.white70),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search, color: Colors.white70))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
