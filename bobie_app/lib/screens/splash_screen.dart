import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/signin');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
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
            const SizedBox(height: 8),
            Text(
              'Pembelajaran Seksualitas Ramah Anak',
              style: GoogleFonts.jua(
                fontSize: 14,
                color: AppColors.darkGray,
              ),
            ),
          ],
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
