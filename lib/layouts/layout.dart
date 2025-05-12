import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:broadcastinformation/screens/calendar.dart';

void main() {
  runApp(MyApp());
}

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

// ------------------- Screen Pages -------------------

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
    return const MainLayout(selectedIndex: 2, child: CalendarContent());
  }
}

class CalendarContent extends StatelessWidget {
  const CalendarContent({Key? key}) : super(key: key);

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

// ------------------- Main Layout -------------------

class MainLayout extends StatefulWidget {
  final Widget child;
  final int selectedIndex;

  const MainLayout({Key? key, required this.child, this.selectedIndex = 0})
    : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> with TickerProviderStateMixin {
  late int _selectedIndex;
  late List<bool> _isActive;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
    _initializeControllers();
    _initializeAnimations();
    _isActive = List.generate(NavigationConfig.navItemCount, (index) => false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _activateItem(_selectedIndex, initial: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: widget.child),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        isActive: _isActive,
        floatAnimations: _floatAnimations,
        scaleAnimations: _scaleAnimations,
        rotateAnimations: _rotateAnimations,
        rippleAnimations: _rippleAnimations,
        opacityAnimations: _opacityAnimations,
        bgCircleAnimations: _bgCircleAnimations,
        onItemTapped: _onItemTapped,
      ),
    );
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

  // ------------------- Animation Controllers -------------------

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

  void _initializeControllers() {
    _floatControllers = _createControllers(
      NavigationConfig.floatAnimationDuration,
    );
    _scaleControllers = _createControllers(
      NavigationConfig.scaleAnimationDuration,
    );
    _rotateControllers = _createControllers(
      NavigationConfig.rotateAnimationDuration,
    );
    _rippleControllers = _createControllers(
      NavigationConfig.rippleAnimationDuration,
    );
    _bgCircleControllers = _createControllers(
      NavigationConfig.bgCircleAnimationDuration,
    );
  }

  List<AnimationController> _createControllers(Duration duration) {
    return List.generate(
      NavigationConfig.navItemCount,
      (index) => AnimationController(duration: duration, vsync: this),
    );
  }

  void _initializeAnimations() {
    _floatAnimations =
        _floatControllers.map((controller) {
          return Tween<double>(begin: 0, end: -40).animate(
            CurvedAnimation(parent: controller, curve: Curves.elasticOut),
          );
        }).toList();

    _scaleAnimations =
        _scaleControllers.map((controller) {
          return Tween<double>(begin: 1.0, end: 1.2).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeOutBack),
          );
        }).toList();

    _rotateAnimations =
        _rotateControllers.map((controller) {
          return Tween<double>(begin: 0, end: 2 * math.pi).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeInOutCubic),
          );
        }).toList();

    _rippleAnimations =
        _rippleControllers.map((controller) {
          return Tween<double>(
            begin: 0.0,
            end: 60.0,
          ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
        }).toList();

    _opacityAnimations =
        _rippleControllers.map((controller) {
          return Tween<double>(
            begin: 0.3,
            end: 0.0,
          ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
        }).toList();

    _bgCircleAnimations =
        _bgCircleControllers.map((controller) {
          return Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
        }).toList();
  }

  void _disposeControllers(List<AnimationController> controllers) {
    for (var controller in controllers) {
      controller.dispose();
    }
  }

  // ------------------- Navigation Methods -------------------

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

  void _activateItem(int index, {bool initial = false}) {
    for (var i = 0; i < NavigationConfig.navItemCount; i++) {
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

  void _navigateToPage(int index) {
    final String routeName = NavigationConfig.getRouteNameByIndex(index);
    if (ModalRoute.of(context)?.settings.name != routeName) {
      Navigator.pushReplacementNamed(context, routeName);
    }
  }
}

// ------------------- Navigation Bar Widget -------------------

class NavigationBar extends StatelessWidget {
  final int selectedIndex;
  final List<bool> isActive;
  final List<Animation<double>> floatAnimations;
  final List<Animation<double>> scaleAnimations;
  final List<Animation<double>> rotateAnimations;
  final List<Animation<double>> rippleAnimations;
  final List<Animation<double>> opacityAnimations;
  final List<Animation<double>> bgCircleAnimations;
  final Function(int) onItemTapped;

  const NavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.isActive,
    required this.floatAnimations,
    required this.scaleAnimations,
    required this.rotateAnimations,
    required this.rippleAnimations,
    required this.opacityAnimations,
    required this.bgCircleAnimations,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }

  Widget _buildNavBar() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: NavigationConfig.navBarColor,
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
        children: List.generate(NavigationConfig.navItemCount, (index) {
          return AnimatedBuilder(
            animation: floatAnimations[index],
            builder: (context, child) {
              if (isActive[index]) {
                return const SizedBox(width: 60);
              }

              return InkWell(
                onTap: () => onItemTapped(index),
                customBorder: const CircleBorder(),
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: Icon(
                    NavigationConfig.getIconByIndex(index),
                    color: NavigationConfig.inactiveIconColor,
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
      children: List.generate(NavigationConfig.navItemCount, (index) {
        return AnimatedBuilder(
          animation: floatAnimations[index],
          builder: (context, child) {
            if (!isActive[index]) {
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
      children: List.generate(NavigationConfig.navItemCount, (index) {
        return AnimatedBuilder(
          animation: bgCircleAnimations[index],
          builder: (context, child) {
            if (!isActive[index]) {
              return const SizedBox(width: 70);
            }

            return Transform.translate(
              offset: Offset(0, floatAnimations[index].value + 5),
              child: Opacity(
                opacity: bgCircleAnimations[index].value * 0.3,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: NavigationConfig.bgCircleColor,
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
      children: List.generate(NavigationConfig.navItemCount, (index) {
        return AnimatedBuilder(
          animation: rippleAnimations[index],
          builder: (context, child) {
            return Opacity(
              opacity: opacityAnimations[index].value,
              child: Container(
                width: rippleAnimations[index].value,
                height: rippleAnimations[index].value,
                decoration: BoxDecoration(
                  color: NavigationConfig.rippleColor.withOpacity(0.3),
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
      children: List.generate(NavigationConfig.navItemCount, (index) {
        return AnimatedBuilder(
          animation: Listenable.merge([
            floatAnimations[index],
            scaleAnimations[index],
            rotateAnimations[index],
          ]),
          builder: (context, child) {
            if (!isActive[index]) {
              return const SizedBox(width: 50);
            }

            return Transform.translate(
              offset: Offset(0, floatAnimations[index].value),
              child: Transform.scale(
                scale: scaleAnimations[index].value,
                child: Transform.rotate(
                  angle: rotateAnimations[index].value,
                  child: GestureDetector(
                    onTap: () => onItemTapped(index),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: NavigationConfig.activeIconColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: NavigationConfig.activeIconColor.withOpacity(
                              0.5,
                            ),
                            blurRadius: 12,
                            spreadRadius: 2,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        gradient: RadialGradient(
                          colors: [
                            NavigationConfig.activeIconColor.withOpacity(0.8),
                            NavigationConfig.activeIconColor,
                          ],
                          center: const Alignment(0.1, 0.1),
                          focal: const Alignment(0, 0),
                          radius: 0.8,
                        ),
                      ),
                      child: Transform.rotate(
                        angle: -rotateAnimations[index].value,
                        child: Icon(
                          NavigationConfig.getIconByIndex(
                            index,
                            isActive: true,
                          ),
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

// ------------------- Custom Painter -------------------

class TransparentGapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ------------------- Navigation Configuration -------------------

class NavigationConfig {
  static const int navItemCount = 4;
  static const Duration floatAnimationDuration = Duration(milliseconds: 400);
  static const Duration scaleAnimationDuration = Duration(milliseconds: 300);
  static const Duration rotateAnimationDuration = Duration(milliseconds: 400);
  static const Duration rippleAnimationDuration = Duration(milliseconds: 700);
  static const Duration bgCircleAnimationDuration = Duration(milliseconds: 300);

  static final Color navBarColor = const Color(0xFF57B4BA);
  static final Color activeIconColor = const Color(0xFF45969B);
  static final Color inactiveIconColor = Colors.white;
  static final Color rippleColor = Colors.white;
  static final Color bgCircleColor = Colors.white;

  static String getRouteNameByIndex(int index) {
    switch (index) {
      case 0:
        return '/home';
      case 1:
        return '/save';
      case 2:
        return '/calendar';
      case 3:
        return '/profile';
      default:
        return '/home';
    }
  }

  static IconData getIconByIndex(int index, {bool isActive = false}) {
    if (isActive) {
      switch (index) {
        case 0:
          return Icons.home;
        case 1:
          return Icons.bookmark;
        case 2:
          return Icons.calendar_today;
        case 3:
          return Icons.person;
        default:
          return Icons.home;
      }
    } else {
      switch (index) {
        case 0:
          return Icons.home_outlined;
        case 1:
          return Icons.bookmark_border;
        case 2:
          return Icons.calendar_today_outlined;
        case 3:
          return Icons.person_outline;
        default:
          return Icons.home_outlined;
      }
    }
  }
}
