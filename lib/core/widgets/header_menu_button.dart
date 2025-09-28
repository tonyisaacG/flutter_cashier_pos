import 'package:flutter/material.dart';

class HeaderMenuButton extends StatelessWidget {
  final VoidCallback onPressed;

  const HeaderMenuButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(
        Icons.more_vert,
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(8),
    );
  }
}
