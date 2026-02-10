import 'dart:async';

import 'package:flutter/material.dart';

import 'dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _slideController;
  late final AnimationController _fadeController;
  late final AnimationController _pulseController;

  late final Animation<Offset> _bahuAnimation;
  late final Animation<Offset> _farisAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _textAnimation;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    final curvedAnimation = CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOutCubic,
    );

    // This animation was for the left-sliding image in your original code
    _bahuAnimation = Tween<Offset>(
      begin: const Offset(-1.5, 0.0),
      end: const Offset(-0.55, 0.0),
    ).animate(curvedAnimation);
    // This animation was for the right-sliding image in your original code
    _farisAnimation = Tween<Offset>(
      begin: const Offset(1.5, 0.0),
      end: const Offset(0.55, 0.0),
    ).animate(curvedAnimation);
    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(curvedAnimation);

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));
    _textAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
    _pulseAnimation = Tween<double>(begin: 5.0, end: 15.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _slideController.forward();
    await Future.delayed(const Duration(milliseconds: 800));
    _fadeController.forward();

    Timer(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const DashboardScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child),
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF5E5D0), Color(0xFFC89B79)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Restoring your original image choices with the new animations
                    SlideTransition(
                      position: _bahuAnimation, // Left-sliding animation
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: _buildAvatar('assets/artist/bahu-splash.jpg'),
                      ),
                    ),
                    SlideTransition(
                      position: _farisAnimation, // Right-sliding animation
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: _buildAvatar('assets/artist/faris-splash.jpg'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _textAnimation,
                  child: Column(
                    children: [
                      const Text(
                        'Bahu & Faris Art',
                        style: TextStyle(
                          fontFamily: 'Serif',
                          color: Color(0xFF422B22),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      FutureBuilder(
                        future: Future.delayed(
                          const Duration(milliseconds: 200),
                        ),
                        builder: (context, snapshot) {
                          return AnimatedOpacity(
                            opacity:
                                snapshot.connectionState == ConnectionState.done
                                ? 1.0
                                : 0.0,
                            duration: const Duration(milliseconds: 500),
                            child: const Text(
                              'An Artistic Journey',
                              style: TextStyle(
                                color: Color(0xFF6E5B52),
                                fontSize: 14,
                                letterSpacing: 1.5,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(String assetPath) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.9), width: 4),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.3),
                blurRadius: _pulseAnimation.value,
                spreadRadius: _pulseAnimation.value / 2,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 15,
                spreadRadius: 3,
              ),
            ],
          ),
          child: child,
        );
      },
      child: ClipOval(
        child: Image.asset(
          assetPath,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
      ),
    );
  }
}
