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

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
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
          pageBuilder:
              (context, animation, secondaryAnimation) => const SignInPage(),
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SplashBackground(
        child: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              RotatingBackgroundLogo(controller: _rotationController),
              SplashContent(
                rotationController: _rotationController,
                logoAnimationController: _logoAnimationController,
                pulseAnimation: _pulseAnimation,
                smknLogoController: _smknLogoController,
                smknFadeAnimation: _smknFadeAnimation,
                fadeInAnimation: _fadeInAnimation,
                slideAnimation: _slideAnimation,
                loadingAnimationController: _loadingAnimationController,
              ),
              FooterText(fadeInAnimation: _fadeInAnimation),
              VersionText(fadeInAnimation: _fadeInAnimation),
            ],
          ),
        ),
      ),
    );
  }
}

class SplashBackground extends StatelessWidget {
  final Widget child;
  static const _themeColor = Color(0xFF57B4BA);
  const SplashBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, _themeColor.withOpacity(0.15)],
        ),
      ),
      child: child,
    );
  }
}

class RotatingBackgroundLogo extends StatelessWidget {
  final AnimationController controller;
  const RotatingBackgroundLogo({Key? key, required this.controller})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Center(
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Transform.translate(
            offset: const Offset(0, -80),
            child: Transform.rotate(
              angle: controller.value * 2 * math.pi,
              child: Opacity(
                opacity: 0.08,
                child: SizedBox(
                  width: screenSize.width * 1.5,
                  height: screenSize.width * 1.5,
                  child: Image.asset('assets/logo.png', fit: BoxFit.contain),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SplashContent extends StatelessWidget {
  final AnimationController rotationController;
  final AnimationController logoAnimationController;
  final Animation<double> pulseAnimation;
  final AnimationController smknLogoController;
  final Animation<double> smknFadeAnimation;
  final Animation<double> fadeInAnimation;
  final Animation<Offset> slideAnimation;
  final AnimationController loadingAnimationController;
  static const _themeColor = Color(0xFF57B4BA);
  const SplashContent({
    Key? key,
    required this.rotationController,
    required this.logoAnimationController,
    required this.pulseAnimation,
    required this.smknLogoController,
    required this.smknFadeAnimation,
    required this.fadeInAnimation,
    required this.slideAnimation,
    required this.loadingAnimationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                RotatingGradientCircle(controller: rotationController),
                RotatingDots(controller: rotationController),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: LogosRow(
                    logoAnimationController: logoAnimationController,
                    pulseAnimation: pulseAnimation,
                    smknLogoController: smknLogoController,
                    smknFadeAnimation: smknFadeAnimation,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          AppTitle(
            fadeInAnimation: fadeInAnimation,
            slideAnimation: slideAnimation,
          ),
          const SizedBox(height: 8),
          AppSubtitle(
            fadeInAnimation: fadeInAnimation,
            slideAnimation: slideAnimation,
          ),
          const SizedBox(height: 50),
          LoadingIndicator(controller: loadingAnimationController),
        ],
      ),
    );
  }
}

class RotatingGradientCircle extends StatelessWidget {
  final AnimationController controller;
  static const _themeColor = Color(0xFF57B4BA);
  const RotatingGradientCircle({Key? key, required this.controller})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: -controller.value * 2 * math.pi,
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
}

class RotatingDots extends StatelessWidget {
  final AnimationController controller;
  static const _themeColor = Color(0xFF57B4BA);
  const RotatingDots({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: controller.value * 2 * math.pi * 1.5,
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
}

class LogosRow extends StatelessWidget {
  final AnimationController logoAnimationController;
  final Animation<double> pulseAnimation;
  final AnimationController smknLogoController;
  final Animation<double> smknFadeAnimation;

  const LogosRow({
    Key? key,
    required this.logoAnimationController,
    required this.pulseAnimation,
    required this.smknLogoController,
    required this.smknFadeAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        PrimaryLogo(
          logoAnimationController: logoAnimationController,
          pulseAnimation: pulseAnimation,
        ),
        LogoSeparator(),
        SecondaryLogo(
          smknLogoController: smknLogoController,
          smknFadeAnimation: smknFadeAnimation,
          pulseAnimation: pulseAnimation,
        ),
      ],
    );
  }
}

class PrimaryLogo extends StatelessWidget {
  final AnimationController logoAnimationController;
  final Animation<double> pulseAnimation;

  const PrimaryLogo({
    Key? key,
    required this.logoAnimationController,
    required this.pulseAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: logoAnimationController,
      child: AnimatedBuilder(
        animation: pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: pulseAnimation.value,
            child: LogoContainer(logoPath: 'assets/logo.png'),
          );
        },
      ),
    );
  }
}

class SecondaryLogo extends StatelessWidget {
  final AnimationController smknLogoController;
  final Animation<double> smknFadeAnimation;
  final Animation<double> pulseAnimation;

  const SecondaryLogo({
    Key? key,
    required this.smknLogoController,
    required this.smknFadeAnimation,
    required this.pulseAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: smknLogoController,
      child: FadeTransition(
        opacity: smknFadeAnimation,
        child: AnimatedBuilder(
          animation: pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: pulseAnimation.value,
              child: LogoContainer(logoPath: 'assets/smkn.png'),
            );
          },
        ),
      ),
    );
  }
}

class LogoContainer extends StatelessWidget {
  final String logoPath;
  static const _themeColor = Color(0xFF57B4BA);
  const LogoContainer({Key? key, required this.logoPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        border: Border.all(color: _themeColor.withOpacity(0.15), width: 2),
      ),
      child: SizedBox(
        height: 90,
        width: 90,
        child: Image.asset(logoPath, fit: BoxFit.contain),
      ),
    );
  }
}

class LogoSeparator extends StatelessWidget {
  static const _themeColor = Color(0xFF57B4BA);
  const LogoSeparator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SeparatorLine(
          colors: [_themeColor.withOpacity(0.3), _themeColor.withOpacity(0.7)],
        ),
        const SizedBox(height: 5),
        SeparatorDot(),
        const SizedBox(height: 5),
        SeparatorLine(
          colors: [_themeColor.withOpacity(0.7), _themeColor.withOpacity(0.3)],
        ),
      ],
    );
  }
}

class SeparatorLine extends StatelessWidget {
  final List<Color> colors;
  const SeparatorLine({Key? key, required this.colors}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 3,
      height: 25,
      margin: const EdgeInsets.symmetric(horizontal: 25),
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
}

class SeparatorDot extends StatelessWidget {
  static const _themeColor = Color(0xFF57B4BA);
  const SeparatorDot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}

class AppTitle extends StatelessWidget {
  final Animation<double> fadeInAnimation;
  final Animation<Offset> slideAnimation;

  const AppTitle({
    Key? key,
    required this.fadeInAnimation,
    required this.slideAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeInAnimation,
      child: SlideTransition(
        position: slideAnimation,
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
}

class AppSubtitle extends StatelessWidget {
  final Animation<double> fadeInAnimation;
  final Animation<Offset> slideAnimation;

  const AppSubtitle({
    Key? key,
    required this.fadeInAnimation,
    required this.slideAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeInAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: const Text(
          'Ruang Informasi Sekolah',
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  final AnimationController controller;
  static const _themeColor = Color(0xFF57B4BA);
  const LoadingIndicator({Key? key, required this.controller})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return SizedBox(
          width: 60,
          height: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              final delayedValue = (controller.value + index * 0.2) % 1.0;
              return LoadingDot(animationValue: delayedValue);
            }),
          ),
        );
      },
    );
  }
}

class LoadingDot extends StatelessWidget {
  final double animationValue;
  static const _themeColor = Color(0xFF57B4BA);
  const LoadingDot({Key? key, required this.animationValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          decoration: BoxDecoration(shape: BoxShape.circle, color: _themeColor),
        ),
      ),
    );
  }
}

class FooterText extends StatelessWidget {
  final Animation<double> fadeInAnimation;
  const FooterText({Key? key, required this.fadeInAnimation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: FadeTransition(
        opacity: fadeInAnimation,
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
}

class VersionText extends StatelessWidget {
  final Animation<double> fadeInAnimation;
  const VersionText({Key? key, required this.fadeInAnimation})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: FadeTransition(
        opacity: fadeInAnimation,
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
