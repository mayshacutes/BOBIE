import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme.dart';
import '../../models/modul.dart';
import '../../widgets/primary_button.dart';

class KuisScreen extends StatefulWidget {
  const KuisScreen({super.key});

  @override
  State<KuisScreen> createState() => _KuisScreenState();
}

class _KuisScreenState extends State<KuisScreen> {
  late List<Modul> _moduls;
  late Modul _modul;
  int _currentQuestion = 0;
  int? _selectedAnswer;
  bool _hasAnswered = false;
  int _correctCount = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    _moduls = (args['moduls'] as List<Modul>).map((m) => m.copyWith()).toList();
    final modulId = args['modulId'] as String;
    _modul = _moduls.firstWhere((m) => m.id == modulId);
  }

  void _selectAnswer(int index) {
    if (_hasAnswered) return;
    setState(() {
      _selectedAnswer = index;
      _hasAnswered = true;
      if (index == quiz.correctIndex) {
        _correctCount++;
      }
    });
  }

  void _next() {
    if (_currentQuestion < _modul.quizList.length - 1) {
      setState(() {
        _currentQuestion++;
        _selectedAnswer = null;
        _hasAnswered = false;
      });
    } else {
      _moduls = _moduls.map((m) {
        if (m.id == _modul.id) {
          return m.copyWith(isCompleted: true);
        }
        final idx = _moduls.indexOf(m);
        if (idx > 0 && _moduls[idx - 1].id == _modul.id) {
          return m.copyWith(isLocked: false);
        }
        return m;
      }).toList();

      Navigator.pushReplacementNamed(
        context,
        '/level-complete',
        arguments: {
          'moduls': _moduls,
          'modulId': _modul.id,
          'correctCount': _correctCount,
          'totalQuestions': _modul.quizList.length,
        },
      );
    }
  }

  Quiz get quiz => _modul.quizList[_currentQuestion];

  @override
  Widget build(BuildContext context) {
    final progress = _currentQuestion + 1;
    final total = _modul.quizList.length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Kuis',
          style: GoogleFonts.jua(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.darkBlue,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.darkBlue),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Soal $progress dari $total',
                style: GoogleFonts.jua(
                  fontSize: 15,
                  color: AppColors.darkGray,
                ),
              ),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: progress / total,
                backgroundColor: AppColors.lightGray,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.green),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.lightSkyBlue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                quiz.question,
                style: GoogleFonts.jua(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkBlue,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ...List.generate(quiz.options.length, (index) {
              final option = quiz.options[index];
              final isSelected = _selectedAnswer == index;
              final isCorrect = index == quiz.correctIndex;
              Color bgColor = AppColors.inputBg;
              Color textColor = AppColors.black;
              IconData? icon;

              if (_hasAnswered) {
                if (isCorrect) {
                  bgColor = AppColors.green.withValues(alpha: 0.15);
                  textColor = AppColors.darkGreen;
                  icon = Icons.check_circle;
                } else if (isSelected && !isCorrect) {
                  bgColor = AppColors.pink.withValues(alpha: 0.15);
                  textColor = AppColors.pink;
                  icon = Icons.cancel;
                }
              }

              return GestureDetector(
                onTap: () => _selectAnswer(index),
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected && _hasAnswered
                          ? (isCorrect ? AppColors.green : AppColors.pink)
                          : isSelected
                              ? AppColors.primaryBlue
                              : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          option,
                          style: GoogleFonts.jua(
                            fontSize: 15,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: textColor,
                          ),
                        ),
                      ),
                      if (icon != null)
                        Icon(icon, color: textColor, size: 24),
                    ],
                  ),
                ),
              );
            }),
            const Spacer(),
            if (_hasAnswered)
              PrimaryButton(
                text: _currentQuestion < _modul.quizList.length - 1
                    ? 'Soal Berikutnya'
                    : 'Lihat Hasil',
                onPressed: _next,
              ),
          ],
        ),
      ),
    );
  }
}
