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
  bool _bobOrganClicked = false;
  bool _bobFuncClicked = false;
  bool _beepOrganClicked = false;
  bool _beepFuncClicked = false;

  final List<_Part> _parts = [
    _Part('mata', 'Mata', '👁️', 'untuk melihat'),
    _Part('hidung', 'Hidung', '👃', 'untuk mencium'),
    _Part('telinga', 'Telinga', '👂', 'untuk mendengar'),
    _Part('mulut', 'Mulut', '👄', 'untuk berbicara & makan'),
    _Part('tangan', 'Tangan', '✋', 'untuk memegang'),
    _Part('kaki', 'Kaki', '🦶', 'untuk berjalan'),
  ];

  final List<_LineConnection> _connections = [];
  bool _submitted = false;
  List<_ScrambledItem> _scrambledLeft = [];
  List<_ScrambledItem> _scrambledRight = [];

  Set<String> _correctLeftIds = {};
  Set<String> _wrongLeftIds = {};

  bool _isDragging = false;
  String? _dragLeftId;
  List<Offset> _dragPoints = [];

  final GlobalKey _stackKey = GlobalKey();
  final Map<String, GlobalKey> _leftKeys = {};
  final Map<String, GlobalKey> _rightKeys = {};

  @override
  void initState() {
    super.initState();
    _scrambleSectionB();
  }

  void _scrambleSectionB() {
    _scrambledLeft = _parts.map((p) => _ScrambledItem(p.id, '${p.emoji} ${p.name}')).toList()..shuffle();
    _scrambledRight = _parts.map((p) => _ScrambledItem(p.id, p.function)).toList()..shuffle();
  }

  bool get _allConnected => _connections.length == _parts.length;

  int get _correctCount {
    int c = 0;
    for (var conn in _connections) {
      final part = _parts.firstWhere((p) => p.id == conn.leftId);
      if (part.function == conn.rightFunc) c++;
    }
    return c;
  }

  String _getLabelById(String id) {
    final item = _scrambledLeft.firstWhere((s) => s.id == id, orElse: () => _ScrambledItem('', ''));
    final itemR = _scrambledRight.firstWhere((s) => s.label == id, orElse: () => _ScrambledItem('', ''));
    if (item.label.isNotEmpty) return item.label;
    return itemR.label;
  }

  void _onPaperTap(String cardId) {
    setState(() {
      switch (cardId) {
        case 'bob_organ': _bobOrganClicked = true; break;
        case 'bob_func': _bobFuncClicked = true; break;
        case 'beep_organ': _beepOrganClicked = true; break;
        case 'beep_func': _beepFuncClicked = true; break;
      }
    });
  }

  void _goToPart(int index) {
    if (index < 0 || index >= _parts.length) return;
    setState(() {
      _currentPartIndex = index;
      _bobOrganClicked = false;
      _bobFuncClicked = false;
      _beepOrganClicked = false;
      _beepFuncClicked = false;
    });
  }

  // ─────────────── DRAG HANDLERS (Section B) ───────────────

  void _onPointerDown(PointerDownEvent event) {
    final stackBox = _stackKey.currentContext?.findRenderObject() as RenderBox?;
    if (stackBox == null) return;
    final localPos = stackBox.globalToLocal(event.position);

    for (var item in _scrambledLeft) {
      final key = _leftKeys[item.id];
      final box = key?.currentContext?.findRenderObject() as RenderBox?;
      if (box == null) continue;
      final cardPos = stackBox.globalToLocal(box.localToGlobal(Offset.zero));
      final cardRect = cardPos & box.size;

      if (cardRect.contains(localPos)) {
        if (_submitted && _correctLeftIds.contains(item.id)) return;
        if (_submitted && _wrongLeftIds.contains(item.id)) {
          _wrongLeftIds.remove(item.id);
        }
        _connections.removeWhere((c) => c.leftId == item.id);

        final startPos = Offset(cardRect.right, cardRect.center.dy);
        _dragLeftId = item.id;
        _dragPoints = [startPos];
        _isDragging = true;
        setState(() {});
        return;
      }
    }
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (!_isDragging || _dragLeftId == null) return;
    _dragPoints.add(event.localPosition);
    setState(() {});
  }

  void _onPointerUp(PointerUpEvent event) {
    if (!_isDragging || _dragLeftId == null) {
      _resetDrag();
      return;
    }

    final stackBox = _stackKey.currentContext?.findRenderObject() as RenderBox?;
    final localPos = stackBox != null
        ? stackBox.globalToLocal(event.position)
        : event.localPosition;

    String? matchedRightLabel;
    for (var item in _scrambledRight) {
      final key = _rightKeys[item.label];
      final box = key?.currentContext?.findRenderObject() as RenderBox?;
      if (box == null) continue;
      if (stackBox == null) continue;
      final cardPos = stackBox.globalToLocal(box.localToGlobal(Offset.zero));
      final cardRect = cardPos & box.size;

      if (cardRect.contains(localPos)) {
        matchedRightLabel = item.label;
        break;
      }
    }

    if (matchedRightLabel != null) {
      _connections.removeWhere((c) => c.rightFunc == matchedRightLabel);
      _connections.add(_LineConnection(_dragLeftId!, matchedRightLabel, List.from(_dragPoints)));
    }

    _resetDrag();
    setState(() {});
  }

  void _resetDrag() {
    _isDragging = false;
    _dragLeftId = null;
    _dragPoints = [];
  }

  void _onSubmit() {
    setState(() => _submitted = true);

    _correctLeftIds = {};
    _wrongLeftIds = {};
    final wrongConns = <_LineConnection>[];
    for (var conn in _connections) {
      final part = _parts.firstWhere((p) => p.id == conn.leftId);
      if (part.function == conn.rightFunc) {
        _correctLeftIds.add(conn.leftId);
      } else {
        _wrongLeftIds.add(conn.leftId);
        wrongConns.add(conn);
      }
    }

    if (wrongConns.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) _showInsightDialog(wrongConns);
      });
    } else {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) _showCompletionDialog(_correctCount);
      });
    }
  }

  void _showInsightDialog(List<_LineConnection> wrongConns) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Ayo Pelajari Lagi!',
                  style: GoogleFonts.jua(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFFE87E45))),
              const SizedBox(height: 4),
              Text('Beberapa jawaban masih belum tepat',
                  style: GoogleFonts.jua(fontSize: 13, color: AppColors.darkGray)),
              const SizedBox(height: 16),
              ...wrongConns.map((conn) {
                final part = _parts.firstWhere((p) => p.id == conn.leftId);
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(part.emoji, style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(part.name,
                                style: GoogleFonts.jua(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.black)),
                            const SizedBox(height: 2),
                            Text('Kamu menjawab: "${_getLabelById(conn.rightFunc)}"',
                                style: GoogleFonts.jua(fontSize: 11, color: Colors.red)),
                            const SizedBox(height: 2),
                            Text('Yang benar: ${part.function}',
                                style: GoogleFonts.jua(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.green)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    setState(() {
                      _connections.removeWhere((c) => _wrongLeftIds.contains(c.leftId));
                      _wrongLeftIds.clear();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF75D035),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                  ),
                  child: Text('Coba Lagi',
                      style: GoogleFonts.jua(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
                        _correctLeftIds = {};
                        _wrongLeftIds = {};
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
    final nextIndex = _currentPartIndex + 1;
    final bobPart = _parts[_currentPartIndex];
    final beepPart = nextIndex < _parts.length ? _parts[nextIndex] : null;
    final totalPages = (_parts.length + 1) ~/ 2;
    final currentPage = _currentPartIndex ~/ 2;

    return Column(
      children: [
        _buildTopBar(),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Kenali Organ & Fungsinya',
              style: GoogleFonts.jua(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.black),
              textAlign: TextAlign.center),
        ),
        const SizedBox(height: 4),
        Text('${currentPage + 1}/$totalPages',
            style: GoogleFonts.jua(fontSize: 14, color: AppColors.darkGray)),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 78),
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) => Stack(
                            children: [
                              Positioned.fill(
                                child: Image.asset(
                                  'assets/images/bob_kertas.png',
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, _, _) => Center(
                                    child: Text('Bob', style: GoogleFonts.jua(fontSize: 14, color: AppColors.darkGray)),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: constraints.maxHeight * 0.40 - 25,
                                left: constraints.maxWidth * 0.08 - 10,
                                width: constraints.maxWidth * 0.36,
                                height: constraints.maxHeight * 0.22,
                                child: _buildPaper(
                                  label: _bobOrganClicked ? bobPart.name : 'Klik',
                                  emoji: _bobOrganClicked ? bobPart.emoji : null,
                                  isClicked: _bobOrganClicked,
                                  onTap: () => _onPaperTap('bob_organ'),
                                  width: double.infinity,
                                  height: double.infinity,
                                  minimal: true,
                                ),
                              ),
                              Positioned(
                                top: constraints.maxHeight * 0.40 - 25,
                                right: constraints.maxWidth * 0.08 - 8,
                                width: constraints.maxWidth * 0.36,
                                height: constraints.maxHeight * 0.22,
                                child: _buildPaper(
                                  label: _bobFuncClicked ? bobPart.function : 'Klik',
                                  isClicked: _bobFuncClicked,
                                  onTap: () => _onPaperTap('bob_func'),
                                  width: double.infinity,
                                  height: double.infinity,
                                  minimal: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (beepPart != null)
                        Expanded(
                          child: LayoutBuilder(
                            builder: (context, constraints) => Stack(
                              children: [
                                Positioned.fill(
                                  child: Image.asset(
                                    'assets/images/beep_kertas.png',
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, _, _) => Center(
                                      child: Text('Beep', style: GoogleFonts.jua(fontSize: 14, color: AppColors.darkGray)),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: constraints.maxHeight * 0.40 - 8,
                                  left: constraints.maxWidth * 0.08 - 10,
                                  width: constraints.maxWidth * 0.36,
                                  height: constraints.maxHeight * 0.22,
                                  child: _buildPaper(
                                    label: _beepOrganClicked ? beepPart.name : 'Klik',
                                    emoji: _beepOrganClicked ? beepPart.emoji : null,
                                    isClicked: _beepOrganClicked,
                                    onTap: () => _onPaperTap('beep_organ'),
                                    width: double.infinity,
                                    height: double.infinity,
                                    minimal: true,
                                  ),
                                ),
                                Positioned(
                                  top: constraints.maxHeight * 0.40,
                                  right: constraints.maxWidth * 0.08 - 15,
                                  width: constraints.maxWidth * 0.36,
                                  height: constraints.maxHeight * 0.22,
                                  child: _buildPaper(
                                    label: _beepFuncClicked ? beepPart.function : 'Klik',
                                    isClicked: _beepFuncClicked,
                                    onTap: () => _onPaperTap('beep_func'),
                                    width: double.infinity,
                                    height: double.infinity,
                                    minimal: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _navArrow(Icons.arrow_back_ios, currentPage > 0, () => _goToPart(_currentPartIndex - 2)),
                    const SizedBox(width: 24),
                    _navArrow(Icons.arrow_forward_ios, currentPage < totalPages - 1, () => _goToPart(_currentPartIndex + 2)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(totalPages, (i) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: i == currentPage ? 20 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: i == currentPage ? const Color(0xFF75D035) : AppColors.gray.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 220, height: 48,
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

  Widget _buildPaper({required String label, String? emoji, required bool isClicked, required VoidCallback onTap, double? width, double? height, bool minimal = false}) {
    if (minimal) {
      return GestureDetector(
        onTap: isClicked ? null : onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: width,
          height: height,
          alignment: Alignment.center,
          child: isClicked
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (emoji != null) ...[
                      Text(emoji, style: const TextStyle(fontSize: 20)),
                      const SizedBox(height: 2),
                    ],
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Text(label,
                          style: GoogleFonts.jua(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.black),
                          textAlign: TextAlign.center),
                    ),
                  ],
                )
              : Text('Klik',
                  style: GoogleFonts.jua(fontSize: 10, color: Colors.orange, fontWeight: FontWeight.w600)),
        ),
      );
    }

    return GestureDetector(
      onTap: isClicked ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        width: width ?? 150,
        height: height ?? 100,
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
                  if (emoji != null) ...[
                    Text(emoji, style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 2),
                  ],
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(label,
                        style: GoogleFonts.jua(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.black),
                        textAlign: TextAlign.center),
                  ),
                ],
              )
            : Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.touch_app, size: 14, color: Colors.orange),
                    const SizedBox(width: 2),
                    Text('Klik',
                        style: GoogleFonts.jua(fontSize: 10, color: Colors.orange, fontWeight: FontWeight.w600)),
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
    final bool isSubmitEnabled = _allConnected && !_submitted;

    return Column(
      children: [
        _buildTopBar(),
        const SizedBox(height: 44),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Tarik Garis ke Fungsi yang Tepat!',
              style: GoogleFonts.jua(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.black),
              textAlign: TextAlign.center),
        ),
        const SizedBox(height: 14),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Stack(
              key: _stackKey,
              clipBehavior: Clip.hardEdge,
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: Level2ConnectionPainter(
                      connections: _connections,
                      parts: _parts,
                      leftKeys: _leftKeys,
                      rightKeys: _rightKeys,
                      submitted: _submitted,
                      correctLeftIds: _correctLeftIds,
                      wrongLeftIds: _wrongLeftIds,
                      stackKey: _stackKey,
                      dragLeftId: _dragLeftId,
                      dragPoints: _dragPoints,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 130, child: _buildColumn(true)),
                    const SizedBox(width: 44),
                    SizedBox(width: 130, child: _buildColumn(false)),
                  ],
                ),
                Positioned.fill(
                  child: Listener(
                    behavior: HitTestBehavior.translucent,
                    onPointerDown: _onPointerDown,
                    onPointerMove: _onPointerMove,
                    onPointerUp: _onPointerUp,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
          child: SizedBox(
            width: 200, height: 48,
            child: ElevatedButton(
              onPressed: isSubmitEnabled
                  ? _onSubmit
                  : (_submitted ? null : null),
              style: ElevatedButton.styleFrom(
                backgroundColor: isSubmitEnabled
                    ? const Color(0xFF75D035)
                    : AppColors.gray,
                disabledBackgroundColor: AppColors.gray,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              child: Text(
                _submitted ? 'Selesai' : 'Submit',
                style: GoogleFonts.jua(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildColumn(bool isLeft) {
    final items = isLeft ? _scrambledLeft : _scrambledRight;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(isLeft ? 'Organ Tubuh' : 'Fungsi',
              style: GoogleFonts.jua(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.darkGray)),
        ),
        ...items.map((item) {
          final connected = _connections.any((c) => isLeft ? c.leftId == item.id : c.rightFunc == item.label);

          bool isCorrect = false;
          bool isWrong = false;
          if (connected && _submitted) {
            if (isLeft) {
              isCorrect = _correctLeftIds.contains(item.id);
              isWrong = _wrongLeftIds.contains(item.id);
            } else {
              final conn = _connections.firstWhere((c) => c.rightFunc == item.label,
                  orElse: () => _LineConnection('', ''));
              if (conn.leftId.isNotEmpty) {
                isCorrect = _correctLeftIds.contains(conn.leftId);
                isWrong = _wrongLeftIds.contains(conn.leftId);
              }
            }
          }

          final isDragSource = _isDragging && isLeft && _dragLeftId == item.id;

          Color bg;
          Color border;
          if (isCorrect) {
            bg = Colors.green.withValues(alpha: 0.12);
            border = Colors.green;
          } else if (isWrong) {
            bg = Colors.red.withValues(alpha: 0.12);
            border = Colors.red;
          } else if (connected) {
            bg = const Color(0xFFF0F8FF);
            border = AppColors.primaryBlue.withValues(alpha: 0.6);
          } else if (isDragSource) {
            bg = AppColors.primaryBlue.withValues(alpha: 0.12);
            border = AppColors.primaryBlue;
          } else {
            bg = Colors.white;
            border = AppColors.gray.withValues(alpha: 0.4);
          }

          return Container(
            key: isLeft ? _leftKeys.putIfAbsent(item.id, () => GlobalKey())
                         : _rightKeys.putIfAbsent(item.label, () => GlobalKey()),
            width: double.infinity,
            height: 54,
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: border, width: 1.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_submitted && connected && !isLeft)
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Icon(
                      isCorrect ? Icons.check_circle : Icons.cancel,
                      size: 16, color: isCorrect ? Colors.green : Colors.red,
                    ),
                  ),
                Expanded(
                  child: Text(
                    item.label,
                    style: GoogleFonts.jua(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (_submitted && connected && isLeft)
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Icon(
                      isCorrect ? Icons.check_circle : Icons.cancel,
                      size: 16, color: isCorrect ? Colors.green : Colors.red,
                    ),
                  ),
              ],
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
                  _correctLeftIds = {};
                  _wrongLeftIds = {};
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

// ─────────────────────── DATA CLASSES ───────────────────────

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
  final List<Offset>? dragPoints;
  const _LineConnection(this.leftId, this.rightFunc, [this.dragPoints]);
}

// ─────────────────────── PAINTER ───────────────────────

class Level2ConnectionPainter extends CustomPainter {
  final List<_LineConnection> connections;
  final List<_Part> parts;
  final Map<String, GlobalKey> leftKeys;
  final Map<String, GlobalKey> rightKeys;
  final bool submitted;
  final Set<String> correctLeftIds;
  final Set<String> wrongLeftIds;
  final GlobalKey stackKey;
  final String? dragLeftId;
  final List<Offset> dragPoints;

  Level2ConnectionPainter({
    required this.connections, required this.parts,
    required this.leftKeys, required this.rightKeys,
    required this.submitted, required this.correctLeftIds,
    required this.wrongLeftIds, required this.stackKey,
    this.dragLeftId, required this.dragPoints,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final stackBox = stackKey.currentContext?.findRenderObject() as RenderBox?;
    if (stackBox == null) return;

    for (var conn in connections) {
      final leftKey = leftKeys[conn.leftId];
      final rightKey = rightKeys[conn.rightFunc];
      if (leftKey?.currentContext == null || rightKey?.currentContext == null) continue;

      final leftBox = leftKey!.currentContext!.findRenderObject() as RenderBox;
      final rightBox = rightKey!.currentContext!.findRenderObject() as RenderBox;

      final start = stackBox.globalToLocal(leftBox.localToGlobal(Offset(leftBox.size.width, leftBox.size.height / 2)));
      final end = stackBox.globalToLocal(rightBox.localToGlobal(Offset(0, rightBox.size.height / 2)));

      final isCorrect = submitted && correctLeftIds.contains(conn.leftId);
      final isWrong = submitted && wrongLeftIds.contains(conn.leftId);

      final paint = Paint()
        ..color = isCorrect ? Colors.green : (isWrong ? Colors.red : const Color(0xFF4FA8DF))
        ..strokeWidth = 3.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      final path = Path();
      if (conn.dragPoints != null && conn.dragPoints!.isNotEmpty) {
        path.moveTo(conn.dragPoints!.first.dx, conn.dragPoints!.first.dy);
        for (int i = 1; i < conn.dragPoints!.length; i++) {
          path.lineTo(conn.dragPoints![i].dx, conn.dragPoints![i].dy);
        }
        path.lineTo(end.dx, end.dy);
      } else {
        path.moveTo(start.dx, start.dy);
        path.lineTo(end.dx, end.dy);
      }
      canvas.drawPath(path, paint);
    }

    if (dragLeftId != null && dragPoints.isNotEmpty) {
      final paint = Paint()
        ..color = const Color(0xFF4FA8DF).withValues(alpha: 0.5)
        ..strokeWidth = 3.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      final path = Path();
      path.moveTo(dragPoints.first.dx, dragPoints.first.dy);
      for (int i = 1; i < dragPoints.length; i++) {
        path.lineTo(dragPoints[i].dx, dragPoints[i].dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant Level2ConnectionPainter oldDelegate) => true;
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
