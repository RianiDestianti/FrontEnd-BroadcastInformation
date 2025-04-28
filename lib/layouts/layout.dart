import 'package:flutter/material.dart';
import 'dart:math' as math;

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
      home: HomePage(),
      routes: {
        '/home': (context) => HomePage(),
        '/save': (context) => SaveScreen(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}

// Example pages
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainLayout(
      selectedIndex: 0,
      child: Center(child: Text('Home Page', style: TextStyle(fontSize: 24))),
    );
  }
}

class SaveScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainLayout(
      selectedIndex: 1,
      child: Center(
        child: Text('Bookmarks Page', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainLayout(
      selectedIndex: 2,
      child: Center(
        child: Text('Profile Page', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

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

  // Animation controllers for different effects
  late List<AnimationController> _floatControllers;
  late List<Animation<double>> _floatAnimations;

  late List<AnimationController> _scaleControllers;
  late List<Animation<double>> _scaleAnimations;

  late List<AnimationController> _rotateControllers;
  late List<Animation<double>> _rotateAnimations;

  late List<AnimationController> _rippleControllers;
  late List<Animation<double>> _rippleAnimations;
  late List<Animation<double>> _opacityAnimations;

  // White circle background animation
  late List<AnimationController> _bgCircleControllers;
  late List<Animation<double>> _bgCircleAnimations;

  // Track states
  late List<bool> _isActive;

  // Colors
  final Color _navBarColor = Color(0xFF57B4BA);
  final Color _activeIconColor = Color(0xFF45969B);
  final Color _inactiveIconColor = Colors.white;
  final Color _rippleColor = Colors.white;
  final Color _bgCircleColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;

    // Initialize animation controllers
    _floatControllers = List.generate(
      3,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: this,
      ),
    );

    _scaleControllers = List.generate(
      3,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      ),
    );

    _rotateControllers = List.generate(
      3,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: this,
      ),
    );

    _rippleControllers = List.generate(
      3,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 700),
        vsync: this,
      ),
    );

    _bgCircleControllers = List.generate(
      3,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      ),
    );

    // Create animations
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

    _isActive = List.generate(3, (index) => false);

    // Activate initially selected item
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _activateItem(_selectedIndex, initial: true);
    });
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (var controller in _floatControllers) {
      controller.dispose();
    }
    for (var controller in _scaleControllers) {
      controller.dispose();
    }
    for (var controller in _rotateControllers) {
      controller.dispose();
    }
    for (var controller in _rippleControllers) {
      controller.dispose();
    }
    for (var controller in _bgCircleControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _activateItem(int index, {bool initial = false}) {
    // Stop and reverse any active animations
    for (var i = 0; i < 3; i++) {
      if (i != index && _isActive[i]) {
        _floatControllers[i].reverse();
        _scaleControllers[i].reverse();
        _bgCircleControllers[i].reverse();
        _isActive[i] = false;
      }
    }

    // Start new animations for tapped item
    if (!_isActive[index]) {
      _floatControllers[index].forward();
      _scaleControllers[index].forward();
      _bgCircleControllers[index].forward();

      if (!initial) {
        // Only play these animations when explicitly tapped, not on initial load
        _rotateControllers[index].reset();
        _rotateControllers[index].forward();

        _rippleControllers[index].reset();
        _rippleControllers[index].forward();
      }

      _isActive[index] = true;
    } else {
      _floatControllers[index].reverse();
      _scaleControllers[index].reverse();
      _bgCircleControllers[index].reverse();
      _isActive[index] = false;
    }
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });

      _activateItem(index);

      // Navigation logic
      switch (index) {
        case 0:
          if (ModalRoute.of(context)?.settings.name != '/home') {
            Navigator.pushReplacementNamed(context, '/home');
          }
          break;
        case 1:
          if (ModalRoute.of(context)?.settings.name != '/save') {
            Navigator.pushReplacementNamed(context, '/save');
          }
          break;
        case 2:
          if (ModalRoute.of(context)?.settings.name != '/profile') {
            Navigator.pushReplacementNamed(context, '/profile');
          }
          break;
      }
    } else {
      // Toggle state
      _activateItem(index);
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
            // Base navigation bar
            Container(
              height: 70,
              decoration: BoxDecoration(
                color: _navBarColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(3, (index) {
                  // Display the icon in the navbar when not active
                  return AnimatedBuilder(
                    animation: _floatAnimations[index],
                    builder: (context, child) {
                      // Only show icon in navbar when not floating
                      if (_isActive[index]) {
                        return SizedBox(width: 60);
                      }

                      // Icon to display
                      IconData iconData;
                      switch (index) {
                        case 0:
                          iconData = Icons.home_outlined;
                          break;
                        case 1:
                          iconData = Icons.bookmark_border;
                          break;
                        case 2:
                          iconData = Icons.person_outline;
                          break;
                        default:
                          iconData = Icons.home_outlined;
                      }

                      return InkWell(
                        onTap: () => _onItemTapped(index),
                        customBorder: CircleBorder(),
                        child: Container(
                          width: 60,
                          height: 60,
                          child: Icon(
                            iconData,
                            color: _inactiveIconColor,
                            size: 24,
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),

            // Transparent dividers (gap) between icons and navbar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(3, (index) {
                return AnimatedBuilder(
                  animation: _floatAnimations[index],
                  builder: (context, child) {
                    if (!_isActive[index]) {
                      return SizedBox(width: 50);
                    }

                    return CustomPaint(
                      size: Size(50, 15),
                      painter: TransparentGapPainter(),
                    );
                  },
                );
              }),
            ),

            // White circular backgrounds
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(3, (index) {
                return AnimatedBuilder(
                  animation: _bgCircleAnimations[index],
                  builder: (context, child) {
                    if (!_isActive[index]) {
                      return SizedBox(width: 70);
                    }

                    return Transform.translate(
                      offset: Offset(
                        0,
                        _floatAnimations[index].value + 5,
                      ), // Position it slightly below the button
                      child: Opacity(
                        opacity:
                            _bgCircleAnimations[index].value *
                            0.3, // Make it semi-transparent
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
            ),

            // Ripple effects
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(3, (index) {
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
            ),

            // Floating buttons with animations
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(3, (index) {
                // Define active icon based on index
                IconData activeIconData;
                switch (index) {
                  case 0:
                    activeIconData = Icons.home;
                    break;
                  case 1:
                    activeIconData = Icons.bookmark;
                    break;
                  case 2:
                    activeIconData = Icons.person;
                    break;
                  default:
                    activeIconData = Icons.home;
                }

                return AnimatedBuilder(
                  animation: Listenable.merge([
                    _floatAnimations[index],
                    _scaleAnimations[index],
                    _rotateAnimations[index],
                  ]),
                  builder: (context, child) {
                    // Only show when active
                    if (!_isActive[index]) {
                      return SizedBox(width: 50);
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
                                    offset: Offset(0, 2),
                                  ),
                                ],
                                gradient: RadialGradient(
                                  colors: [
                                    _activeIconColor.withOpacity(0.8),
                                    _activeIconColor,
                                  ],
                                  center: Alignment(0.1, 0.1),
                                  focal: Alignment(0, 0),
                                  radius: 0.8,
                                ),
                              ),
                              child: Transform.rotate(
                                // Counter-rotate the icon to keep it upright
                                angle: -_rotateAnimations[index].value,
                                child: Icon(
                                  activeIconData,
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
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for transparent gap
class TransparentGapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // No painting for transparency
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
