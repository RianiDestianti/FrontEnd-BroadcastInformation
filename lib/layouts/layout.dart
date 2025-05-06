import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:broadcastinformation/screens/calendar.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Premium Floating Nav',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
      routes: _buildAppRoutes(),
    );
  }
  
  Map<String, WidgetBuilder> _buildAppRoutes() {
    return {
      '/home': (context) => const HomePage(),
      '/save': (context) => const SaveScreen(),
      '/calendar': (context) => const CalendarPage(),
      '/profile': (context) => const ProfilePage(),
    };
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MainLayout(
      selectedIndex: 0,
      child: Center(child: Text('Home Page', style: TextStyle(fontSize: 24))),
    );
  }
}

class SaveScreen extends StatelessWidget {
  const SaveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MainLayout(
      selectedIndex: 1,
      child: Center(
        child: Text('Bookmarks Page', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

class CalendarPage extends StatelessWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MainLayout(selectedIndex: 2, child: _CalendarScreen());
  }
}

class _CalendarScreen extends StatelessWidget {
  const _CalendarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CalendarPage();
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MainLayout(
      selectedIndex: 3,
      child: Center(
        child: Text('Profile Page', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

class MainLayout extends StatefulWidget {
  final Widget child;
  final int selectedIndex;
  
  const MainLayout({
    Key? key, 
    required this.child, 
    this.selectedIndex = 0
  }) : super(key: key);
  
  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> with TickerProviderStateMixin {
  static const int _navItemCount = 4;
  static const Duration _floatAnimationDuration = Duration(milliseconds: 400);
  static const Duration _scaleAnimationDuration = Duration(milliseconds: 300);
  static const Duration _rotateAnimationDuration = Duration(milliseconds: 400);
  static const Duration _rippleAnimationDuration = Duration(milliseconds: 700);
  static const Duration _bgCircleAnimationDuration = Duration(milliseconds: 300);
  
  final Color _navBarColor = const Color(0xFF57B4BA);
  final Color _activeIconColor = const Color(0xFF45969B);
  final Color _inactiveIconColor = Colors.white;
  final Color _rippleColor = Colors.white;
  final Color _bgCircleColor = Colors.white;
  
  late int _selectedIndex;
  late List<bool> _isActive;
  
  late List<AnimationController> _floatControllers;
  late List<AnimationController> _scaleControllers;
  late List<AnimationController> _rotateControllers;
  late List<AnimationController> _rippleControllers;
  late List<AnimationController> _bgCircleControllers;
  
  late List<Animation<double>> _floatAnimations;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _rotateAnimations;
  late List<Animation<double>> _rippleAnimations;
  late List<Animation<double>> _opacityAnimations;
  late List<Animation<double>> _bgCircleAnimations;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
    _initializeControllers();
    _initializeAnimations();
    _isActive = List.generate(_navItemCount, (index) => false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _activateItem(_selectedIndex, initial: true);
    });
  }

  void _initializeControllers() {
    _floatControllers = _createControllers(_floatAnimationDuration);
    _scaleControllers = _createControllers(_scaleAnimationDuration);
    _rotateControllers = _createControllers(_rotateAnimationDuration);
    _rippleControllers = _createControllers(_rippleAnimationDuration);
    _bgCircleControllers = _createControllers(_bgCircleAnimationDuration);
  }

  List<AnimationController> _createControllers(Duration duration) {
    return List.generate(
      _navItemCount,
      (index) => AnimationController(
        duration: duration,
        vsync: this,
      ),
    );
  }

  void _initializeAnimations() {
    _floatAnimations = _floatControllers.map((controller) {
      return Tween<double>(begin: 0, end: -40).animate(
        CurvedAnimation(parent: controller, curve: Curves.elasticOut),
      );
    }).toList();
    
    _scaleAnimations = _scaleControllers.map((controller) {
      return Tween<double>(begin: 1.0, end: 1.2).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutBack),
      );
    }).toList();
    
    _rotateAnimations = _rotateControllers.map((controller) {
      return Tween<double>(begin: 0, end: 2 * math.pi).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOutCubic),
      );
    }).toList();
    
    _rippleAnimations = _rippleControllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 60.0,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
    }).toList();
    
    _opacityAnimations = _rippleControllers.map((controller) {
      return Tween<double>(
        begin: 0.3,
        end: 0.0,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
    }).toList();
    
    _bgCircleAnimations = _bgCircleControllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
    }).toList();
  }

  @override
  void dispose() {
    _disposeControllers(_floatControllers);
    _disposeControllers(_scaleControllers);
    _disposeControllers(_rotateControllers);
    _disposeControllers(_rippleControllers);
    _disposeControllers(_bgCircleControllers);
    super.dispose();
  }

  void _disposeControllers(List<AnimationController> controllers) {
    for (var controller in controllers) {
      controller.dispose();
    }
  }

  void _activateItem(int index, {bool initial = false}) {
    for (var i = 0; i < _navItemCount; i++) {
      if (i != index && _isActive[i]) {
        _deactivateItem(i);
      }
    }

    if (!_isActive[index]) {
      _activateSingleItem(index, initial);
    } else {
      _deactivateItem(index);
    }
  }

  void _activateSingleItem(int index, bool initial) {
    _floatControllers[index].forward();
    _scaleControllers[index].forward();
    _bgCircleControllers[index].forward();

    if (!initial) {
      _rotateControllers[index].reset();
      _rotateControllers[index].forward();

      _rippleControllers[index].reset();
      _rippleControllers[index].forward();
    }

    _isActive[index] = true;
  }

  void _deactivateItem(int index) {
    _floatControllers[index].reverse();
    _scaleControllers[index].reverse();
    _bgCircleControllers[index].reverse();
    _isActive[index] = false;
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });

      _activateItem(index);
      _navigateToPage(index);
    } else {
      _activateItem(index);
    }
  }

  void _navigateToPage(int index) {
    final String routeName = _getRouteNameByIndex(index);
    if (ModalRoute.of(context)?.settings.name != routeName) {
      Navigator.pushReplacementNamed(context, routeName);
    }
  }

  String _getRouteNameByIndex(int index) {
    switch (index) {
      case 0: return '/home';
      case 1: return '/save';
      case 2: return '/calendar';
      case 3: return '/profile';
      default: return '/home';
    }
  }

  IconData _getIconByIndex(int index, {bool isActive = false}) {
    if (isActive) {
      switch (index) {
        case 0: return Icons.home;
        case 1: return Icons.bookmark;
        case 2: return Icons.calendar_today;
        case 3: return Icons.person;
        default: return Icons.home;
      }
    } else {
      switch (index) {
        case 0: return Icons.home_outlined;
        case 1: return Icons.bookmark_border;
        case 2: return Icons.calendar_today_outlined;
        case 3: return Icons.person_outline;
        default: return Icons.home_outlined;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: widget.child),
      bottomNavigationBar: Container(
        height: 80,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            _buildNavBar(),
            _buildTransparentGaps(),
            _buildBackgroundCircles(),
            _buildRippleEffects(),
            _buildActiveIcons(),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBar() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: _navBarColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(_navItemCount, (index) {
          return AnimatedBuilder(
            animation: _floatAnimations[index],
            builder: (context, child) {
              if (_isActive[index]) {
                return const SizedBox(width: 60);
              }

              return InkWell(
                onTap: () => _onItemTapped(index),
                customBorder: const CircleBorder(),
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: Icon(
                    _getIconByIndex(index),
                    color: _inactiveIconColor,
                    size: 24,
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Widget _buildTransparentGaps() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(_navItemCount, (index) {
        return AnimatedBuilder(
          animation: _floatAnimations[index],
          builder: (context, child) {
            if (!_isActive[index]) {
              return const SizedBox(width: 50);
            }

            return CustomPaint(
              size: const Size(50, 15),
              painter: TransparentGapPainter(),
            );
          },
        );
      }),
    );
  }

  Widget _buildBackgroundCircles() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(_navItemCount, (index) {
        return AnimatedBuilder(
          animation: _bgCircleAnimations[index],
          builder: (context, child) {
            if (!_isActive[index]) {
              return const SizedBox(width: 70);
            }

            return Transform.translate(
              offset: Offset(0, _floatAnimations[index].value + 5),
              child: Opacity(
                opacity: _bgCircleAnimations[index].value * 0.3,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: _bgCircleColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildRippleEffects() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(_navItemCount, (index) {
        return AnimatedBuilder(
          animation: _rippleAnimations[index],
          builder: (context, child) {
            return Opacity(
              opacity: _opacityAnimations[index].value,
              child: Container(
                width: _rippleAnimations[index].value,
                height: _rippleAnimations[index].value,
                decoration: BoxDecoration(
                  color: _rippleColor.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildActiveIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(_navItemCount, (index) {
        return AnimatedBuilder(
          animation: Listenable.merge([
            _floatAnimations[index],
            _scaleAnimations[index],
            _rotateAnimations[index],
          ]),
          builder: (context, child) {
            if (!_isActive[index]) {
              return const SizedBox(width: 50);
            }

            return Transform.translate(
              offset: Offset(0, _floatAnimations[index].value),
              child: Transform.scale(
                scale: _scaleAnimations[index].value,
                child: Transform.rotate(
                  angle: _rotateAnimations[index].value,
                  child: GestureDetector(
                    onTap: () => _onItemTapped(index),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: _activeIconColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _activeIconColor.withOpacity(0.5),
                            blurRadius: 12,
                            spreadRadius: 2,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        gradient: RadialGradient(
                          colors: [
                            _activeIconColor.withOpacity(0.8),
                            _activeIconColor,
                          ],
                          center: const Alignment(0.1, 0.1),
                          focal: const Alignment(0, 0),
                          radius: 0.8,
                        ),
                      ),
                      child: Transform.rotate(
                        angle: -_rotateAnimations[index].value,
                        child: Icon(
                          _getIconByIndex(index, isActive: true),
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

class TransparentGapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {}
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}