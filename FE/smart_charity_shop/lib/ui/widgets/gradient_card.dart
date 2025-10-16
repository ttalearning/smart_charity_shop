import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class GradientCard extends StatelessWidget {
  final Widget child;
  final double? height;
  final EdgeInsets? margin;
  final Color startColor;
  final Color endColor;
  final List<BoxShadow>? boxShadow;

  const GradientCard({
    super.key,
    required this.child,
    this.height,
    this.margin,
    this.startColor = AppColors.primary,
    this.endColor = AppColors.tertiary,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: margin ?? const EdgeInsets.all(0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [startColor, endColor],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow:
            boxShadow ??
            [
              BoxShadow(
                color: startColor.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
      ),
      child: child,
    );
  }
}
