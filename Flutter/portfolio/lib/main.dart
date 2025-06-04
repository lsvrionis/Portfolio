import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; //imported for url launching

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
            // Add more sections here later...
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

class _FirstSectionState extends State<FirstSection> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: const Color(0xFFF6F2EF),
      child: Column(
        children: [
          // Top Row with name and button
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
                          query: Uri.encodeFull('subject=Hello Lily&body=I loved your portfolio!'),
                        );

                        if (await canLaunchUrl(emailLaunchUri)) {
                          await launchUrl(emailLaunchUri);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Could not open email app.')),
                          );
                        }
                      },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: isHovering ? const Color(0xFF4B65D4) : const Color(0xFF5E7CFE),
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

          // Spacer and Centered "portfolio." Text
          const Spacer(),
          const Center(
            child: Text(
              "portfolio.",
              style: TextStyle(
                fontFamily: 'Solway',
                fontSize: 72,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5E7CFE),
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
