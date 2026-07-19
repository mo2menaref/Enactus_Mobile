import 'package:flutter/material.dart';

class CustomEnactusCard extends StatelessWidget {
  final String title;
  final Color cardColor;

  const CustomEnactusCard({
    super.key,
    required this.title,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cardColor, width: 2),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: cardColor,
          ),
        ),
      ),
    );
  }
}