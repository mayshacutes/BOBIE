import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

class AppBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<AppBottomNavBar> createState() => _AppBottomNavBarState();
}

class _AppBottomNavBarState extends State<AppBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.bottomNavBg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = constraints.maxWidth / 4;
          return Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                left: itemWidth * widget.currentIndex + (itemWidth - 48) / 2,
                top: 8,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: AppColors.orange,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x66FF9800),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  _NavItem(
                    icon: widget.currentIndex == 0 ? Icons.flag : Icons.flag_outlined,
                    label: 'Level',
                    isActive: widget.currentIndex == 0,
                    onTap: () => widget.onTap(0),
                    itemWidth: itemWidth,
                  ),
                  _NavItem(
                    icon: widget.currentIndex == 1 ? Icons.menu_book : Icons.menu_book_outlined,
                    label: 'Modul',
                    isActive: widget.currentIndex == 1,
                    onTap: () => widget.onTap(1),
                    itemWidth: itemWidth,
                  ),
                  _NavItem(
                    icon: widget.currentIndex == 2 ? Icons.bar_chart : Icons.bar_chart_outlined,
                    label: 'Leaderboard',
                    isActive: widget.currentIndex == 2,
                    onTap: () => widget.onTap(2),
                    itemWidth: itemWidth,
                  ),
                  _NavItem(
                    icon: widget.currentIndex == 3 ? Icons.person : Icons.person_outline,
                    label: 'Profile',
                    isActive: widget.currentIndex == 3,
                    onTap: () => widget.onTap(3),
                    itemWidth: itemWidth,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final double itemWidth;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.itemWidth,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: itemWidth,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Icon(
              icon,
              color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.5),
              size: 26,
            ),
            const SizedBox(height: 15),
            Text(
              label,
              style: GoogleFonts.jua(
                fontSize: 10,
                color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
