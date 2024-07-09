import 'package:flutter/material.dart';
import 'package:tic_tac_toe/core/design_system/design_system.dart';

class TTTScaffold extends StatelessWidget {
  const TTTScaffold({
    super.key,
    required this.child,
  });
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: child,
      ),
    );
  }
}
