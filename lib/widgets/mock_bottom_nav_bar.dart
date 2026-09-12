import 'package:flutter/material.dart';

class MockBottomNavBar extends StatelessWidget {
  const MockBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            BottomNavItem(icon: Icons.home_outlined, label: 'Home', isActive: true),
            BottomNavItem(icon: Icons.insert_chart_outlined, label: 'Statistic'),
            BottomNavItem(icon: Icons.crop_free, label: 'Scan', isCenter: true),
            BottomNavItem(icon: Icons.credit_card_outlined, label: 'Card'),
            BottomNavItem(icon: Icons.person_outline, label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isCenter;

  const BottomNavItem({
    super.key,
    required this.icon,
    required this.label,
    this.isActive = false,
    this.isCenter = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isCenter) {
      return CircleAvatar(
        radius: 28,
        backgroundColor: const Color(0xFFCEF175),
        child: Icon(icon, color: Colors.black),
      );
    }
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: isActive ? Colors.black : Colors.black45),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive ? Colors.black : Colors.black45,
          ),
        ),
      ],
    );
  }
}
