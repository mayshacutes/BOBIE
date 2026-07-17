import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    _fadeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 60),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 20),
    ]).animate(_controller);
    _controller.forward();

    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/signin');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo_bobie.png',
                width: 200,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _Letter('B', AppColors.logoPurple),
                    _Letter('O', AppColors.logoBlue),
                    _Letter('B', AppColors.logoPink),
                    _Letter('i', AppColors.logoYellow),
                    _Letter('e', AppColors.logoPurple),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Letter extends StatelessWidget {
  final String letter;
  final Color color;

  const _Letter(this.letter, this.color);

  @override
  Widget build(BuildContext context) {
    return Text(
      letter,
      style: GoogleFonts.jua(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }
}
