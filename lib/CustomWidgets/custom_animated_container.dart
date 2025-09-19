import 'package:flutter/material.dart';

class CustomAnimatedContainer extends StatelessWidget {
  final Color? backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final Duration animationDuration;
  final double? height;
  final double? width;
  final double borderRadius;
  final Widget? child;
  final EdgeInsetsGeometry? padding;

  const CustomAnimatedContainer({
    super.key,
    this.height,
    this.width,
    this.borderRadius = 1.5,
    this.backgroundColor,
    this.borderColor = Colors.indigo,
    this.borderWidth = 0.0,
    this.child,
    this.padding,
    required this.animationDuration,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      padding: padding,
      height: height,
      width: width,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: borderWidth),
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      duration: animationDuration,
      child: child,
    );
  }
}
