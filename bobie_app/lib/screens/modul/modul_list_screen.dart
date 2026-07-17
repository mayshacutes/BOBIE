import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme.dart';
import '../../models/modul.dart';
import '../../models/app_user.dart';

class ModulListScreen extends StatefulWidget {
  final MascotGender gender;

  const ModulListScreen({super.key, required this.gender});

  @override
  State<ModulListScreen> createState() => _ModulListScreenState();
}

class _ModulListScreenState extends State<ModulListScreen> {
  late List<Modul> _moduls;

  @override
  void initState() {
    super.initState();
    _moduls = dummyModulList.map((m) => m.copyWith()).toList();
  }

  void _openLevelDialog(Modul modul) {
    if (modul.isLocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selesaikan pulau sebelumnya untuk membuka ini!'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: _LevelDialog(
          modul: modul,
          onStartLevel: (level) async {
            Navigator.pop(context);

            if (modul.id == '1' && level == 1) {
              final result = await Navigator.pushNamed(
                context,
                '/level1',
                arguments: widget.gender,
              );
              if (result is int) {
                setState(() {
                  final lvl = modul.levels.firstWhere((l) => l.number == 1);
                  if (result > lvl.stars) lvl.stars = result;
                  lvl.isCompleted = true;
                  final nextIndex = modul.levels.indexWhere((l) => l.number == 2);
                  if (nextIndex != -1) {
                    modul.levels[nextIndex].isUnlocked = true;
                  }
                });
              }
              return;
            }

            Navigator.pushNamed(
              context,
              '/level-game',
              arguments: {'modulId': modul.id, 'moduls': _moduls, 'level': level},
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: AppColors.levelGradient,
              ),
            ),
          ),
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg_level.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const SizedBox(),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        for (int i = 0; i < _moduls.length; i++)
                          _IslandCard(
                            modul: _moduls[i],
                            index: i,
                            onTap: () => _openLevelDialog(_moduls[i]),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LevelDialog extends StatelessWidget {
  final Modul modul;
  final void Function(int level) onStartLevel;

  const _LevelDialog({required this.modul, required this.onStartLevel});

  @override
  Widget build(BuildContext context) {
    final allCompleted = modul.levels.every((l) => l.isCompleted);
    return SingleChildScrollView(
      child: Container(
      width: 340,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 4),
          Text(
            modul.title,
            style: GoogleFonts.jua(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.black),
          ),
          const SizedBox(height: 2),
          Text(
            modul.subtitle,
            style: GoogleFonts.jua(fontSize: 11, color: AppColors.darkGray),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 12,
              crossAxisSpacing: 8,
              childAspectRatio: 0.6,
            ),
            itemCount: modul.levels.length,
            itemBuilder: (context, index) {
              final level = modul.levels[index];
              return _LevelItem(level: level, onTap: level.isUnlocked ? () => onStartLevel(level.number) : null);
            },
          ),
          if (allCompleted) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: Text(
                  'Ikuti Ujian',
                  style: GoogleFonts.jua(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ),
            ),
          ],
        ],
      ),
          Positioned(
            top: -8,
            right: -8,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Color(0xFFF25A67),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 16),
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }
}

class _LevelItem extends StatelessWidget {
  final Level level;
  final VoidCallback? onTap;

  const _LevelItem({required this.level, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isUnlocked = level.isUnlocked;
    final isCompleted = level.isCompleted;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isUnlocked ? const Color(0xFF75D035) : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: isUnlocked ? const Color(0xFF75D035) : AppColors.gray,
                width: 2,
              ),
              boxShadow: isUnlocked
                  ? [BoxShadow(color: const Color(0xFF75D035).withValues(alpha: 0.3), blurRadius: 6, offset: const Offset(0, 2))]
                  : null,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  '${level.number}',
                  style: GoogleFonts.jua(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isUnlocked ? Colors.white : AppColors.gray,
                  ),
                ),
                if (!isUnlocked)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Icon(Icons.lock, color: AppColors.gray, size: 12),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final sizes = [12.0, 16.0, 12.0];
            return Padding(
              padding: EdgeInsets.only(left: i > 0 ? 1 : 0),
              child: Icon(
                i < level.stars ? Icons.star : Icons.star_border,
                color: isCompleted ? const Color(0xFFF25A67) : AppColors.gray,
                size: sizes[i],
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _IslandCard extends StatefulWidget {
  final Modul modul;
  final int index;
  final VoidCallback onTap;

  const _IslandCard({
    required this.modul,
    required this.index,
    required this.onTap,
  });

  @override
  State<_IslandCard> createState() => _IslandCardState();
}

class _IslandCardState extends State<_IslandCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final offsets = [0.0, -40.0, -130.0, -160.0];
    return Transform.translate(
      offset: Offset(0, widget.index < offsets.length ? offsets[widget.index] : 0),
      child: Padding(
        padding: EdgeInsets.only(
          left: widget.index.isEven ? 10.0 : 180.0,
          right: widget.index.isEven ? 180.0 : 10.0,
          bottom: 0,
        ),
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: widget.onTap,
            onTapDown: (_) => setState(() => _isHovered = true),
            onTapUp: (_) => setState(() => _isHovered = false),
            onTapCancel: () => setState(() => _isHovered = false),
            child: AnimatedScale(
              scale: _isHovered ? 1.05 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: SizedBox(
                width: widget.index == 2 ? 260 : 215,
                height: widget.index == 2 ? 260 : 215,
                child: Image.asset(
                  widget.modul.imageAsset,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Icon(
                      Icons.landscape,
                      size: 80,
                      color: AppColors.green,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
