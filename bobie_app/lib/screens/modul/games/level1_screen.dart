import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme.dart';
import '../../../models/app_user.dart';

enum _LevelPhase { sectionA, sectionB, result }

class BodyPart {
  final String id;
  final String label;
  final Offset position;
  const BodyPart(this.id, this.label, this.position);
}

const List<BodyPart> _bodyParts = [
  BodyPart('kepala', 'Kepala', Offset(0.52, 0.18)),
  BodyPart('mata_kiri', 'Mata', Offset(0.45, 0.255)),
  BodyPart('mata_kanan', 'Mata', Offset(0.59, 0.255)),
  BodyPart('hidung', 'Hidung', Offset(0.50, 0.28)),
  BodyPart('mulut', 'Mulut', Offset(0.525, 0.32)),
  BodyPart('tangan_kiri', 'Tangan', Offset(0.235, 0.34)),
  BodyPart('tangan_kanan', 'Tangan', Offset(0.725, 0.535)),
  BodyPart('kaki_kiri', 'Kaki', Offset(0.42, 0.85)),
  BodyPart('kaki_kanan', 'Kaki', Offset(0.685, 0.84)),
];

const Map<String, Offset> _boxPositions = {
  'kepala': Offset(0.50, 0.02),
  'mata_kiri': Offset(0.14, 0.06),
  'mata_kanan': Offset(0.86, 0.06),
  'hidung': Offset(0.14, 0.28),
  'mulut': Offset(0.86, 0.19),
  'tangan_kiri': Offset(0.06, 0.40),
  'tangan_kanan': Offset(0.94, 0.60),
  'kaki_kiri': Offset(0.28, 0.99),
  'kaki_kanan': Offset(0.72, 0.99),
};

class Level1Screen extends StatefulWidget {
  final MascotGender gender;

  const Level1Screen({super.key, this.gender = MascotGender.boy});

  @override
  State<Level1Screen> createState() => _Level1ScreenState();
}

class _Level1ScreenState extends State<Level1Screen> {
  _LevelPhase _phase = _LevelPhase.sectionA;
  String? _bubbleText;
  Set<String> _tappedParts = {};

  Map<String, String?> _placedLabels = {
    for (final part in _bodyParts) part.id: null,
  };
  bool _submitted = false;
  int _correctPlacements = 0;

  void _onTapPart(BodyPart part) {
    setState(() {
      _bubbleText = part.label;
      _tappedParts.add(part.id);
    });
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _bubbleText = null);
    });

    if (_tappedParts.length == _bodyParts.length) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) setState(() => _phase = _LevelPhase.sectionB);
      });
    }
  }

  void _onLabelDropped(BodyPart part, String droppedLabel) {
    setState(() {
      _placedLabels[part.id] = droppedLabel;
    });
  }

  void _onSubmit() {
    int correct = 0;
    for (final part in _bodyParts) {
      if (_placedLabels[part.id] == part.label) correct++;
    }
    setState(() {
      _submitted = true;
      _correctPlacements = correct;
    });
  }

  void _goToResult() {
    setState(() => _phase = _LevelPhase.result);
  }

  void _resetLevel() {
    setState(() {
      _phase = _LevelPhase.sectionA;
      _bubbleText = null;
      _tappedParts = {};
      _placedLabels = {for (final part in _bodyParts) part.id: null};
      _submitted = false;
      _correctPlacements = 0;
    });
  }

  int get _starsEarned {
    final ratio = _correctPlacements / _bodyParts.length;
    if (ratio >= 0.9) return 3;
    if (ratio >= 0.6) return 2;
    if (ratio > 0) return 1;
    return 0;
  }

  String get _mascotAsset => widget.gender == MascotGender.boy
      ? 'assets/images/mascot_boy.png'
      : 'assets/images/mascot_girl.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA3DEFA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Halo, Tubuhku!',
          style: GoogleFonts.jua(fontSize: 20, color: AppColors.black),
        ),
      ),
      body: SafeArea(
        child: switch (_phase) {
          _LevelPhase.sectionA => _SectionA(
              bubbleText: _bubbleText,
              tappedParts: _tappedParts,
              onTapPart: _onTapPart,
              mascotAsset: _mascotAsset,
            ),
          _LevelPhase.sectionB => _SectionB(
              placedLabels: _placedLabels,
              submitted: _submitted,
              correctCount: _correctPlacements,
              onDropped: _onLabelDropped,
              onSubmit: _onSubmit,
              onGoToResult: _goToResult,
              mascotAsset: _mascotAsset,
            ),
          _LevelPhase.result => _ResultView(
              stars: _starsEarned,
              onRestart: _resetLevel,
              onContinue: () => Navigator.pop(context, _starsEarned),
            ),
        },
      ),
    );
  }
}

// ---------------- SECTION A: Tap to reveal (small circle markers) ----------------

class _SectionA extends StatelessWidget {
  final String? bubbleText;
  final Set<String> tappedParts;
  final void Function(BodyPart part) onTapPart;
  final String mascotAsset;

  const _SectionA({
    required this.bubbleText,
    required this.tappedParts,
    required this.onTapPart,
    required this.mascotAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Text(
            'Ketuk bagian tubuh maskot untuk mendengar namanya!',
            textAlign: TextAlign.center,
            style: GoogleFonts.jua(fontSize: 15, color: AppColors.darkBlue),
          ),
        ),
        Expanded(
          child: Center(
            child: AspectRatio(
              aspectRatio: 0.6,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final w = constraints.maxWidth;
                  final h = constraints.maxHeight;
                  return Stack(
                    children: [
                      _MascotImage(assetPath: mascotAsset),
                      if (bubbleText != null)
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: _SpeechBubble(text: bubbleText!),
                        ),
                      for (final part in _bodyParts)
                        Positioned(
                          left: part.position.dx * w - 18,
                          top: part.position.dy * h - 18,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => onTapPart(part),
                            child: _TapZone(isDone: tappedParts.contains(part.id)),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            '${tappedParts.length} / ${_bodyParts.length} ditemukan',
            style: GoogleFonts.jua(fontSize: 14, color: AppColors.darkGray),
          ),
        ),
      ],
    );
  }
}

class _TapZone extends StatelessWidget {
  final bool isDone;
  const _TapZone({required this.isDone});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDone
            ? AppColors.green.withValues(alpha: 0.5)
            : Colors.white.withValues(alpha: 0.35),
        border: Border.all(
          color: isDone ? AppColors.green : Colors.white,
          width: 2,
        ),
      ),
      child: isDone
          ? const Icon(Icons.check, color: Colors.white, size: 18)
          : null,
    );
  }
}

class _SpeechBubble extends StatelessWidget {
  final String text;
  const _SpeechBubble({required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 8),
          ],
        ),
        child: Text(
          text.toUpperCase(),
          style: GoogleFonts.jua(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryBlue,
          ),
        ),
      ),
    );
  }
}

// ---------------- SECTION B: Drag label to outer box, connected by an arrow ----------------

class _SectionB extends StatefulWidget {
  final Map<String, String?> placedLabels;
  final bool submitted;
  final int correctCount;
  final void Function(BodyPart part, String label) onDropped;
  final VoidCallback onSubmit;
  final VoidCallback onGoToResult;
  final String mascotAsset;

  const _SectionB({
    required this.placedLabels,
    required this.submitted,
    required this.correctCount,
    required this.onDropped,
    required this.onSubmit,
    required this.onGoToResult,
    required this.mascotAsset,
  });

  @override
  State<_SectionB> createState() => _SectionBState();
}

class _SectionBState extends State<_SectionB> {
  late List<String> _availableLabels;

  @override
  void initState() {
    super.initState();
    _availableLabels = _bodyParts.map((p) => p.label).toSet().toList()
      ..shuffle();
  }

  bool get _allFilled => widget.placedLabels.values.every((v) => v != null);

  @override
  Widget build(BuildContext context) {
    final wrongCount = widget.submitted
        ? _bodyParts.length - widget.correctCount
        : 0;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Text(
            widget.submitted
                ? 'Ini hasil jawabanmu!'
                : 'Seret label ke kotak yang menunjuk bagian tubuh yang tepat!',
            textAlign: TextAlign.center,
            style: GoogleFonts.jua(fontSize: 15, color: AppColors.darkBlue),
          ),
        ),
        Expanded(
          child: Center(
            child: AspectRatio(
              aspectRatio: 0.6,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final w = constraints.maxWidth;
                  final h = constraints.maxHeight;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      _MascotImage(assetPath: widget.mascotAsset),
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _ConnectorPainter(
                            parts: _bodyParts,
                            boxPositions: _boxPositions,
                          ),
                        ),
                      ),
                      for (final part in _bodyParts)
                        Positioned(
                          left: part.position.dx * w - 4,
                          top: part.position.dy * h - 4,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppColors.darkGray.withValues(alpha: 0.6),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      for (final part in _bodyParts)
                        Positioned(
                          left: (_boxPositions[part.id]!.dx * w) - 30,
                          top: (_boxPositions[part.id]!.dy * h) - 16,
                          child: _DropZone(
                            part: part,
                            placedLabel: widget.placedLabels[part.id],
                            submitted: widget.submitted,
                            onAccept: (label) => widget.onDropped(part, label),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        if (widget.submitted) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _CountBadge(
                icon: Icons.check_circle,
                color: AppColors.green,
                count: widget.correctCount,
              ),
              const SizedBox(width: 16),
              _CountBadge(
                icon: Icons.cancel,
                color: AppColors.pink,
                count: wrongCount,
              ),
            ],
          ),
          const SizedBox(height: 12),
        ] else
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: _availableLabels
                  .map((label) => Draggable<String>(
                        data: label,
                        feedback: _LabelChip(label: label, dragging: true),
                        childWhenDragging: _LabelChip(label: label, faded: true),
                        child: _LabelChip(label: label),
                      ))
                  .toList(),
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
          child: SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: widget.submitted
                  ? widget.onGoToResult
                  : (_allFilled ? widget.onSubmit : null),
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.submitted
                    ? AppColors.primaryBlue
                    : (_allFilled ? AppColors.green : AppColors.gray),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(23),
                ),
              ),
              child: Text(
                widget.submitted ? 'Lanjut ke Hasil' : 'Submit',
                style: GoogleFonts.jua(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CountBadge extends StatelessWidget {
  final IconData icon;
  final Color color;
  final int count;

  const _CountBadge({required this.icon, required this.color, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 4),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 6),
          Text(
            '$count',
            style: GoogleFonts.jua(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _ConnectorPainter extends CustomPainter {
  final List<BodyPart> parts;
  final Map<String, Offset> boxPositions;

  _ConnectorPainter({required this.parts, required this.boxPositions});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.darkGray.withValues(alpha: 0.45)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (final part in parts) {
      final boxOffset = boxPositions[part.id];
      if (boxOffset == null) continue;

      final from = Offset(boxOffset.dx * size.width, boxOffset.dy * size.height);
      final to = Offset(part.position.dx * size.width, part.position.dy * size.height);

      canvas.drawLine(from, to, paint);

      final angle = (to - from).direction;
      const arrowLen = 7.0;
      const arrowAngle = 0.45;
      final p1 = to - Offset(math.cos(angle - arrowAngle), math.sin(angle - arrowAngle)) * arrowLen;
      final p2 = to - Offset(math.cos(angle + arrowAngle), math.sin(angle + arrowAngle)) * arrowLen;

      final arrowPaint = Paint()
        ..color = AppColors.darkGray.withValues(alpha: 0.6)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;
      canvas.drawLine(to, p1, arrowPaint);
      canvas.drawLine(to, p2, arrowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ConnectorPainter oldDelegate) => false;
}

class _DropZone extends StatelessWidget {
  final BodyPart part;
  final String? placedLabel;
  final bool submitted;
  final void Function(String label) onAccept;

  const _DropZone({
    required this.part,
    required this.placedLabel,
    required this.submitted,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    final isFilled = placedLabel != null;
    final isCorrect = placedLabel == part.label;

    Color boxColor;
    if (!submitted) {
      boxColor = isFilled ? Colors.white : Colors.white.withValues(alpha: 0.95);
    } else {
      boxColor = isCorrect
          ? AppColors.green.withValues(alpha: 0.9)
          : AppColors.pink.withValues(alpha: 0.9);
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        DragTarget<String>(
          onAcceptWithDetails: (details) {
            if (!isFilled && !submitted) onAccept(details.data);
          },
          builder: (context, candidateData, rejectedData) {
            return Container(
              width: 60,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: boxColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: candidateData.isNotEmpty
                      ? AppColors.orange
                      : AppColors.darkGray.withValues(alpha: 0.4),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 3),
                ],
              ),
              child: Text(
                placedLabel ?? '?',
                style: GoogleFonts.jua(
                  fontSize: 10,
                  color: (isFilled && !submitted) ? AppColors.darkGray : Colors.white,
                ),
              ),
            );
          },
        ),
        if (submitted)
          Positioned(
            top: -6,
            right: -6,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: isCorrect ? AppColors.green : AppColors.pink,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: Icon(
                isCorrect ? Icons.check : Icons.close,
                size: 12,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}

class _LabelChip extends StatelessWidget {
  final String label;
  final bool dragging;
  final bool faded;

  const _LabelChip({
    required this.label,
    this.dragging = false,
    this.faded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: faded ? 0.3 : 1,
      child: Material(
        elevation: dragging ? 6 : 2,
        borderRadius: BorderRadius.circular(14),
        color: AppColors.orange,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Text(
            label,
            style: GoogleFonts.jua(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------- Result (no wrong-answer list — just stars) ----------------

class _ResultView extends StatelessWidget {
  final int stars;
  final VoidCallback onRestart;
  final VoidCallback onContinue;

  const _ResultView({
    required this.stars,
    required this.onRestart,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) {
                return Icon(
                  i < stars ? Icons.star_rounded : Icons.star_border_rounded,
                  size: 56,
                  color: AppColors.yellow,
                );
              }),
            ),
            const SizedBox(height: 16),
            Text(
              'Level Selesai!',
              style: GoogleFonts.jua(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBlue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Kamu dapat $stars bintang',
              style: GoogleFonts.jua(fontSize: 15, color: AppColors.darkGray),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 46,
                    child: OutlinedButton(
                      onPressed: onRestart,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primaryBlue),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(23),
                        ),
                      ),
                      child: Text(
                        'Ulang',
                        style: GoogleFonts.jua(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 46,
                    child: ElevatedButton(
                      onPressed: onContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(23),
                        ),
                      ),
                      child: Text(
                        'Lanjut',
                        style: GoogleFonts.jua(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- Mascot image (with graceful fallback) ----------------

class _MascotImage extends StatelessWidget {
  final String assetPath;
  const _MascotImage({required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        assetPath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                color: Color(0xFFFFD8A8),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 110,
              height: 160,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
