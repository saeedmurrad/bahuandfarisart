import 'package:flutter/material.dart';
import 'art_gallery_screen.dart';
import 'gallery_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 1000,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 2.0,
            colors: [
              Color(0xFF6A11CB),
              Color(0xFF2575FC),
              Color(0xFF050816),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
            child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Welcome Back',
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Artistic Journey',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),


                    ],
                  ),
                ],
              ),
              Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ───────── TOP BAR ─────────
                const SizedBox(height: 24),

                // ───────── HERO CARD ─────────
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF020617),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white24,
                    ),
                  ),

                  child: Column(// ─────── ROW + COLUMN MIX LAYOUT ───────
                  children:[
                    Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // ───── LEFT SIDE : AVATAR ─────
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF818CF8),
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/artist/PHOTO-2026-02-08-20-25-56.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      // ───── RIGHT SIDE : ALL TEXT ─────
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            const Text(
                              'Hasnat Bahu',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 4),

                            const Text(
                              'Drawing • Painting • Creative exploration',
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 13,
                              ),
                            ),

                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                     Column(// ───── YOUR EXPANDABLE INTRO (UNCHANGED) ─────
                     children: [ExpandableIntroText(
                        text:
                        'I create expressive artwork inspired by nature, emotion and '
                            'imagination. This space keeps all my drawings together '
                            'in one simple gallery. I believe art is a journey of self discovery '
                            'and every stroke carries a story, a feeling, and a silent message '
                            'that connects hearts beyond words.',
                      ),])
                    ],
                  ),
               ] ),
          ),

                // const SizedBox(height: 24),

              ],
            ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ──

                  // ───────── HERO CARD ─────────
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ───────── TOP BAR ─────────
                      const SizedBox(height: 24),

                      // ───────── HERO CARD ─────────
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF020617),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white24,
                          ),
                        ),

                        child: Column(// ─────── ROW + COLUMN MIX LAYOUT ───────
                            children:[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  // ───── LEFT SIDE : AVATAR ─────
                                  Container(
                                    width: 90,
                                    height: 90,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(0xFF818CF8),
                                        width: 2,
                                      ),
                                    ),
                                    child: ClipOval(
                                      child: Image.asset(
                                        'assets/artist/PHOTO-2026-02-08-20-30-06.jpg',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 16),

                                  // ───── RIGHT SIDE : ALL TEXT ─────
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Faris Khalique',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),

                                        const SizedBox(height: 4),

                                        const Text(
                                          'Drawing • Painting • Creative exploration',
                                          style: TextStyle(
                                            color: Colors.white60,
                                            fontSize: 13,
                                          ),
                                        ),

                                        const SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Column(// ───── YOUR EXPANDABLE INTRO (UNCHANGED) ─────
                                      children: [ExpandableIntroText(
                                        text:
                                        'I create expressive artwork inspired by nature, emotion and '
                                            'imagination. This space keeps all my drawings together '
                                            'in one simple gallery. I believe art is a journey of self discovery '
                                            'and every stroke carries a story, a feeling, and a silent message '
                                            'that connects hearts beyond words.',
                                      ),])
                                ],
                              ),
                            ] ),
                      ),

                      // const SizedBox(height: 24),

                    ],
                  ),

                  const SizedBox(height: 24),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ArtGalleryScreen()),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF6A11CB),
                            Color(0xFF2575FC),
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'View Artworks',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const GalleryScreen()),
                      );
                    },
                 child:  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white30),
                    ),
                    child: const Center(
                      child: Text(
                        'Artist Photo',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),

          )
                ],
              ),
             ]
            ),
          ),
        ),
      ),
    );
  }
}

class ExpandableIntroText extends StatefulWidget {
  final String text;

  const ExpandableIntroText({super.key, required this.text});

  @override
  State<ExpandableIntroText> createState() => _ExpandableIntroTextState();
}

class _ExpandableIntroTextState extends State<ExpandableIntroText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: isExpanded ? null : 80,
              child: Text(
                widget.text,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // BLUR EFFECT WHEN NOT EXPANDED
            if (!isExpanded)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        const Color(0xFF020617).withOpacity(0.9),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: 6),

        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white24),
            ),
            child: Text(
              isExpanded ? "Show less" : "View more",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ],
    );
  }
}






class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
