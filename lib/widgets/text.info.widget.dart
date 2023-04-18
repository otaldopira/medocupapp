import 'package:flutter/material.dart';

class TextInfo extends StatelessWidget {
  final IconData icon;
  final String texto;

  const TextInfo({super.key, required this.icon, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.blue,
        ),
        const SizedBox(width: 8),
        Text(
          texto,
          style: TextStyle(color: Colors.grey[700]),
        ),
      ],
    );
  }
}
