import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme.dart';
import '../../../models/app_user.dart';

enum _LevelPhase { sectionA, sectionB }

class Level1Screen extends StatefulWidget {
  final MascotGender gender;

  const Level1Screen({super.key, this.gender = MascotGender.boy});

  @override
  State<Level1Screen> createState() => _Level1ScreenState();
}

class _Level1ScreenState extends State<Level1Screen> {
  bool soundOn = true;
  _LevelPhase _phase = _LevelPhase.sectionA;
  bool submitted = false;
  String? _highlightedPart;
  final Set<String> _tappedInA = {};

  final List<_BodyPart> _bodyPartsA = [
    _BodyPart('rambut', 'Rambut', 0.50, 0.11, 'left', 0.11),
    _BodyPart('mata', 'Mata', 0.58, 0.26, 'right', 0.22),
    _BodyPart('mulut', 'Mulut', 0.50, 0.30, 'left', 0.35),
    _BodyPart('tangan', 'Tangan', 0.28, 0.51, 'left', 0.53),
    _BodyPart('perut', 'Perut', 0.50, 0.57, 'right', 0.51),
    _BodyPart('kaki', 'Kaki', 0.56, 0.85, 'right', 0.85),
  ];

  final List<_BodyPart> _bodyPartsB = [
    _BodyPart('rambut', 'Rambut', 0.50, 0.07, 'left', 0.07),
    _BodyPart('mata', 'Mata', 0.58, 0.25, 'right', 0.22),
    _BodyPart('mulut', 'Mulut', 0.50, 0.267, 'left', 0.317),
    _BodyPart('tangan', 'Tangan', 0.23, 0.51, 'left', 0.53),
    _BodyPart('perut', 'Perut', 0.50, 0.57, 'right', 0.51),
    _BodyPart('kaki', 'Kaki', 0.61, 0.85, 'right', 0.85),
  ];

  late Map<String, String?> _dropTargets;
  late List<String> _availableLabels;

  void _initGame() {
    _dropTargets = {for (var p in _bodyPartsB) p.id: null};
    _availableLabels = _bodyPartsB.map((p) => p.id).toList()..shuffle();
  }

  void _playSound(_BodyPart part) {
    if (!soundOn) return;
    setState(() => _highlightedPart = part.id);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) setState(() => _highlightedPart = null);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(part.label, style: GoogleFonts.jua(fontSize: 14)),
        duration: const Duration(seconds: 1),
        backgroundColor: AppColors.primaryBlue,
      ),
    );
  }

  void _onLabelDropped(String partId, String labelId) {
    setState(() {
      for (var entry in _dropTargets.entries) {
        if (entry.value == labelId) {
          _dropTargets[entry.key] = null;
        }
      }
      _dropTargets[partId] = labelId;
      _availableLabels.remove(labelId);
    });
  }

  void _removeLabelFromSlot(String partId) {
    setState(() {
      final label = _dropTargets[partId];
      if (label != null) {
        _availableLabels.add(label);
        _dropTargets[partId] = null;
      }
    });
  }

  bool get _allFilled => _dropTargets.values.every((v) => v != null);

  void _submit() {
    if (!_allFilled) return;
    setState(() => submitted = true);

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        int correct = 0;
        for (var part in _bodyPartsB) {
          if (_dropTargets[part.id] == part.id) correct++;
        }
        _showCompletionDialog(correct);
      }
    });
  }

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
              Text('level 1',
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
                        submitted = false;
                        _dropTargets = {for (var p in _bodyPartsB) p.id: null};
                        _availableLabels = _bodyPartsB.map((p) => p.id).toList()..shuffle();
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
          _LevelPhase.sectionA => _buildSectionA(),
          _LevelPhase.sectionB => _buildSectionB(),
        },
      ),
    );
  }

  // ─────────────────────────── SECTION A ───────────────────────────

  Widget _buildSectionA() {
    return Column(
      children: [
        _buildTopBar(),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
          child: Text('Halo, Tubuhku!',
              style: GoogleFonts.jua(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.black),
              textAlign: TextAlign.center),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              children: [
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final cw = constraints.maxWidth;
                      final ch = cw * 1.3;
                      return Stack(
                        children: [
                          Center(
                            child: Image.asset(
                              'assets/images/bob_renang.png',
                              width: cw * 0.85,
                              height: ch * 0.85,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => Center(
                                child: Text('Gambar Bob',
                                    style: GoogleFonts.jua(fontSize: 16, color: AppColors.darkGray)),
                              ),
                            ),
                          ),
                          for (var part in _bodyPartsA)
                            Positioned(
                              left: cw * part.markerX - 12,
                              top: ch * part.markerY - 12 + 100,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() => _tappedInA.add(part.id));
                                  _playSound(part);
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: _tappedInA.contains(part.id) ? 16 : 24,
                                  height: _tappedInA.contains(part.id) ? 16 : 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _tappedInA.contains(part.id)
                                        ? AppColors.green.withValues(alpha: 0.6)
                                        : const Color(0xFFF25A67).withValues(alpha: 0.7),
                                    border: Border.all(
                                      color: _tappedInA.contains(part.id) ? AppColors.green : Colors.white,
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFF25A67).withValues(alpha: 0.4),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                  child: _tappedInA.contains(part.id)
                                      ? const Icon(Icons.check, color: Colors.white, size: 10)
                                      : const Icon(Icons.volume_up, color: Colors.white, size: 12),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -22),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 0),
                      Text('Klik bagian tubuh untuk mengetahui namanya',
                          style: GoogleFonts.jua(fontSize: 14, color: AppColors.darkGray),
                          textAlign: TextAlign.center),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 220,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            _initGame();
                            setState(() => _phase = _LevelPhase.sectionB);
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
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────── SECTION B ───────────────────────────

  Widget _buildSectionB() {
    return Column(
      children: [
        _buildTopBar(),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          child: Text('Apa saja bagian tubuhku?',
              style: GoogleFonts.jua(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.black),
              textAlign: TextAlign.center),
        ),
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                    child: Column(
                      children: [
                        _buildGameArea(),
                        const SizedBox(height: 12),
                        _buildLabelsRow(),
                      ],
                    ),
                  ),
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -40),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16, 0, 24),
                  child: SizedBox(
                  width: 200,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: (_allFilled && !submitted) ? _submit : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF75D035),
                      disabledBackgroundColor: AppColors.gray,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: Text(submitted ? 'Selesai' : 'Submit',
                        style: GoogleFonts.jua(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
  }

  // ─────────────────────── SHARED WIDGETS ───────────────────────

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
          Text('Level 1',
              style: GoogleFonts.jua(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.black)),
          const Spacer(),
          _CircleButton(
            icon: Icons.replay,
            gradient: const [Color(0xFFEAAA0A), Color(0xFF9A7413)],
            onPressed: () {
              if (_phase == _LevelPhase.sectionB) {
                setState(() {
                  submitted = false;
                  _dropTargets = {for (var p in _bodyPartsB) p.id: null};
                  _availableLabels = _bodyPartsB.map((p) => p.id).toList()..shuffle();
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

  Widget _buildGameArea() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final W = constraints.maxWidth;
        final areaHeight = W * 1.3;

        final marginX = W * 0.22;
        final imageLeft = marginX;
        final imageRight = W - marginX;
        final imageWidth = imageRight - imageLeft;
        final imageTop = areaHeight * 0.04;
        final imageBottom = areaHeight * 0.96;
        final imageHeight = imageBottom - imageTop;

        const boxW = 68.0;
        const boxH = 28.0;
        final leftBoxRight = 24.0 + boxW;
        final rightBoxLeft = W - 24.0 - boxW;

        final arrows = <_ArrowData>[];
        for (var part in _bodyPartsB) {
          final mX = imageLeft + part.markerX * imageWidth;
          final mY = imageTop + part.markerY * imageHeight;
          final bY = imageTop + part.boxY * areaHeight;
          if (part.side == 'left') {
            arrows.add(_ArrowData(Offset(leftBoxRight, bY), Offset(mX, mY)));
          } else {
            arrows.add(_ArrowData(Offset(rightBoxLeft, bY), Offset(mX, mY)));
          }
        }

        return SizedBox(
          width: W,
          height: areaHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: CustomPaint(painter: _ArrowPainter(arrows: arrows)),
              ),
              Positioned(
                left: imageLeft,
                top: imageTop,
                width: imageWidth,
                height: imageHeight,
                child: Image.asset(
                  'assets/images/bob_renang.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Text('Gambar Bob',
                        style: GoogleFonts.jua(fontSize: 16, color: AppColors.darkGray)),
                  ),
                ),
              ),
              for (var part in _bodyPartsB)
                Positioned(
                  left: imageLeft + part.markerX * imageWidth - 5,
                  top: imageTop + part.markerY * imageHeight - 5,
                  child: GestureDetector(
                    onTap: () {
                      if (!submitted && soundOn) {
                        setState(() => _highlightedPart = part.id);
                        Future.delayed(const Duration(milliseconds: 600), () {
                          if (mounted) setState(() => _highlightedPart = null);
                        });
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(part.label, style: GoogleFonts.jua(fontSize: 14)),
                            duration: const Duration(seconds: 1),
                            backgroundColor: AppColors.primaryBlue,
                          ),
                        );
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: _highlightedPart == part.id ? 14 : 10,
                      height: _highlightedPart == part.id ? 14 : 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _highlightedPart == part.id ? AppColors.orange : const Color(0xFFF25A67),
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: (_highlightedPart == part.id ? AppColors.orange : const Color(0xFFF25A67))
                                .withValues(alpha: 0.5),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              for (var part in _bodyPartsB)
                if (part.side == 'left')
                  Positioned(
                    left: 24,
                    top: imageTop + part.boxY * areaHeight - boxH / 2,
                    child: _buildDropBox(part, boxW, boxH),
                  )
                else
                  Positioned(
                    right: 24,
                    top: imageTop + part.boxY * areaHeight - boxH / 2,
                    child: _buildDropBox(part, boxW, boxH),
                  ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDropBox(_BodyPart part, double boxW, double boxH) {
    final isFilled = _dropTargets[part.id] != null;
    final isCorrect = submitted && _dropTargets[part.id] == part.id;
    final isWrong = submitted && _dropTargets[part.id] != null && _dropTargets[part.id] != part.id;

    return DragTarget<String>(
      onAcceptWithDetails: (details) => _onLabelDropped(part.id, details.data),
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;
        return GestureDetector(
          onTap: isFilled && !submitted ? () => _removeLabelFromSlot(part.id) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: boxW,
            height: boxH,
            decoration: BoxDecoration(
              color: isCorrect
                  ? Colors.green.withValues(alpha: 0.2)
                  : isWrong
                      ? Colors.red.withValues(alpha: 0.2)
                      : isHovering
                          ? AppColors.primaryBlue.withValues(alpha: 0.15)
                          : Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isCorrect
                    ? Colors.green
                    : isWrong
                        ? Colors.red
                        : isFilled
                            ? AppColors.primaryBlue
                            : AppColors.gray.withValues(alpha: 0.6),
                width: isFilled ? 2 : 1.5,
              ),
            ),
            child: isFilled
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          _dropTargets[part.id]!,
                          style: GoogleFonts.jua(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isCorrect ? Colors.green : isWrong ? Colors.red : AppColors.primaryBlue,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (submitted)
                        Padding(
                          padding: const EdgeInsets.only(left: 1),
                          child: Icon(
                            isCorrect ? Icons.check_circle : Icons.cancel,
                            color: isCorrect ? Colors.green : Colors.red,
                            size: 12,
                          ),
                        ),
                    ],
                  )
                : const SizedBox(),
          ),
        );
      },
    );
  }

  Widget _buildLabelsRow() {
    if (submitted) return const SizedBox();
    final labels = _bodyPartsB.map((p) => p.id).toList();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: labels.sublist(0, 3).map((id) => _buildLabelChip(id)).toList(),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: labels.sublist(3, 6).map((id) => _buildLabelChip(id)).toList(),
        ),
      ],
    );
  }

  Widget _buildLabelChip(String labelId) {
    final part = _bodyPartsB.firstWhere((p) => p.id == labelId);
    final isAvailable = _availableLabels.contains(labelId);
    if (!isAvailable) return const SizedBox(width: 90);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Draggable<String>(
        data: labelId,
        feedback: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 82,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFDD52E), Color(0xFF977F1B)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(part.label,
                style: GoogleFonts.jua(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF3D3A3B))),
          ),
        ),
        childWhenDragging: Opacity(
          opacity: 0.3,
          child: Container(
            width: 82,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(part.label, style: GoogleFonts.jua(fontSize: 12, color: AppColors.gray)),
          ),
        ),
        child: Container(
          width: 82,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFDD52E), Color(0xFF977F1B)],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(part.label,
              style: GoogleFonts.jua(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF3D3A3B))),
        ),
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
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: gradient.last.withValues(alpha: 0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
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

class _BodyPart {
  final String id;
  final String label;
  final double markerX;
  final double markerY;
  final String side;
  final double boxY;
  const _BodyPart(this.id, this.label, this.markerX, this.markerY, this.side, this.boxY);
}

class _ArrowData {
  final Offset from;
  final Offset to;
  const _ArrowData(this.from, this.to);
}

class _ArrowPainter extends CustomPainter {
  final List<_ArrowData> arrows;
  _ArrowPainter({required this.arrows});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.darkGray.withValues(alpha: 0.35)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (var arrow in arrows) {
      canvas.drawLine(arrow.from, arrow.to, paint);

      final dx = arrow.to.dx - arrow.from.dx;
      final dy = arrow.to.dy - arrow.from.dy;
      if (dx == 0 && dy == 0) continue;
      final angle = math.atan2(dy, dx);
      const arrowLen = 8.0;
      const arrowAngle = 0.5;

      final path = Path()
        ..moveTo(arrow.to.dx, arrow.to.dy)
        ..lineTo(
          arrow.to.dx - arrowLen * math.cos(angle - arrowAngle),
          arrow.to.dy - arrowLen * math.sin(angle - arrowAngle),
        )
        ..moveTo(arrow.to.dx, arrow.to.dy)
        ..lineTo(
          arrow.to.dx - arrowLen * math.cos(angle + arrowAngle),
          arrow.to.dy - arrowLen * math.sin(angle + arrowAngle),
        );

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ArrowPainter oldDelegate) => true;
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onPressed;

  const _CircleButton({
    required this.icon,
    required this.gradient,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradient),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: gradient.last.withValues(alpha: 0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
