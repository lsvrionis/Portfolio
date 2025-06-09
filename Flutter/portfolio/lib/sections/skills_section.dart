import 'package:flutter/material.dart';

class SkillsSection extends StatelessWidget {
  static final GlobalKey globalKey = GlobalKey();

  const SkillsSection({Key? key}) : super(key: key);

  static const backgroundColor = Color(0xFFF6F2EF);
  static const headingColor = Color(0xFF0022B7);
  static const boxColor = Color(0xFF006D5B);
  static const borderColor = Color(0xFF0022B7);
  static const textColor = Color(0xFFF6F2EF);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 700;

    return Container(
      key: globalKey,
      color: backgroundColor,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 60,
        horizontal: isMobile ? 16 : 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'skills',
            style: TextStyle(
              fontFamily: 'Solway',
              fontSize: isMobile ? 40 : 60,
              fontWeight: FontWeight.bold,
              color: headingColor,
            ),
          ),
          const SizedBox(height: 40),
          isMobile
              ? Column(
                  children: [
                    _skillBox('Languages', [
                      'HTML', 'CSS', 'JavaScript', 'TypeScript', 'Dart',
                      'C', 'Python', 'Java', 'SQL',
                    ], isMobile),
                    const SizedBox(height: 24),
                    _skillBox('Frameworks', [
                      'React', 'Node.js', 'Next.js', 'WordPress',
                      'Flutter', 'Tailwind', 'Bootstrap',
                    ], isMobile),
                    const SizedBox(height: 24),
                    _skillBox('Tools', [
                      'GitHub', 'Git', 'VS Code', 'Visual Studio',
                      'Eclipse', 'LaTeX', 'Figma', 'GCP',
                      'Docker', 'Firebase', 'Vercel',
                    ], isMobile),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _skillBox('Languages', [
                      'HTML', 'CSS', 'JavaScript', 'TypeScript', 'Dart',
                      'C', 'Python', 'Java', 'SQL',
                    ], isMobile),
                    _skillBox('Frameworks', [
                      'React', 'Node.js', 'Next.js', 'WordPress',
                      'Flutter', 'Tailwind', 'Bootstrap',
                    ], isMobile),
                    _skillBox('Tools', [
                      'GitHub', 'Git', 'VS Code', 'Visual Studio',
                      'Eclipse', 'LaTeX', 'Figma', 'GCP',
                      'Docker', 'Firebase', 'Vercel',
                    ], isMobile),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _skillBox(String title, List<String> skills, bool isMobile) {
    final box = _HoverCard(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 12),
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Solway',
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: skills.map((skill) => _HoverSkillTag(label: skill)).toList(),
            ),
          ],
        ),
      ),
    );

    return isMobile ? box : Flexible(fit: FlexFit.loose, child: box);
  }
}

class _HoverSkillTag extends StatefulWidget {
  final String label;

  const _HoverSkillTag({required this.label, super.key});

  @override
  State<_HoverSkillTag> createState() => _HoverSkillTagState();
}

class _HoverSkillTagState extends State<_HoverSkillTag> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 700;
    final fontSize = isMobile ? 13.0 : 15.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
        decoration: BoxDecoration(
          color: _isHovering ? SkillsSection.borderColor : SkillsSection.boxColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: SkillsSection.borderColor),
          boxShadow: _isHovering
              ? [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))]
              : [],
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            color: SkillsSection.textColor,
            fontFamily: 'Solway',
            fontWeight: FontWeight.w500,
            fontSize: fontSize,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

class _HoverCard extends StatefulWidget {
  final Widget child;

  const _HoverCard({required this.child, super.key});

  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedScale(
        scale: _isHovering ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: widget.child,
      ),
    );
  }
}
