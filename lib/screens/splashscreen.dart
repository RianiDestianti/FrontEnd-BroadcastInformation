import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:lottie/lottie.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  static const _animationDuration = Duration(milliseconds: 1500);
  static const _rotationDuration = Duration(milliseconds: 5000);
  static const _pulseDuration = Duration(milliseconds: 1500);
  static const _textAnimationDuration = Duration(milliseconds: 1200);
  static const _loadingDuration = Duration(milliseconds: 2000);
  static const _navigationDelay = Duration(milliseconds: 6000);
  static const _navigationTransitionDuration = Duration(milliseconds: 800);
  static const _themeColor = Color(0xFF57B4BA);

  late final AnimationController _logoAnimationController;
  late final AnimationController _smknLogoController;
  late final AnimationController _rotationController;
  late final AnimationController _pulseController;
  late final AnimationController _textAnimationController;
  late final AnimationController _loadingAnimationController;

  late final Animation<double> _fadeInAnimation;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _pulseAnimation;
  late final Animation<double> _smknFadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimationControllers();
    _createAnimations();
    _startAnimationSequence();
    _scheduleNavigation();
  }

  void _initializeAnimationControllers() {
    _logoAnimationController = AnimationController(
      duration: _animationDuration,
      vsync: this,
    );

    _smknLogoController = AnimationController(
      duration: _animationDuration,
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: _rotationDuration,
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: _pulseDuration,
      vsync: this,
    )..repeat(reverse: true);

    _textAnimationController = AnimationController(
      duration: _textAnimationDuration,
      vsync: this,
    );

    _loadingAnimationController = AnimationController(
      duration: _loadingDuration,
      vsync: this,
    )..repeat();
  }

  void _createAnimations() {
    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(_pulseController);

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textAnimationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _textAnimationController, curve: Curves.easeOut),
    );

    _smknFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _smknLogoController, curve: Curves.easeIn),
    );
  }

  void _startAnimationSequence() {
    _logoAnimationController.forward();

    Future.delayed(const Duration(milliseconds: 300), () {
      _smknLogoController.forward();
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      _textAnimationController.forward();
    });
  }

  void _scheduleNavigation() {
    Timer(_navigationDelay, () {
      if (!mounted) return;
      
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const SignInPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final fadeAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            );

            return FadeTransition(opacity: fadeAnimation, child: child);
          },
          transitionDuration: _navigationTransitionDuration,
        ),
      );
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
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, _themeColor.withOpacity(0.15)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildRotatingBackgroundLogo(screenSize),
              _buildContentColumn(),
              _buildFooterText(),
              _buildVersionText(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRotatingBackgroundLogo(Size screenSize) {
    return Center(
      child: AnimatedBuilder(
        animation: _rotationController,
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotationController.value * 2 * math.pi,
            child: Opacity(
              opacity: 0.08,
              child: SizedBox(
                width: screenSize.width * 1.5,
                height: screenSize.width * 1.5,
                child: Image.asset(
                  'assets/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContentColumn() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                _buildRotatingGradientCircle(),
                _buildRotatingDots(),
                _buildLogosRow(),
              ],
            ),
          ),
          const SizedBox(height: 40),
          _buildAppTitle(),
          const SizedBox(height: 8),
          _buildAppSubtitle(),
          const SizedBox(height: 50),
          _buildLoadingIndicator(),
        ],
      ),
    );
  }

  Widget _buildRotatingGradientCircle() {
    return AnimatedBuilder(
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
                  _themeColor.withOpacity(0.1),
                  _themeColor.withOpacity(0.3),
                  _themeColor.withOpacity(0.1),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRotatingDots() {
    return AnimatedBuilder(
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
                      color: _themeColor.withOpacity(0.7),
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLogosRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildPrimaryLogo(),
        _buildLogoSeparator(),
        _buildSecondaryLogo(),
      ],
    );
  }

  Widget _buildPrimaryLogo() {
    return ScaleTransition(
      scale: _logoAnimationController,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: _buildLogoContainer(
              logoPath: 'assets/logo.png',
            ),
          );
        },
      ),
    );
  }

  Widget _buildSecondaryLogo() {
    return ScaleTransition(
      scale: _smknLogoController,
      child: FadeTransition(
        opacity: _smknFadeAnimation,
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: _buildLogoContainer(
                logoPath: 'assets/smkn.png',
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLogoContainer({required String logoPath}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: _themeColor.withOpacity(0.25),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
        border: Border.all(
          color: _themeColor.withOpacity(0.15),
          width: 2,
        ),
      ),
      child: SizedBox(
        height: 90,
        width: 90,
        child: Image.asset(
          logoPath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildLogoSeparator() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSeparatorLine(
          colors: [
            _themeColor.withOpacity(0.3),
            _themeColor.withOpacity(0.7),
          ],
        ),
        const SizedBox(height: 5),
        _buildSeparatorDot(),
        const SizedBox(height: 5),
        _buildSeparatorLine(
          colors: [
            _themeColor.withOpacity(0.7),
            _themeColor.withOpacity(0.3),
          ],
        ),
      ],
    );
  }

  Widget _buildSeparatorLine({required List<Color> colors}) {
    return Container(
      width: 3,
      height: 25,
      margin: const EdgeInsets.symmetric(
        horizontal: 25,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildSeparatorDot() {
    return Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _themeColor.withOpacity(0.9),
        boxShadow: [
          BoxShadow(
            color: _themeColor.withOpacity(0.3),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildAppTitle() {
    return FadeTransition(
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
    );
  }

  Widget _buildAppSubtitle() {
    return FadeTransition(
      opacity: _fadeInAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: const Text(
          'Ruang Informasi Sekolah',
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return AnimatedBuilder(
      animation: _loadingAnimationController,
      builder: (context, child) {
        return SizedBox(
          width: 60,
          height: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              final delayedValue = (_loadingAnimationController.value + index * 0.2) % 1.0;
              return _buildLoadingDot(delayedValue);
            }),
          ),
        );
      },
    );
  }

  Widget _buildLoadingDot(double animationValue) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _themeColor.withOpacity(0.3 + animationValue * 0.7),
      ),
      child: Transform.scale(
        scale: 0.7 + animationValue * 0.5,
        child: const DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _themeColor,
          ),
        ),
      ),
    );
  }

  Widget _buildFooterText() {
    return Positioned(
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
              color: Colors.black54,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVersionText() {
    return Positioned(
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
    );
  }
}