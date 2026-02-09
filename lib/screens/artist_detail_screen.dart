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
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // We don't need an app bar, as we will create a custom floating back button.
      body: Stack(
        children: [
          // --- Full-Width Header Image ---
          Container(
            height: screenHeight * 0.4,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(avatarAsset),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
          // --- Gradient for Text Readability ---
          Container(
            height: screenHeight * 0.4,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
              ),
            ),
          ),

          // --- Scrollable Content Sheet ---
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: screenHeight * 0.35,
                ), // Start content below the header
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFFBF8F3), // Canvas background color
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- Name and Skills ---
                        Text(
                          name,
                          style: const TextStyle(
                            fontFamily: 'Serif',
                            color: Color(0xFF422B22),
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          skills,
                          style: const TextStyle(
                            color: Color(0xFFC89B79),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Divider(
                          color: const Color(0xFF422B22).withOpacity(0.2),
                        ),
                        const SizedBox(height: 24),

                        // --- Introduction Text ---
                        Text(
                          intro,
                          style: const TextStyle(
                            color: Color(0xFF6E5B52),
                            fontSize: 15,
                            height: 1.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // --- Floating Back Button ---
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 10,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
