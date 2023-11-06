import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

class SVGIconButton extends StatelessWidget {
  final String svgPath;
  final VoidCallback onPressed;
  final double size;
  Color color;

  SVGIconButton({required this.svgPath, required this.onPressed, required this.size,required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SvgPicture.asset(
        svgPath,
        height: size,
        width: size,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
}