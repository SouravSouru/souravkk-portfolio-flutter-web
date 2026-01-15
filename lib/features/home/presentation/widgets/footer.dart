import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      alignment: Alignment.center,
      color: Theme.of(context).cardColor,
      child: const Text(
        "© 2026 Sourav K K. Built with Flutter Web.",
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}
