import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme.dart';
import '../../models/modul.dart';
import '../../models/level_progress.dart';

Future<void> showIslandDetailDialog({
  required BuildContext context,
  required Modul modul,
  required void Function(int levelNumber) onLevelTap,
}) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: _IslandDetailCard(modul: modul, onLevelTap: onLevelTap),
    ),
  );
}

class _IslandDetailCard extends StatelessWidget {
  final Modul modul;
  final void Function(int levelNumber) onLevelTap;

  const _IslandDetailCard({required this.modul, required this.onLevelTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        modul.title,
                        style: GoogleFonts.jua(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkBlue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        modul.subtitle,
                        style: GoogleFonts.jua(
                          fontSize: 13,
                          color: AppColors.darkGray,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.pink,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, color: Colors.white, size: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 10,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 12,
                crossAxisSpacing: 8,
                childAspectRatio: 0.72,
              ),
              itemBuilder: (context, index) {
                final levelNumber = index + 1;
                // Only island '1' has real content so far; other islands stay locked
                // beyond level 1 until their games are built.
                final hasContent = modul.id == '1';
                final isUnlocked = hasContent && LevelProgress.isUnlocked(modul.id, levelNumber);
                final stars = LevelProgress.getStars(modul.id, levelNumber);
                return _LevelCircle(
                  levelNumber: levelNumber,
                  isUnlocked: isUnlocked,
                  starsEarned: stars,
                  onTap: isUnlocked
                      ? () {
                          Navigator.pop(context);
                          onLevelTap(levelNumber);
                        }
                      : null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelCircle extends StatelessWidget {
  final int levelNumber;
  final bool isUnlocked;
  final int starsEarned;
  final VoidCallback? onTap;

  const _LevelCircle({
    required this.levelNumber,
    required this.isUnlocked,
    required this.starsEarned,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isUnlocked ? AppColors.green : AppColors.lockedGray.withValues(alpha: 0.3),
              border: Border.all(
                color: isUnlocked ? AppColors.darkGreen : AppColors.lockedGray,
                width: 2,
              ),
            ),
            child: isUnlocked
                ? Text(
                    '$levelNumber',
                    style: GoogleFonts.jua(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                : Icon(Icons.lock, size: 16, color: AppColors.darkGray),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (i) {
              return Icon(
                i < starsEarned ? Icons.star_rounded : Icons.star_border_rounded,
                size: 10,
                color: AppColors.yellow,
              );
            }),
          ),
        ],
      ),
    );
  }
}
