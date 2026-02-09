import 'package:flutter/material.dart';

class ArtistDetailScreen extends StatelessWidget {
  final String name;
  final String skills;
  final String avatarAsset;
  final String intro;

  const ArtistDetailScreen({
    super.key,
    required this.name,
    required this.skills,
    required this.avatarAsset,
    required this.intro,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Allows the body to go behind the app bar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2E3141), // Deep slate blue
              Color(0xFF1B1C25), // Dark charcoal
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // --- Large Avatar ---
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF818CF8),
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(avatarAsset, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 24),

                // --- Name and Skills ---
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  skills,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFc7d2fe),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 32),

                // --- Divider ---
                Divider(
                  color: Colors.white.withOpacity(0.2),
                  indent: 40,
                  endIndent: 40,
                ),
                const SizedBox(height: 32),

                // --- Introduction Text ---
                Text(
                  intro,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 15,
                    height: 1.7,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
