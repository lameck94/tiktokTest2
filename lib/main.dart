import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

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

  // Toggle auto-scroll
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
      // Optional: show snackbar when user scrolls manually
    }
  }

  Widget _buildVideoCard(int index) {
    final randomColor =
        Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(0.8);

    final title = _simulatedVideos[index % _simulatedVideos.length];

    return Container(
      color: Colors.black,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          /// Fake Video Container
          Center(
            child: Container(
              height: 200,
              width: 300,
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
              child: const Center(
                child: Text(
                  'Video',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          /// Caption + Username
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '@user_funky_${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              // User touched screen → stop auto scroll
              if (_isAutoScrolling &&
                  notification is ScrollStartNotification &&
                  notification.dragDetails != null) {
                _stopAutoScroll(userInitiated: true);
                setState(() {});
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

          /// Floating Auto Scroll Button
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

          /// Transparent AppBar
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: const Text(
                'Simulated Video Feed',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.white70,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.white70),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
