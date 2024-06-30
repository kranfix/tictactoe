import 'package:flutter/material.dart';
import 'package:tic_tac_toe_flutter/core/design_system/tokens/colors/colors.dart';

class BoxItem extends StatelessWidget {
  const BoxItem({
    super.key,
    this.onTap,
    this.color = AppColors.nilBox,
    this.child,
  });
  final VoidCallback? onTap;
  final Color color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(25),
        ),
        child: child == null
            ? null
            : DefaultTextStyle(
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 50,
                ),
                child: child!,
              ),
      ),
    );
  }
}
