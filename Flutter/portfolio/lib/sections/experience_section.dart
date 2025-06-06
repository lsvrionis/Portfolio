import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  static const Color backgroundColor = Color(0xFFF6F2EF);
  static const Color highlightColor = Color(0xFF5E7CFE);

  static const String limbitlessUrl = 'https://limbitless-solutions.org/';
  static const String ucfOsiUrl = 'https://osi.ucf.edu/';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'experience',
            style: TextStyle(
              fontFamily: 'Solway',
              fontSize: 60,
              fontWeight: FontWeight.bold,
              color: highlightColor,
            ),
          ),
          const SizedBox(height: 60),
          _buildTimeline(context),
        ],
      ),
    );
  }

  Widget _buildTimeline(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 45,
          left: 72,
          child: CustomPaint(
            size: const Size(6, 290),
            painter: VerticalArrowPainter(color: highlightColor),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 55),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildExperienceTile(
                context: context,
                dateRange: 'Jan. 2025 – Present',
                role: 'Web Development & UX/UI Design Intern',
                company: 'Limbitless Solutions INC.',
                url: limbitlessUrl,
                bullets: [
                  'Current intern at Limbitless Solutions INC., a nonprofit organization based at the University of Central Florida, that creates personalized 3D-printed prosthetic arms for children.',
                  'I develop accessible, responsive web projects using <b>JavaScript, HTML, CSS, and WCAG standards</b> and design UX/UI concepts with <b>Figma</b> to enhance accessibility through technology.',
                ],
              ),
              const SizedBox(height: 60),
              _buildExperienceTile(
                context: context,
                dateRange: 'Apr. 2024 – Apr. 2025',
                role: 'Web Designer',
                company: "UCF's Office of Student Involvement",
                url: ucfOsiUrl,
                bullets: [
                  'Designed and maintained the Office of Student Involvement website for UCF events and campaigns, as well as a variety of other UCF-affiliated websites, using <b>HTML, CSS, Bootstrap, and WordPress</b> to ensure responsive and accessible user interfaces.',
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildExperienceTile({
    required BuildContext context,
    required String dateRange,
    required String role,
    required String company,
    required String url,
    required List<String> bullets,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _HoverScaleWidget(
          child: Container(
            margin: const EdgeInsets.only(top: 6),
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: highlightColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: 32),
        Expanded(
          child: GestureDetector(
            onTap: () => _launchUrl(url),
            child: _HoverScaleTranslateWidget(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateRange,
                    style: const TextStyle(
                      fontFamily: 'Solway',
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontFamily: 'Solway',
                          fontSize: 25,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(text: '$role @ '),
                          TextSpan(
                            text: company,
                            style: const TextStyle(
                              color: highlightColor,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  for (final bullet in bullets)
                    Padding(
                      padding: const EdgeInsets.only(left: 24, bottom: 8),
                      child: _buildBulletPoint(context, bullet),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBulletPoint(BuildContext context, String text) {
    final regex = RegExp(r'<b>(.*?)</b>');
    final spans = <TextSpan>[];
    int lastIndex = 0;
    for (final match in regex.allMatches(text)) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(text: text.substring(lastIndex, match.start)));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ));
      lastIndex = match.end;
    }
    if (lastIndex < text.length) {
      spans.add(TextSpan(text: text.substring(lastIndex)));
    }

    final maxWidth = MediaQuery.of(context).size.width * 0.8;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontFamily: 'Solway',
            fontSize: 25,
            color: Colors.black87,
          ),
          children: [
            const TextSpan(text: '•  '),
            ...spans,
          ],
        ),
      ),
    );
  }

  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('Could not launch $url');
    }
  }
}

class VerticalArrowPainter extends CustomPainter {
  final Color color;
  final double width;
  final double height;

  VerticalArrowPainter({
    required this.color,
    this.width = 6,
    this.height = 250,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final arrowHeadHeight = 20.0;
    final shaftHeight = height - arrowHeadHeight;

    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width / 2 - width * 1.5, arrowHeadHeight);
    path.lineTo(size.width / 2 + width * 1.5, arrowHeadHeight);
    path.close();
    canvas.drawPath(path, paint);

    final shaftRect = Rect.fromLTWH(
      (size.width - width) / 2,
      arrowHeadHeight,
      width,
      shaftHeight,
    );
    canvas.drawRect(shaftRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _HoverScaleWidget extends StatefulWidget {
  final Widget child;
  final double scaleFactor;

  const _HoverScaleWidget({required this.child, this.scaleFactor = 1.05, Key? key}) : super(key: key);

  @override
  State<_HoverScaleWidget> createState() => _HoverScaleWidgetState();
}

class _HoverScaleWidgetState extends State<_HoverScaleWidget> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedScale(
        scale: _hovering ? widget.scaleFactor : 1,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: widget.child,
      ),
    );
  }
}

class _HoverScaleTranslateWidget extends StatefulWidget {
  final Widget child;
  final double scaleFactor;
  final double translateX;

  const _HoverScaleTranslateWidget({
    required this.child,
    this.scaleFactor = 1.05,
    this.translateX = 10,
    Key? key,
  }) : super(key: key);

  @override
  State<_HoverScaleTranslateWidget> createState() => _HoverScaleTranslateWidgetState();
}

class _HoverScaleTranslateWidgetState extends State<_HoverScaleTranslateWidget> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()
          ..translate(_hovering ? widget.translateX : 0)
          ..scale(_hovering ? widget.scaleFactor : 1),
        child: widget.child,
      ),
    );
  }
}
