import 'package:bahuandfarisart/screens/artist_detail_screen.dart';
import 'package:flutter/material.dart';

import 'art_gallery_screen.dart';
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
              Color(0xFF3A3852), // Warm, dusky purple
              Color(0xFF2E2D3E), // Deep, soft charcoal
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
                    fontFamily: 'Serif', // A more artistic font if available
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'An Artistic Journey',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    letterSpacing: 1.5,
                  ),
                ),
                const Spacer(flex: 2),

                // --- ARTIST AVATARS ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _ArtistAvatar(
                      name: 'Muhammad Hassnat Bahu',
                      avatarAsset:
                          'assets/artist/PHOTO-2026-02-08-20-25-56.jpg',
                      onTap: () => _navigateToArtistDetail(context, bahuData),
                    ),
                    _ArtistAvatar(
                      name: 'Muhammad Faris',
                      avatarAsset:
                          'assets/artist/PHOTO-2026-02-08-20-30-06.jpg',
                      onTap: () => _navigateToArtistDetail(context, farisData),
                    ),
                  ],
                ),
                const Spacer(flex: 3),

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
      MaterialPageRoute(
        builder: (context) => ArtistDetailScreen(
          name: artistData['name']!,
          skills: artistData['skills']!,
          avatarAsset: artistData['avatarAsset']!,
          intro: artistData['intro']!,
        ),
      ),
    );
  }
}

// --- ARTIST DATA MAPS ---
const bahuData = {
  'name': 'Muhammad Hassnat Bahu',
  'skills': 'Drawing • Painting • Animal & Nature Art',
  'avatarAsset': 'assets/artist/PHOTO-2026-02-08-20-25-56.jpg',
  'intro':
      'Welcome to the Creative World of Muhammad Hassnat Bahoo...\n\nMeet Muhammad Hassnat Bahoo — a young artist with an extraordinary eye for detail and a heart full of imagination. Hassnat loves drawing, painting, and bringing the beauty of animals and the rainforest to life through his artwork. His passion for creativity shines in every piece he creates, and he takes great pride in his growing portfolio.\n\nThis website is a window into his artistic world — a place where colors, creatures, and creativity come together to celebrate his talent and ever‑expanding artistic journey.',
};

const farisData = {
  'name': 'Muhammad Faris',
  'skills': 'Astronomy & Space • Geography & Maps • Drawing & Art',
  'avatarAsset': 'assets/artist/PHOTO-2026-02-08-20-30-06.jpg',
  'intro':
      'Welcome to Muhammad Faris’s World of Wonder...\n\nStep into the vibrant universe of Muhammad Faris — a curious young explorer with a passion for discovering how our world and the cosmos work. Faris loves learning about astronomy, planets, and the solar system, and he’s just as fascinated by the amazing animals that share our planet. His curiosity doesn’t stop there: he enjoys exploring body parts and how they function, studying countries and maps, and diving into the mysteries of rocks, volcanoes, and geology.\n\nWith a sketchbook always nearby, Faris brings his discoveries to life through drawing and art. This website is his creative playground — a place where science, geography, nature, and imagination come together in colorful harmony.',
};

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
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF818CF8), width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipOval(child: Image.asset(avatarAsset, fit: BoxFit.cover)),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
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

  const _NavigationButton({
    required this.onTap,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
          color: Colors.white.withOpacity(0.1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white70),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
