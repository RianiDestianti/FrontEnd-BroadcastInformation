import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:lottie/lottie.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _logoAnimationController;
  late AnimationController _smknLogoController;
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _textAnimationController;
  late AnimationController _loadingAnimationController;

  // Animations
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _smknFadeAnimation;

  @override
  void initState() {
    super.initState();

    // Logo animation controller
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // SMKN logo animation controller
    _smknLogoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Continuous rotation animation controller
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 5000),
      vsync: this,
    )..repeat(); // Make it repeat forever

    // Pulse animation controller
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true); // Pulse in and out

    // Text animation controller
    _textAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Loading animation controller
    _loadingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(); // Make loading animation repeat

    // Pulse animation
    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(_pulseController);

    // Fade in animation for text
    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textAnimationController, curve: Curves.easeIn),
    );

    // Slide animation for text
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _textAnimationController, curve: Curves.easeOut),
    );

    // Fade in animation for SMKN logo
    _smknFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _smknLogoController, curve: Curves.easeIn),
    );

    // Start animation sequence
    _startAnimationSequence();

    // Navigate to login screen after 6 seconds
    Timer(const Duration(milliseconds: 6000), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) => const SignInPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Create a beautiful circular reveal transition
            Animation<double> fadeAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            );

            return FadeTransition(opacity: fadeAnimation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    });
  }

  void _startAnimationSequence() async {
    // Start app logo animation
    _logoAnimationController.forward();
    
    // Start SMKN logo animation slightly delayed
    Future.delayed(const Duration(milliseconds: 300), () {
      _smknLogoController.forward();
    });

    // Start text animation after logos appear
    Future.delayed(const Duration(milliseconds: 1200), () {
      _textAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _smknLogoController.dispose();
    _rotationController.dispose();
    _pulseController.dispose();
    _textAnimationController.dispose();
    _loadingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFF57B4BA);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          // Add a subtle gradient background
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, themeColor.withOpacity(0.15)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background rotating particles
              AnimatedBuilder(
                animation: _rotationController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotationController.value * 2 * math.pi,
                    child: Opacity(
                      opacity: 0.08,
                      child: Image.asset('assets/logo.png', fit: BoxFit.cover),
                    ),
                  );
                },
              ),

              // Main content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Decorative rotating background
                    SizedBox(
                      height: 200,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Rotating circular background
                          AnimatedBuilder(
                            animation: _rotationController,
                            builder: (context, child) {
                              return Transform.rotate(
                                angle: -_rotationController.value * 2 * math.pi,
                                child: Container(
                                  width: 280,
                                  height: 280,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: SweepGradient(
                                      colors: [
                                        themeColor.withOpacity(0.1),
                                        themeColor.withOpacity(0.3),
                                        themeColor.withOpacity(0.1),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          
                          // Rotating decorative circles
                          AnimatedBuilder(
                            animation: _rotationController,
                            builder: (context, child) {
                              return Transform.rotate(
                                angle: _rotationController.value * 2 * math.pi * 1.5,
                                child: SizedBox(
                                  width: 320,
                                  height: 320,
                                  child: Stack(
                                    children: List.generate(8, (index) {
                                      final angle = (index / 8) * 2 * math.pi;
                                      return Positioned(
                                        left: 160 + 145 * math.cos(angle),
                                        top: 160 + 145 * math.sin(angle),
                                        child: Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: themeColor.withOpacity(0.7),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              );
                            },
                          ),
                          
                          // Logos container - Side by side
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // App Logo - Left side
                              ScaleTransition(
                                scale: _logoAnimationController,
                                child: AnimatedBuilder(
                                  animation: _pulseAnimation,
                                  builder: (context, child) {
                                    return Transform.scale(
                                      scale: _pulseAnimation.value,
                                      child: child,
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: themeColor.withOpacity(0.3),
                                          blurRadius: 15,
                                          spreadRadius: 3,
                                        ),
                                      ],
                                    ),
                                    child: SizedBox(
                                      height: 90,
                                      width: 90,
                                      child: Image.asset(
                                        'assets/logo.png',
                                        fit: BoxFit.contain,
                                      ),
                                      
                                    ),
                                  ),
                                ),
                              ),
                              
                              // Connector between logos
                              Container(
                                width: 40,
                                height: 3,
                                margin: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      themeColor.withOpacity(0.7),
                                      themeColor.withOpacity(0.9),
                                      themeColor.withOpacity(0.7),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              
                              // SMKN Logo - Right side
                              ScaleTransition(
                                scale: _smknLogoController,
                                child: FadeTransition(
                                  opacity: _smknFadeAnimation,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.15),
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: SizedBox(
                                      height: 90,
                                      width: 90,
                                      child: Image.asset(
                                        'assets/smkn.png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // App name with fade and slide animation
                    FadeTransition(
                      opacity: _fadeInAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: const Text(
                          'EduInform',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Tagline with fade and slide animation
                    FadeTransition(
                      opacity: _fadeInAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: const Text(
                          'Ruang Informasi Sekolah',
                          style: TextStyle(fontSize: 18, color: Colors.black54),
                        ),
                      ),
                    ),

                    const SizedBox(height: 50),

                    // Custom animated loading indicator
                    AnimatedBuilder(
                      animation: _loadingAnimationController,
                      builder: (context, child) {
                        return SizedBox(
                          width: 60,
                          height: 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(3, (index) {
                              // Create staggered animation for each dot
                              final delayedValue =
                                  (_loadingAnimationController.value +
                                      index * 0.2) %
                                  1.0;
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 3),
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: themeColor.withOpacity(
                                    0.3 + delayedValue * 0.7,
                                  ),
                                ),
                                child: Transform.scale(
                                  scale: 0.7 + delayedValue * 0.5,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFF57B4BA),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // School name at the bottom
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: FadeTransition(
                  opacity: _fadeInAnimation,
                  child: const Center(
                    child: Text(
                      'SMK Negeri 11 Bandung',
                      style: TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.w500,
                        color: Colors.black54
                      ),
                    ),
                  ),
                ),
              ),

              // Version info
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: FadeTransition(
                  opacity: _fadeInAnimation,
                  child: const Center(
                    child: Text(
                      'Version 1.0.0',
                      style: TextStyle(color: Colors.black38, fontSize: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}