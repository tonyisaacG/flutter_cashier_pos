import 'package:flutter/material.dart';

class GlobalMenuOverlay extends StatelessWidget {
  final bool isVisible;
  final VoidCallback onClose;
  final String currentRoute;
  final Function(String) onNavigate;

  const GlobalMenuOverlay({
    super.key,
    required this.isVisible,
    required this.onClose,
    required this.currentRoute,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return Stack(
      children: [
        // Backdrop
        GestureDetector(
          onTap: onClose,
          child: Container(
            color: Colors.black.withOpacity(0.01),
          ),
        ),
        // Menu
        Positioned(
          top: 60,
          right: 16,
          child: Container(
            width: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _buildMenuItems(),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildMenuItems() {
    switch (currentRoute) {
      case '/purchases':
        return [
          _buildMenuItem('عرض فواتير الشراء', '/purchase-list'),
          _buildMenuItem('عرض فواتير المرتجعات', '/purchase-return-list'),
        ];
      case '/sales':
        return [
          _buildMenuItem('عرض فواتير المبيعات', '/sale-list'),
          _buildMenuItem('عرض مرتجعات المبيعات', '/sale-return-list'),
        ];
      default:
        return [];
    }
  }

  Widget _buildMenuItem(String title, String route) {
    return InkWell(
      onTap: () {
        onClose();
        onNavigate(route);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
