import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/sign_in_screen.dart';
import 'screens/auth/sign_up_screen.dart';
import 'screens/modul/modul_list_screen.dart';
import 'screens/modul/modul_screen.dart';
import 'screens/modul/materi_screen.dart';
import 'screens/modul/kuis_screen.dart';
import 'screens/modul/level_complete_screen.dart';
import 'screens/leaderboard_screen.dart';
import 'screens/profile_screen.dart';
import 'widgets/bottom_nav_bar.dart';

void main() {
  runApp(const BobieApp());
}

class BobieApp extends StatelessWidget {
  const BobieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BOBIE',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return _buildPageRoute(const SplashScreen(), settings);
          case '/signin':
            return _buildPageRoute(const SignInScreen(), settings);
          case '/signup':
            return _buildPageRoute(const SignUpScreen(), settings);
          case '/main':
            final studentName = settings.arguments as String? ?? 'Siswa';
            return _buildPageRoute(
              _MainShell(studentName: studentName),
              settings,
            );
          case '/materi':
            return _buildPageRoute(const MateriScreen(), settings);
          case '/kuis':
            return _buildPageRoute(const KuisScreen(), settings);
          case '/level-complete':
            return _buildPageRoute(const LevelCompleteScreen(), settings);
          case '/leaderboard':
            return _buildPageRoute(const LeaderboardScreen(), settings);
          case '/profile':
            final name = settings.arguments as String? ?? 'Siswa';
            return _buildPageRoute(ProfileScreen(studentName: name), settings);
          default:
            return _buildPageRoute(const SplashScreen(), settings);
        }
      },
    );
  }

  PageRouteBuilder _buildPageRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}

class _MainShell extends StatefulWidget {
  final String studentName;

  const _MainShell({required this.studentName});

  @override
  State<_MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<_MainShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const ModulListScreen(),
      const ModulScreen(),
      const LeaderboardScreen(),
      ProfileScreen(studentName: widget.studentName),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
