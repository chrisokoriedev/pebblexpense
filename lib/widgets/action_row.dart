import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ActionRow extends StatelessWidget {
  const ActionRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ActionButton(
            icon: Icons.arrow_outward,
            label: 'Add Expense',
            isPrimary: true,
            onTap: () => context.push('/add'),
          ),
          ActionButton(
            icon: Icons.south_west,
            label: 'Request',
            onTap: () {},
          ),
          ActionButton(
            icon: Icons.swap_horiz,
            label: 'Exchange',
            onTap: () {},
          ),
          ActionButton(
            icon: Icons.more_horiz,
            label: 'More',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isPrimary;
  final VoidCallback onTap;

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isPrimary ? const Color(0xFFCEF175) : Colors.white;
    
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            radius: 28,
            backgroundColor: bgColor,
            child: Icon(icon, color: Colors.black, size: 24),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
