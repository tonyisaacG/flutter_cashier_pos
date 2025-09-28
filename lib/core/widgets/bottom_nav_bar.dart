import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, 'الرئيسية', Icons.home, '/'),
          _buildNavItem(1, 'المنتجات', Icons.inventory, '/products'),
          _buildNavItem(2, 'المبيعات', Icons.point_of_sale, '/sales'),
          _buildNavItem(3, 'المشتريات', Icons.local_shipping, '/purchases'),
          _buildNavItem(4, 'التقارير', Icons.analytics, '/reports'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String label, IconData icon, String route) {
    final isSelected = widget.currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => widget.onTap(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? const Color(0xFF4CAF50) : Colors.grey.shade600,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? const Color(0xFF4CAF50) : Colors.grey.shade600,
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
