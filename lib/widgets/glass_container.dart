import 'dart:ui';
import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blur;
  final Color? color;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;
  final double borderWidth;
  final BoxShape shape;

  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 24.0,
    this.blur = 20.0,
    this.color,
    this.borderColor,
    this.padding,
    this.borderWidth = 1.0,
    this.shape = BoxShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final defaultColor = color ?? (isDark 
        ? Colors.white.withValues(alpha: 0.03) 
        : Colors.black.withValues(alpha: 0.02));
        
    final defaultBorderColor = borderColor ?? (isDark 
        ? Colors.white.withValues(alpha: 0.08) 
        : Colors.black.withValues(alpha: 0.06));

    // Performance Optimization: Skip BackdropFilter entirely if blur is 0
    if (blur == 0.0) {
      return Container(
        padding: padding,
        decoration: BoxDecoration(
          color: defaultColor,
          shape: shape,
          borderRadius: shape == BoxShape.circle ? null : BorderRadius.circular(borderRadius),
          border: Border.all(
            color: defaultBorderColor,
            width: borderWidth,
          ),
        ),
        child: child,
      );
    }

    return ClipRRect(
      borderRadius: shape == BoxShape.circle ? BorderRadius.zero : BorderRadius.circular(borderRadius),
      clipBehavior: Clip.antiAlias,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: defaultColor,
            shape: shape,
            borderRadius: shape == BoxShape.circle ? null : BorderRadius.circular(borderRadius),
            border: Border.all(
              color: defaultBorderColor,
              width: borderWidth,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
