import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';

void main() {
  runApp(const ArtGalleryApp());
}

class ArtGalleryApp extends StatelessWidget {
  const ArtGalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bahu & Faris Art',
      theme: ThemeData(useMaterial3: true),
      home: const SplashScreen(),
    );
  }
}
