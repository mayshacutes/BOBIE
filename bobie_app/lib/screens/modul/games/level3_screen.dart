import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme.dart';

class Level3Screen extends StatefulWidget {
  const Level3Screen({super.key});

  @override
  State<Level3Screen> createState() => _Level3ScreenState();
}

class _Level3ScreenState extends State<Level3Screen> {
  bool soundOn = true;

  final List<_Activity> _activities = [
    _Activity('olahraga', '🏃', 'Olahraga', true),
    _Activity('makan_sayur', '🥗', 'Makan Sayur', true),
    _Activity('mandi', '🛁', 'Mandi', true),
    _Activity('tidur_awal', '😴', 'Tidur Awal', true),
    _Activity('minum_air', '💧', 'Minum Air Putih', true),
    _Activity('main_game', '🎮', 'Main Game Terus', false),
    _Activity('begadang', '🌙', 'Begadang', false),
    _Activity('jajan_sembarangan', '🍭', 'Jajan Sembarangan', false),
    _Activity('main_hp', '📱', 'Main HP Terus', false),
    _Activity('makan_permen', '🍬', 'Makan Permen', false),
  ];

  late List<int> _shuffledIndices;
  int _currentIndex = 0;
  int _correctCount = 0;
  bool _showResult = false;
  String _resultMessage = '';
  bool? _lastCorrect;
  bool _isFlipped = false;

  @override
  void initState() {
    super.initState();
    _shuffledIndices = List.generate(_activities.length, (i) => i)..shuffle();
  }

  void _resetGame() {
    setState(() {
      _shuffledIndices = List.generate(_activities.length, (i) => i)..shuffle();
      _currentIndex = 0;
      _correctCount = 0;
      _showResult = false;
      _resultMessage = '';
      _lastCorrect = null;
      _isFlipped = false;
    });
  }

  void _flipCard() {
    if (_isFlipped || _showResult) return;
    setState(() => _isFlipped = true);
  }

  void _dropToBasket(bool isGood) {
    if (!_isFlipped || _showResult) return;
    final idx = _shuffledIndices[_currentIndex];
    final activity = _activities[idx];
    final correct = activity.isGood == isGood;

    if (correct) {
      _correctCount++;
      _resultMessage = 'Hebat! ${activity.name} termasuk kegiatan yang ${isGood ? "BAIK" : "BURUK"} untuk tubuh!';
    } else {
      _resultMessage = 'Yah kurang tepat! ${activity.name} sebenarnya kegiatan yang ${!isGood ? "BAIK" : "BURUK"} untuk tubuh.';
    }
    _lastCorrect = correct;

    setState(() => _showResult = true);
  }

  void _nextCard() {
    if (_currentIndex >= _activities.length - 1) {
      _showCompletionDialog();
      return;
    }
    setState(() {
      _currentIndex++;
      _isFlipped = false;
      _showResult = false;
      _resultMessage = '';
      _lastCorrect = null;
    });
  }

  void _showCompletionDialog() {
    int stars = _correctCount >= 9 ? 3 : (_correctCount >= 7 ? 2 : 1);
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
              Text('level 3',
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
              Text('+${_correctCount * 10} XP',
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
                      _resetGame();
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
            _buildInstruction(),
            Expanded(child: _buildGameArea()),
          ],
        ),
      ),
    );
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
          Text('Level 3',
              style: GoogleFonts.jua(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.black)),
          const Spacer(),
          _CircleButton(
            icon: Icons.replay,
            gradient: const [Color(0xFFEAAA0A), Color(0xFF9A7413)],
            onPressed: _resetGame,
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

  Widget _buildInstruction() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Text('Balik dan masukkan kartunya',
          style: GoogleFonts.jua(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.black),
          textAlign: TextAlign.center),
    );
  }

  Widget _buildGameArea() {
    if (_currentIndex >= _activities.length) return const SizedBox();
    final idx = _shuffledIndices[_currentIndex];
    final activity = _activities[idx];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          Text('${_currentIndex + 1} / ${_activities.length}',
              style: GoogleFonts.jua(fontSize: 14, color: AppColors.darkGray)),
          const SizedBox(height: 8),
          Expanded(
            child: Row(
              children: [
                Expanded(child: _buildBasket(false)),
                Expanded(flex: 2, child: Center(child: _buildCard(activity))),
                Expanded(child: _buildBasket(true)),
              ],
            ),
          ),
          if (_showResult) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: _lastCorrect == true
                    ? Colors.green.withValues(alpha: 0.1)
                    : Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _lastCorrect == true ? Colors.green : Colors.red,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _lastCorrect == true ? Icons.check_circle : Icons.cancel,
                    color: _lastCorrect == true ? Colors.green : Colors.red,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(_resultMessage,
                        style: GoogleFonts.jua(
                          fontSize: 13,
                          color: _lastCorrect == true ? Colors.green.shade700 : Colors.red.shade700,
                        )),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: 180,
              height: 44,
              child: ElevatedButton(
                onPressed: _nextCard,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4FA8DF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                ),
                child: Text(
                  _currentIndex >= _activities.length - 1 ? 'Selesai' : 'Lanjut',
                  style: GoogleFonts.jua(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }

  Widget _buildCard(_Activity activity) {
    return GestureDetector(
      onTap: _flipCard,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        transitionBuilder: (child, animation) {
          final rotate = Tween<double>(begin: -0.5, end: 0).animate(animation);
          return AnimatedBuilder(
            animation: rotate,
            builder: (context, child) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()..rotateY(rotate.value * 3.14159),
                child: child,
              );
            },
            child: child,
          );
        },
        child: _isFlipped ? _buildCardFront(activity) : _buildCardBack(),
      ),
    );
  }

  Widget _buildCardBack() {
    const cardW = 140.0;
    const cardH = 190.0;
    return Stack(
      children: [
        for (int i = 2; i >= 1; i--)
          Positioned(
            left: i * 3.0,
            top: i * 3.0,
            child: Container(
              width: cardW,
              height: cardH,
              decoration: BoxDecoration(
                color: Color.lerp(const Color(0xFF4FA8DF), Colors.white, i / 3)!,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF1A3D5E).withValues(alpha: 0.3), width: 2),
              ),
            ),
          ),
        Container(
          key: const ValueKey('back'),
          width: cardW,
          height: cardH,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4FA8DF), Color(0xFF2B5B79)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF1A3D5E), width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 8,
                offset: const Offset(2, 4),
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.touch_app, color: Colors.white, size: 30),
                ),
                const SizedBox(height: 10),
                Text('Tap untuk\nmembalik',
                    style: GoogleFonts.jua(fontSize: 12, color: Colors.white, height: 1.3),
                    textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardFront(_Activity activity) {
    return Draggable<_Activity>(
      data: activity,
      feedback: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 130,
          height: 170,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF4FA8DF), width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 12,
                offset: const Offset(4, 6),
              ),
            ],
          ),
          child: _buildCardContent(activity),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.35,
        child: Container(
          width: 140,
          height: 190,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.gray, width: 2),
          ),
          child: Center(
            child: Icon(Icons.drag_indicator, size: 32, color: AppColors.gray),
          ),
        ),
      ),
      child: Container(
        key: const ValueKey('front'),
        width: 140,
        height: 190,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF4FA8DF), width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: _buildCardContent(activity),
      ),
    );
  }

  Widget _buildCardContent(_Activity activity) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(activity.emoji, style: const TextStyle(fontSize: 48)),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(activity.name,
              style: GoogleFonts.jua(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.black),
              textAlign: TextAlign.center),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: activity.isGood ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            activity.isGood ? 'Seret ke BAIK' : 'Seret ke BURUK',
            style: GoogleFonts.jua(
              fontSize: 10,
              color: activity.isGood ? Colors.green.shade700 : Colors.red.shade700,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Icon(Icons.swipe, size: 18, color: AppColors.gray),
      ],
    );
  }

  Widget _buildBasket(bool isGood) {
    final label = isGood ? 'BAIK' : 'BURUK';
    final color = isGood ? Colors.green : Colors.red;

    return DragTarget<_Activity>(
      onAcceptWithDetails: (details) => _dropToBasket(isGood),
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isHovering
                ? color.withValues(alpha: 0.15)
                : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isHovering ? color : AppColors.gray.withValues(alpha: 0.3),
              width: isHovering ? 3 : 2,
            ),
            boxShadow: isHovering
                ? [BoxShadow(color: color.withValues(alpha: 0.2), blurRadius: 12)]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                isGood ? 'assets/images/bob_cart.png' : 'assets/images/beep_cart.png',
                width: 50,
                height: 50,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(
                  isGood ? Icons.thumb_up_alt_rounded : Icons.thumb_down_alt_rounded,
                  size: 36,
                  color: color,
                ),
              ),
              const SizedBox(height: 6),
              Text(label,
                  style: GoogleFonts.jua(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
              Text('Letakkan di sini',
                  style: GoogleFonts.jua(fontSize: 9, color: AppColors.gray)),
            ],
          ),
        );
      },
    );
  }
}

class _Activity {
  final String id;
  final String emoji;
  final String name;
  final bool isGood;

  const _Activity(this.id, this.emoji, this.name, this.isGood);
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
