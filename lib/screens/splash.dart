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
    _controllers = _createControllers();
    _animations = SplashAnimations(_controllers);
    _startAnimations();
    _navigateAfterDelay();
  }

  List<AnimationController> _createControllers() => [
        AnimationController(duration: SplashConstants.animationDuration, vsync: this)..forward(),
        AnimationController(duration: SplashConstants.animationDuration, vsync: this),
        AnimationController(duration: SplashConstants.rotationDuration, vsync: this)..repeat(),
        AnimationController(duration: SplashConstants.pulseDuration, vsync: this)..repeat(reverse: true),
        AnimationController(duration: SplashConstants.textAnimationDuration, vsync: this),
        AnimationController(duration: SplashConstants.loadingDuration, vsync: this)..repeat(),
      ];

  void _startAnimations() {
    Timer(SplashConstants.smknLogoDelay, () => _controllers[1].forward());
    Timer(SplashConstants.textAnimationDelay, () => _controllers[4].forward());
  }

  void _navigateAfterDelay() {
    Timer(SplashConstants.navigationDelay, () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const SignInPage(),
          transitionsBuilder: (_, animation, __, child) => FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
            child: child,
          ),
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
      body: SplashBackground(
        child: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              RotatingBackgroundLogo(controller: _controllers[2]),
              SplashContent(animations: _animations),
              FooterText(fadeAnimation: _animations.fadeIn),
              VersionText(fadeAnimation: _animations.fadeIn),
            ],
          ),
        ),
      ),
    );
  }
}

class SplashAnimations {
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

  final List<AnimationController> controllers;
  late final Animation<double> pulse;
  late final Animation<double> fadeIn;
  late final Animation<Offset> slide;
  late final Animation<double> smknFade;
}

class SplashBackground extends StatelessWidget {
  const SplashBackground({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, SplashStyles.themeColor.withOpacity(0.15)],
        ),
      ),
      child: child,
    );
  }
}

class RotatingBackgroundLogo extends StatelessWidget {
  const RotatingBackgroundLogo({super.key, required this.controller});
  final AnimationController controller;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context).width * SplashStyles.backgroundLogoSizeFactor;
    return Center(
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, __) => Transform.translate(
          offset: const Offset(0, -80),
          child: Transform.rotate(
            angle: controller.value * 2 * math.pi,
            child: Opacity(
              opacity: SplashStyles.backgroundLogoOpacity,
              child: SizedBox.square(
                dimension: size,
                child: Image.asset('assets/logo.png', fit: BoxFit.contain),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SplashContent extends StatelessWidget {
  const SplashContent({super.key, required this.animations});
  final SplashAnimations animations;
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
                RotatingGradientCircle(controller: animations.controllers[2]),
                RotatingDots(controller: animations.controllers[2]),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: LogosRow(animations: animations),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          AnimatedText(
            text: 'EduInform',
            style: SplashStyles.titleStyle,
            fadeAnimation: animations.fadeIn,
            slideAnimation: animations.slide,
          ),
          const SizedBox(height: 8),
          AnimatedText(
            text: 'Ruang Informasi Sekolah',
            style: SplashStyles.subtitleStyle,
            fadeAnimation: animations.fadeIn,
            slideAnimation: animations.slide,
          ),
          const SizedBox(height: 50),
          LoadingIndicator(controller: animations.controllers[5]),
        ],
      ),
    );
  }
}

class RotatingGradientCircle extends StatelessWidget {
  const RotatingGradientCircle({super.key, required this.controller});
  final AnimationController controller;
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) => Transform.rotate(
        angle: -controller.value * 2 * math.pi,
        child: Container(
          width: SplashStyles.circleSize,
          height: SplashStyles.circleSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: SweepGradient(
              colors: [
                SplashStyles.themeColor.withOpacity(0.1),
                SplashStyles.themeColor.withOpacity(0.3),
                SplashStyles.themeColor.withOpacity(0.1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RotatingDots extends StatelessWidget {
  const RotatingDots({super.key, required this.controller});
  final AnimationController controller;
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) => Transform.rotate(
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
                child: const Dot(),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class Dot extends StatelessWidget {
  const Dot({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: SplashStyles.dotSize,
      height: SplashStyles.dotSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: SplashStyles.themeColor.withOpacity(0.7),
      ),
    );
  }
}

class LogosRow extends StatelessWidget {
  const LogosRow({super.key, required this.animations});
  final SplashAnimations animations;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedLogo(
          logoPath: 'assets/logo.png',
          scaleController: animations.controllers[0],
          pulseAnimation: animations.pulse,
        ),
        const LogoSeparator(),
        AnimatedLogo(
          logoPath: 'assets/smkn.png',
          scaleController: animations.controllers[1],
          pulseAnimation: animations.pulse,
          fadeAnimation: animations.smknFade,
        ),
      ],
    );
  }
}

class AnimatedLogo extends StatelessWidget {
  const AnimatedLogo({
    super.key,
    required this.logoPath,
    required this.scaleController,
    required this.pulseAnimation,
    this.fadeAnimation,
  });

  final String logoPath;
  final AnimationController scaleController;
  final Animation<double> pulseAnimation;
  final Animation<double>? fadeAnimation;

  @override
  Widget build(BuildContext context) {
    Widget logo = ScaleTransition(
      scale: scaleController,
      child: AnimatedBuilder(
        animation: pulseAnimation,
        builder: (_, __) => Transform.scale(
          scale: pulseAnimation.value,
          child: LogoContainer(logoPath: logoPath),
        ),
      ),
    );

    return fadeAnimation != null ? FadeTransition(opacity: fadeAnimation!, child: logo) : logo;
  }
}

class LogoContainer extends StatelessWidget {
  const LogoContainer({super.key, required this.logoPath});
  final String logoPath;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: SplashStyles.themeColor.withOpacity(SplashStyles.shadowOpacity),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
        border: Border.all(
          color: SplashStyles.themeColor.withOpacity(SplashStyles.borderOpacity),
          width: 2,
        ),
      ),
      child: SizedBox.square(
        dimension: SplashStyles.logoSize,
        child: Image.asset(logoPath, fit: BoxFit.contain),
      ),
    );
  }
}

class LogoSeparator extends StatelessWidget {
  const LogoSeparator({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SeparatorLine(
          colors: [SplashStyles.themeColor.withOpacity(0.3), SplashStyles.themeColor.withOpacity(0.7)],
        ),
        const SizedBox(height: 5),
        const SeparatorDot(),
        const SizedBox(height: 5),
        SeparatorLine(
          colors: [SplashStyles.themeColor.withOpacity(0.7), SplashStyles.themeColor.withOpacity(0.3)],
        ),
      ],
    );
  }
}

class SeparatorLine extends StatelessWidget {
  const SeparatorLine({super.key, required this.colors});
  final List<Color> colors;
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
  const SeparatorDot({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: SplashStyles.themeColor.withOpacity(0.9),
        boxShadow: [
          BoxShadow(
            color: SplashStyles.themeColor.withOpacity(0.3),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}

class AnimatedText extends StatelessWidget {
  const AnimatedText({
    super.key,
    required this.text,
    required this.style,
    required this.fadeAnimation,
    required this.slideAnimation,
  });

  final String text;
  final TextStyle style;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;

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

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key, required this.controller});
  final AnimationController controller;
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) => SizedBox(
        width: 60,
        height: SplashStyles.loadingDotSize,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            final delayedValue = (controller.value + index * 0.2) % 1.0;
            return LoadingDot(animationValue: delayedValue);
          }),
        ),
      ),
    );
  }
}

class LoadingDot extends StatelessWidget {
  const LoadingDot({super.key, required this.animationValue});
  final double animationValue;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: SplashStyles.loadingDotSize,
      height: SplashStyles.loadingDotSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: SplashStyles.themeColor.withOpacity(0.3 + animationValue * 0.7),
      ),
      child: Transform.scale(
        scale: 0.7 + animationValue * 0.5,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: SplashStyles.themeColor,
          ),
        ),
      ),
    );
  }
}

class FooterText extends StatelessWidget {
  const FooterText({super.key, required this.fadeAnimation});
  final Animation<double> fadeAnimation;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: const Center(
          child: Text('SMK Negeri 11 Bandung', style: SplashStyles.footerStyle),
        ),
      ),
    );
  }
}

class VersionText extends StatelessWidget {
  const VersionText({super.key, required this.fadeAnimation});
  final Animation<double> fadeAnimation;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: const Center(
          child: Text('Version 1.0.0', style: SplashStyles.versionStyle),
        ),
      ),
    );
  }
}