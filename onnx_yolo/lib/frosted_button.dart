import 'dart:ui';

import 'package:flutter/material.dart';

class FrostedButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final double size;
  final Color? iconColor;

  const FrostedButton({
    super.key,
    this.onPressed,
    required this.icon,
    this.size = 62,
    this.iconColor,
  });

  @override
  State<FrostedButton> createState() => _FrostedButtonState();
}

class _FrostedButtonState extends State<FrostedButton>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;
  double _opacity = 0.2;
  double _shadow = 12;

  void _press() {
    setState(() {
      _scale = 0.88;
      _opacity = 0.28;
      _shadow = 4;
    });
  }

  void _release() {
    setState(() {
      _scale = 1.0;
      _opacity = 0.2;
      _shadow = 12;
    });
    widget.onPressed?.call();
  }

  void _cancel() {
    setState(() {
      _scale = 1.0;
      _opacity = 0.2;
      _shadow = 12;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTapDown: (_) => _press(),
      onTapUp: (_) => _release(),
      onTapCancel: _cancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: colorScheme.inverseSurface.withValues(alpha: 0.25),
                // color: CupertinoColors.systemGrey2.withValues(alpha: _opacity),
                blurRadius: _shadow,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // color: CupertinoColors.systemGrey.withOpacity(_opacity),
                  //   // color: widget.color.withValues(alpha: _opacity),
                  border: Border.all(
                    // color: CupertinoColors.systemGrey.withValues(
                    //   alpha: _opacity,
                    // ),
                    color: colorScheme.onSurfaceVariant.withValues(
                      alpha: _opacity,
                    ),
                    width: 1.414,
                  ),
                  gradient: RadialGradient(
                    colors: [
                      // Colors.white.withValues(alpha: 0.28),
                      // Colors.white.withValues(alpha: 0.05),
                      colorScheme.surface.withValues(alpha: 0.28),
                      colorScheme.surface.withValues(alpha: 0.05),
                    ],
                    center: Alignment.topLeft,
                    radius: 0.9,
                  ),
                ),
                child: Icon(
                  widget.icon,
                  size: widget.size * 0.5,
                  color: widget.iconColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
