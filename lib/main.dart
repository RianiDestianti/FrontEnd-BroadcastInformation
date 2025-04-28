import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'screens/home.dart';
import 'screens/profile.dart';
import 'screens/changepassword.dart';
import 'screens/save.dart'; // <- tambahkan import save.dart juga

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Color(0xFF57B4BA), // Tema utama sesuai dengan layout Anda
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
      home: const SignInPage(),
      // Pendefinisian routes
      routes: {
        '/home': (context) => const HomePage(),
        '/login': (context) => const SignInPage(),
        '/profile': (context) => const ProfilePage(),
        '/save':
            (context) => const SaveScreen(), // <- tambahkan route untuk save
        '/change-password': (context) => const ChangePasswordScreen(),
      },
    );
  }
}
