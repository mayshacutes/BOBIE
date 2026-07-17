import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme.dart';
import '../../models/modul.dart';
import '../../widgets/primary_button.dart';

class MateriScreen extends StatefulWidget {
  const MateriScreen({super.key});

  @override
  State<MateriScreen> createState() => _MateriScreenState();
}

class _MateriScreenState extends State<MateriScreen> {
  late List<Modul> _moduls;
  late Modul _modul;
  int _currentPage = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    _moduls = (args['moduls'] as List<Modul>).map((m) => m.copyWith()).toList();
    final modulId = args['modulId'] as String;
    _modul = _moduls.firstWhere((m) => m.id == modulId);
  }

  void _next() {
    if (_currentPage < _modul.materiList.length - 1) {
      setState(() => _currentPage++);
    } else {
      Navigator.pushReplacementNamed(
        context,
        '/kuis',
        arguments: {'moduls': _moduls, 'modulId': _modul.id},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final materi = _modul.materiList[_currentPage];
    final isLast = _currentPage == _modul.materiList.length - 1;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          _modul.title,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.lightSkyBlue,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    materi.imageAsset.isNotEmpty
                        ? materi.imageAsset
                        : 'assets/images/island_1.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Center(
                      child: Icon(Icons.image, size: 48, color: AppColors.gray),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: List.generate(
                _modul.materiList.length,
                (i) => Expanded(
                  child: Container(
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: i == _currentPage
                          ? AppColors.primaryBlue
                          : AppColors.lightGray,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              materi.title,
              style: GoogleFonts.jua(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              materi.content,
              style: GoogleFonts.jua(
                fontSize: 15,
                color: AppColors.darkGray,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              text: isLast ? 'Mulai Kuis' : 'Lanjut',
              onPressed: _next,
            ),
          ],
        ),
      ),
    );
  }
}
