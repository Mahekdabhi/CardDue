import 'package:flutter/material.dart';

class PremiumButton extends StatefulWidget {
  final VoidCallback? onTap;
  final Widget child;
  final Color? color;
  final double borderRadius;
  final double height;
  final double? width;
  final bool isLoading;

  const PremiumButton({
    super.key,
    required this.onTap,
    required this.child,
    this.color,
    this.borderRadius = 16.0,
    this.height = 56.0,
    this.width,
    this.isLoading = false,
  });

  @override
  State<PremiumButton> createState() => _PremiumButtonState();
}

class _PremiumButtonState extends State<PremiumButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onTap != null && !widget.isLoading) {
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.onTap != null && !widget.isLoading) {
      _controller.reverse();
    }
  }

  void _handleTapCancel() {
    if (widget.onTap != null && !widget.isLoading) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonColor = widget.color ?? theme.primaryColor;
    final isDisabled = widget.onTap == null || widget.isLoading;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: isDisabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: isDisabled ? null : widget.onTap,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: widget.height,
            width: widget.width,
            decoration: BoxDecoration(
              color: isDisabled 
                  ? buttonColor.withValues(alpha: 0.4) 
                  : (_isHovered ? buttonColor.withValues(alpha: 0.9) : buttonColor),
              borderRadius: BorderRadius.circular(widget.borderRadius),
              boxShadow: [
                if (!isDisabled)
                  BoxShadow(
                    color: buttonColor.withValues(alpha: _isHovered ? 0.4 : 0.25),
                    blurRadius: _isHovered ? 16 : 10,
                    offset: Offset(0, _isHovered ? 6 : 4),
                  ),
              ],
            ),
            alignment: Alignment.center,
            child: widget.isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : widget.child,
          ),
        ),
      ),
    );
  }
}
