import 'package:flutter/material.dart';

/// * FADE IN ANIMATION WIDGET
/// * Reusable animation widget for smooth fade-in effects
/// * Follows Material 3 design principles
class FadeInAnimation extends StatefulWidget {
  /// The child widget to animate
  final Widget child;
  
  /// Animation duration (default: 600ms)
  final Duration duration;
  
  /// Animation delay before starting (default: no delay)
  final Duration delay;
  
  /// Animation curve (default: easeOut)
  final Curve curve;
  
  /// Animation offset for slide effect (optional)
  final Offset? offset;

  const FadeInAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
    this.delay = Duration.zero,
    this.curve = Curves.easeOut,
    this.offset,
  });

  @override
  State<FadeInAnimation> createState() => _FadeInAnimationState();
}

class _FadeInAnimationState extends State<FadeInAnimation>
    with SingleTickerProviderStateMixin {
  
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  @override
  void initState() {
    super.initState();
    _initializeAnimation();
    _startAnimation();
  }
  
  void _initializeAnimation() {
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
    
    if (widget.offset != null) {
      _slideAnimation = Tween<Offset>(
        begin: widget.offset!,
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ));
    }
  }
  
  void _startAnimation() async {
    if (widget.delay != Duration.zero) {
      await Future.delayed(widget.delay);
    }
    if (mounted) {
      _controller.forward();
    }
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    if (widget.offset != null) {
      return FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: widget.child,
        ),
      );
    }
    
    return FadeTransition(
      opacity: _fadeAnimation,
      child: widget.child,
    );
  }
}

/// * STAGGERED FADE IN ANIMATION
/// * Animate multiple children with staggered timing
class StaggeredFadeInAnimation extends StatelessWidget {
  /// List of children to animate
  final List<Widget> children;
  
  /// Base duration for each animation
  final Duration duration;
  
  /// Delay between each child animation
  final Duration staggerDelay;
  
  /// Animation curve
  final Curve curve;
  
  /// Scroll direction for children layout
  final Axis direction;

  const StaggeredFadeInAnimation({
    super.key,
    required this.children,
    this.duration = const Duration(milliseconds: 600),
    this.staggerDelay = const Duration(milliseconds: 100),
    this.curve = Curves.easeOut,
    this.direction = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    return direction == Axis.vertical
        ? Column(
            children: _buildStaggeredChildren(),
          )
        : Row(
            children: _buildStaggeredChildren(),
          );
  }
  
  List<Widget> _buildStaggeredChildren() {
    return children.asMap().entries.map((entry) {
      final index = entry.key;
      final child = entry.value;
      
      return FadeInAnimation(
        duration: duration,
        delay: staggerDelay * index,
        curve: curve,
        offset: direction == Axis.vertical 
            ? const Offset(0, 0.3) 
            : const Offset(0.3, 0),
        child: child,
      );
    }).toList();
  }
} 