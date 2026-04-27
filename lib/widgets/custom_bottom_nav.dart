import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const CustomBottomNav({super.key, required this.currentIndex, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B1B1E).withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.only(bottom: 24, top: 12, left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(icon: Icons.home_filled, label: 'Home', isActive: currentIndex == 0, onTap: () => onTap?.call(0)),
          _buildNavItem(icon: Icons.menu_book, label: 'Courses', isActive: currentIndex == 1, onTap: () => onTap?.call(1)),
          _buildNavItem(icon: Icons.forum, label: 'Community', isActive: currentIndex == 2, onTap: () => onTap?.call(2)),
          _buildNavItem(icon: Icons.groups, label: 'Meetups', isActive: currentIndex == 3, onTap: () => onTap?.call(3)),
        ],
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required String label, required bool isActive, VoidCallback? onTap}) {
    final color = isActive ? const Color(0xFF406093) : const Color(0xFF1B1B1E).withOpacity(0.6);
    final bgColor = isActive ? const Color(0xFFF5F3F7) : Colors.transparent;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
