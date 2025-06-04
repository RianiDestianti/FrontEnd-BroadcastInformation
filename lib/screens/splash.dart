import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import 'login.dart';
import '../constants/constant.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final SplashAnimations _animations;
  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _animations = SplashAnimations(_controllers);
    _startAnimationSequence();
    _scheduleNavigation();
  }

  void _initializeControllers() {
    _controllers = [
      AnimationController(duration: SplashConstants.animationDuration, vsync: this),
      AnimationController(duration: SplashConstants.animationDuration, vsync: this),
      AnimationController(duration: SplashConstants.rotationDuration, vsync: this)..repeat(),
      AnimationController(duration: SplashConstants.pulseDuration, vsync: this)..repeat(reverse: true),
      AnimationController(duration: SplashConstants.textAnimationDuration, vsync: this),
      AnimationController(duration: SplashConstants.loadingDuration, vsync: this)..repeat(),
    ];
  }

  void _startAnimationSequence() {
    _controllers[0].forward();
    Timer(SplashConstants.smknLogoDelay, () => _controllers[1].forward());
    Timer(SplashConstants.textAnimationDelay, () => _controllers[4].forward());
  }

  void _scheduleNavigation() {
    Timer(SplashConstants.navigationDelay, () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, _) => const SignInPage(),
          transitionsBuilder: (context, animation, _, child) {
            return FadeTransition(
              opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
              child: child,
            );
          },
          transitionDuration: SplashConstants.navigationTransitionDuration,
        ),
      );
    });
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _SplashBackground(
        child: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              _RotatingBackgroundLogo(controller: _controllers[2]),
              _SplashContent(animations: _animations),
              _FooterText(fadeAnimation: _animations.fadeIn),
              _VersionText(fadeAnimation: _animations.fadeIn),
            ],
          ),
        ),
      ),
    );
  }
}

class SplashAnimations {
  final List<AnimationController> controllers;
  late final Animation<double> pulse;
  late final Animation<double> fadeIn;
  late final Animation<Offset> slide;
  late final Animation<double> smknFade;

  SplashAnimations(this.controllers) {
    pulse = Tween<double>(begin: 0.95, end: 1.05).animate(controllers[3]);
    
    fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controllers[4], curve: Curves.easeIn),
    );
    
    slide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: controllers[4], curve: Curves.easeOut),
    );
    
    smknFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controllers[1], curve: Curves.easeIn),
    );
  }
}

class _SplashBackground extends StatelessWidget {
  final Widget child;
  const _SplashBackground({required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, SplashConstants.themeColor.withOpacity(0.15)],
        ),
      ),
      child: child,
    );
  }
}

class _RotatingBackgroundLogo extends StatelessWidget {
  final AnimationController controller;
  const _RotatingBackgroundLogo({required this.controller});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width * 1.5;
    return Center(
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) => Transform.translate(
          offset: const Offset(0, -80),
          child: Transform.rotate(
            angle: controller.value * 2 * math.pi,
            child: Opacity(
              opacity: 0.08,
              child: SizedBox(
                width: size,
                height: size,
                child: Image.asset('assets/logo.png', fit: BoxFit.contain),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SplashContent extends StatelessWidget {
  final SplashAnimations animations;
  const _SplashContent({required this.animations});
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
                _RotatingGradientCircle(controller: animations.controllers[2]),
                _RotatingDots(controller: animations.controllers[2]),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _LogosRow(animations: animations),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          _AnimatedText(
            text: 'EduInform',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              letterSpacing: 1.2,
            ),
            fadeAnimation: animations.fadeIn,
            slideAnimation: animations.slide,
          ),
          const SizedBox(height: 8),
          _AnimatedText(
            text: 'Ruang Informasi Sekolah',
            style: const TextStyle(fontSize: 18, color: Colors.black54),
            fadeAnimation: animations.fadeIn,
            slideAnimation: animations.slide,
          ),
          const SizedBox(height: 50),
          _LoadingIndicator(controller: animations.controllers[5]),
        ],
      ),
    );
  }
}

class _RotatingGradientCircle extends StatelessWidget {
  final AnimationController controller;
  const _RotatingGradientCircle({required this.controller});
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) => Transform.rotate(
        angle: -controller.value * 2 * math.pi,
        child: Container(
          width: 280,
          height: 280,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: SweepGradient(
              colors: [
                SplashConstants.themeColor.withOpacity(0.1),
                SplashConstants.themeColor.withOpacity(0.3),
                SplashConstants.themeColor.withOpacity(0.1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RotatingDots extends StatelessWidget {
  final AnimationController controller;
  const _RotatingDots({required this.controller});
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) => Transform.rotate(
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
                child: _Dot(),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: SplashConstants.themeColor.withOpacity(0.7),
      ),
    );
  }
}

class _LogosRow extends StatelessWidget {
  final SplashAnimations animations;
  const _LogosRow({required this.animations});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _AnimatedLogo(
          logoPath: 'assets/logo.png',
          scaleController: animations.controllers[0],
          pulseAnimation: animations.pulse,
        ),
        const _LogoSeparator(),
        _AnimatedLogo(
          logoPath: 'assets/smkn.png',
          scaleController: animations.controllers[1],
          pulseAnimation: animations.pulse,
          fadeAnimation: animations.smknFade,
        ),
      ],
    );
  }
}

class _AnimatedLogo extends StatelessWidget {
  final String logoPath;
  final AnimationController scaleController;
  final Animation<double> pulseAnimation;
  final Animation<double>? fadeAnimation;
  
  const _AnimatedLogo({
    required this.logoPath,
    required this.scaleController,
    required this.pulseAnimation,
    this.fadeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    Widget logo = ScaleTransition(
      scale: scaleController,
      child: AnimatedBuilder(
        animation: pulseAnimation,
        builder: (context, _) => Transform.scale(
          scale: pulseAnimation.value,
          child: _LogoContainer(logoPath: logoPath),
        ),
      ),
    );

    if (fadeAnimation != null) {
      logo = FadeTransition(opacity: fadeAnimation!, child: logo);
    }

    return logo;
  }
}

class _LogoContainer extends StatelessWidget {
  final String logoPath;
  const _LogoContainer({required this.logoPath});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: SplashConstants.themeColor.withOpacity(0.25),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
        border: Border.all(
          color: SplashConstants.themeColor.withOpacity(0.15), 
          width: 2,
        ),
      ),
      child: SizedBox(
        height: 90,
        width: 90,
        child: Image.asset(logoPath, fit: BoxFit.contain),
      ),
    );
  }
}

class _LogoSeparator extends StatelessWidget {
  const _LogoSeparator();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SeparatorLine(
          colors: [
            SplashConstants.themeColor.withOpacity(0.3),
            SplashConstants.themeColor.withOpacity(0.7),
          ],
        ),
        const SizedBox(height: 5),
        _SeparatorDot(),
        const SizedBox(height: 5),
        _SeparatorLine(
          colors: [
            SplashConstants.themeColor.withOpacity(0.7),
            SplashConstants.themeColor.withOpacity(0.3),
          ],
        ),
      ],
    );
  }
}

class _SeparatorLine extends StatelessWidget {
  final List<Color> colors;
  const _SeparatorLine({required this.colors});
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

class _SeparatorDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: SplashConstants.themeColor.withOpacity(0.9),
        boxShadow: [
          BoxShadow(
            color: SplashConstants.themeColor.withOpacity(0.3),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}

class _AnimatedText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
  
  const _AnimatedText({
    required this.text,
    required this.style,
    required this.fadeAnimation,
    required this.slideAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: Text(text, style: style),
      ),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  final AnimationController controller;
  const _LoadingIndicator({required this.controller});
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) => SizedBox(
        width: 60,
        height: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            final delayedValue = (controller.value + index * 0.2) % 1.0;
            return _LoadingDot(animationValue: delayedValue);
          }),
        ),
      ),
    );
  }
}

class _LoadingDot extends StatelessWidget {
  final double animationValue;
  const _LoadingDot({required this.animationValue});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: SplashConstants.themeColor.withOpacity(0.3 + animationValue * 0.7),
      ),
      child: Transform.scale(
        scale: 0.7 + animationValue * 0.5,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: SplashConstants.themeColor,
          ),
        ),
      ),
    );
  }
}

class _FooterText extends StatelessWidget {
  final Animation<double> fadeAnimation;
  const _FooterText({required this.fadeAnimation});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: FadeTransition(
        opacity: fadeAnimation,
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

class _VersionText extends StatelessWidget {
  final Animation<double> fadeAnimation;
  const _VersionText({required this.fadeAnimation});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: FadeTransition(
        opacity: fadeAnimation,
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