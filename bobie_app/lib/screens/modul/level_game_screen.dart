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
  bool showResult = false;

  final List<_BodyPart> _bodyParts = [
    _BodyPart('rambut', 'Rambut', 0.50, 0.07),
    _BodyPart('mata', 'Mata', 0.50, 0.19),
    _BodyPart('mulut', 'Mulut', 0.50, 0.32),
    _BodyPart('tangan', 'Tangan', 0.15, 0.52),
    _BodyPart('perut', 'Perut', 0.50, 0.56),
    _BodyPart('kaki', 'Kaki', 0.50, 0.84),
  ];

  late Map<String, String?> _dropTargets;
  late List<String> _availableLabels;

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
    _dropTargets = {for (var p in _bodyParts) p.id: null};
    _availableLabels = _bodyParts.map((p) => p.id).toList()..shuffle();
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
    setState(() => showResult = true);

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        int correct = 0;
        for (var part in _bodyParts) {
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
              Text('level ${_level.number}',
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
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.pop(context);
                    },
                  ),
                  _buildResultButton(
                    icon: Icons.replay,
                    gradient: const [Color(0xFFEAAA0A), Color(0xFF9A7413)],
                    label: 'Ulangi',
                    onPressed: () {
                      Navigator.pop(ctx);
                      setState(() {
                        showResult = false;
                        _dropTargets = {for (var p in _bodyParts) p.id: null};
                        _availableLabels = _bodyParts.map((p) => p.id).toList()..shuffle();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  child: Column(
                    children: [
                      Text('Apa saja bagian tubuhku?',
                          style: GoogleFonts.jua(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.black),
                          textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      _buildBodyImage(),
                      const SizedBox(height: 16),
                      _buildLabelsRow(),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: 200,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: (_allFilled && !showResult) ? _submit : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF75D035),
                            disabledBackgroundColor: AppColors.gray,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          ),
                          child: Text('Submit',
                              style: GoogleFonts.jua(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
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
      padding: const EdgeInsets.fromLTRB(12, 66, 12, 6),
      child: Row(
        children: [
          _CircleButton(
            icon: Icons.home,
            gradient: const [Color(0xFF75D035), Color(0xFF388105)],
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          Text('Level ${_level.number}',
              style: GoogleFonts.jua(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.black)),
          const Spacer(),
          _CircleButton(
            icon: Icons.replay,
            gradient: const [Color(0xFFEAAA0A), Color(0xFF9A7413)],
            onPressed: () {
              setState(() {
                showResult = false;
                _dropTargets = {for (var p in _bodyParts) p.id: null};
                _availableLabels = _bodyParts.map((p) => p.id).toList()..shuffle();
              });
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

  Widget _buildBodyImage() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cw = constraints.maxWidth;
        final ch = cw * 1.3;
        return Container(
          width: cw,
          height: ch,
          decoration: BoxDecoration(
            color: AppColors.lightSkyBlue.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
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
              for (var part in _bodyParts)
                Positioned(
                  left: cw * part.relX - 30,
                  top: ch * part.relY - 12,
                  child: _buildDropZone(part, 60, 24),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDropZone(_BodyPart part, double w, double h) {
    final isFilled = _dropTargets[part.id] != null;
    final isCorrect = showResult && _dropTargets[part.id] == part.id;
    final isWrong = showResult && _dropTargets[part.id] != null && _dropTargets[part.id] != part.id;

    return DragTarget<String>(
      onAcceptWithDetails: (details) => _onLabelDropped(part.id, details.data),
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;
        return GestureDetector(
          onTap: isFilled ? () => _removeLabelFromSlot(part.id) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: w,
            height: h,
            decoration: BoxDecoration(
              color: isCorrect
                  ? Colors.green.withValues(alpha: 0.25)
                  : isWrong
                      ? Colors.red.withValues(alpha: 0.25)
                      : isHovering
                          ? AppColors.primaryBlue.withValues(alpha: 0.15)
                          : Colors.white.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isCorrect
                    ? Colors.green
                    : isWrong
                        ? Colors.red
                        : isFilled
                            ? AppColors.primaryBlue
                            : AppColors.gray,
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
                      if (showResult)
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
                : Center(
                    child: Icon(Icons.drag_indicator, size: 14, color: AppColors.gray.withValues(alpha: 0.6)),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildLabelsRow() {
    if (showResult) return const SizedBox();
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      alignment: WrapAlignment.center,
      children: _availableLabels.map((label) {
        final part = _bodyParts.firstWhere((p) => p.id == label);
        return Draggable<String>(
          data: label,
          feedback: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(part.label,
                  style: GoogleFonts.jua(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
            ),
          ),
          childWhenDragging: Opacity(
            opacity: 0.3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.lightGray,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.gray),
              ),
              child: Text(part.label, style: GoogleFonts.jua(fontSize: 13, color: AppColors.gray)),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primaryBlue, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(part.label,
                style: GoogleFonts.jua(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primaryBlue)),
          ),
        );
      }).toList(),
    );
  }
}

class _BodyPart {
  final String id;
  final String label;
  final double relX;
  final double relY;
  const _BodyPart(this.id, this.label, this.relX, this.relY);
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
