import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class IntroSection extends StatelessWidget {
  static final GlobalKey globalKey = GlobalKey();

  const IntroSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 700;

        return Container(
          key: globalKey,
          color: const Color(0xFFF6F2EF),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (isMobile) ...[
                const HoverScaleImage(),
                const SizedBox(height: 32),
              ],
              isMobile
                  ? _buildIntroContent(isMobile)
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 2, child: _buildIntroContent(isMobile)),
                        const SizedBox(width: 40),
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: 60),
                            child: HoverScaleImage(),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildIntroContent(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "hello!",
              style: TextStyle(
                fontSize: isMobile ? 40 : 60,
                fontWeight: FontWeight.bold,
                fontFamily: 'Solway',
                color: const Color(0xFF0022B7),
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: 250,
              height: 4,
              child: const ColoredBox(color: Color(0xFF006D5B)),
            ),
          ],
        ),
        const SizedBox(height: 30),
        RichText(
          textAlign: TextAlign.start,
          text: TextSpan(
            style: TextStyle(
              fontFamily: 'Solway',
              fontSize: isMobile ? 18 : 25,
              color: Colors.black,
            ),
            children: const [
              TextSpan(text: "I’m "),
              TextSpan(
                text: "Lily",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0022B7),
                ),
              ),
              TextSpan(text: ", an Orlando-based "),
              TextSpan(
                text: "front-end developer",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: " and "),
              TextSpan(
                text: "UI/UX designer",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text:
                    ". I’m all about creating designs that are visually appealing, but also impactful and accessible.",
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        RichText(
          textAlign: TextAlign.start,
          text: TextSpan(
            style: TextStyle(
              fontFamily: 'Solway',
              fontSize: isMobile ? 18 : 25,
              color: Colors.black,
            ),
            children: const [
              TextSpan(
                text:
                    "Currently, I’m in my undergrad at the University of Central Florida studying information technology and cognitive sciences.",
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        FocusTraversalGroup(
          child: Column(
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
          ),
        ),
      ],
    );
  }
}

class LinkIconRow extends StatefulWidget {
  final IconData icon;
  final String label;
  final String url;

  const LinkIconRow({
    super.key,
    required this.icon,
    required this.label,
    required this.url,
  });

  @override
  State<LinkIconRow> createState() => _LinkIconRowState();
}

class _LinkIconRowState extends State<LinkIconRow> {
  bool isHovered = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;
    final textSize = isMobile ? 18.0 : 25.0;

    return Semantics(
      label: '${widget.label} link',
      button: true,
      child: FocusableActionDetector(
        focusNode: _focusNode,
        mouseCursor: SystemMouseCursors.click,
        onShowFocusHighlight: (focus) => setState(() {}),
        onShowHoverHighlight: (hover) => setState(() => isHovered = hover),
        child: GestureDetector(
          onTap: () => launchUrl(Uri.parse(widget.url)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: isMobile ? 40 : 48,
                  height: isMobile ? 40 : 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _focusNode.hasFocus
                        ? Colors.orange
                        : const Color(0xFF0022B7),
                  ),
                  child: Icon(
                    widget.icon,
                    color: const Color(0xFFF6F2EF),
                    size: isMobile ? 20 : 24,
                  ),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label,
                      style: TextStyle(
                        fontSize: textSize,
                        fontFamily: 'Solway',
                        color: Colors.black,
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(top: 4),
                      height: 2,
                      alignment: Alignment.centerLeft,
                      width: isHovered ? 180 : 0,
                      color: const Color(0xFF006D5B),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HoverScaleImage extends StatefulWidget {
  const HoverScaleImage({super.key});

  @override
  _HoverScaleImageState createState() => _HoverScaleImageState();
}

class _HoverScaleImageState extends State<HoverScaleImage> {
  bool _isHovered = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Semantics(
      label: 'Portrait photo of Lily Vrionis',
      button: true,
      onTapHint: 'Opens Lily\'s Instagram profile',
      child: FocusableActionDetector(
        focusNode: _focusNode,
        mouseCursor: SystemMouseCursors.click,
        onShowFocusHighlight: (focus) => setState(() {}),
        onShowHoverHighlight: (hover) => setState(() => _isHovered = hover),
        child: GestureDetector(
          onTap: () async {
            const url = 'https://instagram.com/lsvrionis';
            if (await canLaunchUrl(Uri.parse(url))) {
              await launchUrl(Uri.parse(url));
            }
          },
          child: Container(
            height: isMobile ? 300 : 500,
            decoration: BoxDecoration(
              border: Border.all(
                color: _focusNode.hasFocus
                    ? Color(0xFF006D5B)
                    : const Color(0xFF006D5B),
                width: 5,
              ),
            ),
            padding: const EdgeInsets.all(4),
            child: AnimatedScale(
              scale: _isHovered && !isMobile ? 1.05 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Image.asset(
                'images/Lily.jpg',
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
      ),
    );
  }
}
