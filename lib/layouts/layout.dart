import 'package:flutter/material.dart';
import 'package:broadcastinformation/screens/kalender.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Navigation',
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

class _MainLayoutState extends State<MainLayout> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: widget.child),
      bottomNavigationBar: SimpleNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      _navigateToPage(index);
    }
  }

  void _navigateToPage(int index) {
    final String routeName = NavigationConfig.getRouteNameByIndex(index);
    if (ModalRoute.of(context)?.settings.name != routeName) {
      Navigator.pushReplacementNamed(context, routeName);
    }
  }
}

// ------------------- Simple Navigation Bar -------------------

class SimpleNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const SimpleNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          final bool isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () => onItemTapped(index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? NavigationConfig.activeBackgroundColor
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    NavigationConfig.getIconByIndex(
                      index,
                      isActive: isSelected,
                    ),
                    color:
                        isSelected
                            ? NavigationConfig.activeIconColor
                            : NavigationConfig.inactiveIconColor,
                    size: 24,
                  ),
                  if (isSelected) ...[
                    const SizedBox(width: 8),
                    Text(
                      NavigationConfig.getLabelByIndex(index),
                      style: TextStyle(
                        color: NavigationConfig.activeIconColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ------------------- Navigation Configuration -------------------

class NavigationConfig {
  static const int navItemCount = 4;

  static final Color navBarColor = const Color(0xFF57B4BA);
  static final Color activeIconColor = Colors.white;
  static final Color inactiveIconColor = Colors.white.withOpacity(0.6);
  static final Color activeBackgroundColor = Colors.white.withOpacity(0.2);

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

  static String getLabelByIndex(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'Saved';
      case 2:
        return 'Calendar';
      case 3:
        return 'Profile';
      default:
        return 'Home';
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
