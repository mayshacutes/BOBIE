import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme.dart';
import '../../models/modul.dart';

class LevelGameScreen extends StatefulWidget {
  const LevelGameScreen({super.key});

  @override
  State<LevelGameScreen> createState() => _LevelGameScreenState();
}

class _LevelGameScreenState extends State<LevelGameScreen> {
  late Level _level;
  late String _modulId;
  late List<Modul> _moduls;
  bool soundOn = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _moduls = args['moduls'] as List<Modul>;
      _modulId = args['modulId'] as String;
      final modul = _moduls.firstWhere((m) => m.id == _modulId);
      final levelNumber = args['level'] as int;
      _level = modul.levels.firstWhere((l) => l.number == levelNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: Center(
                child: Text(
                  'Level ${_level.number}\n${_level.title}',
                  style: GoogleFonts.jua(fontSize: 18, color: AppColors.darkGray),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(
              icon: const Icon(Icons.home, color: AppColors.darkGray),
              onPressed: () => Navigator.pop(context)),
          Text('Level ${_level.number}',
              style: GoogleFonts.jua(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.black)),
          const Spacer(),
          IconButton(
              icon: const Icon(Icons.replay, color: AppColors.darkGray), onPressed: () {}),
          IconButton(
            icon: Icon(soundOn ? Icons.volume_up : Icons.volume_off,
                color: soundOn ? AppColors.primaryBlue : AppColors.darkGray),
            onPressed: () => setState(() => soundOn = !soundOn),
          ),
        ],
      ),
    );
  }
}
