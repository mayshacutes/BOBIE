import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme.dart';
import '../../models/modul.dart';
import '../../widgets/primary_button.dart';

class LevelCompleteScreen extends StatelessWidget {
  const LevelCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final moduls = args['moduls'] as List<Modul>;
    final modulId = args['modulId'] as String;
    final correctCount = args['correctCount'] as int;
    final totalQuestions = args['totalQuestions'] as int;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.lightOrange,
                  shape: BoxShape.circle,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Image.asset(
                    'assets/images/trophy.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Center(
                      child: Icon(Icons.emoji_events, size: 48, color: AppColors.orange),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'SELAMAT!',
                style: GoogleFonts.jua(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.orange,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Kamu sudah menyelesaikan level ini',
                style: GoogleFonts.jua(
                  fontSize: 16,
                  color: AppColors.darkGray,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.lightSkyBlue,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Skor: $correctCount/$totalQuestions',
                  style: GoogleFonts.jua(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
              const Spacer(flex: 1),
              PrimaryButton(
                text: 'Kembali',
                backgroundColor: AppColors.primaryBlue,
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/main',
                  (route) => false,
                  arguments: args['studentName'] ?? '',
                ),
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                text: 'Ulangi',
                backgroundColor: AppColors.orange,
                onPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    '/materi',
                    arguments: {'modulId': modulId, 'moduls': moduls, 'onModulUpdated': (_) {}},
                  );
                },
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                text: 'Lanjut',
                backgroundColor: AppColors.green,
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/main',
                    (route) => false,
                    arguments: args['studentName'] ?? '',
                  );
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
