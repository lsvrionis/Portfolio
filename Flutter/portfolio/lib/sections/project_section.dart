import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectSection extends StatelessWidget {
  static final GlobalKey globalKey = GlobalKey();

  const ProjectSection({Key? key}) : super(key: key);

  static const Color backgroundColor = Color(0xFFF6F2EF);
  static const Color headingColor = Color(0xFF0022B7);
  static const Color boxColor = Color(0xFF006D5B);
  static const Color borderColor = Color(0xFF0022B7);
  static const Color headerRectColor = Color(0xFFF6F2EF);
  static const Color titleColor = Color(0xFFF6F2EF);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 700;

    return Container(
      key: globalKey,
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(
              'projects',
              style: TextStyle(
                fontFamily: 'Solway',
                fontSize: isMobile ? 40 : 60,
                fontWeight: FontWeight.bold,
                color: headingColor,
              ),
            ),
          ),
          const SizedBox(height: 40),
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 600;
              return SizedBox(
                width: double.infinity,
                child: Wrap(
                  spacing: 20,
                  runSpacing: isMobile ? 40 : 20,
                  alignment: WrapAlignment.center,
                  children: [
                    HoverCard(
                      semanticLabel: 'Project card for Mend journaling app',
                      child: MendProjectCard(height: isMobile ? 730 : null),
                    ),
                    HoverCard(
                      semanticLabel: 'Project card for Capistrano Distillery website',
                      child: CapistranoProjectCard(height: isMobile ? 730 : null),
                    ),
                    HoverCard(
                      semanticLabel: 'Project card for BLOT web application',
                      child: BlotProjectCard(height: isMobile ? 800 : null),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class HoverCard extends StatefulWidget {
  final Widget child;
  final String? semanticLabel;

  const HoverCard({super.key, required this.child, this.semanticLabel});

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool _hovering = false;
  bool _focused = false;

  void _onFocusChange(bool focused) {
    setState(() {
      _focused = focused;
    });
  }

  @override
  Widget build(BuildContext context) {
    final scale = (_hovering || _focused) ? 1.03 : 1.0;

    return Focus(
      onFocusChange: _onFocusChange,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovering = true),
        onExit: (_) => setState(() => _hovering = false),
        child: Semantics(
          container: true,
          label: widget.semanticLabel,
          child: AnimatedScale(
            scale: scale,
            duration: const Duration(milliseconds: 200),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class ProjectCardBase extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final List<Widget> links;
  final double? height;

  const ProjectCardBase({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.links,
    this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const double borderRadius = 16;
    const double headerHeight = 140;
    const double cardWidth = 380;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: cardWidth,
      height: height ?? 650,
      decoration: BoxDecoration(
        color: ProjectSection.boxColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: ProjectSection.borderColor, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with logo
          Container(
            height: headerHeight,
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ProjectSection.headerRectColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(borderRadius),
                topRight: Radius.circular(borderRadius),
              ),
            ),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  height: headerHeight - 40,
                  semanticLabel: '$title logo',
                ),
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Solway',
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: ProjectSection.titleColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 3,
                        width: 100,
                        decoration: BoxDecoration(
                          color: ProjectSection.headerRectColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  Text(
                    description,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontFamily: 'Solway',
                      fontSize: 18,
                      color: ProjectSection.titleColor,
                      height: 1.4,
                    ),
                  ),
                  const Spacer(),
                  const Divider(
                    color: ProjectSection.headerRectColor,
                    thickness: 1.5,
                  ),
                  const SizedBox(height: 12),
                  ...links,
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MendProjectCard extends StatelessWidget {
  final double? height;
  const MendProjectCard({super.key, this.height});
  @override
  Widget build(BuildContext context) {
    return ProjectCardBase(
      imagePath: 'images/mend.webp',
      title: 'Mend',
      description:
          "Completely rebranded a previous project called Mend, a daily journaling app that integrates OpenAI's "
          "API to analyze journal entries and provide personalized coping strategies based on user input.\n\n"
          "I collaborated with a team on the design with a calm user experience in mind by using cool tones, typography, and iterative feedback-driven improvements.",
      links: const [
        _AccessibleLink(
          url: 'https://github.com/ukhan1219/m3nd',
          label: 'View on GitHub',
          iconColor: ProjectSection.headerRectColor,
        ),
      ],
      height: height,
    );
  }
}

class CapistranoProjectCard extends StatelessWidget {
  final double? height;
  const CapistranoProjectCard({super.key, this.height});
  @override
  Widget build(BuildContext context) {
    return ProjectCardBase(
      imagePath: 'images/capistrano.webp',
      title: 'Capistrano Distillery',
      description:
          "Collaborated on the development of a website for Capistrano Distillery using React.js.\n\n"
          "Met with a designer to gather client requirements and feedback, and implemented key features like appointment booking and modular product card components to display detailed liquor metadata, including ingredient composition and tasting profile.",
      links: const [
        _AccessibleLink(
          url: 'https://www.capistranodistillery.com/',
          label: 'View the website',
          iconColor: ProjectSection.headerRectColor,
        ),
      ],
      height: height,
    );
  }
}

class BlotProjectCard extends StatelessWidget {
  final double? height;
  const BlotProjectCard({super.key, this.height});
  @override
  Widget build(BuildContext context) {
    return ProjectCardBase(
      imagePath: 'images/blot.png',
      title: 'BLOT',
      height: height ?? 720,
      description:
          "Basic needs for Ladies Over Time (BLOT) is a web application built with React.js, HTML, and CSS that locates and lists the information surrounding women's shelters across the United States.\n\n"
          "This project was made to combat issues like period poverty through raising awareness of resources geared towards improving the lives of low-income and homeless women.\n"
          "It won the Fidelity category at WiNGHacks 2024!",
      links: const [
        _AccessibleLink(
          url: 'https://github.com/rockbison1230/WingHacksAL',
          label: 'View on GitHub',
          iconColor: ProjectSection.headerRectColor,
        ),
        SizedBox(height: 12),
        _AccessibleLink(
          url: 'https://devpost.com/software/blot-83kaxi',
          label: 'View on Devpost',
          iconColor: ProjectSection.headerRectColor,
        ),
      ],
    );
  }
}

class _AccessibleLink extends StatefulWidget {
  final String url;
  final String label;
  final Color iconColor;

  const _AccessibleLink({
    required this.url,
    required this.label,
    required this.iconColor,
    super.key,
  });

  @override
  State<_AccessibleLink> createState() => _AccessibleLinkState();
}

class _AccessibleLinkState extends State<_AccessibleLink>
    with SingleTickerProviderStateMixin {
  bool _isHovering = false;
  bool _isFocused = false;

  late AnimationController _controller;
  late Animation<double> _widthFactor;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _widthFactor = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void _onEnter(PointerEvent details) {
    setState(() {
      _isHovering = true;
      _controller.forward();
    });
  }

  void _onExit(PointerEvent details) {
    setState(() {
      _isHovering = false;
      _controller.reverse();
    });
  }

  void _onFocusChange(bool focused) {
    setState(() {
      _isFocused = focused;
      if (focused) {
        _controller.forward();
      } else if (!_isHovering) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onTap() async {
    final uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = widget.iconColor;

    return Focus(
      onFocusChange: _onFocusChange,
      child: MouseRegion(
        onEnter: _onEnter,
        onExit: _onExit,
        cursor: SystemMouseCursors.click,
        child: Semantics(
          button: true,
          label: widget.label,
          child: Tooltip(
            message: widget.label,
            child: InkWell(
              borderRadius: BorderRadius.circular(4),
              onTap: _onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.code, size: 20, color: textColor),
                    const SizedBox(width: 8),
                    Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        Text(
                          widget.label,
                          style: TextStyle(
                            fontFamily: 'Solway',
                            fontSize: 18,
                            color: textColor,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        AnimatedBuilder(
                          animation: _widthFactor,
                          builder: (context, child) {
                            return Container(
                              margin: const EdgeInsets.only(top: 2),
                              height: 2,
                              width: _widthFactor.value *
                                  _textWidth(context, widget.label, 18),
                              color: textColor,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _textWidth(BuildContext context, String text, double fontSize) {
    final TextPainter painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(fontFamily: 'Solway', fontSize: fontSize),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    );
    painter.layout();
    return painter.size.width;
  }
}
