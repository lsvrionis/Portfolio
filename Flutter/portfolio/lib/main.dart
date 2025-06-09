import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // For email launching
import 'dart:async'; // For timers
import 'dart:math'; // For pi
import 'sections/experience_section.dart';
import 'sections/skills_section.dart';
import 'sections/project_section.dart';
import 'sections/intro_section.dart';


final GlobalKey introKey = GlobalKey();
final GlobalKey experienceKey = GlobalKey();
final GlobalKey skillsKey = GlobalKey();
final GlobalKey projectsKey = GlobalKey();

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

class PortfolioHome extends StatefulWidget {
  const PortfolioHome({super.key});

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome> {
  final scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      final isScrolledNow = scrollController.offset > 0;
      if (isScrolledNow != _isScrolled) {
        setState(() => _isScrolled = isScrolledNow);
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void scrollTo(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F2EF),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                const SizedBox(height: 80),
                const FirstSection(),
                IntroSection(key: introKey),
                ExperienceSection(key: experienceKey),
                const BouncingArrows(),
                SkillsSection(key: skillsKey),
                ProjectSection(key: projectsKey),
                const FooterSection(),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: NavBar(hasShadow: _isScrolled, scrollToSection: scrollTo),
          ),
        ],
      ),
    );
  }
}

class NavBar extends StatefulWidget {
  final bool hasShadow;
  final Function(GlobalKey) scrollToSection;

  const NavBar({super.key, required this.hasShadow, required this.scrollToSection});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  bool isContactHover = false;
  bool isMenuOpen = false;

  // For closing dropdown when clicking outside
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  void _toggleMenu() {
    if (isMenuOpen) {
      _closeMenu();
    } else {
      _openMenu();
    }
  }

void _openMenu() {
  final overlay = Overlay.of(context);
  final renderBox = context.findRenderObject() as RenderBox;
  final size = renderBox.size;
  final offset = renderBox.localToGlobal(Offset.zero);
  final screenWidth = MediaQuery.of(context).size.width;

  const menuWidth = 180.0;
  const sidePadding = 16.0;
  const extraDownOffset = 12.0;

  double left = offset.dx + size.width - menuWidth;
if (left + menuWidth > screenWidth - sidePadding) {
  left = screenWidth - menuWidth - sidePadding;
}
if (left < sidePadding) {
  left = sidePadding;
}


  final top = offset.dy + size.height + 8 + extraDownOffset;

  _overlayEntry = OverlayEntry(
    builder: (context) => Stack(
      children: [
        // Tap anywhere outside to close
        Positioned.fill(
          child: GestureDetector(
            onTap: _closeMenu,
            behavior: HitTestBehavior.translucent,
          ),
        ),
        Positioned(
          top: top,
          left: left,
          width: menuWidth,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: const Offset(-127.0, 5.0), // negative X moves it left, positive Y moves it down
            child: Material(
              color: const Color(0xFFF6F2EF),
              elevation: 8,
              borderRadius: BorderRadius.circular(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Close "X" button
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: _closeMenu,
                      tooltip: 'Close menu',
                    ),
                  ),
                  _DropDownItem(
                    label: 'Experience',
                    onTap: () {
                      widget.scrollToSection(experienceKey);
                      _closeMenu();
                    },
                  ),
                  _DropDownItem(
                    label: 'Skills',
                    onTap: () {
                      widget.scrollToSection(skillsKey);
                      _closeMenu();
                    },
                  ),
                  _DropDownItem(
                    label: 'Projects',
                    onTap: () {
                      widget.scrollToSection(projectsKey);
                      _closeMenu();
                    },
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: GestureDetector(
                      onTap: () {
                        launchUrl(Uri.parse('mailto:lsvrionis@gmail.com'));
                        _closeMenu();
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0022B7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(
                          child: Text(
                            'Contact Me',
                            style: TextStyle(
                              fontFamily: 'Solway',
                              fontSize: 20,
                              color: Color(0xFFF6F2EF),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );

  overlay.insert(_overlayEntry!);
  setState(() => isMenuOpen = true);
}

void _closeMenu() {
  _overlayEntry?.remove();
  _overlayEntry = null;
  setState(() => isMenuOpen = false);
}

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F2EF),
        boxShadow: widget.hasShadow
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ]
            : [],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Lily Vrionis as text link
          _NavLink(
            label: 'Lily Vrionis',
            color: const Color(0xFF0022B7),
            hoverColor: const Color(0xFF006D5B),
            onTap: () => widget.scrollToSection(introKey),
          ),

          // Right: navigation or hamburger
          if (!isMobile)
            Row(
              children: [
                _NavLink(
                  label: 'Experience',
                  color: const Color(0xFF0022B7),
                  hoverColor: const Color(0xFF006D5B),
                  onTap: () => widget.scrollToSection(experienceKey),
                ),
                const SizedBox(width: 24),
                _NavLink(
                  label: 'Skills',
                  color: const Color(0xFF0022B7),
                  hoverColor: const Color(0xFF006D5B),
                  onTap: () => widget.scrollToSection(skillsKey),
                ),
                const SizedBox(width: 24),
                _NavLink(
                  label: 'Projects',
                  color: const Color(0xFF0022B7),
                  hoverColor: const Color(0xFF006D5B),
                  onTap: () => widget.scrollToSection(projectsKey),
                ),
                const SizedBox(width: 24),

                // Contact Me pill-shaped button
                MouseRegion(
                  onEnter: (_) => setState(() => isContactHover = true),
                  onExit: (_) => setState(() => isContactHover = false),
                  child: GestureDetector(
                    onTap: () => launchUrl(Uri.parse('mailto:lsvrionis@gmail.com')),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      transform: isContactHover
                          ? Matrix4.translationValues(0, -3, 0)
                          : Matrix4.identity(),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: isContactHover
                            ? const Color(0xFF006D5B)
                            : const Color(0xFF0022B7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Contact Me',
                        style: TextStyle(
                          fontFamily: 'Solway',
                          fontSize: 22,
                          color: Color(0xFFF6F2EF),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          else
            CompositedTransformTarget(
              link: _layerLink,
              child: GestureDetector(
                onTap: _toggleMenu,
                child: Icon(
                  isMenuOpen ? Icons.close : Icons.menu,
                  size: 32,
                  color: const Color(0xFF0022B7),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Dropdown menu item widget used in the hamburger menu dropdown
class _DropDownItem extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _DropDownItem({required this.label, required this.onTap, Key? key}) : super(key: key);

  @override
  State<_DropDownItem> createState() => _DropDownItemState();
}

class _DropDownItemState extends State<_DropDownItem> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: ListTile(
        title: Text(
          widget.label,
          style: TextStyle(
            fontFamily: 'Solway',
            fontSize: 20,
            color: _hover ? const Color(0xFF006D5B) : const Color(0xFF0022B7),
          ),
        ),
        onTap: widget.onTap,
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  final String label;
  final Color color;
  final Color hoverColor;
  final VoidCallback onTap;

  const _NavLink({required this.label, required this.color, required this.hoverColor, required this.onTap});

  @override
  State<_NavLink> createState() => _NavLinkState();
}
class _NavLinkState extends State<_NavLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text(
          widget.label,
          style: TextStyle(
            fontFamily: 'Solway',
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: _isHovered ? widget.hoverColor : widget.color,
          ),
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
  final double fontSize = 72;  // Always 72, no mobile scaling down

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
    _visibleTimer = Timer(const Duration(seconds: 2), _startFlip);
  }

  void _startFlip() {
    _controller.forward(from: 0).whenComplete(() {
      setState(() {
        currentIndex++;
      });
      _controller.reset();

      if (currentIndex < words.length - 1) {
        _visibleTimer = Timer(const Duration(seconds: 1), _startFlip);
      } else if (currentIndex == words.length - 1) {
        _visibleTimer = Timer(const Duration(seconds: 1), () {
          _controller.forward(from: 0).whenComplete(() {
            setState(() {
              currentIndex = 0;
            });
            _controller.reset();
          });
        });
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
        : words[0];

    final double fontSize = 72;


    return Container(
      height: MediaQuery.of(context).size.height,
      color: const Color(0xFFF6F2EF),
      child: Column(
        children: [
          const SizedBox(height: 0),
          const Spacer(),
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -25),
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
                        style: TextStyle(
    fontFamily: 'Solway',
    fontWeight: FontWeight.w800,
    fontSize: fontSize,
    height: 1,
    color: const Color(0xFF0022B7),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const Spacer(),
          Transform.translate(
            offset: const Offset(0, -55),
            child: const BouncingArrows(),
          ),
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
    with TickerProviderStateMixin {
  late final AnimationController _controller1;
  late final AnimationController _controller2;
  late final AnimationController _controller3;

  late final Animation<double> _animation1;
  late final Animation<double> _animation2;
  late final Animation<double> _animation3;

  @override
  void initState() {
    super.initState();

    _controller1 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _controller2 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _controller3 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation1 = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _controller1, curve: Curves.easeInOut),
    );

    _animation2 = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _controller2, curve: Curves.easeInOut),
    );

    _animation3 = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _controller3, curve: Curves.easeInOut),
    );

    // Start staggered animations with delays
    Future.delayed(const Duration(milliseconds: 200), () {
      _controller2.repeat(reverse: true);
    });

    Future.delayed(const Duration(milliseconds: 400), () {
      _controller3.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF6F2EF),
      padding: const EdgeInsets.only(bottom: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _animation1,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _animation1.value),
                child: child,
              );
            },
            child: const Icon(Icons.keyboard_arrow_down,
                color: Color(0xFF006D5B), size: 45),
          ),
          const SizedBox(width: 50),
          AnimatedBuilder(
            animation: _animation2,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _animation2.value),
                child: child,
              );
            },
            child: const Icon(Icons.keyboard_arrow_down,
                color: Color(0xFF006D5B), size: 45),
          ),
          const SizedBox(width: 50),
          AnimatedBuilder(
            animation: _animation3,
            builder: (context, child) {
              return Transform.translate(                
                offset: Offset(0, _animation3.value),
                child: child,
              );
            },
            child: const Icon(Icons.keyboard_arrow_down,
                color: Color(0xFF006D5B), size: 45),
          ),
        ],
      ),
    );
  }
}

// --- FooterSection --- 

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final links = [
      _FooterLink(label: 'resume', url: 'https://drive.google.com/file/d/152A3JnKG62VKzUUMxlQEdcaNZ_5erlrC/view?usp=sharing'),
      _FooterLink(label: 'github', url: 'https://github.com/lsvrionis'),
      _FooterLink(label: 'email', url: 'mailto:lsvrionis@gmail.com'),
      _FooterLink(label: 'linkedin', url: 'https://linkedin.com/in/lily-vrionis'),
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 700;

    // Responsive font size
    double fontSize;
    if (screenWidth < 400) {
      fontSize = 12;
    } else if (screenWidth < 600) {
      fontSize = 16;
    } else {
      fontSize = 20;
    }

    List<Widget> linkWidgets = [];
    for (int i = 0; i < links.length; i++) {
      linkWidgets.add(_FooterLinkWidget(link: links[i], fontSize: fontSize));
      if (i < links.length - 1) {
        linkWidgets.add(Padding(
          padding: EdgeInsets.symmetric(horizontal: fontSize * 0.6),
          child: Text(
            '•',
            style: TextStyle(
              fontSize: fontSize,
              color: const Color(0xFFF6F2EF),
              fontWeight: FontWeight.bold,
            ),
          ),
        ));
      }
    }

    return Container(
      width: double.infinity,
      color: const Color(0xFF0022B7),
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: fontSize * 1.2),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              // For desktop, expand container width to full width for right align
              // For mobile, width is min needed (shrink wrap)
              width: isMobile ? null : constraints.maxWidth,
              alignment: isMobile ? Alignment.center : Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: linkWidgets,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FooterLink {
  final String label;
  final String url;
  const _FooterLink({required this.label, required this.url});
}

class _FooterLinkWidget extends StatefulWidget {
  final _FooterLink link;
  final double fontSize;

  const _FooterLinkWidget({required this.link, required this.fontSize, super.key});

  @override
  State<_FooterLinkWidget> createState() => _FooterLinkWidgetState();
}

class _FooterLinkWidgetState extends State<_FooterLinkWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.parse(widget.link.url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.link.label,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'Solway',
                fontSize: widget.fontSize,
                color: const Color(0xFFF6F2EF),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.only(top: 4),
              height: 2,
              width: _isHovered ? 2 * widget.fontSize : 0,
              decoration: const BoxDecoration(
                color: Color(0xFFF6F2EF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}