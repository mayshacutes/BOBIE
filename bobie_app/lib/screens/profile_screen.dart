import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

class ProfileScreen extends StatelessWidget {
  final String studentName;

  const ProfileScreen({super.key, required this.studentName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _YellowHeader(name: 'Maysha Akmala'),
            _WhiteContent(onLogout: () {
              Navigator.pushNamedAndRemoveUntil(context, '/signin', (route) => false);
            }),
          ],
        ),
      ),
    );
  }
}

class _YellowHeader extends StatelessWidget {
  final String name;

  const _YellowHeader({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 30, left: 20, right: 8, bottom: 30),
      decoration: const BoxDecoration(color: Color(0xFFEAAA0A)),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    name,
                    style: GoogleFonts.jua(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.share, color: Colors.white, size: 24),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.settings, color: Colors.white, size: 24),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 80,
            height: 80,
            child: Image.asset(
              'assets/images/avatar_cewe.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Center(
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: GoogleFonts.jua(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WhiteContent extends StatelessWidget {
  final VoidCallback onLogout;

  const _WhiteContent({required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.white),
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '@AKMALAMAYSHA',
                style: GoogleFonts.jua(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.black),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.lightOrange,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Kelas 4 SD',
                  style: GoogleFonts.jua(fontSize: 11, color: AppColors.orange),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    '2',
                    style: GoogleFonts.jua(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF75D035)),
                  ),
                  Text(
                    'Level',
                    style: GoogleFonts.jua(fontSize: 12, color: AppColors.darkGray),
                  ),
                ],
              ),
              _StatItem(value: '120', label: 'Pengikut'),
              _StatItem(value: '85', label: 'Mengikuti'),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.person_add, color: AppColors.primaryBlue, size: 20),
              label: Text(
                'Tambah Teman',
                style: GoogleFonts.jua(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primaryBlue),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primaryBlue),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Ringkasan',
            style: GoogleFonts.jua(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.black),
          ),
          const SizedBox(height: 12),
          _RingkasanRow(emoji: '\u{1F4C5}', label: 'Hari di Aplikasi', value: '30 Hari'),
          const SizedBox(height: 8),
          _RingkasanRow(emoji: '\u{1F3EB}', label: 'Sekolah', value: 'SDN 1 Airlangga'),
          const SizedBox(height: 8),
          _RingkasanRow(emoji: '\u{1F469}\u{200D}\u{1F3EB}', label: 'Wali Kelas', value: 'Bu Sari'),
          const SizedBox(height: 8),
          _RingkasanRow(emoji: '\u{2B50}', label: 'Total XP', value: '520 XP'),
          const SizedBox(height: 20),
          Text(
            'Lencana',
            style: GoogleFonts.jua(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.black),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _BadgeItem(emoji: '\u{1F31F}', label: 'Pemula'),
              _BadgeItem(emoji: '\u{2B50}', label: 'Rajin'),
              _BadgeItem(emoji: '\u{1F4A1}', label: 'Cerdas'),
              _BadgeItem(emoji: '\u{1F512}', label: '???'),
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: SizedBox(
            width: 200,
            height: 44,
            child: ElevatedButton.icon(
              onPressed: onLogout,
              icon: const Icon(Icons.logout, color: Colors.white),
              label: Text(
                'Keluar',
                style: GoogleFonts.jua(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.pink,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
              ),
            ),
          ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.jua(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.black),
        ),
        Text(
          label,
          style: GoogleFonts.jua(fontSize: 12, color: AppColors.darkGray),
        ),
      ],
    );
  }
}

class _RingkasanRow extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;

  const _RingkasanRow({required this.emoji, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.jua(fontSize: 13, color: AppColors.darkGray),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.jua(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.black),
        ),
      ],
    );
  }
}

class _BadgeItem extends StatelessWidget {
  final String emoji;
  final String label;

  const _BadgeItem({required this.emoji, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.lightSkyBlue,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(emoji, style: const TextStyle(fontSize: 24)),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.jua(fontSize: 11, color: AppColors.darkGray),
        ),
      ],
    );
  }
}
