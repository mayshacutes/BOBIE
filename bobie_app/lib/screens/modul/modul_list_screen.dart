import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../models/modul.dart';
import '../../models/app_user.dart';
import '../../models/level_progress.dart';
import 'island_detail_dialog.dart';

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

  void _openModul(Modul modul) {
    showIslandDetailDialog(
      context: context,
      modul: modul,
      onLevelTap: (levelNumber) => _openLevel(modul, levelNumber),
    );
  }

  Future<void> _openLevel(Modul modul, int levelNumber) async {
    if (modul.id == '1' && levelNumber == 1) {
      final result = await Navigator.pushNamed(context, '/level1', arguments: widget.gender);
      if (result is int) {
        LevelProgress.setStars(modul.id, levelNumber, result);
        setState(() {});
      }
      return;
    }

    Navigator.pushNamed(
      context,
      '/materi',
      arguments: {'modulId': modul.id, 'moduls': _moduls, 'onModulUpdated': _updateModuls},
    );
  }

  void _updateModuls(List<Modul> updatedModuls) {
    setState(() {
      _moduls = updatedModuls;
    });
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
                            onTap: () => _openModul(_moduls[i]),
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
