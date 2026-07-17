import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightSkyBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Papan Peringkat Sekolah',
          style: GoogleFonts.jua(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.darkBlue,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          _PodiumSection(),
          const SizedBox(height: 16),
          _CurrentUserCard(),
          const SizedBox(height: 12),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: ListView.separated(
                itemCount: _allStudents.length,
                separatorBuilder: (context, index) => const Divider(height: 1, color: AppColors.lightGray),
                itemBuilder: (context, index) {
                  final student = _allStudents[index];
                  final rank = index + 4;
                  return _RankRow(
                    rank: rank,
                    name: student['name']!,
                    points: student['points']!,
                    isYou: false,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PodiumSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _PodiumItem(rank: 2, name: 'Siti', points: '850', height: 80, color: AppColors.gray),
          const SizedBox(width: 12),
          _PodiumItem(rank: 1, name: 'Ahmad', points: '920', height: 100, color: AppColors.orange),
          const SizedBox(width: 12),
          _PodiumItem(rank: 3, name: 'Dewi', points: '780', height: 60, color: const Color(0xFFCD7F32)),
        ],
      ),
    );
  }
}

class _PodiumItem extends StatelessWidget {
  final int rank;
  final String name;
  final String points;
  final double height;
  final Color color;

  const _PodiumItem({
    required this.rank,
    required this.name,
    required this.points,
    required this.height,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$rank',
              style: GoogleFonts.jua(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          name,
          style: GoogleFonts.jua(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.black),
        ),
        Text(
          '$points Poin',
          style: GoogleFonts.jua(fontSize: 11, color: AppColors.darkGray),
        ),
        const SizedBox(height: 4),
        Container(
          width: 48,
          height: height,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
        ),
      ],
    );
  }
}

class _CurrentUserCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.orange,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '5',
                style: GoogleFonts.jua(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.orange,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'You',
              style: GoogleFonts.jua(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          Text(
            '520 Poin',
            style: GoogleFonts.jua(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _RankRow extends StatelessWidget {
  final int rank;
  final String name;
  final String points;
  final bool isYou;

  const _RankRow({
    required this.rank,
    required this.name,
    required this.points,
    required this.isYou,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Text(
              '$rank',
              style: GoogleFonts.jua(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.darkGray,
              ),
            ),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.lightSkyBlue,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(Icons.person, color: AppColors.darkGray, size: 20),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: GoogleFonts.jua(
                fontSize: 15,
                fontWeight: isYou ? FontWeight.w600 : FontWeight.w400,
                color: AppColors.black,
              ),
            ),
          ),
          Text(
            '$points Poin',
            style: GoogleFonts.jua(
              fontSize: 14,
              color: AppColors.darkGray,
            ),
          ),
        ],
      ),
    );
  }
}

const List<Map<String, String>> _allStudents = [
  {'name': 'Rina', 'points': '490'},
  {'name': 'Budi', 'points': '450'},
  {'name': 'Ani', 'points': '420'},
  {'name': 'Doni', 'points': '380'},
  {'name': 'Sari', 'points': '350'},
  {'name': 'Tono', 'points': '310'},
];
