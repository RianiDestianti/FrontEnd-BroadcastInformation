import 'package:flutter/material.dart';
import '../models/model.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MainLayout(selectedIndex: 0, child: HomeContent());
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.home, size: 80, color: Color(0xFF57B4BA)),
          SizedBox(height: 16),
          Text(
            'Home Page',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Welcome to your dashboard',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class CalendarPage extends StatelessWidget {
  const CalendarPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MainLayout(selectedIndex: 1, child: CalendarContent());
  }
}

class CalendarContent extends StatefulWidget {
  const CalendarContent({Key? key}) : super(key: key);
  @override
  State<CalendarContent> createState() => _CalendarContentState();
}

class _CalendarContentState extends State<CalendarContent> {
  DateTime _selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Calendar',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Date:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  CalendarDatePicker(
                    initialDate: _selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                    onDateChanged: (DateTime date) {
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Selected: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF57B4BA),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MainLayout(selectedIndex: 2, child: ProfileContent());
  }
}

class ProfileContent extends StatelessWidget {
  const ProfileContent({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          SizedBox(height: 40),
          CircleAvatar(
            radius: 60,
            backgroundColor: Color(0xFF57B4BA),
            child: Icon(Icons.person, size: 60, color: Colors.white),
          ),
          SizedBox(height: 20),
          Text(
            'Profile Page',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Manage your account settings',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(height: 32),
          ProfileMenuItem(icon: Icons.settings, title: 'Settings'),
          ProfileMenuItem(icon: Icons.help, title: 'Help & Support'),
          ProfileMenuItem(icon: Icons.info, title: 'About'),
        ],
      ),
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  const ProfileMenuItem({Key? key, required this.icon, required this.title})
    : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF57B4BA)),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('$title tapped')));
        },
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
  void didUpdateWidget(MainLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _selectedIndex = widget.selectedIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: widget.child),
      floatingActionButton: null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(40, 0, 40, 20),
        child: FloatingNavigationBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    final String routeName = NavigationConfig.getRouteNameByIndex(index);
    final String? currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute != routeName) {
      Navigator.pushReplacementNamed(context, routeName);
    }
  }
}

// ------------------- Floating Navigation Bar -------------------

class FloatingNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  const FloatingNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: NavigationConfig.navBarColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 15,
            offset: const Offset(0, 6),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: NavigationConfig.navBarColor.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 3),
            spreadRadius: -3,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          NavigationConfig.items.length,
          (index) => _buildNavItem(index),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final bool isSelected = selectedIndex == index;
    final NavigationItem item = NavigationConfig.items[index];
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
            AnimatedScale(
              scale: isSelected ? 1.05 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isSelected ? item.activeIcon : item.inactiveIcon,
                color:
                    isSelected
                        ? NavigationConfig.activeIconColor
                        : NavigationConfig.inactiveIconColor,
                size: 22,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 4),
              AnimatedOpacity(
                opacity: isSelected ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Text(
                  item.label,
                  style: TextStyle(
                    color: NavigationConfig.activeIconColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ------------------- Navigation Configuration -------------------

class NavigationConfig {
  static const Color navBarColor = Color(0xFF57B4BA);
  static const Color activeIconColor = Colors.white;
  static final Color inactiveIconColor = Colors.white.withOpacity(0.7);
  static final Color activeBackgroundColor = Colors.white.withOpacity(0.25);

  static const List<NavigationItem> items = [
    NavigationItem(
      label: 'Home',
      activeIcon: Icons.home,
      inactiveIcon: Icons.home_outlined,
    ),
    NavigationItem(
      label: 'Calendar',
      activeIcon: Icons.calendar_today,
      inactiveIcon: Icons.calendar_today_outlined,
    ),
    NavigationItem(
      label: 'Profile',
      activeIcon: Icons.person,
      inactiveIcon: Icons.person_outline,
    ),
  ];

  static Map<String, WidgetBuilder> get routes => {
    '/home': (context) => const HomePage(),
    '/calendar': (context) => const CalendarPage(),
    '/profile': (context) => const ProfilePage(),
  };

  static String getRouteNameByIndex(int index) {
    const routes = ['/home', '/calendar', '/profile'];
    return index < routes.length ? routes[index] : '/home';
  }
}
