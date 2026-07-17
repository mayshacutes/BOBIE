import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme.dart';
import '../../../models/app_user.dart';

enum _L2Phase { sectionA, sectionB }

class Level2Screen extends StatefulWidget {
  final MascotGender gender;
  const Level2Screen({super.key, this.gender = MascotGender.boy});

  @override
  State<Level2Screen> createState() => _Level2ScreenState();
}

class _Level2ScreenState extends State<Level2Screen> {
  bool soundOn = true;
  _L2Phase _phase = _L2Phase.sectionA;

  final List<_Part> _parts = [
    _Part('mata', 'Mata', '👁️', 'untuk melihat'),
    _Part('hidung', 'Hidung', '👃', 'untuk mencium'),
    _Part('telinga', 'Telinga', '👂', 'untuk mendengar'),
    _Part('mulut', 'Mulut', '👄', 'untuk berbicara & makan'),
    _Part('tangan', 'Tangan', '✋', 'untuk memegang'),
    _Part('kaki', 'Kaki', '🦶', 'untuk berjalan'),
  ];

  final Set<String> _revealedRight = {};
  final Set<String> _revealedLeft = {};

  String? _selectedLeftItem;
  String? _selectedRightItem;
  final Map<String, String> _matches = {};
  bool _submitted = false;

  List<String> _shuffledFunctions = [];

  @override
  void initState() {
    super.initState();
    _shuffledFunctions = _parts.map((p) => p.function).toList()..shuffle();
  }

  int get _correctCount {
    int c = 0;
    for (var entry in _matches.entries) {
      final part = _parts.firstWhere((p) => p.id == entry.key);
      if (part.function == entry.value) c++;
    }
    return c;
  }

  bool get _allMatched => _matches.length == _parts.length;

  void _showCompletionDialog(int correct) {
    int stars = correct >= 6 ? 3 : (correct >= 4 ? 2 : 1);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('SELAMAT!',
                  style: GoogleFonts.jua(fontSize: 28, fontWeight: FontWeight.bold, color: const Color(0xFF489015))),
              const SizedBox(height: 8),
              Text('kamu sudah menyelesaikan',
                  style: GoogleFonts.jua(fontSize: 14, color: AppColors.darkGray)),
              Text('level 2',
                  style: GoogleFonts.jua(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.black)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) {
                  final size = i == 1 ? 44.0 : 32.0;
                  return Padding(
                    padding: EdgeInsets.only(left: i > 0 ? 2 : 0),
                    child: Icon(
                      i < stars ? Icons.star_rounded : Icons.star_border_rounded,
                      color: const Color(0xFFFDD52E),
                      size: size,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 4),
              Text('+${correct * 10} XP',
                  style: GoogleFonts.jua(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildResultButton(
                    icon: Icons.home,
                    gradient: const [Color(0xFF75D035), Color(0xFF388105)],
                    label: 'Kembali',
                    onPressed: () => Navigator.pop(ctx, 0),
                  ),
                  _buildResultButton(
                    icon: Icons.replay,
                    gradient: const [Color(0xFFEAAA0A), Color(0xFF9A7413)],
                    label: 'Ulangi',
                    onPressed: () {
                      Navigator.pop(ctx);
                      setState(() {
                        _submitted = false;
                        _matches.clear();
                        _selectedLeftItem = null;
                        _selectedRightItem = null;
                        _shuffledFunctions = _parts.map((p) => p.function).toList()..shuffle();
                      });
                    },
                  ),
                  _buildResultButton(
                    icon: Icons.arrow_forward,
                    gradient: const [Color(0xFF4FA8DF), Color(0xFF2B5B79)],
                    label: 'Lanjut',
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.pop(context, stars);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: switch (_phase) {
          _L2Phase.sectionA => _buildSectionA(),
          _L2Phase.sectionB => _buildSectionB(),
        },
      ),
    );
  }

  Widget _buildSectionA() {
    return Column(
      children: [
        _buildTopBar(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Semua Bagian Punya Fungsi',
              style: GoogleFonts.jua(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.black),
              textAlign: TextAlign.center),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
            child: Column(
              children: [
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final cw = constraints.maxWidth;
                      final cardW = (cw - 40) / 3;
                      final cardH = cardW * 1.1;
                      final bobW = (cw - 40) / 3;
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Left cards (Fungsi)
                          SizedBox(
                            width: cardW,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Tangan KIRI',
                                    style: GoogleFonts.jua(fontSize: 11, color: AppColors.darkGray)),
                                const SizedBox(height: 4),
                                Expanded(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: _parts.length,
                                    itemBuilder: (context, i) => _buildCard(
                                      part: _parts[i],
                                      isRight: false,
                                      cardW: cardW * 0.85,
                                      cardH: cardH * 0.65,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Bob image
                          SizedBox(
                            width: bobW,
                            child: Image.asset(
                              'assets/images/bob_kertas.png',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => Center(
                                child: Text('Bob',
                                    style: GoogleFonts.jua(fontSize: 14, color: AppColors.darkGray)),
                              ),
                            ),
                          ),
                          // Right cards (Nama)
                          SizedBox(
                            width: cardW,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Tangan KANAN',
                                    style: GoogleFonts.jua(fontSize: 11, color: AppColors.darkGray)),
                                const SizedBox(height: 4),
                                Expanded(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: _parts.length,
                                    itemBuilder: (context, i) => _buildCard(
                                      part: _parts[i],
                                      isRight: true,
                                      cardW: cardW * 0.85,
                                      cardH: cardH * 0.65,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Text('Ketuk kartu untuk membuka',
                    style: GoogleFonts.jua(fontSize: 13, color: AppColors.darkGray)),
                const SizedBox(height: 12),
                SizedBox(
                  width: 220,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() => _phase = _L2Phase.sectionB);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF75D035),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: Text('Uji Pengetahuanku',
                        style: GoogleFonts.jua(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCard({required _Part part, required bool isRight, required double cardW, required double cardH}) {
    final isRevealed = isRight ? _revealedRight.contains(part.id) : _revealedLeft.contains(part.id);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (isRight) {
              _revealedRight.add(part.id);
            } else {
              _revealedLeft.add(part.id);
            }
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          width: cardW,
          height: cardH,
          decoration: BoxDecoration(
            color: isRevealed ? Colors.white : const Color(0xFF6C63FF),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isRevealed ? AppColors.primaryBlue : const Color(0xFF5A52D5),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isRevealed ? AppColors.primaryBlue.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.15),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: isRevealed
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(part.emoji, style: const TextStyle(fontSize: 22)),
                    const SizedBox(height: 2),
                    Text(
                      isRight ? part.name : part.function,
                      style: GoogleFonts.jua(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              : Center(
                  child: Image.asset(
                    'assets/images/beep_kertas.png',
                    width: cardW * 0.5,
                    height: cardH * 0.5,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Text('?',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildSectionB() {
    return Column(
      children: [
        _buildTopBar(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Cocokkan Organ dengan Fungsinya!',
              style: GoogleFonts.jua(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.black),
              textAlign: TextAlign.center),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
              child: Column(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final W = constraints.maxWidth;
                      final leftW = W * 0.4;
                      final rightW = W * 0.4;
                      return SizedBox(
                        width: W,
                        child: Stack(
                          children: [
                            // Left column — body parts (shuffled names)
                            Positioned(left: 0, top: 0, child: _buildMatchColumn(
                              items: _parts.map((p) => _MatchItem(p.id, '${p.emoji} ${p.name}')).toList()..shuffle(),
                              width: leftW,
                              isLeft: true,
                            )),
                            // Right column — functions (shuffled)
                            Positioned(right: 0, top: 0, child: _buildMatchColumn(
                              items: _shuffledFunctions.map((f) {
                                final part = _parts.firstWhere((p) => p.function == f);
                                return _MatchItem(part.id, f);
                              }).toList(),
                              width: rightW,
                              isLeft: false,
                            )),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 200,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: (_allMatched && !_submitted)
                          ? () {
                              setState(() => _submitted = true);
                              Future.delayed(const Duration(seconds: 5), () {
                                if (mounted) _showCompletionDialog(_correctCount);
                              });
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF75D035),
                        disabledBackgroundColor: AppColors.gray,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                      child: Text(_submitted ? 'Selesai' : 'Submit',
                          style: GoogleFonts.jua(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMatchColumn({required List<_MatchItem> items, required double width, required bool isLeft}) {
    return SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(isLeft ? 'Organ' : 'Fungsi',
              style: GoogleFonts.jua(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.darkGray)),
          const SizedBox(height: 6),
          ...items.map((item) {
            final isMatched = _matches.containsKey(item.id);
            final isSelected = isLeft
                ? _selectedLeftItem == item.id
                : _selectedRightItem == item.functionLabel;

            final isCorrect = _submitted && isMatched;
            final isWrong = _submitted && _matches.containsKey(item.id) &&
                _parts.firstWhere((p) => p.id == item.id).function != _matches[item.id];

            Color bg = Colors.white;
            if (isCorrect) {
              bg = Colors.green.withValues(alpha: 0.15);
            } else if (isWrong) {
              bg = Colors.red.withValues(alpha: 0.15);
            } else if (isSelected) {
              bg = AppColors.primaryBlue.withValues(alpha: 0.15);
            }

            Color border = AppColors.gray.withValues(alpha: 0.5);
            if (isCorrect) {
              border = Colors.green;
            } else if (isWrong) {
              border = Colors.red;
            } else if (isSelected) {
              border = AppColors.primaryBlue;
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: GestureDetector(
                onTap: _submitted ? null : () {
                  if (isLeft) {
                    setState(() {
                      if (_selectedLeftItem == item.id) {
                        _selectedLeftItem = null;
                      } else {
                        _selectedLeftItem = item.id;
                        if (_selectedRightItem != null) _tryMatch();
                      }
                    });
                  } else {
                    setState(() {
                      if (_selectedRightItem == item.functionLabel) {
                        _selectedRightItem = null;
                      } else {
                        _selectedRightItem = item.functionLabel;
                        if (_selectedLeftItem != null) _tryMatch();
                      }
                    });
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: border, width: 1.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isMatched && !isLeft)
                        Icon(Icons.check_circle, size: 14,
                            color: isCorrect ? Colors.green : Colors.red),
                      Flexible(
                        child: Text(
                          item.functionLabel,
                          style: GoogleFonts.jua(
                            fontSize: 10,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isCorrect ? Colors.green : isWrong ? Colors.red : AppColors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      if (isMatched && isLeft)
                        Icon(Icons.check_circle, size: 14,
                            color: isCorrect ? Colors.green : Colors.red),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _tryMatch() {
    if (_selectedLeftItem == null || _selectedRightItem == null) return;
    _matches[_selectedLeftItem!] = _selectedRightItem!;
    _selectedLeftItem = null;
    _selectedRightItem = null;
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 6),
      child: Row(
        children: [
          _CircleButton(
            icon: Icons.home,
            gradient: const [Color(0xFF75D035), Color(0xFF388105)],
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          Text('Level 2',
              style: GoogleFonts.jua(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.black)),
          const Spacer(),
          _CircleButton(
            icon: Icons.replay,
            gradient: const [Color(0xFFEAAA0A), Color(0xFF9A7413)],
            onPressed: () {
              if (_phase == _L2Phase.sectionB) {
                setState(() {
                  _submitted = false;
                  _matches.clear();
                  _selectedLeftItem = null;
                  _selectedRightItem = null;
                  _shuffledFunctions = _parts.map((p) => p.function).toList()..shuffle();
                });
              }
            },
          ),
          const SizedBox(width: 4),
          _CircleButton(
            icon: soundOn ? Icons.volume_up : Icons.volume_off,
            gradient: const [Color(0xFFE87E45), Color(0xFFA64410)],
            onPressed: () => setState(() => soundOn = !soundOn),
          ),
        ],
      ),
    );
  }

  Widget _buildResultButton({
    required IconData icon,
    required List<Color> gradient,
    required String label,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: gradient.last.withValues(alpha: 0.3),
                  blurRadius: 4, offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 4),
          Text(label,
              style: GoogleFonts.jua(fontSize: 11, fontWeight: FontWeight.w600, color: gradient.first)),
        ],
      ),
    );
  }
}

class _Part {
  final String id, name, emoji, function;
  const _Part(this.id, this.name, this.emoji, this.function);
}

class _MatchItem {
  final String id, functionLabel;
  const _MatchItem(this.id, this.functionLabel);
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onPressed;
  const _CircleButton({required this.icon, required this.gradient, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradient),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: gradient.last.withValues(alpha: 0.3),
              blurRadius: 4, offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
