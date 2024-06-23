import 'package:flutter/material.dart';
import 'package:tic_tac_toe_flutter/core/design_system/design_system.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GridView.builder(
              shrinkWrap: true,
              itemCount: 9,
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisExtent: 140,
              ),
              itemBuilder: (context, index) {
                return BoxItem(
                  onTap: () {
                    currentIndex.value = index;
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

ValueNotifier<int?> currentIndex = ValueNotifier(null);
