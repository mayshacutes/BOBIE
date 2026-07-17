import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme.dart';

enum _L2Phase { sectionA, sectionB }

class Level2Screen extends StatefulWidget {
  const Level2Screen({super.key});

  @override
  State<Level2Screen> createState() => _Level2ScreenState();
}

class _Level2ScreenState extends State<Level2Screen> {
  bool soundOn = true;
  _L2Phase _phase = _L2Phase.sectionA;
  int _currentPartIndex = 0;
  bool _paperBobClicked = false;
  bool _paperBeepClicked = false;

  final List<_Part> _parts = [
    _Part('mata', 'Mata', '👁️', 'untuk melihat'),
    _Part('hidung', 'Hidung', '👃', 'untuk mencium'),
    _Part('telinga', 'Telinga', '👂', 'untuk mendengar'),
    _Part('mulut', 'Mulut', '👄', 'untuk berbicara & makan'),
    _Part('tangan', 'Tangan', '✋', 'untuk memegang'),
    _Part('kaki', 'Kaki', '🦶', 'untuk berjalan'),
  ];

  String? _selectedLeftId;
  String? _selectedRightFunc;
  final List<_LineConnection> _connections = [];
  bool _submitted = false;
  List<_ScrambledItem> _scrambledLeft = [];
  List<_ScrambledItem> _scrambledRight = [];

  @override
  void initState() {
    super.initState();
    _scrambleSectionB();
  }

  void _scrambleSectionB() {
    _scrambledLeft = _parts.map((p) => _ScrambledItem(p.id, '${p.emoji} ${p.name}')).toList()..shuffle();
    _scrambledRight = _parts.map((p) => _ScrambledItem(p.id, p.function)).toList()..shuffle();
  }

  _Part get _currentPart => _parts[_currentPartIndex];
  bool get _allConnected => _connections.length == _parts.length;

  int get _correctCount {
    int c = 0;
    for (var conn in _connections) {
      final part = _parts.firstWhere((p) => p.id == conn.leftId);
      if (part.function == conn.rightFunc) c++;
    }
    return c;
  }

  void _onPaperTap(bool isBob) {
    setState(() {
      if (isBob) {
        _paperBobClicked = true;
      } else {
        _paperBeepClicked = true;
      }
    });
  }

  void _goToPart(int index) {
    if (index < 0 || index >= _parts.length) return;
    setState(() {
      _currentPartIndex = index;
      _paperBobClicked = false;
      _paperBeepClicked = false;
    });
  }

  void _handleLeftTap(String id) {
    if (_submitted) return;
    setState(() {
      if (_selectedLeftId == id) {
        _selectedLeftId = null;
      } else {
        _selectedLeftId = id;
        if (_selectedRightFunc != null) _makeConnection();
      }
    });
  }

  void _handleRightTap(String func) {
    if (_submitted) return;
    setState(() {
      if (_selectedRightFunc == func) {
        _selectedRightFunc = null;
      } else {
        _selectedRightFunc = func;
        if (_selectedLeftId != null) _makeConnection();
      }
    });
  }

  void _makeConnection() {
    if (_selectedLeftId == null || _selectedRightFunc == null) return;
    final existing = _connections.indexWhere((c) => c.leftId == _selectedLeftId);
    if (existing != -1) _connections.removeAt(existing);
    final existingR = _connections.indexWhere((c) => c.rightFunc == _selectedRightFunc);
    if (existingR != -1) _connections.removeAt(existingR);
    _connections.add(_LineConnection(_selectedLeftId!, _selectedRightFunc!));
    _selectedLeftId = null;
    _selectedRightFunc = null;
  }

  void _removeConnection(int index) {
    if (_submitted) return;
    setState(() => _connections.removeAt(index));
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
                      color: const Color(0xFFFDD52E), size: size,
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
                    label: 'Kembali', onPressed: () => Navigator.pop(ctx, 0),
                  ),
                  _buildResultButton(
                    icon: Icons.replay,
                    gradient: const [Color(0xFFEAAA0A), Color(0xFF9A7413)],
                    label: 'Ulangi', onPressed: () {
                      Navigator.pop(ctx);
                      setState(() {
                        _submitted = false;
                        _connections.clear();
                        _selectedLeftId = null;
                        _selectedRightFunc = null;
                        _scrambleSectionB();
                      });
                    },
                  ),
                  _buildResultButton(
                    icon: Icons.arrow_forward,
                    gradient: const [Color(0xFF4FA8DF), Color(0xFF2B5B79)],
                    label: 'Lanjut', onPressed: () {
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

  // ─────────────────────────── SECTION A ───────────────────────────

  Widget _buildSectionA() {
    return Column(
      children: [
        _buildTopBar(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Kenali Organ & Fungsinya',
              style: GoogleFonts.jua(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.black),
              textAlign: TextAlign.center),
        ),
        const SizedBox(height: 4),
        Text('${_currentPartIndex + 1}/${_parts.length}',
            style: GoogleFonts.jua(fontSize: 14, color: AppColors.darkGray)),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Bob (Nama)
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Image.asset(
                                'assets/images/bob_kertas.png',
                                fit: BoxFit.contain,
                                errorBuilder: (_, _, _) => Center(
                                  child: Text('Bob', style: GoogleFonts.jua(fontSize: 14, color: AppColors.darkGray)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            _buildPaper(
                              label: _paperBobClicked ? _currentPart.name : 'Klik disini',
                              emoji: _paperBobClicked ? _currentPart.emoji : null,
                              isClicked: _paperBobClicked,
                              onTap: () => _onPaperTap(true),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Beep (Fungsi)
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Image.asset(
                                'assets/images/beep_kertas.png',
                                fit: BoxFit.contain,
                                errorBuilder: (_, _, _) => Center(
                                  child: Text('Beep', style: GoogleFonts.jua(fontSize: 14, color: AppColors.darkGray)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            _buildPaper(
                              label: _paperBeepClicked ? _currentPart.function : 'Klik disini',
                              emoji: _paperBeepClicked ? _currentPart.emoji : null,
                              isClicked: _paperBeepClicked,
                              onTap: () => _onPaperTap(false),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _navArrow(Icons.arrow_back_ios, _currentPartIndex > 0, () => _goToPart(_currentPartIndex - 1)),
                    const SizedBox(width: 24),
                    _navArrow(Icons.arrow_forward_ios, _currentPartIndex < _parts.length - 1, () => _goToPart(_currentPartIndex + 1)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_parts.length, (i) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: i == _currentPartIndex ? 20 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: i == _currentPartIndex ? const Color(0xFF75D035) : AppColors.gray.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 220,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      _scrambleSectionB();
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

  Widget _buildPaper({required String label, String? emoji, required bool isClicked, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: isClicked ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        width: 150,
        height: 100,
        decoration: BoxDecoration(
          color: isClicked ? Colors.white : const Color(0xFFFFF3E0),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isClicked ? AppColors.primaryBlue : Colors.orange.withValues(alpha: 0.4),
            width: isClicked ? 2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isClicked ? AppColors.primaryBlue.withValues(alpha: 0.15) : Colors.black.withValues(alpha: 0.08),
              blurRadius: 6, offset: const Offset(0, 3),
            ),
          ],
        ),
        child: isClicked
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(emoji ?? '', style: const TextStyle(fontSize: 28)),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(label,
                        style: GoogleFonts.jua(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.black),
                        textAlign: TextAlign.center),
                  ),
                ],
              )
            : Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.touch_app, size: 18, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text('Klik disini',
                        style: GoogleFonts.jua(fontSize: 13, color: Colors.orange, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _navArrow(IconData icon, bool enabled, VoidCallback onTap) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: enabled ? const Color(0xFF75D035) : AppColors.gray.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }

  // ─────────────────────────── SECTION B ───────────────────────────

  Widget _buildSectionB() {
    return Column(
      children: [
        _buildTopBar(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Tarik Garis ke Fungsi yang Tepat!',
              style: GoogleFonts.jua(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.black),
              textAlign: TextAlign.center),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 12),
            child: Stack(
              children: [
                CustomPaint(
                  size: Size.infinite,
                  painter: _ConnectionPainter(
                    connections: _connections,
                    correctIds: _submitted ? _parts.map((p) => p.id).toSet() : {},
                    isCorrectMap: _submitted
                        ? Map.fromEntries(_parts.map((p) => MapEntry(p.id, p.function)))
                        : {},
                    submitted: _submitted,
                    parts: _parts,
                    leftKeys: _leftKeys,
                    rightKeys: _rightKeys,
                  ),
                ),
                Row(
                  children: [
                    Expanded(child: _buildColumn(true)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildColumn(false)),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: SizedBox(
            width: 200, height: 48,
            child: ElevatedButton(
              onPressed: (_allConnected && !_submitted)
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
        ),
      ],
    );
  }

  final Map<String, GlobalKey> _leftKeys = {};
  final Map<String, GlobalKey> _rightKeys = {};

  Widget _buildColumn(bool isLeft) {
    final items = isLeft ? _scrambledLeft : _scrambledRight;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(isLeft ? 'Organ Tubuh' : 'Fungsi',
            style: GoogleFonts.jua(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.darkGray)),
        const SizedBox(height: 6),
        ...items.map((item) {
          final connected = _connections.any((c) => isLeft ? c.leftId == item.id : c.rightFunc == item.label);
          final isSelected = isLeft ? _selectedLeftId == item.id : _selectedRightFunc == item.label;

          bool isCorrect = false;
          bool isWrong = false;
          if (_submitted && connected) {
            if (isLeft) {
              final c = _connections.firstWhere((c) => c.leftId == item.id);
              isCorrect = _parts.firstWhere((p) => p.id == item.id).function == c.rightFunc;
              isWrong = !isCorrect;
            } else {
              final c = _connections.firstWhere((c) => c.rightFunc == item.label);
              final part = _parts.firstWhere((p) => p.function == item.label);
              isCorrect = c.leftId == part.id;
              isWrong = !isCorrect;
            }
          }

          Color bg = Colors.white;
          Color border = AppColors.gray.withValues(alpha: 0.4);
          if (isCorrect) { bg = Colors.green.withValues(alpha: 0.12); border = Colors.green; }
          else if (isWrong) { bg = Colors.red.withValues(alpha: 0.12); border = Colors.red; }
          else if (isSelected) { bg = AppColors.primaryBlue.withValues(alpha: 0.12); border = AppColors.primaryBlue; }
          else if (connected) { bg = const Color(0xFFF0F8FF); border = AppColors.primaryBlue.withValues(alpha: 0.6); }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: GestureDetector(
              onTap: _submitted ? null : () {
                if (isLeft) {
                  _handleLeftTap(item.id);
                } else {
                  _handleRightTap(item.label);
                }
                if (isLeft && connected) {
                  final idx = _connections.indexWhere((c) => c.leftId == item.id);
                  if (idx != -1) _removeConnection(idx);
                } else if (!isLeft && connected) {
                  final idx = _connections.indexWhere((c) => c.rightFunc == item.label);
                  if (idx != -1) _removeConnection(idx);
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                key: isLeft ? _leftKeys.putIfAbsent(item.id, () => GlobalKey())
                           : _rightKeys.putIfAbsent(item.label, () => GlobalKey()),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: border, width: 1.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (connected && !isLeft)
                      Icon(
                        isCorrect ? Icons.check_circle : Icons.cancel,
                        size: 14, color: isCorrect ? Colors.green : Colors.red,
                      ),
                    Flexible(child: Text(item.label,
                        style: GoogleFonts.jua(fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.black),
                        textAlign: TextAlign.center)),
                    if (connected && isLeft)
                      Icon(
                        isCorrect ? Icons.check_circle : Icons.cancel,
                        size: 14, color: isCorrect ? Colors.green : Colors.red,
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
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
                  _connections.clear();
                  _selectedLeftId = null;
                  _selectedRightFunc = null;
                  _scrambleSectionB();
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
    required IconData icon, required List<Color> gradient,
    required String label, required VoidCallback onPressed,
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

class _ScrambledItem {
  final String id, label;
  const _ScrambledItem(this.id, this.label);
}

class _LineConnection {
  final String leftId, rightFunc;
  const _LineConnection(this.leftId, this.rightFunc);
}

class _ConnectionPainter extends CustomPainter {
  final List<_LineConnection> connections;
  final Set<String> correctIds;
  final Map<String, String> isCorrectMap;
  final bool submitted;
  final List<_Part> parts;
  final Map<String, GlobalKey> leftKeys;
  final Map<String, GlobalKey> rightKeys;

  _ConnectionPainter({
    required this.connections, required this.correctIds,
    required this.isCorrectMap, required this.submitted,
    required this.parts, required this.leftKeys, required this.rightKeys,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var conn in connections) {
      final leftKey = leftKeys[conn.leftId];
      final rightKey = rightKeys[conn.rightFunc];
      if (leftKey == null || rightKey == null) continue;

      final leftRenderBox = leftKey.currentContext?.findRenderObject() as RenderBox?;
      final rightRenderBox = rightKey.currentContext?.findRenderObject() as RenderBox?;
      if (leftRenderBox == null || rightRenderBox == null) continue;

      final leftPos = leftRenderBox.localToGlobal(Offset(leftRenderBox.size.width, leftRenderBox.size.height / 2), ancestor: null);
      final rightPos = rightRenderBox.localToGlobal(Offset(0, rightRenderBox.size.height / 2), ancestor: null);

      final part = parts.firstWhere((p) => p.id == conn.leftId);
      final isCorrect = submitted && part.function == conn.rightFunc;

      final paint = Paint()
        ..color = isCorrect ? Colors.green : (submitted ? Colors.red : const Color(0xFF4FA8DF))
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke;

      final path = Path()
        ..moveTo(leftPos.dx, leftPos.dy)
        ..cubicTo(
          (leftPos.dx + rightPos.dx) / 2, leftPos.dy,
          (leftPos.dx + rightPos.dx) / 2, rightPos.dy,
          rightPos.dx, rightPos.dy,
        );
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ConnectionPainter oldDelegate) => true;
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
