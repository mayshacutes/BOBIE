import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme.dart';
import '../../../models/app_user.dart';

class Level1Screen extends StatefulWidget {
  final MascotGender gender;

  const Level1Screen({super.key, this.gender = MascotGender.boy});

  @override
  State<Level1Screen> createState() => _Level1ScreenState();
}

class _Level1ScreenState extends State<Level1Screen> {
  bool soundOn = true;
  bool submitted = false;
  String? _highlightedPart;

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
  void initState() {
    super.initState();
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
      for (var entry in _dropTargets.entries) {
        if (entry.value != null && entry.value != entry.key && !_availableLabels.contains(entry.value)) {
          _availableLabels.insert(0, entry.value!);
          _dropTargets[entry.key] = null;
        }
      }
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
        for (var part in _bodyParts) {
          if (_dropTargets[part.id] == part.id) correct++;
        }
        _showCompletionDialog(correct);
      }
    });
  }

  void _showCompletionDialog(int correct) {
    int stars = correct >= 6 ? 3 : (correct >= 4 ? 2 : 1);
    int xp = correct * 10;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('SELESAI!',
                  style: GoogleFonts.jua(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.orange)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) => Icon(
                    i < stars ? Icons.star : Icons.star_border,
                    color: const Color(0xFFF25A67),
                    size: 36)),
              ),
              const SizedBox(height: 8),
              Text('$xp XP',
                  style: GoogleFonts.jua(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.primaryBlue)),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx, stars),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                  ),
                  child: Text('Kembali',
                      style: GoogleFonts.jua(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(
              icon: const Icon(Icons.home, color: AppColors.darkGray),
              onPressed: () => Navigator.pop(context)),
          Text('Level 1',
              style: GoogleFonts.jua(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.black)),
          const Spacer(),
          IconButton(
              icon: const Icon(Icons.replay, color: AppColors.darkGray),
              onPressed: () {
                setState(() {
                  submitted = false;
                  _dropTargets = {for (var p in _bodyParts) p.id: null};
                  _availableLabels = _bodyParts.map((p) => p.id).toList()..shuffle();
                });
              }),
          IconButton(
            icon: Icon(soundOn ? Icons.volume_up : Icons.volume_off,
                color: soundOn ? AppColors.primaryBlue : AppColors.darkGray),
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
    final isCorrect = submitted && _dropTargets[part.id] == part.id;
    final isWrong = submitted && _dropTargets[part.id] != null && _dropTargets[part.id] != part.id;

    return DragTarget<String>(
      onAcceptWithDetails: (details) => _onLabelDropped(part.id, details.data),
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;
        return GestureDetector(
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
            } else if (isFilled && !submitted) {
              _removeLabelFromSlot(part.id);
            }
          },
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
                : Center(
                    child: Icon(Icons.drag_indicator, size: 14, color: AppColors.gray.withValues(alpha: 0.6)),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildLabelsRow() {
    if (submitted) return const SizedBox();
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
