import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme.dart';
import '../../models/modul.dart';

class ModulScreen extends StatefulWidget {
  const ModulScreen({super.key});

  @override
  State<ModulScreen> createState() => _ModulScreenState();
}

class _ModulScreenState extends State<ModulScreen> {
  late List<Modul> _moduls;

  @override
  void initState() {
    super.initState();
    _moduls = dummyModulList.map((m) => m.copyWith()).toList();
  }

  void _openModul(Modul modul) {
    if (modul.isLocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selesaikan modul sebelumnya untuk membuka ini!'),
          duration: Duration(seconds: 2),
        ),
      );
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
      backgroundColor: AppColors.lightSkyBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Modul Belajar',
          style: GoogleFonts.jua(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.darkBlue,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _moduls.length,
        itemBuilder: (context, index) {
          final modul = _moduls[index];
          return _ModulCard(
            modul: modul,
            index: index,
            onTap: () => _openModul(modul),
          );
        },
      ),
    );
  }
}

class _ModulCard extends StatelessWidget {
  final Modul modul;
  final int index;
  final VoidCallback onTap;

  const _ModulCard({
    required this.modul,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLocked = modul.isLocked;

    return Container(
      height: 190,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Stack(
            children: [
              SizedBox(
                width: 140,
                height: 190,
                child: Image.asset(
                  modul.imageAsset,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppColors.lightSkyBlue,
                    child: Center(
                      child: Icon(Icons.landscape, size: 48, color: AppColors.gray),
                    ),
                  ),
                ),
              ),
              if (isLocked)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.4),
                    child: const Center(
                      child: Icon(Icons.lock, color: Colors.white, size: 32),
                    ),
                  ),
                ),
              if (modul.isCompleted)
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.check, color: Colors.white, size: 14),
                  ),
                ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.orange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Bagian ${index + 1}',
                      style: GoogleFonts.jua(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    modul.title,
                    style: GoogleFonts.jua(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isLocked ? AppColors.gray : AppColors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: _buildTopicList(),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: 80,
                      height: 32,
                      child: ElevatedButton(
                        onPressed: isLocked ? null : onTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isLocked ? AppColors.gray : AppColors.green,
                          disabledBackgroundColor: AppColors.gray,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          isLocked ? 'Terkunci' : (modul.isCompleted ? 'Ulangi' : 'Baca'),
                          style: GoogleFonts.jua(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicList() {
    final topics = modul.materiList.map((m) => m.title).toList();
    if (topics.isEmpty) {
      return Text(
        modul.subtitle,
        style: GoogleFonts.jua(fontSize: 11, color: AppColors.darkGray),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
    }
    final emojis = ['\u{1F9CD}', '\u{1FA71}', '\u{1F91D}', '\u{1F6E1}\u{FE0F}'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(topics.length, (i) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 3),
          child: Row(
            children: [
              Text(
                '${i < emojis.length ? emojis[i] : '\u{2022}'} ',
                style: const TextStyle(fontSize: 12),
              ),
              Expanded(
                child: Text(
                  topics[i],
                  style: GoogleFonts.jua(
                    fontSize: 11,
                    color: AppColors.darkGray,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
