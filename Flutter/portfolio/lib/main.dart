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
      title: 'Lily Vrionis',
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
            IntroSection(),
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
                    child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        transform: isHovering
                            ? Matrix4.translationValues(0, -5, 0)
                            : Matrix4.translationValues(0, 0, 0),
                        curve: Curves.easeOut,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
          const BouncingArrows(),
        ],
      ),
    );
  }
}

class BouncingArrows extends StatefulWidget {
  const BouncingArrows({super.key});

  @override
  State<BouncingArrows> createState() => _BouncingArrowsState();
}

class _BouncingArrowsState extends State<BouncingArrows>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounce;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _bounce = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: AnimatedBuilder(
        animation: _bounce,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _bounce.value),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.keyboard_arrow_down,
                    color: Color(0xFF5E7CFE), size: 45),
                SizedBox(width: 50),
                Icon(Icons.keyboard_arrow_down,
                    color: Color(0xFF5E7CFE), size: 45),
                SizedBox(width: 50),
                Icon(Icons.keyboard_arrow_down,
                    color: Color(0xFF5E7CFE), size: 45),
              ],
            ),
          );
        },
      ),
    );
  }
}

class IntroSection extends StatelessWidget {
  const IntroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF6F2EF),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Replaced typewriter with static text and longer underline
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "hello!",
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Solway',
                        color: Color(0xFF5E7CFE),
                      ),
                    ),
                    SizedBox(height: 6),
                    // Longer underline
                    SizedBox(
                      width: 250,
                      height: 4,
                      child: ColoredBox(color: Color(0xFF5E7CFE)),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                        fontFamily: 'Solway',
                        fontSize: 25,
                        color: Colors.black),
                    children: [
                      const TextSpan(text: "I’m "),
                      TextSpan(
                          text: "Lily",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF5E7CFE))),
                      const TextSpan(text: ", an Orlando-based "),
                      TextSpan(
                          text: "front-end developer",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const TextSpan(text: " and "),
                      TextSpan(
                          text: "UI/UX designer",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const TextSpan(
                          text:
                              ". I’m all about creating designs that are visually appealing, but also impactful and accessible."),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Currently, I’m in my undergrad at the University of Central Florida studying information technology and cognitive sciences.",
                  style: TextStyle(fontFamily: 'Solway', fontSize: 25),
                ),
                const SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    LinkIconRow(
                      icon: Icons.email,
                      label: "lsvrionis@gmail.com",
                      url: "mailto:lsvrionis@gmail.com",
                    ),
                    LinkIconRow(
                      icon: Icons.person,
                      label: "linkedin.com/in/lily-vrionis",
                      url: "https://linkedin.com/in/lily-vrionis",
                    ),
                    LinkIconRow(
                      icon: Icons.code,
                      label: "github.com/lsvrionis",
                      url: "https://github.com/lsvrionis",
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(width: 40),
          // Right side image
          Expanded(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      const SizedBox(height: 48), // pushes image down
      HoverScaleImage(),
    ],
  ),
)


        ],
      ),
    );
  }
}

class TypewriterText extends StatefulWidget {
  final String text;

  const TypewriterText({super.key, required this.text});

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  String _textToShow = '';
  int _charIndex = 0;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(milliseconds: 150), (timer) {
      if (_charIndex < widget.text.length) {
        setState(() {
          _textToShow += widget.text[_charIndex];
          _charIndex++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _textToShow,
          style: const TextStyle(
            fontSize: 60,
            fontWeight: FontWeight.bold,
            fontFamily: 'Solway',
            color: Color(0xFF5E7CFE),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 180, 
          height: 4,
          color: Color(0xFF5E7CFE),
        ),
      ],
    );
  }
}


class LinkIconRow extends StatefulWidget {
  final IconData icon;
  final String label;
  final String url;
  
  const LinkIconRow(
      {super.key,
      required this.icon,
      required this.label,
      required this.url});

  @override
  State<LinkIconRow> createState() => _LinkIconRowState();
}

class _LinkIconRowState extends State<LinkIconRow> {
  bool isHovered = false;
  
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(widget.url)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Container(
  width: 48, // Increased from just padding
  height: 48,
  decoration: const BoxDecoration(
    shape: BoxShape.circle,
    color: Color(0xFF5E7CFE),
  ),
  child: Icon(widget.icon, color: Color(0xFFF6F2EF), size: 24),
),

              const SizedBox(width: 20),
              LayoutBuilder(
                builder: (context, constraints) {
                  final text = TextPainter(
                    text: TextSpan(
                      text: widget.label,
                      style: const TextStyle(fontSize: 25, fontFamily: 'Solway'),
                    ),
                    textDirection: TextDirection.ltr,
                  )..layout();

                  return Stack(
                    children: [
                      AnimatedScale(
                        scale: isHovered ? 1.1 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        child: Stack(
                          children: [
                            Text(
                              widget.label,
                              style: const TextStyle(
                                fontSize: 25,
                                fontFamily: 'Solway',
                                color: Colors.black,
                              ),
                            ),
                            if (isHovered)
                              Positioned(
                                top: 32,
                                bottom: 0,
                                child: CustomPaint(
                                  painter: ZigzagPainter(text.width),
                                  size: Size(text.width, 5),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ZigzagPainter extends CustomPainter {
  final double width;

  ZigzagPainter(this.width);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    final double zigzagHeight = size.height;
    for (double x = 0; x <= width; x += 6) {
      final isEven = (x ~/ 6) % 2 == 0;
      path.lineTo(x, isEven ? 0 : zigzagHeight);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(ZigzagPainter oldDelegate) => oldDelegate.width != width;
}

class HoverScaleImage extends StatefulWidget {
  @override
  _HoverScaleImageState createState() => _HoverScaleImageState();
}

class _HoverScaleImageState extends State<HoverScaleImage> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        const url = 'https://instagram.com/lsvrionis';
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url));
        }
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Container(
          height: 500,
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFF5E7CFE), width: 5),
          ),
          padding: const EdgeInsets.all(4),
          child: AnimatedScale(
            scale: _isHovered ? 1.05 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Image.asset(
              'images/Lily.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  alignment: Alignment.center,
                  child: const Text(
                    'Image not found',
                    style: TextStyle(fontFamily: 'Solway'),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
