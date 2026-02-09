import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(const ArtGalleryApp());
}

class ArtGalleryApp extends StatelessWidget {
  const ArtGalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Art Gallery',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: DashboardScreen(),
    );
  }
}
