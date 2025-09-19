import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final Color? backgroundColor;
  final double borderRadius;
  final double? height;
  final double? width;
  final Widget? child;
  final EdgeInsetsGeometry? padding;

  const CustomContainer({
    super.key,
    this.height,
    this.width,
    this.backgroundColor,
    this.borderRadius = 0.0,
    this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: backgroundColor,
      ),
      child: child,
    );
  }
}
