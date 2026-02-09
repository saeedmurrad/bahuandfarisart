import 'package:flutter/material.dart';

import 'art_gallery_screen.dart';
import 'artist_detail_screen.dart';
import 'snaps_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFBF8F3), // Soft off-white, like a fresh canvas
              Color(0xFFF3E9E4), // Muted dusty rose
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                // --- HEADER ---
                const Text(
                  'Bahu & Faris',
                  style: TextStyle(
                    fontFamily: 'Serif',
                    color: Color(0xFF422B22), // Dark, warm brown
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'An Artistic Journey',
                  style: TextStyle(
                    color: Color(0xFF6E5B52), // Muted brown
                    fontSize: 16,
                    letterSpacing: 2.0,
                  ),
                ),
                const Spacer(flex: 2),

                // --- ARTIST AVATARS ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _ArtistAvatar(
                      name: 'Muhammad Hassnat Bahu',
                      avatarAsset: 'assets/artist/bahu-2.jpg',
                      onTap: () => _navigateToArtistDetail(context, bahuData),
                    ),
                    _ArtistAvatar(
                      name: 'Muhammad Faris',
                      avatarAsset: 'assets/artist/faris-2.jpg',
                      onTap: () => _navigateToArtistDetail(context, farisData),
                    ),
                  ],
                ),
                const Spacer(flex: 2),

                // --- ARTISTIC SLOGAN ---
                const Text(
                  '"Creativity in Every Stroke"',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF6E5B52),
                    fontSize: 16,
                  ),
                ),
                const Spacer(flex: 1),

                // --- NAVIGATION BUTTONS ---
                _NavigationButton(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ArtGalleryScreen(),
                    ),
                  ),
                  icon: Icons.brush_outlined,
                  label: 'View Artworks',
                  isPrimary: true,
                ),
                const SizedBox(height: 16),
                _NavigationButton(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SnapsScreen(),
                    ),
                  ),
                  icon: Icons.photo_camera_back_outlined,
                  label: 'View Snaps',
                ),
                const Spacer(),

                // --- CREATOR CREDIT ---
                const Text(
                  'Made by Saeed Murrad',
                  style: TextStyle(
                    color: Color(0xFFB0A49D), // Subtle, light brown
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToArtistDetail(
    BuildContext context,
    Map<String, String> artistData,
  ) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ArtistDetailScreen(
              name: artistData['name']!,
              skills: artistData['skills']!,
              avatarAsset: artistData['avatarAsset']!,
              intro: artistData['intro']!,
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
}

// --- WIDGETS ---

class _ArtistAvatar extends StatelessWidget {
  final String name;
  final String avatarAsset;
  final VoidCallback onTap;

  const _ArtistAvatar({
    required this.name,
    required this.avatarAsset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromRGBO(0, 0, 0, 0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(
                avatarAsset,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF422B22),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavigationButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String label;
  final bool isPrimary;

  const _NavigationButton({
    required this.onTap,
    required this.icon,
    required this.label,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isPrimary ? Colors.white : const Color(0xFF6E5B52);
    final iconColor = isPrimary ? Colors.white : const Color(0xFF6E5B52);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: isPrimary
              ? null
              : Border.all(color: const Color(0xFFD3C5BC), width: 1.5),
          color: isPrimary
              ? const Color(0xFFC89B79)
              : Colors.transparent, // Warm terracotta
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: const Color(0xFFC89B79).withAlpha(77), // 0.3 opacity
                    blurRadius: 15,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Full data maps needed for navigation ---
const bahuData = {
  'name': 'Muhammad Hassnat Bahu',
  'skills': 'Drawing • Painting • Animal & Nature Art',
  'avatarAsset': 'assets/artist/bahu-2.jpg',
  'intro':
      'Welcome to the Creative World of Muhammad Hassnat Bahoo...\n\nMeet Muhammad Hassnat Bahoo — a young artist with an extraordinary eye for detail and a heart full of imagination. Hassnat loves drawing, painting, and bringing the beauty of animals and the rainforest to life through his artwork. His passion for creativity shines in every piece he creates, and he takes great pride in his growing portfolio.\n\nThis website is a window into his artistic world — a place where colors, creatures, and creativity come together to celebrate his talent and ever‑expanding artistic journey.',
};

const farisData = {
  'name': 'Muhammad Faris',
  'skills': 'Astronomy & Space • Geography & Maps • Drawing & Art',
  'avatarAsset': 'assets/artist/faris-2.jpg',
  'intro':
      'Welcome to Muhammad Faris’s World of Wonder...\n\nStep into the vibrant universe of Muhammad Faris — a curious young explorer with a passion for discovering how our world and the cosmos work. Faris loves learning about astronomy, planets, and the solar system, and he’s just as fascinated by the amazing animals that share our planet. His curiosity doesn’t stop there: he enjoys exploring body parts and how they function, studying countries and maps, and diving into the mysteries of rocks, volcanoes, and geology.\n\nWith a sketchbook always nearby, Faris brings his discoveries to life through drawing and art. This website is his creative playground — a place where science, geography, nature, and imagination come together in colorful harmony.',
};
