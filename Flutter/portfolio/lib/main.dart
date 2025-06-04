import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // For email launching
import 'dart:async'; // For timers
import 'dart:math'; // For pi

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lily Vrionis Portfolio',
      home: const PortfolioHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PortfolioHome extends StatelessWidget {
  const PortfolioHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: const [
            FirstSection(),
          ],
        ),
      ),
    );
  }
}

class FirstSection extends StatefulWidget {
  const FirstSection({super.key});

  @override
  State<FirstSection> createState() => _FirstSectionState();
}

class _FirstSectionState extends State<FirstSection>
    with SingleTickerProviderStateMixin {
  bool isHovering = false;

  final List<String> words = [
    "portfolio.",
    "journey.",
    "vision.",
    "energy.",
    "future.",
  ];

  int currentIndex = 0;

  late AnimationController _controller;
  late Animation<double> _animation;

  Timer? _visibleTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 0, end: pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _startCycle();
  }

  void _startCycle() {
    // Start the first flip after 2 seconds
    _visibleTimer = Timer(const Duration(seconds: 2), _startFlip);
  }

  void _startFlip() {
    _controller.forward(from: 0).whenComplete(() {
      setState(() {
        currentIndex++;
      });
      _controller.reset();

      if (currentIndex < words.length - 1) {
      // Not yet at the end, continue cycle
      _visibleTimer = Timer(const Duration(seconds: 1), _startFlip);
    } else if (currentIndex == words.length - 1) {
      // Show last word, then flip back to "portfolio."
      _visibleTimer = Timer(const Duration(seconds: 1), () {
        _controller.forward(from: 0).whenComplete(() {
          setState(() {
            currentIndex = 0; // Back to "portfolio."
          });
          _controller.reset(); // Stop flipping
          // No more timers. We're done!
        });
      }
);
    }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _visibleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String displayedWord = words[currentIndex % words.length];
    String nextWord = (currentIndex + 1 < words.length)
        ? words[currentIndex + 1]
        : words[0]; // fallback

    return Container(
      height: MediaQuery.of(context).size.height,
      color: const Color(0xFFF6F2EF),
      child: Column(
        children: [
          // Top Row with name and Contact Me button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Lily Vrionis",
                  style: TextStyle(
                    fontFamily: 'Solway',
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5E7CFE),
                  ),
                ),
                MouseRegion(
                  onEnter: (_) => setState(() => isHovering = true),
                  onExit: (_) => setState(() => isHovering = false),
                  child: InkWell(
                    onTap: () async {
                      final Uri emailLaunchUri = Uri(
                        scheme: 'mailto',
                        path: 'lsvrionis@gmail.com',
                        query: Uri.encodeFull(
                            'subject=Hello Lily&body=I loved your portfolio!'),
                      );

                      if (await canLaunchUrl(emailLaunchUri)) {
                        await launchUrl(emailLaunchUri);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Could not open email app.')),
                        );
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: isHovering
                            ? const Color(0xFF4B65D4)
                            : const Color(0xFF5E7CFE),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Contact Me",
                        style: TextStyle(
                          fontFamily: 'Solway',
                          fontSize: 24,
                          color: Color(0xFFF6F2EF),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          Expanded(
            child: Center(
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  final isFirstHalf = _animation.value <= (pi / 2);
                  final displayText = isFirstHalf ? displayedWord : nextWord;
                  final rotationY =
                      isFirstHalf ? _animation.value : _animation.value - pi;

                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(rotationY),
                    child: Text(
                      displayText,
                      style: const TextStyle(
                        fontFamily: 'Solway',
                        fontSize: 72,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5E7CFE),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }
}
