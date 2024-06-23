import 'package:flutter/material.dart';
import 'package:tic_tac_toe_flutter/core/design_system/tokens/colors/colors.dart';

class BoxItem extends StatelessWidget {
  const BoxItem({
    super.key,
    this.onTap,
    this.color = AppColors.nilBox,
  });
  final VoidCallback? onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }
}
