import 'package:flutter/material.dart';
import 'package:tic_tac_toe/core/design_system/design_system.dart';

class TTTDesignedScaffold extends StatelessWidget {
  const TTTDesignedScaffold({
    super.key,
    required this.child,
  });
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const Positioned(
            right: -10,
            bottom: 0,
            top: 0,
            child: SvgWidget(
              path: Assets.rectangle_svg,
              height: 200,
              width: 200,
            ),
          ),
          const Positioned(
            left: -60,
            bottom: 0,
            top: 100,
            child: SvgWidget(
              path: Assets.star_svg,
              height: 150,
              width: 150,
            ),
          ),
          const Positioned(
            left: -60,
            bottom: 0,
            top: 600,
            child: SvgWidget(
              path: Assets.circle_svg,
              height: 150,
              width: 150,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: child,
          )
        ],
      ),
    );
  }
}
