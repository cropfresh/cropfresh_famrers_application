import 'package:flutter/material.dart';

// * GRADIENT BUTTON WIDGET
// * Material Design 3 compliant button with gradient background
// * Features: Loading states, accessibility, custom styling, animations

class GradientButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final bool isLoading;
  final bool isExpanded;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final double? elevation;
  final List<Color>? gradientColors;
  final AlignmentGeometry? gradientBegin;
  final AlignmentGeometry? gradientEnd;

  const GradientButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.isLoading = false,
    this.isExpanded = true,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    this.borderRadius,
    this.elevation,
    this.gradientColors,
    this.gradientBegin,
    this.gradientEnd,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _loadingAnimation;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // * Setup animations
  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // * Start loading animation if needed
    if (widget.isLoading) {
      _animationController.repeat();
    }
  }

  @override
  void didUpdateWidget(GradientButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // * Handle loading state changes
    if (widget.isLoading != oldWidget.isLoading) {
      if (widget.isLoading) {
        _animationController.repeat();
      } else {
        _animationController.stop();
        _animationController.reset();
      }
    }
  }

  // * Handle press down
  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      setState(() {
        _isPressed = true;
      });
      _animationController.forward();
    }
  }

  // * Handle press up
  void _onTapUp(TapUpDetails details) {
    _handleTapEnd();
  }

  // * Handle press cancel
  void _onTapCancel() {
    _handleTapEnd();
  }

  // * Common tap end handling
  void _handleTapEnd() {
    if (_isPressed) {
      setState(() {
        _isPressed = false;
      });
      if (!widget.isLoading) {
        _animationController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // * Determine colors
    final gradientColors = widget.gradientColors ?? [
      colorScheme.primary,
      colorScheme.primary.withOpacity(0.8),
    ];

    final foregroundColor = widget.foregroundColor ?? colorScheme.onPrimary;
    final isEnabled = widget.onPressed != null && !widget.isLoading;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _isPressed && !widget.isLoading ? _scaleAnimation.value : 1.0,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            onTap: isEnabled ? widget.onPressed : null,
            child: Container(
              width: widget.isExpanded ? double.infinity : null,
              padding: widget.padding ??
                  const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
              decoration: BoxDecoration(
                gradient: isEnabled
                    ? LinearGradient(
                        colors: gradientColors,
                        begin: widget.gradientBegin ?? Alignment.centerLeft,
                        end: widget.gradientEnd ?? Alignment.centerRight,
                      )
                    : null,
                color: !isEnabled ? colorScheme.onSurface.withOpacity(0.12) : null,
                borderRadius: BorderRadius.circular(
                  widget.borderRadius ?? 12,
                ),
                boxShadow: isEnabled
                    ? [
                        BoxShadow(
                          color: colorScheme.primary.withOpacity(0.2),
                          blurRadius: widget.elevation ?? 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: widget.isExpanded 
                    ? MainAxisSize.max 
                    : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // * Loading indicator or icon
                  if (widget.isLoading) ...[
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          foregroundColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ] else if (widget.icon != null) ...[
                    Icon(
                      widget.icon,
                      color: isEnabled 
                          ? foregroundColor 
                          : colorScheme.onSurface.withOpacity(0.38),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                  ],

                  // * Button text
                  Text(
                    widget.isLoading ? 'Loading...' : widget.text,
                    style: textTheme.titleMedium?.copyWith(
                      color: isEnabled 
                          ? foregroundColor 
                          : colorScheme.onSurface.withOpacity(0.38),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// * OUTLINE GRADIENT BUTTON
// * Variant with outline border and gradient text

class OutlineGradientButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final bool isLoading;
  final bool isExpanded;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final List<Color>? gradientColors;
  final double? borderWidth;

  const OutlineGradientButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.isLoading = false,
    this.isExpanded = true,
    this.padding,
    this.borderRadius,
    this.gradientColors,
    this.borderWidth,
  });

  @override
  State<OutlineGradientButton> createState() => _OutlineGradientButtonState();
}

class _OutlineGradientButtonState extends State<OutlineGradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // * Setup animations
  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  // * Handle press down
  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      setState(() {
        _isPressed = true;
      });
      _animationController.forward();
    }
  }

  // * Handle press up
  void _onTapUp(TapUpDetails details) {
    _handleTapEnd();
  }

  // * Handle press cancel
  void _onTapCancel() {
    _handleTapEnd();
  }

  // * Common tap end handling
  void _handleTapEnd() {
    if (_isPressed) {
      setState(() {
        _isPressed = false;
      });
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // * Determine colors
    final gradientColors = widget.gradientColors ?? [
      colorScheme.primary,
      colorScheme.primary.withOpacity(0.8),
    ];

    final isEnabled = widget.onPressed != null && !widget.isLoading;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _isPressed ? _scaleAnimation.value : 1.0,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            onTap: isEnabled ? widget.onPressed : null,
            child: Container(
              width: widget.isExpanded ? double.infinity : null,
              padding: widget.padding ??
                  const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
              decoration: BoxDecoration(
                border: Border.all(
                  width: widget.borderWidth ?? 1,
                  color: isEnabled 
                      ? colorScheme.primary 
                      : colorScheme.onSurface.withOpacity(0.12),
                ),
                borderRadius: BorderRadius.circular(
                  widget.borderRadius ?? 12,
                ),
              ),
              child: Row(
                mainAxisSize: widget.isExpanded 
                    ? MainAxisSize.max 
                    : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // * Loading indicator or icon
                  if (widget.isLoading) ...[
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ] else if (widget.icon != null) ...[
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: isEnabled 
                            ? gradientColors 
                            : [
                                colorScheme.onSurface.withOpacity(0.38),
                                colorScheme.onSurface.withOpacity(0.38),
                              ],
                      ).createShader(bounds),
                      child: Icon(
                        widget.icon,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],

                  // * Button text with gradient
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: isEnabled 
                          ? gradientColors 
                          : [
                              colorScheme.onSurface.withOpacity(0.38),
                              colorScheme.onSurface.withOpacity(0.38),
                            ],
                    ).createShader(bounds),
                    child: Text(
                      widget.isLoading ? 'Loading...' : widget.text,
                      style: textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
} 