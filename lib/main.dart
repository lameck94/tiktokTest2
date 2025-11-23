import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

// Main application component
class AutoScrollFeed extends StatefulWidget {
  const AutoScrollFeed({super.key});

  @override
  State<AutoScrollFeed> createState() => _AutoScrollFeedState();
}

class _AutoScrollFeedState extends State<AutoScrollFeed> {
  // Controller to manage the vertical scrolling of the PageView
  final PageController _pageController = PageController();
  
  // State variables for the auto-scroll functionality
  Timer? _timer;
  bool _isAutoScrolling = false;
  final Duration _scrollInterval = const Duration(seconds: 4); // Scroll every 4 seconds

  // Simulated content data
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
  void initState() {
    super.initState();
    // Add a listener to stop the timer if the user manually scrolls, 
    // but only if the user hasn't toggled the auto-scroll off.
    _pageController.addListener(_handleUserScroll);
  }

  // Handle manual user scrolling to potentially reset or stop the timer
  void _handleUserScroll() {
    if (_isAutoScrolling && _pageController.page != null && !_pageController.page!.isFinite) {
      // User is dragging or initiating scroll manually. Stop the timer temporarily.
      _stopAutoScroll(userInitiated: true);
    }
  }

  // Toggles the auto-scroll timer on and off
  void _toggleAutoScroll() {
    setState(() {
      if (_isAutoScrolling) {
        _stopAutoScroll();
      } else {
        _startAutoScroll();
      }
    });
  }

  // Starts the timer for automatic scrolling
  void _startAutoScroll() {
    _isAutoScrolling = true;
    _timer = Timer.periodic(_scrollInterval, (timer) {
      if (_pageController.hasClients) {
        // Scroll to the next page smoothly
        _pageController.nextPage(
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  // Stops the timer
  void _stopAutoScroll({bool userInitiated = false}) {
    _timer?.cancel();
    _isAutoScrolling = false;
    
    // If the user manually scrolled, they might want to re-enable it easily.
    if (userInitiated) {
        // Optional: Show a message that auto-scroll stopped after manual interaction
    }
  }

  @override
  void dispose() {
    _pageController.removeListener(_handleUserScroll);
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  // --- UI Components ---

  // Build the individual video card widget
  Widget _buildVideoCard(int index) {
    // Generate a random color for the background to simulate different video content
    final randomColor = Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(0.8);
    final title = _simulatedVideos[index % _simulatedVideos.length];

    return Container(
      color: Colors.black, // Dark background for the 'feed' look
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          // Simulated Video Content Area
          Center(
            child: Container(
              height: 200,
              width: 300,
              decoration: BoxDecoration(
                color: randomColor,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'Video ${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          
          // Simulated User Info/Caption Overlay
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '@user_funky_${index + 1}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
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

  // Build the main UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // The main simulated feed using PageView
          PageView.builder(
            scrollDirection: Axis.vertical,
            controller: _pageController,
            itemCount: 100, // Large number for infinite-like scrolling
            itemBuilder: (context, index) {
              return _buildVideoCard(index);
            },
          ),
          
          // Floating Action Button to toggle auto-scroll
          Positioned(
            bottom: 40,
            right: 20,
            child: FloatingActionButton.extended(
              onPressed: _toggleAutoScroll,
              icon: Icon(
                _isAutoScrolling ? Icons.pause_circle_filled : Icons.play_circle_filled,
                size: 28,
              ),
              label: Text(
                _isAutoScrolling ? 'Auto-Scrolling ON' : 'Start Auto-Scroll',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: _isAutoScrolling ? Colors.redAccent : Colors.teal,
              foregroundColor: Colors.white,
              elevation: 8,
            ),
          ),

          // Top Info Bar (Simulated)
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: const Text(
                'Simulated Video Feed',
                style: TextStyle(fontWeight: FontWeight.w300, color: Colors.white70),
              ),
              centerTitle: true,
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

// Entry point of the Flutter application
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hands-Free Scroll Demo',
      // Set the overall theme to dark mode
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.pink,
          brightness: Brightness.dark,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const AutoScrollFeed(),
    );
  }
}