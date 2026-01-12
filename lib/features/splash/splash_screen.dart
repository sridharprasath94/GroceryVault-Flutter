import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../gen/assets.gen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ColoredBox(
        color: Colors.white,
        child: Center(
          child: SvgPicture.asset(
            Assets.images.icon,
            width: 180,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
