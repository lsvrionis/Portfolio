import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  static const Color backgroundColor = Color(0xFFF6F2EF);
  static const Color highlightColor = Color(0xFF0022B7);
  static const Color hoverCompanyColor = Color(0xFF006D5B);
  static const Color separatorColor = Color(0xFF006D5B); // green line

  static const String limbitlessUrl = 'https://limbitless-solutions.org/';
  static const String ucfOsiUrl = 'https://osi.ucf.edu/';

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(
              'experience',
              style: TextStyle(
                fontFamily: 'Solway',
                fontSize: isMobile ? 40 : 60,
                fontWeight: FontWeight.bold,
                color: highlightColor,
              ),
            ),
          ),
          const SizedBox(height: 60),
          isMobile ? _buildMobileTimeline(context) : _buildDesktopTimeline(context),
        ],
      ),
    );
  }

  Widget _buildDesktopTimeline(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExperienceTile(
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
        ExperienceTile(
          dateRange: 'Apr. 2024 – Apr. 2025',
          role: 'Web Designer',
          company: "UCF's Office of Student Involvement",
          url: ucfOsiUrl,
          bullets: [
            'Designed and maintained the Office of Student Involvement website for UCF events and campaigns, as well as a variety of other UCF-affiliated websites, using <b>HTML, CSS, Bootstrap, and WordPress</b> to ensure responsive and accessible user interfaces.',
          ],
        ),
      ],
    );
  }

  Widget _buildMobileTimeline(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMobileItem(
          date: 'Jan. 2025 – Present',
          role: 'Web Development & UX/UI Design Intern',
          company: 'Limbitless Solutions INC.',
          url: limbitlessUrl,
          paragraph:
              'Current intern at Limbitless Solutions INC., a nonprofit organization based at the University of Central Florida, that creates personalized 3D-printed prosthetic arms for children. I develop accessible, responsive web projects using JavaScript, HTML, CSS, and WCAG standards and design UX/UI concepts with Figma to enhance accessibility through technology.',
        ),
        const SizedBox(height: 40),
        _buildMobileItem(
          date: 'Apr. 2024 – Apr. 2025',
          role: 'Web Designer',
          company: "UCF's Office of Student Involvement",
          url: ucfOsiUrl,
          paragraph:
              'Designed and maintained the Office of Student Involvement website for UCF events and campaigns, as well as a variety of other UCF-affiliated websites. Utilized HTML, CSS, Bootstrap, and WordPress to ensure responsive and accessible user interfaces.',
        ),
      ],
    );
  }

  Widget _buildMobileItem({
    required String date,
    required String role,
    required String company,
    required String url,
    required String paragraph,
  }) {
    return Semantics(
      button: true,
      label: 'Experience at $company as $role from $date. Tap for more info.',
      child: GestureDetector(
        onTap: () => _launchUrl(url),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 4,
              height: 140,
              color: separatorColor,
              margin: const EdgeInsets.only(right: 16),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    date,
                    style: const TextStyle(
                      fontFamily: 'Solway',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontFamily: 'Solway',
                        fontSize: 20,
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
                  const SizedBox(height: 8),
                  Text(
                    paragraph,
                    style: const TextStyle(
                      fontFamily: 'Solway',
                      fontSize: 18,
                      height: 1.4,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
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

class ExperienceTile extends StatefulWidget {
  final String dateRange;
  final String role;
  final String company;
  final String url;
  final List<String> bullets;

  const ExperienceTile({
    required this.dateRange,
    required this.role,
    required this.company,
    required this.url,
    required this.bullets,
    super.key,
  });

  @override
  State<ExperienceTile> createState() => _ExperienceTileState();
}

class _ExperienceTileState extends State<ExperienceTile> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: Semantics(
        button: true,
        label:
            '${widget.role} at ${widget.company} from ${widget.dateRange}. Tap for more details.',
        child: GestureDetector(
          onTap: () => _launchUrl(widget.url),
          child: Transform.scale(
            scale: _hovering ? 1.02 : 1.0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 4,
                    height: _hovering ? 160 : 140,
                    color: ExperienceSection.separatorColor,
                    margin: const EdgeInsets.only(right: 16),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.dateRange,
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
                                TextSpan(text: '${widget.role} @ '),
                                TextSpan(
                                  text: widget.company,
                                  style: TextStyle(
                                    color: _hovering
                                        ? ExperienceSection.hoverCompanyColor
                                        : ExperienceSection.highlightColor,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        for (final bullet in widget.bullets)
                          Padding(
                            padding: const EdgeInsets.only(left: 24, bottom: 8),
                            child: _buildBulletPoint(bullet),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
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

    return RichText(
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
